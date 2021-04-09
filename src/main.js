import Vue from 'vue';
import App from './App.vue';
import router from './router';
import Vuex from 'vuex'

import drizzleVuePlugin from '@drizzle/vue-plugin'
import drizzleOptions from '@/plugins/drizzle'

import '@/assets/css/base.css';
import '@/plugins/element-ui';

Vue.use(Vuex)

const store = new Vuex.Store({ state: {} })
// Register the drizzleVuePlugin
Vue.use(drizzleVuePlugin, { store, drizzleOptions })
Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount('#app');
