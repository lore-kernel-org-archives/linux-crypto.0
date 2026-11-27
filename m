Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795763545;
	b=cCBVVRoIgQZ6vUToNffFGZAgw7/a4UBwxEgY8kS3ydclvD1FP3uoR7I5aX1fF+cBQtsb
	 qP/IepHEU+FVcseLH8YfVWM7XwuvrxS51n2QKR29Wcs18nRFarXdJorUZk1iESLVyHK50
	 PuF1BSzbiIYAV5fPWR5YfIOgKk+ATEncjacx1gv8QSR5Yhr0yXbO5s7yTsl1xqMI/AYBH
	 Os22SR1kzvjDKAjgBPdTDWKdPPkjNdk1jhQKRoc+ncPIvtKtseNoBlaXRR/bZA07N6zcZ
	 iQdN8KjVAGYiuXXjwAnSjNQ0jRijUtYQefQHUYEqA9EFhyf5oxh8PCo7fNpZcL0Ze3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795763545;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=lC2ySosyz7nHdF6RRzKEvdsOMwNMDKMcwfeeuRXhTu0=;
	b=y1e4mpUoYKQRyIxWVGnu/GKrtExS7Qiq8Vb+pmRsji4gPL0Fs5AYHtIjTQbH5Mv2vGjX
	 tb1ER+HwFRtt7p8qqjYmYViHtv7PsmmEOttfS8PzZoKnlAHxqoaDqjX1znSv12D/ywex8
	 F5npP4hJlZWc35jN/V9CXr4Z3wNZioxmiyFe+qPoD6X/Mbv8hC4+APDVQWpSUQ6WZiVD/
	 Fejz7pFpoNGqggnWQpwVY9z6SrK1dISsInO8qeMrAKxsaqkNz2yjxGBDu/m5q9dSuX0b4
	 KZfRZf+EVhjJ5q1coEB0AFrJu3belhQ7yDkifWEM1hztmVNUvrCl3FBXTOP0swmY1OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF2C606A31C;
	Fri, 27 Nov 2026 07:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEF2C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: deefc868ea3111f19a56ed5b684f684d-20261127
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d31af603-6962-42ba-b076-0fe41b692c2c,IP:10,
	URL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:d31af603-6962-42ba-b076-0fe41b692c2c,IP:10,UR
	L:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:fe77f6b0d702056796441b369be54daf,BulkI
	D:261127151219SBY5NT0L,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: deefc868ea3111f19a56ed5b684f684d-20261127
X-User: maguicai@kylinos.cn
Received: from localhost.localdomain [(36.106.123.207)] by mailgw.kylinos.cn
	(envelope-from <maguicai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 644476794; Fri, 27 Nov 2026 15:12:13 +0800
From: Guicai Ma <maguicai@kylinos.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>
Subject: [PATCH v2] crypto: af_alg - wake up waiters on zero-length final message
Date: Fri, 27 Nov 2026 02:12:11 -0500
Message-ID: <20261127071211.2778867-1-maguicai@kylinos.cn>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120083244.1156396-1-maguicai@kylinos.cn>
References: <20261120083244.1156396-1-maguicai@kylinos.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

af_alg_data_wakeup() checks !ctx->used before waking readers, which
does not match the condition af_alg_wait_for_data() waits on:

	ctx->init && (!ctx->more || (min && ctx->used >= min))

When a zero-length final sendmsg() (without MSG_MORE) sets ctx->init
and clears ctx->more while ctx->used remains 0, af_alg_data_wakeup()
skips the wakeup and leaves the reader sleeping forever.

Move the condition into a shared af_alg_data_ready() helper, pass min
through af_alg_sendmsg() to af_alg_data_wakeup(), and use the helper on
both the waiting and waking sides.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
Cc: stable@vger.kernel.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Guicai Ma <maguicai@kylinos.cn>
---
v2:
- Move the wait condition into af_alg_data_ready() and use it on both
  sides, as suggested by Herbert.

Tested with two-threaded AF_ALG tests on gcm(aes) and ecb(aes)
(zero-length final sendmsg, MSG_MORE sub-block and multi-chunk sends).

 crypto/af_alg.c         | 13 +++++++------
 crypto/algif_aead.c     |  4 ++--
 crypto/algif_skcipher.c |  5 +++--
 include/crypto/if_alg.h | 15 ++++++++++++++-
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ab84c4488a15..d6104a6ee510 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -912,8 +912,7 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 			break;
 		timeout = MAX_SCHEDULE_TIMEOUT;
 		if (sk_wait_event(sk, &timeout,
-				  ctx->init && (!ctx->more ||
-						(min && ctx->used >= min)),
+				  af_alg_data_ready(ctx, min),
 				  &wait)) {
 			err = 0;
 			break;
@@ -931,14 +930,15 @@ EXPORT_SYMBOL_GPL(af_alg_wait_for_data);
  * af_alg_data_wakeup - wakeup caller when new data can be sent to kernel
  *
  * @sk: socket of connection to user space
+ * @min: minimum request size if partial requests are allowed
  */
-static void af_alg_data_wakeup(struct sock *sk)
+static void af_alg_data_wakeup(struct sock *sk, unsigned int min)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct socket_wq *wq;
 
-	if (!ctx->used)
+	if (!af_alg_data_ready(ctx, min))
 		return;
 
 	rcu_read_lock();
@@ -965,10 +965,11 @@ static void af_alg_data_wakeup(struct sock *sk)
  * @size: size of message from user space
  * @ivsize: the size of the IV for the cipher operation to verify that the
  *	   user-space-provided IV has the right size
+ * @min: minimum request size if partial requests are allowed
  * Return: the number of copied data upon success, < 0 upon error
  */
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
-		   unsigned int ivsize)
+		   unsigned int ivsize, unsigned int min)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -1119,7 +1120,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	ctx->more = msg->msg_flags & MSG_MORE;
 
 unlock:
