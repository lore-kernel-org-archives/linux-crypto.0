Return-Path: <SRS0=TB/N=X7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8387ECE58E
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Oct 2019 00:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C86D3222CA
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Oct 2019 00:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfJFAUM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 20:20:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:21757 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfJFAUM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 20:20:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 17:20:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,261,1566889200"; 
   d="scan'208";a="222522698"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 05 Oct 2019 17:20:10 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iGuHR-0004WM-JN; Sun, 06 Oct 2019 08:20:09 +0800
Date:   Sun, 6 Oct 2019 08:19:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 11/53]
 drivers/crypto/inside-secure/safexcel_cipher.c:2337:37: sparse: sparse:
 restricted __le32 degrades to integer
Message-ID: <201910060818.lKfMlyzA%lkp@intel.com>
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
commit: 4a593fb35d5ccf3ddd41c68ac1cc88d06ec74341 [11/53] crypto: inside-secure - Added support for the CHACHA20 skcipher
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout 4a593fb35d5ccf3ddd41c68ac1cc88d06ec74341
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/inside-secure/safexcel_cipher.c:83:46: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:83:46: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:83:46: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:101:46: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:101:46: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:101:46: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:253:35: sparse: sparse: cast from restricted __be16
   drivers/crypto/inside-secure/safexcel_cipher.c:253:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] @@    got restrunsigned int [usertype] @@
   drivers/crypto/inside-secure/safexcel_cipher.c:253:33: sparse:    expected unsigned int [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:253:33: sparse:    got restricted __le32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:2128:45: sparse: sparse: restricted __be32 degrades to integer
   drivers/crypto/inside-secure/safexcel_cipher.c:2136:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:2136:30: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:2136:30: sparse:    got restricted __be32 [usertype]
   drivers/crypto/inside-secure/safexcel_cipher.c:2227:65: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __be32unsigned int @@
   drivers/crypto/inside-secure/safexcel_cipher.c:2227:65: sparse:    expected unsigned int
   drivers/crypto/inside-secure/safexcel_cipher.c:2227:65: sparse:    got restricted __be32 [usertype]
>> drivers/crypto/inside-secure/safexcel_cipher.c:2337:37: sparse: sparse: restricted __le32 degrades to integer
>> drivers/crypto/inside-secure/safexcel_cipher.c:2346:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 @@    got icted __le32 @@
>> drivers/crypto/inside-secure/safexcel_cipher.c:2346:29: sparse:    expected restricted __le32
>> drivers/crypto/inside-secure/safexcel_cipher.c:2346:29: sparse:    got unsigned int

vim +2337 drivers/crypto/inside-secure/safexcel_cipher.c

  2322	
  2323	static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
  2324						     const u8 *key, unsigned int len)
  2325	{
  2326		struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
  2327		struct safexcel_crypto_priv *priv = ctx->priv;
  2328		int i;
  2329	
  2330		if (len != CHACHA_KEY_SIZE) {
  2331			crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
  2332			return -EINVAL;
  2333		}
  2334	
  2335		if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
  2336			for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++) {
> 2337				if (ctx->key[i] !=
  2338				    get_unaligned_le32(key + i * sizeof(u32))) {
  2339					ctx->base.needs_inv = true;
  2340					break;
  2341				}
  2342			}
  2343		}
  2344	
  2345		for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
> 2346			ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
  2347		ctx->key_len = CHACHA_KEY_SIZE;
  2348	
  2349		return 0;
  2350	}
  2351	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
