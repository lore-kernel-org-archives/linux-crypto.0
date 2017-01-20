From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] crypto: move CCP device driver to misc
Date: Sat, 21 Jan 2017 00:33:41 +0800
Message-ID: <201701210027.ihGnXjEF%fengguang.wu@intel.com>
References: <148484928147.30852.7911360215597694759.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Cc: kbuild-all@01.org, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, lambert.quentin@gmail.com,
        gary.hook@amd.com, linux-kernel@vger.kernel.org,
        Julia.Lawall@lip6.fr, weiyongjun1@huawei.com,
        linux-crypto@vger.kernel.org, umgwanakikbuti@gmail.com,
        brijesh.singh@amd.com
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7594 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752819AbdATQgG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 11:36:06 -0500
Content-Disposition: inline
In-Reply-To: <148484928147.30852.7911360215597694759.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--u3/rZRmxL6MmkK24
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

All errors (new ones prefixed by >>):

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
   drivers/built-in.o: In function `ccp_init_dm_workarea':
>> drivers/misc/amd-sp/ccp-ops.c:141: undefined reference to `dma_pool_alloc'
   drivers/built-in.o: In function `ccp_init_dm_workarea':
   include/linux/dma-mapping.h:190: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_sg_free':
   include/linux/dma-mapping.h:242: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_dm_free':
>> drivers/misc/amd-sp/ccp-ops.c:112: undefined reference to `dma_pool_free'
   drivers/built-in.o: In function `ccp_dm_free':
   include/linux/dma-mapping.h:207: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_init_data':
   include/linux/dma-mapping.h:227: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_destroy':
>> drivers/misc/amd-sp/ccp-dev-v3.c:501: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `ccp_init':
>> drivers/misc/amd-sp/ccp-dev-v3.c:337: undefined reference to `dma_pool_create'
   drivers/misc/amd-sp/ccp-dev-v3.c:456: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `ccp5_destroy':
   include/linux/dma-mapping.h:484: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:490: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp5_init':
>> drivers/misc/amd-sp/ccp-dev-v5.c:676: undefined reference to `dma_pool_create'
   drivers/built-in.o: In function `ccp5_init':
   include/linux/dma-mapping.h:463: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp5_init':
>> drivers/misc/amd-sp/ccp-dev-v5.c:861: undefined reference to `dma_pool_destroy'
   drivers/built-in.o: In function `ccp_platform_probe':
   drivers/misc/amd-sp/ccp-platform.c:148: undefined reference to `devm_ioremap_resource'
   drivers/built-in.o: In function `ccp_platform_probe':
   include/linux/dma-mapping.h:555: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:542: undefined reference to `bad_dma_ops'
   include/linux/dma-mapping.h:544: undefined reference to `bad_dma_ops'
   drivers/built-in.o: In function `ccp_cmd_callback':
   drivers/misc/amd-sp/ccp-dmaengine.c:204: undefined reference to `dma_run_dependencies'
   drivers/built-in.o: In function `ccp_alloc_dma_desc':
   drivers/misc/amd-sp/ccp-dmaengine.c:306: undefined reference to `dma_async_tx_descriptor_init'
   drivers/built-in.o: In function `ccp_dmaengine_register':
   drivers/misc/amd-sp/ccp-dmaengine.c:705: undefined reference to `dma_async_device_register'
   drivers/built-in.o: In function `ccp_dmaengine_unregister':
   drivers/misc/amd-sp/ccp-dmaengine.c:724: undefined reference to `dma_async_device_unregister'
   drivers/built-in.o: In function `img_ascii_lcd_probe':
   drivers/auxdisplay/img-ascii-lcd.c:384: undefined reference to `devm_ioremap_resource'
   collect2: error: ld returned 1 exit status

vim +141 drivers/misc/amd-sp/ccp-ops.c

63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  106  }
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  107  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  108  static void ccp_dm_free(struct ccp_dm_workarea *wa)
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  109  {
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  110  	if (wa->length <= CCP_DMAPOOL_MAX_SIZE) {
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  111  		if (wa->address)
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12 @112  			dma_pool_free(wa->dma_pool, wa->address,
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  113  				      wa->dma.address);
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  114  	} else {
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  115  		if (wa->dma.address)
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  116  			dma_unmap_single(wa->dev, wa->dma.address, wa->length,
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  117  					 wa->dma.dir);
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  118  		kfree(wa->address);
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  119  	}
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  120  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  121  	wa->address = NULL;
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  122  	wa->dma.address = 0;
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  123  }
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  124  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  125  static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  126  				struct ccp_cmd_queue *cmd_q,
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  127  				unsigned int len,
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  128  				enum dma_data_direction dir)
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  129  {
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  130  	memset(wa, 0, sizeof(*wa));
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  131  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  132  	if (!len)
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  133  		return 0;
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  134  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  135  	wa->dev = cmd_q->ccp->dev;
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  136  	wa->length = len;
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  137  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  138  	if (len <= CCP_DMAPOOL_MAX_SIZE) {
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  139  		wa->dma_pool = cmd_q->dma_pool;
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  140  
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12 @141  		wa->address = dma_pool_alloc(wa->dma_pool, GFP_KERNEL,
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  142  					     &wa->dma.address);
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  143  		if (!wa->address)
63b94509 drivers/crypto/ccp/ccp-ops.c Tom Lendacky 2013-11-12  144  			return -ENOMEM;

:::::: The code at line 141 was first introduced by commit
:::::: 63b945091a070d8d4275dc0f7699ba22cd5f9435 crypto: ccp - CCP device driver and interface support

:::::: TO: Tom Lendacky <thomas.lendacky@amd.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--u3/rZRmxL6MmkK24
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
Hb0B+v9mBl5OCh8BAA==

--u3/rZRmxL6MmkK24--
