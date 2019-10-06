Return-Path: <SRS0=TB/N=X7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE69C47404
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Oct 2019 01:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BAFD222C5
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Oct 2019 01:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfJFBNa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 21:13:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:59241 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfJFBNa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 21:13:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 18:13:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,261,1566889200"; 
   d="scan'208";a="217532765"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 05 Oct 2019 18:13:27 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iGv71-000CY6-1Y; Sun, 06 Oct 2019 09:13:27 +0800
Date:   Sun, 6 Oct 2019 09:13:00 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 12/53]
 drivers/crypto/inside-secure/safexcel_cipher.c:2476:26: sparse: sparse: cast
 from restricted __le32
Message-ID: <201910060958.AxYsmWpe%lkp@intel.com>
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
commit: a60619211dd188a5dfa18761b82d096cda76fc9f [12/53] crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout a60619211dd188a5dfa18761b82d096cda76fc9f
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/inside-secure/safexcel_cipher.c:85:46: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:85:46: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:85:46: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:117:46: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:117:46: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:117:46: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:272:35: sparse: sparse: cast from restricted __be16
   drivers/crypto/inside-secure/safexcel_cipher.c:272:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] @@    got restrunsigned int [usertype] @@
   drivers/crypto/inside-secure/safexcel_cipher.c:272:33: sparse:    expected unsigned int [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:272:33: sparse:    got restricted __le32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:2158:45: sparse: sparse: restricted __be32 degrades to integer
   drivers/crypto/inside-secure/safexcel_cipher.c:2166:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:2166:30: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:2166:30: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:2257:65: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:2257:65: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:2257:65: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:2361:37: sparse: sparse: restricted __le32 degrades to integer
   drivers/crypto/inside-secure/safexcel_cipher.c:2370:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 @@    got icted __le32 @@
   drivers/crypto/inside-secure/safexcel_cipher.c:2370:29: sparse:    expected restricted __le32
   drivers/crypto/inside-secure/safexcel_cipher.c:2370:29: sparse:    got unsigned int
>> drivers/crypto/inside-secure/safexcel_cipher.c:2476:26: sparse: sparse: cast from restricted __le32
>> drivers/crypto/inside-secure/safexcel_cipher.c:2476:24: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:2476:24: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:2476:24: sparse:    got restricted __le32 [usertype]

vim +2476 drivers/crypto/inside-secure/safexcel_cipher.c

  2451	
  2452	static int safexcel_aead_chachapoly_crypt(struct aead_request *req,
  2453						  enum safexcel_cipher_direction dir)
  2454	{
  2455		struct safexcel_cipher_req *creq = aead_request_ctx(req);
  2456		struct crypto_aead *aead = crypto_aead_reqtfm(req);
  2457		struct crypto_tfm *tfm = crypto_aead_tfm(aead);
  2458		struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
  2459		struct aead_request *subreq = aead_request_ctx(req);
  2460		u32 key[CHACHA_KEY_SIZE / sizeof(u32) + 1];
  2461		int i, ret = 0;
  2462	
  2463		/*
  2464		 * Instead of wasting time detecting umpteen silly corner cases,
  2465		 * just dump all "small" requests to the fallback implementation.
  2466		 * HW would not be faster on such small requests anyway.
  2467		 */
  2468		if (likely((ctx->aead != EIP197_AEAD_TYPE_IPSEC_ESP ||
  2469			    req->assoclen >= EIP197_AEAD_IPSEC_IV_SIZE) &&
  2470			   req->cryptlen > POLY1305_DIGEST_SIZE)) {
  2471			return safexcel_queue_req(&req->base, creq, dir);
  2472		}
  2473	
  2474		/* HW cannot do full (AAD+payload) zero length, use fallback */
  2475		for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
> 2476			key[i] = cpu_to_le32(ctx->key[i]);
  2477		if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
  2478			/* ESP variant has nonce appended to the key */
  2479			key[CHACHA_KEY_SIZE / sizeof(u32)] = ctx->nonce;
  2480			ret = crypto_aead_setkey(ctx->fback, (u8 *)key,
  2481						 CHACHA_KEY_SIZE +
  2482						 EIP197_AEAD_IPSEC_NONCE_SIZE);
  2483		} else {
  2484			ret = crypto_aead_setkey(ctx->fback, (u8 *)key,
  2485						 CHACHA_KEY_SIZE);
  2486		}
  2487		if (ret) {
  2488			crypto_aead_clear_flags(aead, CRYPTO_TFM_REQ_MASK);
  2489			crypto_aead_set_flags(aead, crypto_aead_get_flags(ctx->fback) &
  2490						    CRYPTO_TFM_REQ_MASK);
  2491			return ret;
  2492		}
  2493	
  2494		aead_request_set_tfm(subreq, ctx->fback);
  2495		aead_request_set_callback(subreq, req->base.flags, req->base.complete,
  2496					  req->base.data);
  2497		aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
  2498				       req->iv);
  2499		aead_request_set_ad(subreq, req->assoclen);
  2500	
  2501		return (dir ==  SAFEXCEL_ENCRYPT) ?
  2502			crypto_aead_encrypt(subreq) :
  2503			crypto_aead_decrypt(subreq);
  2504	}
  2505	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
