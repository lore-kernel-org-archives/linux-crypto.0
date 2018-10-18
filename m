Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36236 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbeJSHks (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 03:40:48 -0400
Date: Fri, 19 Oct 2018 07:36:32 +0800
From: kbuild test robot <lkp@intel.com>
To: Yael Chemla <yael.chemla@foss.arm.com>
Cc: kbuild-all@01.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org,
        Yael Chemla <yael.chemla@foss.arm.com>
Subject: Re: [PATCH 3/3] crypto: ccree: add SM3 support
Message-ID: <201810190734.gAC1zWwm%fengguang.wu@intel.com>
References: <1539867599-20504-4-git-send-email-yael.chemla@foss.arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1539867599-20504-4-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yael,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on crypto/master]
[also build test WARNING on v4.19-rc8 next-20181018]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Yael-Chemla/crypto-ccree-add-SM3-support/20181019-042354
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
config: i386-randconfig-x019-201841 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers/crypto/ccree/cc_hash.c:1729:17: error: 'CC_HW_REV_713' undeclared here (not in a function); did you mean 'CC_HW_REV_712'?
      .min_hw_rev = CC_HW_REV_713,
                    ^~~~~~~~~~~~~
                    CC_HW_REV_712
   drivers/crypto/ccree/cc_hash.c: In function 'cc_init_hash_sram':
   drivers/crypto/ccree/cc_hash.c:1832:40: warning: comparison between pointer and integer
     bool sm3_supported = (drvdata->hw_rev >= CC_HW_REV_713);
                                           ^~
   In file included from include/linux/kernel.h:10:0,
                    from drivers/crypto/ccree/cc_hash.c:4:
   drivers/crypto/ccree/cc_hash.c: In function 'cc_hash_alloc':
   drivers/crypto/ccree/cc_hash.c:1975:22: warning: comparison between pointer and integer
     if (drvdata->hw_rev >= CC_HW_REV_713)
                         ^
   include/linux/compiler.h:58:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/crypto/ccree/cc_hash.c:1975:2: note: in expansion of macro 'if'
     if (drvdata->hw_rev >= CC_HW_REV_713)
     ^~
   drivers/crypto/ccree/cc_hash.c:1975:22: warning: comparison between pointer and integer
     if (drvdata->hw_rev >= CC_HW_REV_713)
                         ^
   include/linux/compiler.h:58:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/crypto/ccree/cc_hash.c:1975:2: note: in expansion of macro 'if'
     if (drvdata->hw_rev >= CC_HW_REV_713)
     ^~
   drivers/crypto/ccree/cc_hash.c:1975:22: warning: comparison between pointer and integer
     if (drvdata->hw_rev >= CC_HW_REV_713)
                         ^
   include/linux/compiler.h:69:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/crypto/ccree/cc_hash.c:1975:2: note: in expansion of macro 'if'
     if (drvdata->hw_rev >= CC_HW_REV_713)
     ^~
   drivers/crypto/ccree/cc_hash.c: In function 'cc_larval_digest_addr':
   drivers/crypto/ccree/cc_hash.c:2252:41: warning: comparison between pointer and integer
     bool sm3_supported = (_drvdata->hw_rev >= CC_HW_REV_713);
                                            ^~

