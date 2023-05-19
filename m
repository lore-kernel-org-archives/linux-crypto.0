Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B16C77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 09:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjESJFn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 05:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjESJFm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 05:05:42 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653FE1723;
        Fri, 19 May 2023 02:05:15 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pzw1s-00AoNA-Ne; Fri, 19 May 2023 17:04:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 17:04:04 +0800
Date:   Fri, 19 May 2023 17:04:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Dmitry Safonov <dima@arista.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH] crypto: shash - Allow cloning on algorithms with no init_tfm
Message-ID: <ZGc7hCaDrnEFG8Lr@gondor.apana.org.au>
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
 <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
 <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 19, 2023 at 10:54:11AM +0200, Ard Biesheuvel wrote:
>
> Does this imply that the cmac-aes-ce and cmac-aes-neon implementations
> for arm64 need a similar treatment?

Good catch.  Since these don't have init functions we can deal
with them at a higher level:

---8<---
Some shash algorithms are so simple that they don't have an init_tfm
function.  These can be cloned trivially.  Check this before failing
in crypto_clone_shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 717b42df3495..1fadb6b59bdc 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -597,7 +597,7 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 		return hash;
 	}
 
-	if (!alg->clone_tfm)
+	if (!alg->clone_tfm && (alg->init_tfm || alg->base.cra_init))
 		return ERR_PTR(-ENOSYS);
 
 	nhash = crypto_clone_tfm(&crypto_shash_type, tfm);
@@ -606,10 +606,12 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 
 	nhash->descsize = hash->descsize;
 
-	err = alg->clone_tfm(nhash, hash);
-	if (err) {
-		crypto_free_shash(nhash);
-		return ERR_PTR(err);
+	if (alg->clone_tfm) {
+		err = alg->clone_tfm(nhash, hash);
+		if (err) {
+			crypto_free_shash(nhash);
+			return ERR_PTR(err);
+		}
 	}
 
 	return nhash;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
