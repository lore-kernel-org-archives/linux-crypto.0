Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732F3C4740A
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 22:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4892C222C0
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 22:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbfJEWgT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 18:36:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:14675 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJEWgS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 18:36:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 15:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,261,1566889200"; 
   d="scan'208";a="197007937"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 05 Oct 2019 15:36:16 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iGset-00010l-PS; Sun, 06 Oct 2019 06:36:15 +0800
Date:   Sun, 6 Oct 2019 06:35:44 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 2/53]
 drivers/crypto/inside-secure/safexcel_hash.c:1945:34: sparse: sparse:
 incorrect type in assignment (different base types)
Message-ID: <201910060642.C6F4if7z%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   4fd7d7befdb531920cae8f78afd4938e4a25e421
commit: b98687bb3b10a0e261c445aac227476bf11dab08 [2/53] crypto: inside-secure - Added support for the AES CBCMAC ahash
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout b98687bb3b10a0e261c445aac227476bf11dab08
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/inside-secure/safexcel_hash.c:1845:25: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/inside-secure/safexcel_hash.c:1845:25: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_hash.c:1845:25: sparse:    got restricted __le32 [usertype]
>> drivers/crypto/inside-secure/safexcel_hash.c:1945:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_hash.c:1945:34: sparse:    expected unsigned int
>> drivers/crypto/inside-secure/safexcel_hash.c:1945:34: sparse:    got restricted __be32 [usertype]

vim +1945 drivers/crypto/inside-secure/safexcel_hash.c

  1836	
  1837	static int safexcel_crc32_init(struct ahash_request *areq)
  1838	{
  1839		struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
  1840		struct safexcel_ahash_req *req = ahash_request_ctx(areq);
  1841	
  1842		memset(req, 0, sizeof(*req));
  1843	
  1844		/* Start from loaded key */
> 1845		req->state[0]	= cpu_to_le32(~ctx->ipad[0]);
  1846		/* Set processed to non-zero to enable invalidation detection */
  1847		req->len	= sizeof(u32);
  1848		req->processed	= sizeof(u32);
  1849	
  1850		ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_CRC32;
  1851		req->digest = CONTEXT_CONTROL_DIGEST_XCM;
  1852		req->state_sz = sizeof(u32);
  1853		req->block_sz = sizeof(u32);
  1854	
  1855		return 0;
  1856	}
  1857	
  1858	static int safexcel_crc32_setkey(struct crypto_ahash *tfm, const u8 *key,
  1859					 unsigned int keylen)
  1860	{
  1861		struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
  1862	
  1863		if (keylen != sizeof(u32)) {
  1864			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
  1865			return -EINVAL;
  1866		}
  1867	
  1868		memcpy(ctx->ipad, key, sizeof(u32));
  1869		return 0;
  1870	}
  1871	
  1872	static int safexcel_crc32_digest(struct ahash_request *areq)
  1873	{
  1874		return safexcel_crc32_init(areq) ?: safexcel_ahash_finup(areq);
  1875	}
  1876	
  1877	struct safexcel_alg_template safexcel_alg_crc32 = {
  1878		.type = SAFEXCEL_ALG_TYPE_AHASH,
  1879		.algo_mask = 0,
  1880		.alg.ahash = {
  1881			.init = safexcel_crc32_init,
  1882			.update = safexcel_ahash_update,
  1883			.final = safexcel_ahash_final,
  1884			.finup = safexcel_ahash_finup,
  1885			.digest = safexcel_crc32_digest,
  1886			.setkey = safexcel_crc32_setkey,
  1887			.export = safexcel_ahash_export,
  1888			.import = safexcel_ahash_import,
  1889			.halg = {
  1890				.digestsize = sizeof(u32),
  1891				.statesize = sizeof(struct safexcel_ahash_export_state),
  1892				.base = {
  1893					.cra_name = "crc32",
  1894					.cra_driver_name = "safexcel-crc32",
  1895					.cra_priority = SAFEXCEL_CRA_PRIORITY,
  1896					.cra_flags = CRYPTO_ALG_OPTIONAL_KEY |
  1897						     CRYPTO_ALG_ASYNC |
  1898						     CRYPTO_ALG_KERN_DRIVER_ONLY,
  1899					.cra_blocksize = 1,
  1900					.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
  1901					.cra_init = safexcel_crc32_cra_init,
  1902					.cra_exit = safexcel_ahash_cra_exit,
  1903					.cra_module = THIS_MODULE,
  1904				},
  1905			},
  1906		},
  1907	};
  1908	
  1909	static int safexcel_cbcmac_init(struct ahash_request *areq)
  1910	{
  1911		struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
  1912		struct safexcel_ahash_req *req = ahash_request_ctx(areq);
  1913	
  1914		memset(req, 0, sizeof(*req));
  1915	
  1916		/* Start from loaded keys */
  1917		memcpy(req->state, ctx->ipad, ctx->key_sz);
  1918		/* Set processed to non-zero to enable invalidation detection */
  1919		req->len	= AES_BLOCK_SIZE;
  1920		req->processed	= AES_BLOCK_SIZE;
  1921	
  1922		req->digest   = CONTEXT_CONTROL_DIGEST_XCM;
  1923		req->state_sz = ctx->key_sz;
  1924		req->block_sz = AES_BLOCK_SIZE;
  1925		req->xcbcmac  = true;
  1926	
  1927		return 0;
  1928	}
  1929	
  1930	static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
  1931					 unsigned int len)
  1932	{
  1933		struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
  1934		struct crypto_aes_ctx aes;
  1935		int ret, i;
  1936	
  1937		ret = aes_expandkey(&aes, key, len);
  1938		if (ret) {
  1939			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
  1940			return ret;
  1941		}
  1942	
  1943		memset(ctx->ipad, 0, 2 * AES_BLOCK_SIZE);
  1944		for (i = 0; i < len / sizeof(u32); i++)
> 1945			ctx->ipad[i + 8] = cpu_to_be32(aes.key_enc[i]);
  1946	
  1947		if (len == AES_KEYSIZE_192) {
  1948			ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
  1949			ctx->key_sz = AES_MAX_KEY_SIZE + 2 * AES_BLOCK_SIZE;
  1950		} else if (len == AES_KEYSIZE_256) {
  1951			ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC256;
  1952			ctx->key_sz = AES_MAX_KEY_SIZE + 2 * AES_BLOCK_SIZE;
  1953		} else {
  1954			ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
  1955			ctx->key_sz = AES_MIN_KEY_SIZE + 2 * AES_BLOCK_SIZE;
  1956		}
  1957	
  1958		memzero_explicit(&aes, sizeof(aes));
  1959		return 0;
  1960	}
  1961	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
