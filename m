Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265E4C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 10:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiKKKFy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiKKKFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 05:05:47 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E4F2494D
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 02:05:44 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1otQur-00CyaP-7f; Fri, 11 Nov 2022 18:05:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Nov 2022 18:05:41 +0800
Date:   Fri, 11 Nov 2022 18:05:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        Kees Cook <keescook@chromium.org>
Subject: crypto: skcipher - Allow sync algorithms with large request contexts
Message-ID: <Y24edaOFBxluH8Ck@gondor.apana.org.au>
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-2-ap420073@gmail.com>
 <Y2jGTvgHnu4QZV+D@gondor.apana.org.au>
 <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
 <Y24c9WcEpvibbRqo@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y24c9WcEpvibbRqo@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 11, 2022 at 05:59:17PM +0800, Herbert Xu wrote:
>
> cryptd is buggy as it tries to use sync_skcipher without going
> through the proper sync_skcipher interface.  In fact it doesn't
> even need sync_skcipher since it's already a proper skcipher and
> can easily access the request context instead of using something
> off the stack.
> 
> Fixes: 36b3875a97b8 ("crypto: cryptd - Remove VLA usage of skcipher")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This won't be enough to allow a sync skcipher that uses more
than 384 bytes of request context though as they will still
show up when you allocate a sync_skcipher.  So we also need
this and then you can just set REQSIZE_LARGE on your algorithm
and it will work correctly.

---8<---
Some sync algorithms may require a large amount of temporary
space during its operations.  There is no reason why they should
be limited just because some legacy users want to place all
temporary data on the stack.

Such algorithms can now set a flag to indicate that they need
extra request context, which will cause them to be invisible
to users that go through the sync_skcipher interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 418211180cee..0ecab31cfe79 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -763,7 +763,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 	struct crypto_skcipher *tfm;
 
 	/* Only sync algorithms allowed. */
-	mask |= CRYPTO_ALG_ASYNC;
+	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a2339f80a615..2a97540156bb 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -14,6 +14,14 @@
 #include <linux/list.h>
 #include <linux/types.h>
 
+/*
+ * Set this if your algorithm is sync but needs a reqsize larger
+ * than MAX_SYNC_SKCIPHER_REQSIZE.
+ *
+ * Reuse bit that is specific to hash algorithms.
+ */
+#define CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE CRYPTO_ALG_OPTIONAL_KEY
+
 struct aead_request;
 struct rtattr;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
