<template>
  <div>
    <div v-loading="!isDrizzleInitialized">
      <el-row type="flex" justify="center">
        <el-col :span="12">
          <el-card>
            <el-row type="flex" justify="space-between">
              <el-col :span="3">
                <el-avatar
                  src="https://www.flaticon.com/premium-icon/icons/svg/1140/1140245.svg"
                  :size="60"
                ></el-avatar>
              </el-col>

              <el-col :span="17">
                <span class="d-block"><b>Name: </b> {{ contractName }}</span>

                <address>
                  <b>Adresss:</b> <span>{{ activeAccount }}</span>
                </address>

                <span class="d-block"
                  ><b>Total Supply:</b> {{ contractSupply }} Ether</span
                >
              </el-col>

              <el-col :span="4">
                <el-button type="warning" @click="showTransferForm = true"
                  >Transfer</el-button
                >
              </el-col>
            </el-row>

            <div style="margin-top: 40px;">
              <b>Total Balance: </b>
              <span class="balance"> {{ activeBalance }} Ether </span>
            </div>
            <div class="tk-info">
              <el-card v-loading="loading">
                <h4>Get Token Information</h4>
                <br />
                <el-input
                  type="text"
                  placeholder="Enter ether address"
                  v-model="address"
                >
                  <el-button
                    slot="append"
                    icon="el-icon-search"
                    @click.prevent="getTokenInfo"
                  ></el-button>
                </el-input>

                <!-- token information -->
                <br />
                <div v-show="accready">
                  <li>Balance: {{ contractBalance }}</li>
                </div>
              </el-card>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- Transfer dialog -->
    <el-dialog
      title="Tranfer Tokens"
      :visible.sync="showTransferForm"
      :before-close="closeTransfer"
      width="20%"
      v-loading="transferLoading"
    >
      <el-form
        ref="transferData"
        :model="transferData"
        label-position="top"
        style="margin-top:-30px"
      >
        <el-form-item label="Receiver address">
          <el-input
            v-model="transferData.address"
            placeholder="0x9Ba1A78869ED137e05F33e2BabDF0b3fdC475A4e"
          ></el-input>
        </el-form-item>

        <el-form-item label="Number of Tokens">
          <el-input
            v-model.number="transferData.token"
            type="number"
            placeholder="100"
          ></el-input>
        </el-form-item>
      </el-form>
      <br />
      <div>
        <el-button
          type="warning"
          icon="el-icon-s-promotion"
          class="full-width"
          @click.prevent="transferToken"
          >Tranfer Tokens</el-button
        >
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
// import { ethers } from "ethers";

const argsName = {
  contractName: 'DappToken',
  method: 'name',
  methodArgs: '',
};

const argsTotalSupply = {
  contractName: 'DappToken',
  method: 'totalSupply',
  methodArgs: '',
};

const argsBalance = {
  contractName: 'DappToken',
  method: 'getAcc',
  methodArgs: '',
};

export default {
  name: 'Home',
  data() {
    return {
      loading: false,
      accready: false,
      address: '',
      showTransferForm: false,
      transferData: {
        address: '',
        token: 0,
      },
      transferLoading: false,
    };
  },
  computed: {
    ...mapGetters('accounts', ['activeAccount', 'activeBalance']),
    ...mapGetters('contracts', ['getContractData']),
    ...mapGetters('drizzle', ['isDrizzleInitialized']),
    ...mapGetters('drizzle', ['drizzleInstance']),
    contractName() {
      return this.getContractData({
        contract: argsName.contractName,
        method: 'name',
      });
    },
    contractSupply() {
      return this.getContractData({
        contract: argsTotalSupply.contractName,
        method: 'totalSupply',
      });
    },
    contractBalance() {
      return this.getContractData({
        contract: argsBalance.contractName,
        method: 'getAcc',
      });
    },
  },
  created() {
    this.$store.dispatch('drizzle/REGISTER_CONTRACT', argsName);
    this.$store.dispatch('drizzle/REGISTER_CONTRACT', argsTotalSupply);
    this.$store.dispatch('drizzle/REGISTER_CONTRACT', argsBalance);
  },
  mounted() {
    const contractEventHandler = ({ contractName, eventName, data }) => {
      const display = `${eventName} of : ${data._numTokens} tokens to account( ${data._receiver})`;
      this.$notify({
        title: contractName,
        message: display,
        type: 'success',
        duration: 0,
      });
      this.transferLoading = false;
      this.showTransferForm = false;
    };
    this.$drizzleEvents.$on('drizzle/contractEvent', payload => {
      contractEventHandler(payload);
    });
  },
  methods: {
    transferToken() {
      this.transferLoading = true;
      this.drizzleInstance.contracts['DappToken'].methods['transfer'].cacheSend(
        this.transferData.address,
        this.transferData.token
      );
    },
    getTokenInfo() {
      this.loading = true;
      this.drizzleInstance.contracts['DappToken'].methods[
        'setAccount'
      ].cacheSend(this.address);
      this.accready = true;
      this.loading = false;
    },
    closeTransfer() {
      this.transferLoading = false;
      this.showTransferForm = false;
    },
  },
};
</script>
