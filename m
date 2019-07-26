Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E912C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 17:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EBD42166E
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 17:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfGZRD2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 13:03:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:2956 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbfGZRD1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 13:03:27 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 10:03:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,311,1559545200"; 
   d="gz'50?scan'50,208,50";a="189681682"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jul 2019 10:03:21 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hr3cm-0009Sa-Rs; Sat, 27 Jul 2019 01:03:20 +0800
Date:   Sat, 27 Jul 2019 01:02:21 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 18/80] arch/s390/crypto/aes_s390.c:111:13: error:
 conflicting types for 'aes_encrypt'
Message-ID: <201907270112.i0QEDhxj%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="msmn2ckh56k3jbaw"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--msmn2ckh56k3jbaw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   0fe1c5a77257b9006b0b4b60652927d647bdd1a3
commit: e59c1c98745637796df824c0177f279b6e9cad94 [18/80] crypto: aes - create AES library based on the fixed time AES code
config: s390-debug_defconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout e59c1c98745637796df824c0177f279b6e9cad94
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/s390/crypto/aes_s390.c:111:13: error: conflicting types for 'aes_encrypt'
    static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
                ^~~~~~~~~~~
   In file included from arch/s390/crypto/aes_s390.c:20:0:
   include/crypto/aes.h:64:6: note: previous declaration of 'aes_encrypt' was here
    void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
         ^~~~~~~~~~~
>> arch/s390/crypto/aes_s390.c:122:13: error: conflicting types for 'aes_decrypt'
    static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
                ^~~~~~~~~~~
   In file included from arch/s390/crypto/aes_s390.c:20:0:
   include/crypto/aes.h:72:6: note: previous declaration of 'aes_decrypt' was here
    void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
         ^~~~~~~~~~~

vim +/aes_encrypt +111 arch/s390/crypto/aes_s390.c

