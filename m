From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: inside-secure - add SafeXcel EIP197 crypto
 engine driver
Date: Thu, 6 Jul 2017 14:09:23 +0300
Message-ID: <20170706110923.blcqo3kgdoyfhbgv@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: antoine.tenart@free-electrons.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36847 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdGFLJi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 07:09:38 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Antoine Tenart,

The patch 1b44c5a60c13: "crypto: inside-secure - add SafeXcel EIP197
crypto engine driver" from May 24, 2017, leads to the following
static checker warning:

	drivers/crypto/inside-secure/safexcel_hash.c:890 safexcel_hmac_sha1_setkey()
	error: buffer overflow 'ctx->ipad' 5 <= 7

drivers/crypto/inside-secure/safexcel_hash.c
   875  static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
   876                                       unsigned int keylen)
   877  {
   878          struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
   879          struct safexcel_ahash_export_state istate, ostate;
   880          int ret, i;
   881  
   882          ret = safexcel_hmac_setkey("safexcel-sha1", key, keylen, &istate, &ostate);
   883          if (ret)
   884                  return ret;
   885  
   886          memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
                       ^^^^^^^^^
   887          memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
                       ^^^^^^^^^
These are SHA1_DIGEST_SIZE (20).

   888  
   889          for (i = 0; i < ARRAY_SIZE(istate.state); i++) {
                                           ^^^^^^^^^^^^
This is SHA256_DIGEST_SIZE (32) so it's bigger.

   890                  if (ctx->ipad[i] != le32_to_cpu(istate.state[i]) ||
   891                      ctx->opad[i] != le32_to_cpu(ostate.state[i])) {
   892                          ctx->base.needs_inv = true;
   893                          break;
   894                  }
   895          }
   896  
   897          return 0;
   898  }

regards,
dan carpenter
