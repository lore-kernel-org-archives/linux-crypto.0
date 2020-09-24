Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91604C4727E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 03:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E3652388A
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 03:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgIXD3b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 23:29:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48816 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgIXD3S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 23:29:18 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLHwO-0001Nu-Hx; Thu, 24 Sep 2020 13:29:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 13:29:04 +1000
Date:   Thu, 24 Sep 2020 13:29:04 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     "Jason A. Donenfeld" <zx2c4@kernel.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Samuel Neves <sneves@dei.uc.pt>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: x86/poly1305 - Remove assignments with no effect
Message-ID: <20200924032904.GA9083@gondor.apana.org.au>
References: <20200921085652.GB7761@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921085652.GB7761@xsang-OptiPlex-9020>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 21, 2020 at 04:56:52PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   eb5f95f1593f7c22dac681b19e815828e2af3efd
> commit: d7d7b853566254648df59f7ea27ea05952a6cfa8 crypto: x86/poly1305 - wire up faster implementations for kernel
> date:   8 months ago
> :::::: branch date: 14 hours ago
> :::::: commit date: 8 months ago
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> cppcheck warnings: (new ones prefixed by >>)
> 
>    arch/x86/crypto/poly1305_glue.c:165:4: warning: Assignment of function parameter has no effect outside the function. Did you forget dereferencing it? [uselessAssignmentPtrArg]
>       inp += POLY1305_BLOCK_SIZE;
>       ^
> >> arch/x86/crypto/poly1305_glue.c:166:4: warning: Assignment of function parameter has no effect outside the function. [uselessAssignmentArg]
>       len -= POLY1305_BLOCK_SIZE;
>       ^

This patch should fix the problem.

---8<---
This patch removes a few ineffectual assignments from the function
crypto_poly1305_setdctxkey.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index f85885d6ccd8..e508dbd91813 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -158,9 +158,6 @@ static unsigned int crypto_poly1305_setdctxkey(struct poly1305_desc_ctx *dctx,
 			dctx->s[1] = get_unaligned_le32(&inp[4]);
 			dctx->s[2] = get_unaligned_le32(&inp[8]);
 			dctx->s[3] = get_unaligned_le32(&inp[12]);
-			inp += POLY1305_BLOCK_SIZE;
-			len -= POLY1305_BLOCK_SIZE;
-			acc += POLY1305_BLOCK_SIZE;
 			dctx->sset = true;
 		}
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