b0c3e75d857f378 Sebastian Siewior    2007-12-01   110  
6c2bb98bc33ae33 Herbert Xu           2006-05-16  @111  static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
bf754ae8ef8bc44 Jan Glauber          2006-01-06   112  {
e6a67ad0e290872 Chen Gang            2015-01-01   113  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
bf754ae8ef8bc44 Jan Glauber          2006-01-06   114  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   115  	if (unlikely(!sctx->fc)) {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   116  		crypto_cipher_encrypt_one(sctx->fallback.cip, out, in);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   117  		return;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   118  	}
69c0e360f990c2d Martin Schwidefsky   2016-08-18   119  	cpacf_km(sctx->fc, &sctx->key, out, in, AES_BLOCK_SIZE);
bf754ae8ef8bc44 Jan Glauber          2006-01-06   120  }
bf754ae8ef8bc44 Jan Glauber          2006-01-06   121  
6c2bb98bc33ae33 Herbert Xu           2006-05-16  @122  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
bf754ae8ef8bc44 Jan Glauber          2006-01-06   123  {
e6a67ad0e290872 Chen Gang            2015-01-01   124  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
bf754ae8ef8bc44 Jan Glauber          2006-01-06   125  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   126  	if (unlikely(!sctx->fc)) {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   127  		crypto_cipher_decrypt_one(sctx->fallback.cip, out, in);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   128  		return;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   129  	}
69c0e360f990c2d Martin Schwidefsky   2016-08-18   130  	cpacf_km(sctx->fc | CPACF_DECRYPT,
edc63a3785b4845 Martin Schwidefsky   2016-08-15   131  		 &sctx->key, out, in, AES_BLOCK_SIZE);
bf754ae8ef8bc44 Jan Glauber          2006-01-06   132  }
bf754ae8ef8bc44 Jan Glauber          2006-01-06   133  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   134  static int fallback_init_cip(struct crypto_tfm *tfm)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   135  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   136  	const char *name = tfm->__crt_alg->cra_name;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   137  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   138  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   139  	sctx->fallback.cip = crypto_alloc_cipher(name, 0,
1ad0f1603a6b2af Eric Biggers         2018-11-14   140  						 CRYPTO_ALG_NEED_FALLBACK);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   141  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   142  	if (IS_ERR(sctx->fallback.cip)) {
39f09392498d8ee Jan Glauber          2008-12-25   143  		pr_err("Allocating AES fallback algorithm %s failed\n",
39f09392498d8ee Jan Glauber          2008-12-25   144  		       name);
b59cdcb339fc728 Roel Kluin           2009-12-18   145  		return PTR_ERR(sctx->fallback.cip);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   146  	}
b0c3e75d857f378 Sebastian Siewior    2007-12-01   147  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   148  	return 0;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   149  }
b0c3e75d857f378 Sebastian Siewior    2007-12-01   150  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   151  static void fallback_exit_cip(struct crypto_tfm *tfm)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   152  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   153  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   154  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   155  	crypto_free_cipher(sctx->fallback.cip);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   156  	sctx->fallback.cip = NULL;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   157  }
bf754ae8ef8bc44 Jan Glauber          2006-01-06   158  
bf754ae8ef8bc44 Jan Glauber          2006-01-06   159  static struct crypto_alg aes_alg = {
bf754ae8ef8bc44 Jan Glauber          2006-01-06   160  	.cra_name		=	"aes",
65b75c36f4e8422 Herbert Xu           2006-08-21   161  	.cra_driver_name	=	"aes-s390",
c7d4d259b747786 Martin Schwidefsky   2016-03-17   162  	.cra_priority		=	300,
f67d1369665b2ce Jan Glauber          2007-05-04   163  	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER |
f67d1369665b2ce Jan Glauber          2007-05-04   164  					CRYPTO_ALG_NEED_FALLBACK,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   165  	.cra_blocksize		=	AES_BLOCK_SIZE,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   166  	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
bf754ae8ef8bc44 Jan Glauber          2006-01-06   167  	.cra_module		=	THIS_MODULE,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   168  	.cra_init               =       fallback_init_cip,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   169  	.cra_exit               =       fallback_exit_cip,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   170  	.cra_u			=	{
bf754ae8ef8bc44 Jan Glauber          2006-01-06   171  		.cipher = {
bf754ae8ef8bc44 Jan Glauber          2006-01-06   172  			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   173  			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   174  			.cia_setkey		=	aes_set_key,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   175  			.cia_encrypt		=	aes_encrypt,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   176  			.cia_decrypt		=	aes_decrypt,
bf754ae8ef8bc44 Jan Glauber          2006-01-06   177  		}
bf754ae8ef8bc44 Jan Glauber          2006-01-06   178  	}
bf754ae8ef8bc44 Jan Glauber          2006-01-06   179  };
bf754ae8ef8bc44 Jan Glauber          2006-01-06   180  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   181  static int setkey_fallback_blk(struct crypto_tfm *tfm, const u8 *key,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   182  		unsigned int len)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   183  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   184  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   185  	unsigned int ret;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   186  
531fa5d620b1e81 Kees Cook            2018-09-18   187  	crypto_sync_skcipher_clear_flags(sctx->fallback.blk,
531fa5d620b1e81 Kees Cook            2018-09-18   188  					 CRYPTO_TFM_REQ_MASK);
531fa5d620b1e81 Kees Cook            2018-09-18   189  	crypto_sync_skcipher_set_flags(sctx->fallback.blk, tfm->crt_flags &
b0c3e75d857f378 Sebastian Siewior    2007-12-01   190  						      CRYPTO_TFM_REQ_MASK);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   191  
531fa5d620b1e81 Kees Cook            2018-09-18   192  	ret = crypto_sync_skcipher_setkey(sctx->fallback.blk, key, len);
64e26807bb93b4a Herbert Xu           2016-06-29   193  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   194  	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
531fa5d620b1e81 Kees Cook            2018-09-18   195  	tfm->crt_flags |= crypto_sync_skcipher_get_flags(sctx->fallback.blk) &
64e26807bb93b4a Herbert Xu           2016-06-29   196  			  CRYPTO_TFM_RES_MASK;
64e26807bb93b4a Herbert Xu           2016-06-29   197  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   198  	return ret;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   199  }
b0c3e75d857f378 Sebastian Siewior    2007-12-01   200  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   201  static int fallback_blk_dec(struct blkcipher_desc *desc,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   202  		struct scatterlist *dst, struct scatterlist *src,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   203  		unsigned int nbytes)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   204  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   205  	unsigned int ret;
64e26807bb93b4a Herbert Xu           2016-06-29   206  	struct crypto_blkcipher *tfm = desc->tfm;
64e26807bb93b4a Herbert Xu           2016-06-29   207  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
531fa5d620b1e81 Kees Cook            2018-09-18   208  	SYNC_SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   209  
531fa5d620b1e81 Kees Cook            2018-09-18   210  	skcipher_request_set_sync_tfm(req, sctx->fallback.blk);
64e26807bb93b4a Herbert Xu           2016-06-29   211  	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
64e26807bb93b4a Herbert Xu           2016-06-29   212  	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   213  
64e26807bb93b4a Herbert Xu           2016-06-29   214  	ret = crypto_skcipher_decrypt(req);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   215  
64e26807bb93b4a Herbert Xu           2016-06-29   216  	skcipher_request_zero(req);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   217  	return ret;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   218  }
b0c3e75d857f378 Sebastian Siewior    2007-12-01   219  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   220  static int fallback_blk_enc(struct blkcipher_desc *desc,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   221  		struct scatterlist *dst, struct scatterlist *src,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   222  		unsigned int nbytes)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   223  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   224  	unsigned int ret;
64e26807bb93b4a Herbert Xu           2016-06-29   225  	struct crypto_blkcipher *tfm = desc->tfm;
64e26807bb93b4a Herbert Xu           2016-06-29   226  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
531fa5d620b1e81 Kees Cook            2018-09-18   227  	SYNC_SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   228  
531fa5d620b1e81 Kees Cook            2018-09-18   229  	skcipher_request_set_sync_tfm(req, sctx->fallback.blk);
64e26807bb93b4a Herbert Xu           2016-06-29   230  	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
64e26807bb93b4a Herbert Xu           2016-06-29   231  	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   232  
64e26807bb93b4a Herbert Xu           2016-06-29   233  	ret = crypto_skcipher_encrypt(req);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   234  	return ret;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   235  }
b0c3e75d857f378 Sebastian Siewior    2007-12-01   236  
a9e62fadf0b02ba Herbert Xu           2006-08-21   237  static int ecb_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
a9e62fadf0b02ba Herbert Xu           2006-08-21   238  			   unsigned int key_len)
a9e62fadf0b02ba Herbert Xu           2006-08-21   239  {
a9e62fadf0b02ba Herbert Xu           2006-08-21   240  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   241  	unsigned long fc;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   242  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   243  	/* Pick the correct function code based on the key length */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   244  	fc = (key_len == 16) ? CPACF_KM_AES_128 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   245  	     (key_len == 24) ? CPACF_KM_AES_192 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   246  	     (key_len == 32) ? CPACF_KM_AES_256 : 0;
a9e62fadf0b02ba Herbert Xu           2006-08-21   247  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   248  	/* Check if the function code is available */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   249  	sctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   250  	if (!sctx->fc)
69c0e360f990c2d Martin Schwidefsky   2016-08-18   251  		return setkey_fallback_blk(tfm, in_key, key_len);
a9e62fadf0b02ba Herbert Xu           2006-08-21   252  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   253  	sctx->key_len = key_len;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   254  	memcpy(sctx->key, in_key, key_len);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   255  	return 0;
a9e62fadf0b02ba Herbert Xu           2006-08-21   256  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   257  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   258  static int ecb_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
a9e62fadf0b02ba Herbert Xu           2006-08-21   259  			 struct blkcipher_walk *walk)
a9e62fadf0b02ba Herbert Xu           2006-08-21   260  {
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   261  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   262  	unsigned int nbytes, n;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   263  	int ret;
a9e62fadf0b02ba Herbert Xu           2006-08-21   264  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   265  	ret = blkcipher_walk_virt(desc, walk);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   266  	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
a9e62fadf0b02ba Herbert Xu           2006-08-21   267  		/* only use complete blocks */
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   268  		n = nbytes & ~(AES_BLOCK_SIZE - 1);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   269  		cpacf_km(sctx->fc | modifier, sctx->key,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   270  			 walk->dst.virt.addr, walk->src.virt.addr, n);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   271  		ret = blkcipher_walk_done(desc, walk, nbytes - n);
a9e62fadf0b02ba Herbert Xu           2006-08-21   272  	}
a9e62fadf0b02ba Herbert Xu           2006-08-21   273  
a9e62fadf0b02ba Herbert Xu           2006-08-21   274  	return ret;
a9e62fadf0b02ba Herbert Xu           2006-08-21   275  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   276  
a9e62fadf0b02ba Herbert Xu           2006-08-21   277  static int ecb_aes_encrypt(struct blkcipher_desc *desc,
a9e62fadf0b02ba Herbert Xu           2006-08-21   278  			   struct scatterlist *dst, struct scatterlist *src,
a9e62fadf0b02ba Herbert Xu           2006-08-21   279  			   unsigned int nbytes)
a9e62fadf0b02ba Herbert Xu           2006-08-21   280  {
a9e62fadf0b02ba Herbert Xu           2006-08-21   281  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
a9e62fadf0b02ba Herbert Xu           2006-08-21   282  	struct blkcipher_walk walk;
a9e62fadf0b02ba Herbert Xu           2006-08-21   283  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   284  	if (unlikely(!sctx->fc))
b0c3e75d857f378 Sebastian Siewior    2007-12-01   285  		return fallback_blk_enc(desc, dst, src, nbytes);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   286  
a9e62fadf0b02ba Herbert Xu           2006-08-21   287  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   288  	return ecb_aes_crypt(desc, 0, &walk);
a9e62fadf0b02ba Herbert Xu           2006-08-21   289  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   290  
a9e62fadf0b02ba Herbert Xu           2006-08-21   291  static int ecb_aes_decrypt(struct blkcipher_desc *desc,
a9e62fadf0b02ba Herbert Xu           2006-08-21   292  			   struct scatterlist *dst, struct scatterlist *src,
a9e62fadf0b02ba Herbert Xu           2006-08-21   293  			   unsigned int nbytes)
a9e62fadf0b02ba Herbert Xu           2006-08-21   294  {
a9e62fadf0b02ba Herbert Xu           2006-08-21   295  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
a9e62fadf0b02ba Herbert Xu           2006-08-21   296  	struct blkcipher_walk walk;
a9e62fadf0b02ba Herbert Xu           2006-08-21   297  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   298  	if (unlikely(!sctx->fc))
b0c3e75d857f378 Sebastian Siewior    2007-12-01   299  		return fallback_blk_dec(desc, dst, src, nbytes);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   300  
a9e62fadf0b02ba Herbert Xu           2006-08-21   301  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   302  	return ecb_aes_crypt(desc, CPACF_DECRYPT, &walk);
a9e62fadf0b02ba Herbert Xu           2006-08-21   303  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   304  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   305  static int fallback_init_blk(struct crypto_tfm *tfm)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   306  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   307  	const char *name = tfm->__crt_alg->cra_name;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   308  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   309  
531fa5d620b1e81 Kees Cook            2018-09-18   310  	sctx->fallback.blk = crypto_alloc_sync_skcipher(name, 0,
64e26807bb93b4a Herbert Xu           2016-06-29   311  						   CRYPTO_ALG_NEED_FALLBACK);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   312  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   313  	if (IS_ERR(sctx->fallback.blk)) {
39f09392498d8ee Jan Glauber          2008-12-25   314  		pr_err("Allocating AES fallback algorithm %s failed\n",
39f09392498d8ee Jan Glauber          2008-12-25   315  		       name);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   316  		return PTR_ERR(sctx->fallback.blk);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   317  	}
b0c3e75d857f378 Sebastian Siewior    2007-12-01   318  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   319  	return 0;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   320  }
b0c3e75d857f378 Sebastian Siewior    2007-12-01   321  
b0c3e75d857f378 Sebastian Siewior    2007-12-01   322  static void fallback_exit_blk(struct crypto_tfm *tfm)
b0c3e75d857f378 Sebastian Siewior    2007-12-01   323  {
b0c3e75d857f378 Sebastian Siewior    2007-12-01   324  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   325  
531fa5d620b1e81 Kees Cook            2018-09-18   326  	crypto_free_sync_skcipher(sctx->fallback.blk);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   327  }
b0c3e75d857f378 Sebastian Siewior    2007-12-01   328  
a9e62fadf0b02ba Herbert Xu           2006-08-21   329  static struct crypto_alg ecb_aes_alg = {
a9e62fadf0b02ba Herbert Xu           2006-08-21   330  	.cra_name		=	"ecb(aes)",
a9e62fadf0b02ba Herbert Xu           2006-08-21   331  	.cra_driver_name	=	"ecb-aes-s390",
aff304e7a0e8f92 Harald Freudenberger 2018-04-05   332  	.cra_priority		=	401,	/* combo: aes + ecb + 1 */
f67d1369665b2ce Jan Glauber          2007-05-04   333  	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
f67d1369665b2ce Jan Glauber          2007-05-04   334  					CRYPTO_ALG_NEED_FALLBACK,
a9e62fadf0b02ba Herbert Xu           2006-08-21   335  	.cra_blocksize		=	AES_BLOCK_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   336  	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
a9e62fadf0b02ba Herbert Xu           2006-08-21   337  	.cra_type		=	&crypto_blkcipher_type,
a9e62fadf0b02ba Herbert Xu           2006-08-21   338  	.cra_module		=	THIS_MODULE,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   339  	.cra_init		=	fallback_init_blk,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   340  	.cra_exit		=	fallback_exit_blk,
a9e62fadf0b02ba Herbert Xu           2006-08-21   341  	.cra_u			=	{
a9e62fadf0b02ba Herbert Xu           2006-08-21   342  		.blkcipher = {
a9e62fadf0b02ba Herbert Xu           2006-08-21   343  			.min_keysize		=	AES_MIN_KEY_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   344  			.max_keysize		=	AES_MAX_KEY_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   345  			.setkey			=	ecb_aes_set_key,
a9e62fadf0b02ba Herbert Xu           2006-08-21   346  			.encrypt		=	ecb_aes_encrypt,
a9e62fadf0b02ba Herbert Xu           2006-08-21   347  			.decrypt		=	ecb_aes_decrypt,
a9e62fadf0b02ba Herbert Xu           2006-08-21   348  		}
a9e62fadf0b02ba Herbert Xu           2006-08-21   349  	}
a9e62fadf0b02ba Herbert Xu           2006-08-21   350  };
a9e62fadf0b02ba Herbert Xu           2006-08-21   351  
a9e62fadf0b02ba Herbert Xu           2006-08-21   352  static int cbc_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
a9e62fadf0b02ba Herbert Xu           2006-08-21   353  			   unsigned int key_len)
a9e62fadf0b02ba Herbert Xu           2006-08-21   354  {
a9e62fadf0b02ba Herbert Xu           2006-08-21   355  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   356  	unsigned long fc;
b0c3e75d857f378 Sebastian Siewior    2007-12-01   357  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   358  	/* Pick the correct function code based on the key length */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   359  	fc = (key_len == 16) ? CPACF_KMC_AES_128 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   360  	     (key_len == 24) ? CPACF_KMC_AES_192 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   361  	     (key_len == 32) ? CPACF_KMC_AES_256 : 0;
a9e62fadf0b02ba Herbert Xu           2006-08-21   362  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   363  	/* Check if the function code is available */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   364  	sctx->fc = (fc && cpacf_test_func(&kmc_functions, fc)) ? fc : 0;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   365  	if (!sctx->fc)
69c0e360f990c2d Martin Schwidefsky   2016-08-18   366  		return setkey_fallback_blk(tfm, in_key, key_len);
a9e62fadf0b02ba Herbert Xu           2006-08-21   367  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   368  	sctx->key_len = key_len;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   369  	memcpy(sctx->key, in_key, key_len);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   370  	return 0;
a9e62fadf0b02ba Herbert Xu           2006-08-21   371  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   372  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   373  static int cbc_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
a9e62fadf0b02ba Herbert Xu           2006-08-21   374  			 struct blkcipher_walk *walk)
a9e62fadf0b02ba Herbert Xu           2006-08-21   375  {
f262f0f5cad0c9e Herbert Xu           2013-11-05   376  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   377  	unsigned int nbytes, n;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   378  	int ret;
f262f0f5cad0c9e Herbert Xu           2013-11-05   379  	struct {
f262f0f5cad0c9e Herbert Xu           2013-11-05   380  		u8 iv[AES_BLOCK_SIZE];
f262f0f5cad0c9e Herbert Xu           2013-11-05   381  		u8 key[AES_MAX_KEY_SIZE];
f262f0f5cad0c9e Herbert Xu           2013-11-05   382  	} param;
a9e62fadf0b02ba Herbert Xu           2006-08-21   383  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   384  	ret = blkcipher_walk_virt(desc, walk);
f262f0f5cad0c9e Herbert Xu           2013-11-05   385  	memcpy(param.iv, walk->iv, AES_BLOCK_SIZE);
f262f0f5cad0c9e Herbert Xu           2013-11-05   386  	memcpy(param.key, sctx->key, sctx->key_len);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   387  	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
a9e62fadf0b02ba Herbert Xu           2006-08-21   388  		/* only use complete blocks */
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   389  		n = nbytes & ~(AES_BLOCK_SIZE - 1);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   390  		cpacf_kmc(sctx->fc | modifier, &param,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   391  			  walk->dst.virt.addr, walk->src.virt.addr, n);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   392  		ret = blkcipher_walk_done(desc, walk, nbytes - n);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   393  	}
f262f0f5cad0c9e Herbert Xu           2013-11-05   394  	memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
a9e62fadf0b02ba Herbert Xu           2006-08-21   395  	return ret;
a9e62fadf0b02ba Herbert Xu           2006-08-21   396  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   397  
a9e62fadf0b02ba Herbert Xu           2006-08-21   398  static int cbc_aes_encrypt(struct blkcipher_desc *desc,
a9e62fadf0b02ba Herbert Xu           2006-08-21   399  			   struct scatterlist *dst, struct scatterlist *src,
a9e62fadf0b02ba Herbert Xu           2006-08-21   400  			   unsigned int nbytes)
a9e62fadf0b02ba Herbert Xu           2006-08-21   401  {
a9e62fadf0b02ba Herbert Xu           2006-08-21   402  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
a9e62fadf0b02ba Herbert Xu           2006-08-21   403  	struct blkcipher_walk walk;
a9e62fadf0b02ba Herbert Xu           2006-08-21   404  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   405  	if (unlikely(!sctx->fc))
b0c3e75d857f378 Sebastian Siewior    2007-12-01   406  		return fallback_blk_enc(desc, dst, src, nbytes);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   407  
a9e62fadf0b02ba Herbert Xu           2006-08-21   408  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   409  	return cbc_aes_crypt(desc, 0, &walk);
a9e62fadf0b02ba Herbert Xu           2006-08-21   410  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   411  
a9e62fadf0b02ba Herbert Xu           2006-08-21   412  static int cbc_aes_decrypt(struct blkcipher_desc *desc,
a9e62fadf0b02ba Herbert Xu           2006-08-21   413  			   struct scatterlist *dst, struct scatterlist *src,
a9e62fadf0b02ba Herbert Xu           2006-08-21   414  			   unsigned int nbytes)
a9e62fadf0b02ba Herbert Xu           2006-08-21   415  {
a9e62fadf0b02ba Herbert Xu           2006-08-21   416  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
a9e62fadf0b02ba Herbert Xu           2006-08-21   417  	struct blkcipher_walk walk;
a9e62fadf0b02ba Herbert Xu           2006-08-21   418  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   419  	if (unlikely(!sctx->fc))
b0c3e75d857f378 Sebastian Siewior    2007-12-01   420  		return fallback_blk_dec(desc, dst, src, nbytes);
b0c3e75d857f378 Sebastian Siewior    2007-12-01   421  
a9e62fadf0b02ba Herbert Xu           2006-08-21   422  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   423  	return cbc_aes_crypt(desc, CPACF_DECRYPT, &walk);
a9e62fadf0b02ba Herbert Xu           2006-08-21   424  }
a9e62fadf0b02ba Herbert Xu           2006-08-21   425  
a9e62fadf0b02ba Herbert Xu           2006-08-21   426  static struct crypto_alg cbc_aes_alg = {
a9e62fadf0b02ba Herbert Xu           2006-08-21   427  	.cra_name		=	"cbc(aes)",
a9e62fadf0b02ba Herbert Xu           2006-08-21   428  	.cra_driver_name	=	"cbc-aes-s390",
aff304e7a0e8f92 Harald Freudenberger 2018-04-05   429  	.cra_priority		=	402,	/* ecb-aes-s390 + 1 */
f67d1369665b2ce Jan Glauber          2007-05-04   430  	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
f67d1369665b2ce Jan Glauber          2007-05-04   431  					CRYPTO_ALG_NEED_FALLBACK,
a9e62fadf0b02ba Herbert Xu           2006-08-21   432  	.cra_blocksize		=	AES_BLOCK_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   433  	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
a9e62fadf0b02ba Herbert Xu           2006-08-21   434  	.cra_type		=	&crypto_blkcipher_type,
a9e62fadf0b02ba Herbert Xu           2006-08-21   435  	.cra_module		=	THIS_MODULE,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   436  	.cra_init		=	fallback_init_blk,
b0c3e75d857f378 Sebastian Siewior    2007-12-01   437  	.cra_exit		=	fallback_exit_blk,
a9e62fadf0b02ba Herbert Xu           2006-08-21   438  	.cra_u			=	{
a9e62fadf0b02ba Herbert Xu           2006-08-21   439  		.blkcipher = {
a9e62fadf0b02ba Herbert Xu           2006-08-21   440  			.min_keysize		=	AES_MIN_KEY_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   441  			.max_keysize		=	AES_MAX_KEY_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   442  			.ivsize			=	AES_BLOCK_SIZE,
a9e62fadf0b02ba Herbert Xu           2006-08-21   443  			.setkey			=	cbc_aes_set_key,
a9e62fadf0b02ba Herbert Xu           2006-08-21   444  			.encrypt		=	cbc_aes_encrypt,
a9e62fadf0b02ba Herbert Xu           2006-08-21   445  			.decrypt		=	cbc_aes_decrypt,
a9e62fadf0b02ba Herbert Xu           2006-08-21   446  		}
a9e62fadf0b02ba Herbert Xu           2006-08-21   447  	}
a9e62fadf0b02ba Herbert Xu           2006-08-21   448  };
a9e62fadf0b02ba Herbert Xu           2006-08-21   449  
99d97222150a24e Gerald Schaefer      2011-04-26   450  static int xts_fallback_setkey(struct crypto_tfm *tfm, const u8 *key,
99d97222150a24e Gerald Schaefer      2011-04-26   451  				   unsigned int len)
99d97222150a24e Gerald Schaefer      2011-04-26   452  {
99d97222150a24e Gerald Schaefer      2011-04-26   453  	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
99d97222150a24e Gerald Schaefer      2011-04-26   454  	unsigned int ret;
99d97222150a24e Gerald Schaefer      2011-04-26   455  
531fa5d620b1e81 Kees Cook            2018-09-18   456  	crypto_sync_skcipher_clear_flags(xts_ctx->fallback,
531fa5d620b1e81 Kees Cook            2018-09-18   457  					 CRYPTO_TFM_REQ_MASK);
531fa5d620b1e81 Kees Cook            2018-09-18   458  	crypto_sync_skcipher_set_flags(xts_ctx->fallback, tfm->crt_flags &
99d97222150a24e Gerald Schaefer      2011-04-26   459  						     CRYPTO_TFM_REQ_MASK);
99d97222150a24e Gerald Schaefer      2011-04-26   460  
531fa5d620b1e81 Kees Cook            2018-09-18   461  	ret = crypto_sync_skcipher_setkey(xts_ctx->fallback, key, len);
64e26807bb93b4a Herbert Xu           2016-06-29   462  
99d97222150a24e Gerald Schaefer      2011-04-26   463  	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
531fa5d620b1e81 Kees Cook            2018-09-18   464  	tfm->crt_flags |= crypto_sync_skcipher_get_flags(xts_ctx->fallback) &
64e26807bb93b4a Herbert Xu           2016-06-29   465  			  CRYPTO_TFM_RES_MASK;
64e26807bb93b4a Herbert Xu           2016-06-29   466  
99d97222150a24e Gerald Schaefer      2011-04-26   467  	return ret;
99d97222150a24e Gerald Schaefer      2011-04-26   468  }
99d97222150a24e Gerald Schaefer      2011-04-26   469  
99d97222150a24e Gerald Schaefer      2011-04-26   470  static int xts_fallback_decrypt(struct blkcipher_desc *desc,
99d97222150a24e Gerald Schaefer      2011-04-26   471  		struct scatterlist *dst, struct scatterlist *src,
99d97222150a24e Gerald Schaefer      2011-04-26   472  		unsigned int nbytes)
99d97222150a24e Gerald Schaefer      2011-04-26   473  {
64e26807bb93b4a Herbert Xu           2016-06-29   474  	struct crypto_blkcipher *tfm = desc->tfm;
64e26807bb93b4a Herbert Xu           2016-06-29   475  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
531fa5d620b1e81 Kees Cook            2018-09-18   476  	SYNC_SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
99d97222150a24e Gerald Schaefer      2011-04-26   477  	unsigned int ret;
99d97222150a24e Gerald Schaefer      2011-04-26   478  
531fa5d620b1e81 Kees Cook            2018-09-18   479  	skcipher_request_set_sync_tfm(req, xts_ctx->fallback);
64e26807bb93b4a Herbert Xu           2016-06-29   480  	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
64e26807bb93b4a Herbert Xu           2016-06-29   481  	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
99d97222150a24e Gerald Schaefer      2011-04-26   482  
64e26807bb93b4a Herbert Xu           2016-06-29   483  	ret = crypto_skcipher_decrypt(req);
99d97222150a24e Gerald Schaefer      2011-04-26   484  
64e26807bb93b4a Herbert Xu           2016-06-29   485  	skcipher_request_zero(req);
99d97222150a24e Gerald Schaefer      2011-04-26   486  	return ret;
99d97222150a24e Gerald Schaefer      2011-04-26   487  }
99d97222150a24e Gerald Schaefer      2011-04-26   488  
99d97222150a24e Gerald Schaefer      2011-04-26   489  static int xts_fallback_encrypt(struct blkcipher_desc *desc,
99d97222150a24e Gerald Schaefer      2011-04-26   490  		struct scatterlist *dst, struct scatterlist *src,
99d97222150a24e Gerald Schaefer      2011-04-26   491  		unsigned int nbytes)
99d97222150a24e Gerald Schaefer      2011-04-26   492  {
64e26807bb93b4a Herbert Xu           2016-06-29   493  	struct crypto_blkcipher *tfm = desc->tfm;
64e26807bb93b4a Herbert Xu           2016-06-29   494  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
531fa5d620b1e81 Kees Cook            2018-09-18   495  	SYNC_SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
99d97222150a24e Gerald Schaefer      2011-04-26   496  	unsigned int ret;
99d97222150a24e Gerald Schaefer      2011-04-26   497  
531fa5d620b1e81 Kees Cook            2018-09-18   498  	skcipher_request_set_sync_tfm(req, xts_ctx->fallback);
64e26807bb93b4a Herbert Xu           2016-06-29   499  	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
64e26807bb93b4a Herbert Xu           2016-06-29   500  	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
99d97222150a24e Gerald Schaefer      2011-04-26   501  
64e26807bb93b4a Herbert Xu           2016-06-29   502  	ret = crypto_skcipher_encrypt(req);
99d97222150a24e Gerald Schaefer      2011-04-26   503  
64e26807bb93b4a Herbert Xu           2016-06-29   504  	skcipher_request_zero(req);
99d97222150a24e Gerald Schaefer      2011-04-26   505  	return ret;
99d97222150a24e Gerald Schaefer      2011-04-26   506  }
99d97222150a24e Gerald Schaefer      2011-04-26   507  
99d97222150a24e Gerald Schaefer      2011-04-26   508  static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
99d97222150a24e Gerald Schaefer      2011-04-26   509  			   unsigned int key_len)
99d97222150a24e Gerald Schaefer      2011-04-26   510  {
99d97222150a24e Gerald Schaefer      2011-04-26   511  	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   512  	unsigned long fc;
28856a9e52c7cac Stephan Mueller      2016-02-09   513  	int err;
28856a9e52c7cac Stephan Mueller      2016-02-09   514  
28856a9e52c7cac Stephan Mueller      2016-02-09   515  	err = xts_check_key(tfm, in_key, key_len);
28856a9e52c7cac Stephan Mueller      2016-02-09   516  	if (err)
28856a9e52c7cac Stephan Mueller      2016-02-09   517  		return err;
99d97222150a24e Gerald Schaefer      2011-04-26   518  
a4f2779ecf2f42b Harald Freudenberger 2016-12-15   519  	/* In fips mode only 128 bit or 256 bit keys are valid */
a4f2779ecf2f42b Harald Freudenberger 2016-12-15   520  	if (fips_enabled && key_len != 32 && key_len != 64) {
a4f2779ecf2f42b Harald Freudenberger 2016-12-15   521  		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
a4f2779ecf2f42b Harald Freudenberger 2016-12-15   522  		return -EINVAL;
a4f2779ecf2f42b Harald Freudenberger 2016-12-15   523  	}
a4f2779ecf2f42b Harald Freudenberger 2016-12-15   524  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   525  	/* Pick the correct function code based on the key length */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   526  	fc = (key_len == 32) ? CPACF_KM_XTS_128 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   527  	     (key_len == 64) ? CPACF_KM_XTS_256 : 0;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   528  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   529  	/* Check if the function code is available */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   530  	xts_ctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   531  	if (!xts_ctx->fc)
69c0e360f990c2d Martin Schwidefsky   2016-08-18   532  		return xts_fallback_setkey(tfm, in_key, key_len);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   533  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   534  	/* Split the XTS key into the two subkeys */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   535  	key_len = key_len / 2;
99d97222150a24e Gerald Schaefer      2011-04-26   536  	xts_ctx->key_len = key_len;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   537  	memcpy(xts_ctx->key, in_key, key_len);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   538  	memcpy(xts_ctx->pcc_key, in_key + key_len, key_len);
99d97222150a24e Gerald Schaefer      2011-04-26   539  	return 0;
99d97222150a24e Gerald Schaefer      2011-04-26   540  }
99d97222150a24e Gerald Schaefer      2011-04-26   541  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   542  static int xts_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
99d97222150a24e Gerald Schaefer      2011-04-26   543  			 struct blkcipher_walk *walk)
99d97222150a24e Gerald Schaefer      2011-04-26   544  {
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   545  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   546  	unsigned int offset, nbytes, n;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   547  	int ret;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   548  	struct {
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   549  		u8 key[32];
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   550  		u8 tweak[16];
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   551  		u8 block[16];
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   552  		u8 bit[16];
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   553  		u8 xts[16];
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   554  	} pcc_param;
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   555  	struct {
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   556  		u8 key[32];
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   557  		u8 init[16];
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   558  	} xts_param;
99d97222150a24e Gerald Schaefer      2011-04-26   559  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   560  	ret = blkcipher_walk_virt(desc, walk);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   561  	offset = xts_ctx->key_len & 0x10;
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   562  	memset(pcc_param.block, 0, sizeof(pcc_param.block));
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   563  	memset(pcc_param.bit, 0, sizeof(pcc_param.bit));
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   564  	memset(pcc_param.xts, 0, sizeof(pcc_param.xts));
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   565  	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
69c0e360f990c2d Martin Schwidefsky   2016-08-18   566  	memcpy(pcc_param.key + offset, xts_ctx->pcc_key, xts_ctx->key_len);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   567  	cpacf_pcc(xts_ctx->fc, pcc_param.key + offset);
99d97222150a24e Gerald Schaefer      2011-04-26   568  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   569  	memcpy(xts_param.key + offset, xts_ctx->key, xts_ctx->key_len);
9dda2769af4f3f3 Gerald Schaefer      2013-11-19   570  	memcpy(xts_param.init, pcc_param.xts, 16);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   571  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   572  	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
99d97222150a24e Gerald Schaefer      2011-04-26   573  		/* only use complete blocks */
99d97222150a24e Gerald Schaefer      2011-04-26   574  		n = nbytes & ~(AES_BLOCK_SIZE - 1);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   575  		cpacf_km(xts_ctx->fc | modifier, xts_param.key + offset,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   576  			 walk->dst.virt.addr, walk->src.virt.addr, n);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   577  		ret = blkcipher_walk_done(desc, walk, nbytes - n);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   578  	}
99d97222150a24e Gerald Schaefer      2011-04-26   579  	return ret;
99d97222150a24e Gerald Schaefer      2011-04-26   580  }
99d97222150a24e Gerald Schaefer      2011-04-26   581  
99d97222150a24e Gerald Schaefer      2011-04-26   582  static int xts_aes_encrypt(struct blkcipher_desc *desc,
99d97222150a24e Gerald Schaefer      2011-04-26   583  			   struct scatterlist *dst, struct scatterlist *src,
99d97222150a24e Gerald Schaefer      2011-04-26   584  			   unsigned int nbytes)
99d97222150a24e Gerald Schaefer      2011-04-26   585  {
99d97222150a24e Gerald Schaefer      2011-04-26   586  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
99d97222150a24e Gerald Schaefer      2011-04-26   587  	struct blkcipher_walk walk;
99d97222150a24e Gerald Schaefer      2011-04-26   588  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   589  	if (unlikely(!xts_ctx->fc))
99d97222150a24e Gerald Schaefer      2011-04-26   590  		return xts_fallback_encrypt(desc, dst, src, nbytes);
99d97222150a24e Gerald Schaefer      2011-04-26   591  
99d97222150a24e Gerald Schaefer      2011-04-26   592  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   593  	return xts_aes_crypt(desc, 0, &walk);
99d97222150a24e Gerald Schaefer      2011-04-26   594  }
99d97222150a24e Gerald Schaefer      2011-04-26   595  
99d97222150a24e Gerald Schaefer      2011-04-26   596  static int xts_aes_decrypt(struct blkcipher_desc *desc,
99d97222150a24e Gerald Schaefer      2011-04-26   597  			   struct scatterlist *dst, struct scatterlist *src,
99d97222150a24e Gerald Schaefer      2011-04-26   598  			   unsigned int nbytes)
99d97222150a24e Gerald Schaefer      2011-04-26   599  {
99d97222150a24e Gerald Schaefer      2011-04-26   600  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
99d97222150a24e Gerald Schaefer      2011-04-26   601  	struct blkcipher_walk walk;
99d97222150a24e Gerald Schaefer      2011-04-26   602  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   603  	if (unlikely(!xts_ctx->fc))
99d97222150a24e Gerald Schaefer      2011-04-26   604  		return xts_fallback_decrypt(desc, dst, src, nbytes);
99d97222150a24e Gerald Schaefer      2011-04-26   605  
99d97222150a24e Gerald Schaefer      2011-04-26   606  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   607  	return xts_aes_crypt(desc, CPACF_DECRYPT, &walk);
99d97222150a24e Gerald Schaefer      2011-04-26   608  }
99d97222150a24e Gerald Schaefer      2011-04-26   609  
99d97222150a24e Gerald Schaefer      2011-04-26   610  static int xts_fallback_init(struct crypto_tfm *tfm)
99d97222150a24e Gerald Schaefer      2011-04-26   611  {
99d97222150a24e Gerald Schaefer      2011-04-26   612  	const char *name = tfm->__crt_alg->cra_name;
99d97222150a24e Gerald Schaefer      2011-04-26   613  	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
99d97222150a24e Gerald Schaefer      2011-04-26   614  
531fa5d620b1e81 Kees Cook            2018-09-18   615  	xts_ctx->fallback = crypto_alloc_sync_skcipher(name, 0,
64e26807bb93b4a Herbert Xu           2016-06-29   616  						  CRYPTO_ALG_NEED_FALLBACK);
99d97222150a24e Gerald Schaefer      2011-04-26   617  
99d97222150a24e Gerald Schaefer      2011-04-26   618  	if (IS_ERR(xts_ctx->fallback)) {
99d97222150a24e Gerald Schaefer      2011-04-26   619  		pr_err("Allocating XTS fallback algorithm %s failed\n",
99d97222150a24e Gerald Schaefer      2011-04-26   620  		       name);
99d97222150a24e Gerald Schaefer      2011-04-26   621  		return PTR_ERR(xts_ctx->fallback);
99d97222150a24e Gerald Schaefer      2011-04-26   622  	}
99d97222150a24e Gerald Schaefer      2011-04-26   623  	return 0;
99d97222150a24e Gerald Schaefer      2011-04-26   624  }
99d97222150a24e Gerald Schaefer      2011-04-26   625  
99d97222150a24e Gerald Schaefer      2011-04-26   626  static void xts_fallback_exit(struct crypto_tfm *tfm)
99d97222150a24e Gerald Schaefer      2011-04-26   627  {
99d97222150a24e Gerald Schaefer      2011-04-26   628  	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
99d97222150a24e Gerald Schaefer      2011-04-26   629  
531fa5d620b1e81 Kees Cook            2018-09-18   630  	crypto_free_sync_skcipher(xts_ctx->fallback);
99d97222150a24e Gerald Schaefer      2011-04-26   631  }
99d97222150a24e Gerald Schaefer      2011-04-26   632  
99d97222150a24e Gerald Schaefer      2011-04-26   633  static struct crypto_alg xts_aes_alg = {
99d97222150a24e Gerald Schaefer      2011-04-26   634  	.cra_name		=	"xts(aes)",
99d97222150a24e Gerald Schaefer      2011-04-26   635  	.cra_driver_name	=	"xts-aes-s390",
aff304e7a0e8f92 Harald Freudenberger 2018-04-05   636  	.cra_priority		=	402,	/* ecb-aes-s390 + 1 */
99d97222150a24e Gerald Schaefer      2011-04-26   637  	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
99d97222150a24e Gerald Schaefer      2011-04-26   638  					CRYPTO_ALG_NEED_FALLBACK,
99d97222150a24e Gerald Schaefer      2011-04-26   639  	.cra_blocksize		=	AES_BLOCK_SIZE,
99d97222150a24e Gerald Schaefer      2011-04-26   640  	.cra_ctxsize		=	sizeof(struct s390_xts_ctx),
99d97222150a24e Gerald Schaefer      2011-04-26   641  	.cra_type		=	&crypto_blkcipher_type,
99d97222150a24e Gerald Schaefer      2011-04-26   642  	.cra_module		=	THIS_MODULE,
99d97222150a24e Gerald Schaefer      2011-04-26   643  	.cra_init		=	xts_fallback_init,
99d97222150a24e Gerald Schaefer      2011-04-26   644  	.cra_exit		=	xts_fallback_exit,
99d97222150a24e Gerald Schaefer      2011-04-26   645  	.cra_u			=	{
99d97222150a24e Gerald Schaefer      2011-04-26   646  		.blkcipher = {
99d97222150a24e Gerald Schaefer      2011-04-26   647  			.min_keysize		=	2 * AES_MIN_KEY_SIZE,
99d97222150a24e Gerald Schaefer      2011-04-26   648  			.max_keysize		=	2 * AES_MAX_KEY_SIZE,
99d97222150a24e Gerald Schaefer      2011-04-26   649  			.ivsize			=	AES_BLOCK_SIZE,
99d97222150a24e Gerald Schaefer      2011-04-26   650  			.setkey			=	xts_aes_set_key,
99d97222150a24e Gerald Schaefer      2011-04-26   651  			.encrypt		=	xts_aes_encrypt,
99d97222150a24e Gerald Schaefer      2011-04-26   652  			.decrypt		=	xts_aes_decrypt,
99d97222150a24e Gerald Schaefer      2011-04-26   653  		}
99d97222150a24e Gerald Schaefer      2011-04-26   654  	}
99d97222150a24e Gerald Schaefer      2011-04-26   655  };
99d97222150a24e Gerald Schaefer      2011-04-26   656  
0200f3ecc19660b Gerald Schaefer      2011-05-04   657  static int ctr_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
0200f3ecc19660b Gerald Schaefer      2011-05-04   658  			   unsigned int key_len)
0200f3ecc19660b Gerald Schaefer      2011-05-04   659  {
0200f3ecc19660b Gerald Schaefer      2011-05-04   660  	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   661  	unsigned long fc;
0200f3ecc19660b Gerald Schaefer      2011-05-04   662  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   663  	/* Pick the correct function code based on the key length */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   664  	fc = (key_len == 16) ? CPACF_KMCTR_AES_128 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   665  	     (key_len == 24) ? CPACF_KMCTR_AES_192 :
69c0e360f990c2d Martin Schwidefsky   2016-08-18   666  	     (key_len == 32) ? CPACF_KMCTR_AES_256 : 0;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   667  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   668  	/* Check if the function code is available */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   669  	sctx->fc = (fc && cpacf_test_func(&kmctr_functions, fc)) ? fc : 0;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   670  	if (!sctx->fc)
69c0e360f990c2d Martin Schwidefsky   2016-08-18   671  		return setkey_fallback_blk(tfm, in_key, key_len);
0200f3ecc19660b Gerald Schaefer      2011-05-04   672  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   673  	sctx->key_len = key_len;
69c0e360f990c2d Martin Schwidefsky   2016-08-18   674  	memcpy(sctx->key, in_key, key_len);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   675  	return 0;
0200f3ecc19660b Gerald Schaefer      2011-05-04   676  }
0200f3ecc19660b Gerald Schaefer      2011-05-04   677  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   678  static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   679  {
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   680  	unsigned int i, n;
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   681  
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   682  	/* only use complete blocks, max. PAGE_SIZE */
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   683  	memcpy(ctrptr, iv, AES_BLOCK_SIZE);
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   684  	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(AES_BLOCK_SIZE - 1);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   685  	for (i = (n / AES_BLOCK_SIZE) - 1; i > 0; i--) {
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   686  		memcpy(ctrptr + AES_BLOCK_SIZE, ctrptr, AES_BLOCK_SIZE);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   687  		crypto_inc(ctrptr + AES_BLOCK_SIZE, AES_BLOCK_SIZE);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   688  		ctrptr += AES_BLOCK_SIZE;
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   689  	}
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   690  	return n;
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   691  }
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   692  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   693  static int ctr_aes_crypt(struct blkcipher_desc *desc, unsigned long modifier,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   694  			 struct blkcipher_walk *walk)
0200f3ecc19660b Gerald Schaefer      2011-05-04   695  {
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   696  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   697  	u8 buf[AES_BLOCK_SIZE], *ctrptr;
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   698  	unsigned int n, nbytes;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   699  	int ret, locked;
0200f3ecc19660b Gerald Schaefer      2011-05-04   700  
1c2c7029c008922 Harald Freudenberger 2019-05-27   701  	locked = mutex_trylock(&ctrblk_lock);
0200f3ecc19660b Gerald Schaefer      2011-05-04   702  
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   703  	ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
0200f3ecc19660b Gerald Schaefer      2011-05-04   704  	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   705  		n = AES_BLOCK_SIZE;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   706  		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   707  			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   708  		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   709  		cpacf_kmctr(sctx->fc | modifier, sctx->key,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   710  			    walk->dst.virt.addr, walk->src.virt.addr,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   711  			    n, ctrptr);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   712  		if (ctrptr == ctrblk)
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   713  			memcpy(walk->iv, ctrptr + n - AES_BLOCK_SIZE,
0200f3ecc19660b Gerald Schaefer      2011-05-04   714  			       AES_BLOCK_SIZE);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   715  		crypto_inc(walk->iv, AES_BLOCK_SIZE);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   716  		ret = blkcipher_walk_done(desc, walk, nbytes - n);
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   717  	}
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   718  	if (locked)
1c2c7029c008922 Harald Freudenberger 2019-05-27   719  		mutex_unlock(&ctrblk_lock);
0200f3ecc19660b Gerald Schaefer      2011-05-04   720  	/*
0200f3ecc19660b Gerald Schaefer      2011-05-04   721  	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
0200f3ecc19660b Gerald Schaefer      2011-05-04   722  	 */
0200f3ecc19660b Gerald Schaefer      2011-05-04   723  	if (nbytes) {
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   724  		cpacf_kmctr(sctx->fc | modifier, sctx->key,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   725  			    buf, walk->src.virt.addr,
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   726  			    AES_BLOCK_SIZE, walk->iv);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   727  		memcpy(walk->dst.virt.addr, buf, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   728  		crypto_inc(walk->iv, AES_BLOCK_SIZE);
0200f3ecc19660b Gerald Schaefer      2011-05-04   729  		ret = blkcipher_walk_done(desc, walk, 0);
0200f3ecc19660b Gerald Schaefer      2011-05-04   730  	}
0519e9ad89e5cd6 Harald Freudenberger 2014-01-16   731  
0200f3ecc19660b Gerald Schaefer      2011-05-04   732  	return ret;
0200f3ecc19660b Gerald Schaefer      2011-05-04   733  }
0200f3ecc19660b Gerald Schaefer      2011-05-04   734  
0200f3ecc19660b Gerald Schaefer      2011-05-04   735  static int ctr_aes_encrypt(struct blkcipher_desc *desc,
0200f3ecc19660b Gerald Schaefer      2011-05-04   736  			   struct scatterlist *dst, struct scatterlist *src,
0200f3ecc19660b Gerald Schaefer      2011-05-04   737  			   unsigned int nbytes)
0200f3ecc19660b Gerald Schaefer      2011-05-04   738  {
0200f3ecc19660b Gerald Schaefer      2011-05-04   739  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
0200f3ecc19660b Gerald Schaefer      2011-05-04   740  	struct blkcipher_walk walk;
0200f3ecc19660b Gerald Schaefer      2011-05-04   741  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   742  	if (unlikely(!sctx->fc))
69c0e360f990c2d Martin Schwidefsky   2016-08-18   743  		return fallback_blk_enc(desc, dst, src, nbytes);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   744  
0200f3ecc19660b Gerald Schaefer      2011-05-04   745  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   746  	return ctr_aes_crypt(desc, 0, &walk);
0200f3ecc19660b Gerald Schaefer      2011-05-04   747  }
0200f3ecc19660b Gerald Schaefer      2011-05-04   748  
0200f3ecc19660b Gerald Schaefer      2011-05-04   749  static int ctr_aes_decrypt(struct blkcipher_desc *desc,
0200f3ecc19660b Gerald Schaefer      2011-05-04   750  			   struct scatterlist *dst, struct scatterlist *src,
0200f3ecc19660b Gerald Schaefer      2011-05-04   751  			   unsigned int nbytes)
0200f3ecc19660b Gerald Schaefer      2011-05-04   752  {
0200f3ecc19660b Gerald Schaefer      2011-05-04   753  	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
0200f3ecc19660b Gerald Schaefer      2011-05-04   754  	struct blkcipher_walk walk;
0200f3ecc19660b Gerald Schaefer      2011-05-04   755  
69c0e360f990c2d Martin Schwidefsky   2016-08-18   756  	if (unlikely(!sctx->fc))
69c0e360f990c2d Martin Schwidefsky   2016-08-18   757  		return fallback_blk_dec(desc, dst, src, nbytes);
69c0e360f990c2d Martin Schwidefsky   2016-08-18   758  
0200f3ecc19660b Gerald Schaefer      2011-05-04   759  	blkcipher_walk_init(&walk, dst, src, nbytes);
7bac4f5b8e3a607 Martin Schwidefsky   2016-08-15   760  	return ctr_aes_crypt(desc, CPACF_DECRYPT, &walk);
0200f3ecc19660b Gerald Schaefer      2011-05-04   761  }
0200f3ecc19660b Gerald Schaefer      2011-05-04   762  
0200f3ecc19660b Gerald Schaefer      2011-05-04   763  static struct crypto_alg ctr_aes_alg = {
0200f3ecc19660b Gerald Schaefer      2011-05-04   764  	.cra_name		=	"ctr(aes)",
0200f3ecc19660b Gerald Schaefer      2011-05-04   765  	.cra_driver_name	=	"ctr-aes-s390",
aff304e7a0e8f92 Harald Freudenberger 2018-04-05   766  	.cra_priority		=	402,	/* ecb-aes-s390 + 1 */
69c0e360f990c2d Martin Schwidefsky   2016-08-18   767  	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
69c0e360f990c2d Martin Schwidefsky   2016-08-18   768  					CRYPTO_ALG_NEED_FALLBACK,
0200f3ecc19660b Gerald Schaefer      2011-05-04   769  	.cra_blocksize		=	1,
0200f3ecc19660b Gerald Schaefer      2011-05-04   770  	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
0200f3ecc19660b Gerald Schaefer      2011-05-04   771  	.cra_type		=	&crypto_blkcipher_type,
0200f3ecc19660b Gerald Schaefer      2011-05-04   772  	.cra_module		=	THIS_MODULE,
69c0e360f990c2d Martin Schwidefsky   2016-08-18   773  	.cra_init		=	fallback_init_blk,
69c0e360f990c2d Martin Schwidefsky   2016-08-18   774  	.cra_exit		=	fallback_exit_blk,
0200f3ecc19660b Gerald Schaefer      2011-05-04   775  	.cra_u			=	{
0200f3ecc19660b Gerald Schaefer      2011-05-04   776  		.blkcipher = {
0200f3ecc19660b Gerald Schaefer      2011-05-04   777  			.min_keysize		=	AES_MIN_KEY_SIZE,
0200f3ecc19660b Gerald Schaefer      2011-05-04   778  			.max_keysize		=	AES_MAX_KEY_SIZE,
0200f3ecc19660b Gerald Schaefer      2011-05-04   779  			.ivsize			=	AES_BLOCK_SIZE,
0200f3ecc19660b Gerald Schaefer      2011-05-04   780  			.setkey			=	ctr_aes_set_key,
0200f3ecc19660b Gerald Schaefer      2011-05-04   781  			.encrypt		=	ctr_aes_encrypt,
0200f3ecc19660b Gerald Schaefer      2011-05-04   782  			.decrypt		=	ctr_aes_decrypt,
0200f3ecc19660b Gerald Schaefer      2011-05-04   783  		}
0200f3ecc19660b Gerald Schaefer      2011-05-04   784  	}
0200f3ecc19660b Gerald Schaefer      2011-05-04   785  };
0200f3ecc19660b Gerald Schaefer      2011-05-04   786  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   787  static int gcm_aes_setkey(struct crypto_aead *tfm, const u8 *key,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   788  			  unsigned int keylen)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   789  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   790  	struct s390_aes_ctx *ctx = crypto_aead_ctx(tfm);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   791  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   792  	switch (keylen) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   793  	case AES_KEYSIZE_128:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   794  		ctx->fc = CPACF_KMA_GCM_AES_128;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   795  		break;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   796  	case AES_KEYSIZE_192:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   797  		ctx->fc = CPACF_KMA_GCM_AES_192;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   798  		break;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   799  	case AES_KEYSIZE_256:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   800  		ctx->fc = CPACF_KMA_GCM_AES_256;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   801  		break;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   802  	default:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   803  		return -EINVAL;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   804  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   805  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   806  	memcpy(ctx->key, key, keylen);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   807  	ctx->key_len = keylen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   808  	return 0;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   809  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   810  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   811  static int gcm_aes_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   812  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   813  	switch (authsize) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   814  	case 4:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   815  	case 8:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   816  	case 12:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   817  	case 13:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   818  	case 14:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   819  	case 15:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   820  	case 16:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   821  		break;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   822  	default:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   823  		return -EINVAL;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   824  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   825  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   826  	return 0;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   827  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   828  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   829  static void gcm_walk_start(struct gcm_sg_walk *gw, struct scatterlist *sg,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   830  			   unsigned int len)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   831  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   832  	memset(gw, 0, sizeof(*gw));
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   833  	gw->walk_bytes_remain = len;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   834  	scatterwalk_start(&gw->walk, sg);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   835  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   836  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   837  static inline unsigned int _gcm_sg_clamp_and_map(struct gcm_sg_walk *gw)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   838  {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   839  	struct scatterlist *nextsg;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   840  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   841  	gw->walk_bytes = scatterwalk_clamp(&gw->walk, gw->walk_bytes_remain);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   842  	while (!gw->walk_bytes) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   843  		nextsg = sg_next(gw->walk.sg);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   844  		if (!nextsg)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   845  			return 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   846  		scatterwalk_start(&gw->walk, nextsg);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   847  		gw->walk_bytes = scatterwalk_clamp(&gw->walk,
bef9f0ba300a55d Harald Freudenberger 2019-05-23   848  						   gw->walk_bytes_remain);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   849  	}
bef9f0ba300a55d Harald Freudenberger 2019-05-23   850  	gw->walk_ptr = scatterwalk_map(&gw->walk);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   851  	return gw->walk_bytes;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   852  }
bef9f0ba300a55d Harald Freudenberger 2019-05-23   853  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   854  static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
bef9f0ba300a55d Harald Freudenberger 2019-05-23   855  					     unsigned int nbytes)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   856  {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   857  	gw->walk_bytes_remain -= nbytes;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   858  	scatterwalk_unmap(&gw->walk);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   859  	scatterwalk_advance(&gw->walk, nbytes);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   860  	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   861  	gw->walk_ptr = NULL;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   862  }
bef9f0ba300a55d Harald Freudenberger 2019-05-23   863  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   864  static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   865  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   866  	int n;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   867  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   868  	if (gw->buf_bytes && gw->buf_bytes >= minbytesneeded) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   869  		gw->ptr = gw->buf;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   870  		gw->nbytes = gw->buf_bytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   871  		goto out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   872  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   873  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   874  	if (gw->walk_bytes_remain == 0) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   875  		gw->ptr = NULL;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   876  		gw->nbytes = 0;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   877  		goto out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   878  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   879  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   880  	if (!_gcm_sg_clamp_and_map(gw)) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   881  		gw->ptr = NULL;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   882  		gw->nbytes = 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   883  		goto out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   884  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   885  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   886  	if (!gw->buf_bytes && gw->walk_bytes >= minbytesneeded) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   887  		gw->ptr = gw->walk_ptr;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   888  		gw->nbytes = gw->walk_bytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   889  		goto out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   890  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   891  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   892  	while (1) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   893  		n = min(gw->walk_bytes, AES_BLOCK_SIZE - gw->buf_bytes);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   894  		memcpy(gw->buf + gw->buf_bytes, gw->walk_ptr, n);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   895  		gw->buf_bytes += n;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   896  		_gcm_sg_unmap_and_advance(gw, n);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   897  		if (gw->buf_bytes >= minbytesneeded) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   898  			gw->ptr = gw->buf;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   899  			gw->nbytes = gw->buf_bytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   900  			goto out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   901  		}
bef9f0ba300a55d Harald Freudenberger 2019-05-23   902  		if (!_gcm_sg_clamp_and_map(gw)) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   903  			gw->ptr = NULL;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   904  			gw->nbytes = 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   905  			goto out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   906  		}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   907  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   908  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   909  out:
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   910  	return gw->nbytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   911  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   912  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   913  static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   914  {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   915  	if (gw->walk_bytes_remain == 0) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   916  		gw->ptr = NULL;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   917  		gw->nbytes = 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   918  		goto out;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   919  	}
bef9f0ba300a55d Harald Freudenberger 2019-05-23   920  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   921  	if (!_gcm_sg_clamp_and_map(gw)) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   922  		gw->ptr = NULL;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   923  		gw->nbytes = 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   924  		goto out;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   925  	}
bef9f0ba300a55d Harald Freudenberger 2019-05-23   926  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   927  	if (gw->walk_bytes >= minbytesneeded) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   928  		gw->ptr = gw->walk_ptr;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   929  		gw->nbytes = gw->walk_bytes;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   930  		goto out;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   931  	}
bef9f0ba300a55d Harald Freudenberger 2019-05-23   932  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   933  	scatterwalk_unmap(&gw->walk);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   934  	gw->walk_ptr = NULL;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   935  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   936  	gw->ptr = gw->buf;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   937  	gw->nbytes = sizeof(gw->buf);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   938  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   939  out:
bef9f0ba300a55d Harald Freudenberger 2019-05-23   940  	return gw->nbytes;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   941  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   942  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   943  static int gcm_in_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   944  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   945  	if (gw->ptr == NULL)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   946  		return 0;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   947  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   948  	if (gw->ptr == gw->buf) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   949  		int n = gw->buf_bytes - bytesdone;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   950  		if (n > 0) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   951  			memmove(gw->buf, gw->buf + bytesdone, n);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   952  			gw->buf_bytes = n;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   953  		} else
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   954  			gw->buf_bytes = 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   955  	} else
bef9f0ba300a55d Harald Freudenberger 2019-05-23   956  		_gcm_sg_unmap_and_advance(gw, bytesdone);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   957  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   958  	return bytesdone;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   959  }
bef9f0ba300a55d Harald Freudenberger 2019-05-23   960  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   961  static int gcm_out_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   962  {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   963  	int i, n;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   964  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   965  	if (gw->ptr == NULL)
bef9f0ba300a55d Harald Freudenberger 2019-05-23   966  		return 0;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   967  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   968  	if (gw->ptr == gw->buf) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   969  		for (i = 0; i < bytesdone; i += n) {
bef9f0ba300a55d Harald Freudenberger 2019-05-23   970  			if (!_gcm_sg_clamp_and_map(gw))
bef9f0ba300a55d Harald Freudenberger 2019-05-23   971  				return i;
bef9f0ba300a55d Harald Freudenberger 2019-05-23   972  			n = min(gw->walk_bytes, bytesdone - i);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   973  			memcpy(gw->walk_ptr, gw->buf + i, n);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   974  			_gcm_sg_unmap_and_advance(gw, n);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   975  		}
bef9f0ba300a55d Harald Freudenberger 2019-05-23   976  	} else
bef9f0ba300a55d Harald Freudenberger 2019-05-23   977  		_gcm_sg_unmap_and_advance(gw, bytesdone);
bef9f0ba300a55d Harald Freudenberger 2019-05-23   978  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   979  	return bytesdone;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   980  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   981  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   982  static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   983  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   984  	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   985  	struct s390_aes_ctx *ctx = crypto_aead_ctx(tfm);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   986  	unsigned int ivsize = crypto_aead_ivsize(tfm);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   987  	unsigned int taglen = crypto_aead_authsize(tfm);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   988  	unsigned int aadlen = req->assoclen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   989  	unsigned int pclen = req->cryptlen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   990  	int ret = 0;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   991  
bef9f0ba300a55d Harald Freudenberger 2019-05-23   992  	unsigned int n, len, in_bytes, out_bytes,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   993  		     min_bytes, bytes, aad_bytes, pc_bytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   994  	struct gcm_sg_walk gw_in, gw_out;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   995  	u8 tag[GHASH_DIGEST_SIZE];
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   996  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   997  	struct {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   998  		u32 _[3];		/* reserved */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18   999  		u32 cv;			/* Counter Value */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1000  		u8 t[GHASH_DIGEST_SIZE];/* Tag */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1001  		u8 h[AES_BLOCK_SIZE];	/* Hash-subkey */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1002  		u64 taadl;		/* Total AAD Length */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1003  		u64 tpcl;		/* Total Plain-/Cipher-text Length */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1004  		u8 j0[GHASH_BLOCK_SIZE];/* initial counter value */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1005  		u8 k[AES_MAX_KEY_SIZE];	/* Key */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1006  	} param;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1007  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1008  	/*
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1009  	 * encrypt
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1010  	 *   req->src: aad||plaintext
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1011  	 *   req->dst: aad||ciphertext||tag
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1012  	 * decrypt
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1013  	 *   req->src: aad||ciphertext||tag
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1014  	 *   req->dst: aad||plaintext, return 0 or -EBADMSG
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1015  	 * aad, plaintext and ciphertext may be empty.
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1016  	 */
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1017  	if (flags & CPACF_DECRYPT)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1018  		pclen -= taglen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1019  	len = aadlen + pclen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1020  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1021  	memset(&param, 0, sizeof(param));
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1022  	param.cv = 1;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1023  	param.taadl = aadlen * 8;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1024  	param.tpcl = pclen * 8;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1025  	memcpy(param.j0, req->iv, ivsize);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1026  	*(u32 *)(param.j0 + ivsize) = 1;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1027  	memcpy(param.k, ctx->key, ctx->key_len);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1028  
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1029  	gcm_walk_start(&gw_in, req->src, len);
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1030  	gcm_walk_start(&gw_out, req->dst, len);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1031  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1032  	do {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1033  		min_bytes = min_t(unsigned int,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1034  				  aadlen > 0 ? aadlen : pclen, AES_BLOCK_SIZE);
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1035  		in_bytes = gcm_in_walk_go(&gw_in, min_bytes);
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1036  		out_bytes = gcm_out_walk_go(&gw_out, min_bytes);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1037  		bytes = min(in_bytes, out_bytes);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1038  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1039  		if (aadlen + pclen <= bytes) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1040  			aad_bytes = aadlen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1041  			pc_bytes = pclen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1042  			flags |= CPACF_KMA_LAAD | CPACF_KMA_LPC;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1043  		} else {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1044  			if (aadlen <= bytes) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1045  				aad_bytes = aadlen;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1046  				pc_bytes = (bytes - aadlen) &
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1047  					   ~(AES_BLOCK_SIZE - 1);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1048  				flags |= CPACF_KMA_LAAD;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1049  			} else {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1050  				aad_bytes = bytes & ~(AES_BLOCK_SIZE - 1);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1051  				pc_bytes = 0;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1052  			}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1053  		}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1054  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1055  		if (aad_bytes > 0)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1056  			memcpy(gw_out.ptr, gw_in.ptr, aad_bytes);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1057  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1058  		cpacf_kma(ctx->fc | flags, &param,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1059  			  gw_out.ptr + aad_bytes,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1060  			  gw_in.ptr + aad_bytes, pc_bytes,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1061  			  gw_in.ptr, aad_bytes);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1062  
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1063  		n = aad_bytes + pc_bytes;
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1064  		if (gcm_in_walk_done(&gw_in, n) != n)
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1065  			return -ENOMEM;
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1066  		if (gcm_out_walk_done(&gw_out, n) != n)
bef9f0ba300a55d Harald Freudenberger 2019-05-23  1067  			return -ENOMEM;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1068  		aadlen -= aad_bytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1069  		pclen -= pc_bytes;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1070  	} while (aadlen + pclen > 0);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1071  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1072  	if (flags & CPACF_DECRYPT) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1073  		scatterwalk_map_and_copy(tag, req->src, len, taglen, 0);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1074  		if (crypto_memneq(tag, param.t, taglen))
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1075  			ret = -EBADMSG;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1076  	} else
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1077  		scatterwalk_map_and_copy(param.t, req->dst, len, taglen, 1);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1078  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1079  	memzero_explicit(&param, sizeof(param));
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1080  	return ret;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1081  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1082  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1083  static int gcm_aes_encrypt(struct aead_request *req)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1084  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1085  	return gcm_aes_crypt(req, CPACF_ENCRYPT);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1086  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1087  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1088  static int gcm_aes_decrypt(struct aead_request *req)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1089  {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1090  	return gcm_aes_crypt(req, CPACF_DECRYPT);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1091  }
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1092  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1093  static struct aead_alg gcm_aes_aead = {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1094  	.setkey			= gcm_aes_setkey,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1095  	.setauthsize		= gcm_aes_setauthsize,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1096  	.encrypt		= gcm_aes_encrypt,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1097  	.decrypt		= gcm_aes_decrypt,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1098  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1099  	.ivsize			= GHASH_BLOCK_SIZE - sizeof(u32),
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1100  	.maxauthsize		= GHASH_DIGEST_SIZE,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1101  	.chunksize		= AES_BLOCK_SIZE,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1102  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1103  	.base			= {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1104  		.cra_blocksize		= 1,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1105  		.cra_ctxsize		= sizeof(struct s390_aes_ctx),
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1106  		.cra_priority		= 900,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1107  		.cra_name		= "gcm(aes)",
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1108  		.cra_driver_name	= "gcm-aes-s390",
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1109  		.cra_module		= THIS_MODULE,
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1110  	},
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1111  };
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1112  
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1113  static struct crypto_alg *aes_s390_algs_ptr[5];
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1114  static int aes_s390_algs_num;
c7260ca335a09fb Harald Freudenberger 2018-03-01  1115  static struct aead_alg *aes_s390_aead_alg;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1116  
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1117  static int aes_s390_register_alg(struct crypto_alg *alg)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1118  {
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1119  	int ret;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1120  
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1121  	ret = crypto_register_alg(alg);
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1122  	if (!ret)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1123  		aes_s390_algs_ptr[aes_s390_algs_num++] = alg;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1124  	return ret;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1125  }
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1126  
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1127  static void aes_s390_fini(void)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1128  {
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1129  	while (aes_s390_algs_num--)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1130  		crypto_unregister_alg(aes_s390_algs_ptr[aes_s390_algs_num]);
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1131  	if (ctrblk)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1132  		free_page((unsigned long) ctrblk);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1133  
c7260ca335a09fb Harald Freudenberger 2018-03-01  1134  	if (aes_s390_aead_alg)
c7260ca335a09fb Harald Freudenberger 2018-03-01  1135  		crypto_unregister_aead(aes_s390_aead_alg);
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1136  }
4f57ba716b12ab9 Ingo Tuchscherer     2013-10-15  1137  
9f7819c1e51d531 Heiko Carstens       2008-04-17  1138  static int __init aes_s390_init(void)
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1139  {
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1140  	int ret;
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1141  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1142  	/* Query available functions for KM, KMC, KMCTR and KMA */
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1143  	cpacf_query(CPACF_KM, &km_functions);
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1144  	cpacf_query(CPACF_KMC, &kmc_functions);
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1145  	cpacf_query(CPACF_KMCTR, &kmctr_functions);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1146  	cpacf_query(CPACF_KMA, &kma_functions);
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1147  
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1148  	if (cpacf_test_func(&km_functions, CPACF_KM_AES_128) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1149  	    cpacf_test_func(&km_functions, CPACF_KM_AES_192) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1150  	    cpacf_test_func(&km_functions, CPACF_KM_AES_256)) {
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1151  		ret = aes_s390_register_alg(&aes_alg);
86aa9fc2456d8a6 Jan Glauber          2007-02-05  1152  		if (ret)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1153  			goto out_err;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1154  		ret = aes_s390_register_alg(&ecb_aes_alg);
86aa9fc2456d8a6 Jan Glauber          2007-02-05  1155  		if (ret)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1156  			goto out_err;
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1157  	}
a9e62fadf0b02ba Herbert Xu           2006-08-21  1158  
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1159  	if (cpacf_test_func(&kmc_functions, CPACF_KMC_AES_128) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1160  	    cpacf_test_func(&kmc_functions, CPACF_KMC_AES_192) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1161  	    cpacf_test_func(&kmc_functions, CPACF_KMC_AES_256)) {
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1162  		ret = aes_s390_register_alg(&cbc_aes_alg);
86aa9fc2456d8a6 Jan Glauber          2007-02-05  1163  		if (ret)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1164  			goto out_err;
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1165  	}
a9e62fadf0b02ba Herbert Xu           2006-08-21  1166  
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1167  	if (cpacf_test_func(&km_functions, CPACF_KM_XTS_128) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1168  	    cpacf_test_func(&km_functions, CPACF_KM_XTS_256)) {
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1169  		ret = aes_s390_register_alg(&xts_aes_alg);
99d97222150a24e Gerald Schaefer      2011-04-26  1170  		if (ret)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1171  			goto out_err;
99d97222150a24e Gerald Schaefer      2011-04-26  1172  	}
99d97222150a24e Gerald Schaefer      2011-04-26  1173  
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1174  	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_AES_128) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1175  	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_AES_192) ||
69c0e360f990c2d Martin Schwidefsky   2016-08-18  1176  	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_AES_256)) {
0200f3ecc19660b Gerald Schaefer      2011-05-04  1177  		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
0200f3ecc19660b Gerald Schaefer      2011-05-04  1178  		if (!ctrblk) {
0200f3ecc19660b Gerald Schaefer      2011-05-04  1179  			ret = -ENOMEM;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1180  			goto out_err;
0200f3ecc19660b Gerald Schaefer      2011-05-04  1181  		}
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1182  		ret = aes_s390_register_alg(&ctr_aes_alg);
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1183  		if (ret)
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1184  			goto out_err;
0200f3ecc19660b Gerald Schaefer      2011-05-04  1185  	}
0200f3ecc19660b Gerald Schaefer      2011-05-04  1186  
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1187  	if (cpacf_test_func(&kma_functions, CPACF_KMA_GCM_AES_128) ||
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1188  	    cpacf_test_func(&kma_functions, CPACF_KMA_GCM_AES_192) ||
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1189  	    cpacf_test_func(&kma_functions, CPACF_KMA_GCM_AES_256)) {
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1190  		ret = crypto_register_aead(&gcm_aes_aead);
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1191  		if (ret)
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1192  			goto out_err;
c7260ca335a09fb Harald Freudenberger 2018-03-01  1193  		aes_s390_aead_alg = &gcm_aes_aead;
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1194  	}
bf7fa038707c4c7 Harald Freudenberger 2017-09-18  1195  
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1196  	return 0;
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1197  out_err:
d863d5945f2be0a Martin Schwidefsky   2016-08-18  1198  	aes_s390_fini();
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1199  	return ret;
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1200  }
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1201  
d05377c12ae2ac8 Hendrik Brueckner    2015-02-19  1202  module_cpu_feature_match(MSA, aes_s390_init);
9f7819c1e51d531 Heiko Carstens       2008-04-17  1203  module_exit(aes_s390_fini);
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1204  
5d26a105b5a73e5 Kees Cook            2014-11-20  1205  MODULE_ALIAS_CRYPTO("aes-all");
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1206  
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1207  MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
bf754ae8ef8bc44 Jan Glauber          2006-01-06  1208  MODULE_LICENSE("GPL");

:::::: The code at line 111 was first introduced by commit
:::::: 6c2bb98bc33ae33c7a33a133a4cd5a06395fece5 [CRYPTO] all: Pass tfm instead of ctx to algorithms

:::::: TO: Herbert Xu <herbert@gondor.apana.org.au>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--msmn2ckh56k3jbaw
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/gPIyXlfi0UBAA==

--msmn2ckh56k3jbaw--
