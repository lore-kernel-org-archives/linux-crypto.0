Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1ACC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 14:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080452073B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 14:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgE2OXx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 10:23:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41054 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgE2OXx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 10:23:53 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jefvJ-0007wl-Lw; Sat, 30 May 2020 00:23:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 May 2020 00:23:49 +1000
Date:   Sat, 30 May 2020 00:23:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [v2 PATCH] crypto: algif_aead - Only wake up when ctx->more is zero
Message-ID: <20200529142349.GA10563@gondor.apana.org.au>
References: <20200529045443.GA475@gondor.apana.org.au>
 <20200529124048.GA7283@gondor.apana.org.au>
 <20200529131811.GA9137@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529131811.GA9137@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AEAD does not support partial requests so we must not wake up
while ctx->more is set.  In order to distinguish between the
case of no data sent yet and a zero-length request, a new init
flag has been added to ctx.
    
SKCIPHER has also been modified to ensure that at least a block
of data is available if there is more data to come.
    
Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b1cd3535c5256..3366a3173e733 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -639,6 +639,7 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 
 	if (!ctx->used)
 		ctx->merge = 0;
+	ctx->init = ctx->more;
 }
 EXPORT_SYMBOL_GPL(af_alg_pull_tsgl);
 
@@ -738,9 +739,10 @@ EXPORT_SYMBOL_GPL(af_alg_wmem_wakeup);
  *
  * @sk socket of connection to user space
  * @flags If MSG_DONTWAIT is set, then only report if function would sleep
+ * @min Set to minimum request size if partial requests are allowed.
  * @return 0 when writable memory is available, < 0 upon error
  */
-int af_alg_wait_for_data(struct sock *sk, unsigned flags)
+int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
@@ -758,7 +760,9 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags)
 		if (signal_pending(current))
 			break;
 		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, (ctx->used || !ctx->more),
+		if (sk_wait_event(sk, &timeout,
+				  ctx->init && (!ctx->more ||
+						(min && ctx->used >= min)),
 				  &wait)) {
 			err = 0;
 			break;
@@ -847,7 +851,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	}
 
 	lock_sock(sk);
-	if (!ctx->more && ctx->used) {
+	if (ctx->init && (init || !ctx->more)) {
 		err = -EINVAL;
 		goto unlock;
 	}
@@ -858,6 +862,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
 		ctx->aead_assoclen = con.aead_assoclen;
+		ctx->init = true;
 	}
 
 	while (size) {
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index eb1910b6d434c..857e9598e4dc0 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -106,8 +106,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
 
-	if (!ctx->used) {
-		err = af_alg_wait_for_data(sk, flags);
+	if (!ctx->init || ctx->more) {
+		err = af_alg_wait_for_data(sk, flags, 0);
 		if (err)
 			return err;
 	}
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 24dd2fc2431cc..a2a588c71bdab 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -61,8 +61,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	int err = 0;
 	size_t len = 0;
 
-	if (!ctx->used) {
-		err = af_alg_wait_for_data(sk, flags);
+	if (!ctx->init || (ctx->more && ctx->used < bs)) {
+		err = af_alg_wait_for_data(sk, flags, bs);
 		if (err)
 			return err;
 	}
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 56527c85d1222..98fb5b3158f2a 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -135,6 +135,7 @@ struct af_alg_async_req {
  *			SG?
  * @enc:		Cryptographic operation to be performed when
  *			recvmsg is invoked.
+ * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
  */
 struct af_alg_ctx {
@@ -151,6 +152,7 @@ struct af_alg_ctx {
 	bool more;
 	bool merge;
 	bool enc;
+	bool init;
 
 	unsigned int len;
 };
@@ -226,7 +228,7 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
 void af_alg_wmem_wakeup(struct sock *sk);
-int af_alg_wait_for_data(struct sock *sk, unsigned flags);
+int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
