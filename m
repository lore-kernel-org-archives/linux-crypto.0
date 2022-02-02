Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69291C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Feb 2022 07:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiBBH3j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Feb 2022 02:29:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60834 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237462AbiBBH3i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Feb 2022 02:29:38 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nF9Pl-0005rZ-0d; Wed, 02 Feb 2022 17:46:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Feb 2022 17:46:48 +1100
Date:   Wed, 2 Feb 2022 17:46:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jan Beulich <jbeulich@suse.com>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: api - Move cryptomgr soft dependency into algapi
Message-ID: <Yfoo2L0vUibufXiL@gondor.apana.org.au>
References: <83208d0b-cbe0-8ca9-195c-ee1673f08573@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83208d0b-cbe0-8ca9-195c-ee1673f08573@suse.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 31, 2022 at 04:30:06PM +0100, Jan Beulich wrote:
> Herbert,
> 
> unexpectedly after updating to 5.16 on one of my systems (the 1st one
> I tried) btrfs.ko would not load anymore. Since this did happen before,
> I inspected module dependencies, but they were all fine. Nevertheless
> it was libcrc32c.ko which actually failed to load, but the error
> ("Accessing a corrupted shared library") wasn't very helpful. Until I
> spotted crypto_alg_lookup(), and "only" a few steps I found this commit
> of yours. The problem, ultimately, is that all of the sudden
> cryptomgr.ko needs to be available in initrd. Without any module having
> a dependency on it, it wouldn't get pulled in automatically. And there
> was no need for it before (until later in the boot process, when / was
> already mounted).
> 
> Can this be addressed in some way, i.e. is there a way to re-work your
> change to remove the dependency again?

Does this patch help?

---8<---
The soft dependency on cryptomgr is only needed in algapi because
if algapi isn't present then no algorithms can be loaded.  This
also fixes the case where api is built-in but algapi is built as
a module as the soft dependency would otherwise get lost.

Fixes: 8ab23d547f65 ("crypto: api - Add softdep on cryptomgr")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9f15e11f5d73..79db3e461543 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1330,3 +1330,4 @@ module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cryptographic algorithms API");
+MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/crypto/api.c b/crypto/api.c
index cf0869dd130b..7ddfe946dd56 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -643,4 +643,3 @@ EXPORT_SYMBOL_GPL(crypto_req_done);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: cryptomgr");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
