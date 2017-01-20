From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/2] misc: amd-sp: introduce the AMD Secure Processor
 device
Date: Sat, 21 Jan 2017 03:51:29 +0800
Message-ID: <201701210334.F3DYxq8m%fengguang.wu@intel.com>
References: <148484929157.30852.14374439914599162367.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Cc: kbuild-all@01.org, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, lambert.quentin@gmail.com,
        gary.hook@amd.com, linux-kernel@vger.kernel.org,
        Julia.Lawall@lip6.fr, weiyongjun1@huawei.com,
        linux-crypto@vger.kernel.org, umgwanakikbuti@gmail.com,
        brijesh.singh@amd.com
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148484929157.30852.14374439914599162367.stgit@brijesh-build-machine>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Brijesh,

[auto build test ERROR on cryptodev/master]
[also build test ERROR on next-20170120]
[cannot apply to char-misc/char-misc-testing v4.10-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Brijesh-Singh/Introduce-AMD-Secure-Processor-device/20170120-185157
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: um-allyesconfig (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um 

All error/warnings (new ones prefixed by >>):

warning: (AMD_CCP && SND_SOC_SH4_SIU) selects DMADEVICES which has unmet direct dependencies (HAS_DMA)
   arch/um/drivers/built-in.o: In function `vde_open_real':
   (.text+0xc9a1): warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   arch/um/drivers/built-in.o: In function `vde_open_real':
   (.text+0xc7ec): warning: Using 'getpwuid' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   arch/um/drivers/built-in.o: In function `vde_open_real':
   (.text+0xcb05): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   arch/um/drivers/built-in.o: In function `pcap_nametoaddr':
   (.text+0x1d595): warning: Using 'gethostbyname' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   arch/um/drivers/built-in.o: In function `pcap_nametonetaddr':
   (.text+0x1d635): warning: Using 'getnetbyname' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   arch/um/drivers/built-in.o: In function `pcap_nametoproto':
   (.text+0x1d855): warning: Using 'getprotobyname' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   arch/um/drivers/built-in.o: In function `pcap_nametoport':
   (.text+0x1d687): warning: Using 'getservbyname' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
   crypto/built-in.o: In function `async_memcpy':
   include/linux/dma-mapping.h:257: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:257: undefined reference to `bad_dma_ops'
   crypto/built-in.o: In function `async_xor':
   include/linux/dma-mapping.h:257: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:257: undefined reference to `bad_dma_ops'
   crypto/built-in.o: In function `async_xor_val':
   include/linux/dma-mapping.h:257: undefined reference to `bad_dma_ops'
   crypto/built-in.o:include/linux/dma-mapping.h:257: more undefined references to `bad_dma_ops' follow
   drivers/built-in.o: In function `dwc_desc_get':
>> include/linux/dmapool.h:30: undefined reference to `dma_pool_alloc'
   drivers/built-in.o: In function `dwc_desc_put':
>> drivers/dma/dw/core.c:137: undefined reference to `dma_pool_free'
   drivers/dma/dw/core.c:133: undefined reference to `dma_pool_free'
   drivers/built-in.o: In function `dw_dma_probe':
>> drivers/dma/dw/core.c:1508: undefined reference to `dmam_pool_create'
   drivers/built-in.o: In function `dw_probe':
>> drivers/dma/dw/platform.c:192: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `dw_probe':
   include/linux/dma-mapping.h:555: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `fsl_edma_free_desc':
>> drivers/dma/fsl-edma.c:288: undefined reference to `dma_pool_free'
   drivers/built-in.o: In function `fsl_edma_alloc_desc':
>> drivers/dma/fsl-edma.c:525: undefined reference to `dma_pool_alloc'
   drivers/dma/fsl-edma.c:525: undefined reference to `dma_pool_free'
   drivers/built-in.o: In function `fsl_edma_free_chan_resources':
>> drivers/dma/fsl-edma.c:808: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `fsl_edma_alloc_chan_resources':
>> drivers/dma/fsl-edma.c:788: undefined reference to `dma_pool_create'
   drivers/built-in.o: In function `fsl_edma_probe':
>> drivers/dma/fsl-edma.c:898: undefined reference to `devm_ioremap_resource'
   drivers/dma/fsl-edma.c:906: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `idma64_desc_free':
>> drivers/dma/idma64.c:214: undefined reference to `dma_pool_free'
   drivers/built-in.o: In function `idma64_free_chan_resources':
>> drivers/dma/idma64.c:520: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `idma64_alloc_chan_resources':
>> drivers/dma/idma64.c:504: undefined reference to `dma_pool_create'
   drivers/built-in.o: In function `idma64_platform_probe':
>> drivers/dma/idma64.c:644: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `idma64_platform_probe':
   include/linux/dma-mapping.h:555: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `idma64_prep_slave_sg':
>> drivers/dma/idma64.c:315: undefined reference to `dma_pool_alloc'
   drivers/built-in.o: In function `hidma_mgmt_probe':
>> drivers/dma/qcom/hidma_mgmt.c:165: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `hidma_ll_init':
>> drivers/dma/qcom/hidma_ll.c:749: undefined reference to `dmam_alloc_coherent'
   drivers/built-in.o: In function `hidma_probe':
>> drivers/dma/qcom/hidma.c:735: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `hidma_probe':
   include/linux/dma-mapping.h:555: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   drivers/built-in.o:include/linux/dma-mapping.h:542: more undefined references to `bad_dma_ops' follow
   drivers/built-in.o: In function `sp_platform_probe':
>> drivers/misc/amd-sp/sp-platform.c:133: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `sp_platform_probe':
   include/linux/dma-mapping.h:555: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:555: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_dev_suspend':
>> include/linux/spinlock.h:362: undefined reference to `ccp_queues_suspended'
   drivers/built-in.o: In function `ccp_destroy':
   drivers/misc/amd-sp/ccp-dev-v3.c:534: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `ccp_init':
   drivers/misc/amd-sp/ccp-dev-v3.c:370: undefined reference to `dma_pool_create'
   drivers/misc/amd-sp/ccp-dev-v3.c:489: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `ccp5_destroy':
   include/linux/dma-mapping.h:484: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:490: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp5_init':
   drivers/misc/amd-sp/ccp-dev-v5.c:707: undefined reference to `dma_pool_create'
   drivers/built-in.o: In function `ccp5_init':
   include/linux/dma-mapping.h:463: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp5_init':
   drivers/misc/amd-sp/ccp-dev-v5.c:892: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `ccp_init_dm_workarea':
   drivers/misc/amd-sp/ccp-ops.c:141: undefined reference to `dma_pool_alloc'
   drivers/built-in.o: In function `ccp_init_dm_workarea':
   include/linux/dma-mapping.h:190: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_sg_free':
   include/linux/dma-mapping.h:242: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_dm_free':
   drivers/misc/amd-sp/ccp-ops.c:112: undefined reference to `dma_pool_free'
   drivers/built-in.o: In function `ccp_dm_free':
   include/linux/dma-mapping.h:207: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_init_data':
   include/linux/dma-mapping.h:227: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `img_ascii_lcd_probe':
   drivers/auxdisplay/img-ascii-lcd.c:384: undefined reference to `devm_ioremap_resource'
   collect2: error: ld returned 1 exit status

vim +30 include/linux/dmapool.h

dd0fc66f Al Viro         2005-10-07  24  void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
3a11ec5e Victor Fusco    2005-09-10  25  		     dma_addr_t *handle);
^1da177e Linus Torvalds  2005-04-16  26  
ad82362b Sean O. Stalley 2015-09-08  27  static inline void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
ad82362b Sean O. Stalley 2015-09-08  28  				    dma_addr_t *handle)
ad82362b Sean O. Stalley 2015-09-08  29  {
ad82362b Sean O. Stalley 2015-09-08 @30  	return dma_pool_alloc(pool, mem_flags | __GFP_ZERO, handle);
ad82362b Sean O. Stalley 2015-09-08  31  }
ad82362b Sean O. Stalley 2015-09-08  32  
^1da177e Linus Torvalds  2005-04-16  33  void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t addr);

:::::: The code at line 30 was first introduced by commit
:::::: ad82362b2defd4adad87d8538617b2f51a4bf9c3 mm: add dma_pool_zalloc() call to DMA API

:::::: TO: Sean O. Stalley <sean.stalley@intel.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--h31gzZEtNLTqOjlF
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--h31gzZEtNLTqOjlF--