vim +/if +1975 drivers/crypto/ccree/cc_hash.c

  1952	
  1953	int cc_hash_alloc(struct cc_drvdata *drvdata)
  1954	{
  1955		struct cc_hash_handle *hash_handle;
  1956		cc_sram_addr_t sram_buff;
  1957		u32 sram_size_to_alloc;
  1958		struct device *dev = drvdata_to_dev(drvdata);
  1959		int rc = 0;
  1960		int alg;
  1961	
  1962		hash_handle = kzalloc(sizeof(*hash_handle), GFP_KERNEL);
  1963		if (!hash_handle)
  1964			return -ENOMEM;
  1965	
  1966		INIT_LIST_HEAD(&hash_handle->hash_list);
  1967		drvdata->hash_handle = hash_handle;
  1968	
  1969		sram_size_to_alloc = sizeof(digest_len_init) +
  1970				sizeof(md5_init) +
  1971				sizeof(sha1_init) +
  1972				sizeof(sha224_init) +
  1973				sizeof(sha256_init);
  1974	
> 1975		if (drvdata->hw_rev >= CC_HW_REV_713)
  1976			sram_size_to_alloc += sizeof(sm3_init);
  1977	
  1978		if (drvdata->hw_rev >= CC_HW_REV_712)
  1979			sram_size_to_alloc += sizeof(digest_len_sha512_init) +
  1980				sizeof(sha384_init) + sizeof(sha512_init);
  1981	
  1982		sram_buff = cc_sram_alloc(drvdata, sram_size_to_alloc);
  1983		if (sram_buff == NULL_SRAM_ADDR) {
  1984			dev_err(dev, "SRAM pool exhausted\n");
  1985			rc = -ENOMEM;
  1986			goto fail;
  1987		}
  1988	
  1989		/* The initial digest-len offset */
  1990		hash_handle->digest_len_sram_addr = sram_buff;
  1991	
  1992		/*must be set before the alg registration as it is being used there*/
  1993		rc = cc_init_hash_sram(drvdata);
  1994		if (rc) {
  1995			dev_err(dev, "Init digest CONST failed (rc=%d)\n", rc);
  1996			goto fail;
  1997		}
  1998	
  1999		/* ahash registration */
  2000		for (alg = 0; alg < ARRAY_SIZE(driver_hash); alg++) {
  2001			struct cc_hash_alg *t_alg;
  2002			int hw_mode = driver_hash[alg].hw_mode;
  2003	
  2004			/* We either support both HASH and MAC or none */
  2005			if (driver_hash[alg].min_hw_rev > drvdata->hw_rev)
  2006				continue;
  2007			if (driver_hash[alg].is_mac) {
  2008				/* register hmac version */
  2009				t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
  2010				if (IS_ERR(t_alg)) {
  2011					rc = PTR_ERR(t_alg);
  2012					dev_err(dev, "%s alg allocation failed\n",
  2013						driver_hash[alg].driver_name);
  2014					goto fail;
  2015				}
  2016				t_alg->drvdata = drvdata;
  2017	
  2018				rc = crypto_register_ahash(&t_alg->ahash_alg);
  2019				if (rc) {
  2020					dev_err(dev, "%s alg registration failed\n",
  2021						driver_hash[alg].driver_name);
  2022					kfree(t_alg);
  2023					goto fail;
  2024				} else {
  2025					list_add_tail(&t_alg->entry,
  2026						      &hash_handle->hash_list);
  2027				}
  2028			}
  2029			if (hw_mode == DRV_CIPHER_XCBC_MAC ||
  2030			    hw_mode == DRV_CIPHER_CMAC)
  2031				continue;
  2032	
  2033			/* register hash version */
  2034			t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, false);
  2035			if (IS_ERR(t_alg)) {
  2036				rc = PTR_ERR(t_alg);
  2037				dev_err(dev, "%s alg allocation failed\n",
  2038					driver_hash[alg].driver_name);
  2039				goto fail;
  2040			}
  2041			t_alg->drvdata = drvdata;
  2042	
  2043			rc = crypto_register_ahash(&t_alg->ahash_alg);
  2044			if (rc) {
  2045				dev_err(dev, "%s alg registration failed\n",
  2046					driver_hash[alg].driver_name);
  2047				kfree(t_alg);
  2048				goto fail;
  2049			} else {
  2050				list_add_tail(&t_alg->entry, &hash_handle->hash_list);
  2051			}
  2052		}
  2053	
  2054		return 0;
  2055	
  2056	fail:
  2057		kfree(drvdata->hash_handle);
  2058		drvdata->hash_handle = NULL;
  2059		return rc;
  2060	}
  2061	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--uAKRQypu60I7Lcqm
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
dRTyyQOur7YK0wdGdvN/AfxsKl5nrgEA

--uAKRQypu60I7Lcqm--
