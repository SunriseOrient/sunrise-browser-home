<template>
  <div class="head">
    <span class="logo">J.</span>
    <el-icon class="setting">
      <i-ep-more-filled />
    </el-icon>
  </div>

  <Search class="search-component"></Search>
  <Navigation></Navigation>

  <div class="foot">
    <p>© 2026 简语</p>
    <p>{{ speech }}</p>
    <div class="icons"><i class="iconfont ali-github"></i></div>
  </div>
</template>

<script>
import Search from "./components/Search.vue";
import Navigation from "./components/Navigation.vue";

export default {
  name: "app",
  components: {
    Search,
    Navigation,
  },
  data() {
    return {
      speech: "",
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    init() {
      this.loadSpeech();
    },
    loadSpeech() {
      fetch("https://v1.hitokoto.cn")
        .then((response) => response.json())
        .then((data) => {
          let _speech = data.hitokoto;
          if (data.from_who) {
            _speech += ` -- ${data.from_who}`;
          }
          if (data.from) {
            if (!data.from_who) {
              _speech += ` -- `;
            }
            _speech += `《${data.from}》`;
          }
          this.speech = _speech;
        })
        .catch(console.error);
    },
  },
};
</script>

<style lang="scss">
.head {
  position: absolute;
  top: 0;
  width: 100%;
  padding: 20px 30px;
  box-sizing: border-box;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 24px;
  color: var(--text-primary);

  .logo {
    font-family: "Microsoft YaHei", Inter, Helvetica;
    font-weight: 700;
  }

  .setting {
    color: var(--text-secondary);
  }

  @media (max-width: 768px) {
    padding: 15px 20px;
    font-size: 20px;
  }
}

.search-component {
  margin-bottom: 60px;

  @media (max-width: 768px) {
    margin-bottom: 40px;
  }
}

.foot {
  position: absolute;
  bottom: 0;
  width: 100%;
  color: var(--text-secondary);
  font-size: 12px;
  text-align: center;
  padding: 40px 0 50px 0;

  .icons {
    margin-top: 20px;
    color: var(--text-muted);
  }

  & > p {
    margin: 10px 0;
  }

  @media (max-width: 768px) {
    padding: 30px 0 20px 0;
  }
}
</style>