-	af_alg_data_wakeup(sk);
+	af_alg_data_wakeup(sk, min);
 	ctx->write = false;
 	release_sock(sk);
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 5574e2d70539..137a947f0620 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,7 +64,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct crypto_aead *tfm = pask->private;
 	unsigned int ivsize = crypto_aead_ivsize(tfm);
 
-	return af_alg_sendmsg(sock, msg, size, ivsize);
+	return af_alg_sendmsg(sock, msg, size, ivsize, 0);
 }
 
 static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
@@ -87,7 +87,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
 
-	if (!ctx->init || ctx->more) {
+	if (!af_alg_data_ready(ctx, 0)) {
 		err = af_alg_wait_for_data(sk, flags, 0);
 		if (err)
 			return err;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 291dbd698932..cece9cf387cc 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -63,7 +63,8 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
 
-	return af_alg_sendmsg(sock, msg, size, ivsize);
+	return af_alg_sendmsg(sock, msg, size, ivsize,
+			      crypto_skcipher_chunksize(tfm));
 }
 
 static int algif_skcipher_export(struct sock *sk, struct skcipher_request *req)
@@ -113,7 +114,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	int err = 0;
 	size_t len = 0;
 
-	if (!ctx->init || (ctx->more && ctx->used < bs)) {
+	if (!af_alg_data_ready(ctx, bs)) {
 		err = af_alg_wait_for_data(sk, flags, bs);
 		if (err)
 			return err;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 0d51428c1da4..cb0951f33612 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -244,12 +244,25 @@ static inline bool af_alg_readable(struct sock *sk)
 	return PAGE_SIZE <= af_alg_rcvbuf(sk);
 }
 
+/**
+ * af_alg_data_ready - Is there enough TX data to proceed?
+ *
+ * @ctx: socket context of connection to user space
+ * @min: minimum request size if partial requests are allowed
+ *
+ * Returns: true => data is ready, false => not ready
+ */
+static inline bool af_alg_data_ready(struct af_alg_ctx *ctx, unsigned int min)
+{
+	return ctx->init && (!ctx->more || (min && ctx->used >= min));
+}
+
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst);
 void af_alg_wmem_wakeup(struct sock *sk);
 int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
-		   unsigned int ivsize);
+		   unsigned int ivsize, unsigned int min);
 void af_alg_free_resources(struct af_alg_async_req *areq);
 __poll_t af_alg_poll(struct file *file, struct socket *sock,
 			 poll_table *wait);
-- 
2.47.3

