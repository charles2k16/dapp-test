<template>
  <div>
    <span>{{ contractData }}</span>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

const args = {
  contractName: 'DappToken',
  method: 'name',
  methodArgs: '',
};
export default {
  name: 'TokenName',
  computed: {
    ...mapGetters('contracts', ['getContractData']),
    contractData() {
      return this.getContractData({
        contract: args.contractName,
        method: args.method,
      });
    },
  },
  created() {
    this.$store.dispatch('drizzle/REGISTER_CONTRACT', args);
  },
};
</script>
