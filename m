Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016913;
	b=eZVDpAcSilRRz7zxIecGoYqOgXYnCpL3uHTELbMVYErnGsccYuJf5+I0pyjipYXe3GoF
	 3JTJtCgkNu7WdTEKdraBK2wavZv7HLtEHHePLdgu+/sN7ZctVh3bCENB544xwcQgmSIF3
	 JW/6yqI3/W5nvyfwAt/jSGa7ILGDj+osvRfh4Wy8MGYnG0kAgn6C+y0Gn1oOCrCkjSWu5
	 +getUF1FfDDXQdSoY8CO5EbTp+kPu2puYcNyVxyBimWFuiALQ3PuuenmBOC/BInPkQrpk
	 stUMo0y9e9JKstIibkGvx9GuzDwQI5tsfMn65wI/UNvTBh2ayQEnC99dStSJuwU7RaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016913;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=t1a4VxT+Pk2crxdHaNNbCokZ/OkMNurAwIpmr6aLpac=;
	b=pq8dXUSLXeCb7d8qv3oQ0Wu72rWT9varv5Mo95rbOv1eQzmwqjKB+I8DVvLeMLQF70V1
	 quQzB/lJGDpgpDOBI979FFLdJKLrxvwzf7BbldKOyr0KwiXfQ5ESLIgjqzVfvmxxzNILZ
	 HntwID0EyMZ5NTwtVPfuT1pZ2OXti8bgCj+Mkk6cHnWP8+PgN7RURuBaaUYLx5g5UGGGE
	 UPoiHLY2Ys/redg0ylgyh2w+uS2cz86n/M42IaeatcJAxGTs3lHSrAieDjrQ92JfTIKM1
	 Ox5fHUsnkg0T9xmopyppbFY/JrYUSl1ZJjj7U8LNl9doYBDa7RwlT/3h1GHXsfi+H3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00D1606A332;
	Wed, 18 Nov 2026 15:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A00D1606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 79cf064ae36711f19a56ed5b684f684d-20261118
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_UNTRUSTED
	SA_UNFAMILIAR, SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b2c141c3-b415-426c-9499-9d1cf7a5fc5f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:b2c141c3-b415-426c-9499-9d1cf7a5fc5f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:4de01b488f591930c82e08556fa3400e,BulkI
	D:2611182329446W18NI2N,BulkQuantity:1,SF:19|38|66|72|78|102|127|153|850|86
	5|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 79cf064ae36711f19a56ed5b684f684d-20261118
X-User: maguicai@kylinos.cn
Received: from localhost.localdomain [(106.47.122.66)] by mailgw.kylinos.cn
	(envelope-from <maguicai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1243958509; Wed, 18 Nov 2026 23:48:18 +0800
From: Guicai Ma <maguicai@kylinos.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: af_alg - Fix data-race in af_alg_wait_for_data() and af_alg_wait_for_wmem()
Date: Wed, 18 Nov 2026 10:48:15 -0500
Message-ID: <20261118154815.607879-1-maguicai@kylinos.cn>
X-Mailer: git-send-email 2.47.3
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

KCSAN reported a data-race between af_alg_sendmsg() and
af_alg_wait_for_data():

  BUG: KCSAN: data-race in af_alg_sendmsg / af_alg_wait_for_data

  write to 0xffff8eec18118fa4 of 1 bytes by task 17152 on cpu 17:
   af_alg_sendmsg+0x1c7/0xfa0 crypto/af_alg.c:949
   skcipher_sendmsg+0x78/0x90 crypto/algif_skcipher.c:47
   ...

  read to 0xffff8eec18118fa4 of 1 bytes by task 17143 on cpu 1:
   af_alg_wait_for_data+0x1f9/0x3c0 crypto/af_alg.c:854
   _skcipher_recvmsg+0x52f/0x720 crypto/algif_skcipher.c:65
   ...

  value changed: 0x13 -> 0x1b

Both af_alg_wait_for_data() and af_alg_wait_for_wmem() are called with
the socket lock held and use sk_wait_event() to wait for the condition.
However, sk_wait_event() calls release_sock() before evaluating the
condition expression for the first time, which reads ctx->init,
ctx->more, and ctx->used without the socket lock. Meanwhile,
af_alg_sendmsg() acquires the socket lock and modifies ctx->write (which
shares the same 1-byte bitfield as ctx->more and ctx->init), as well as
ctx->init, ctx->more, and ctx->used.

Unlike TCP/UDP sockets, af_alg updates these context fields only in
process context under lock_sock(sk). Since add_wait_queue() with
woken_wake_function is already done while holding the socket lock, check
the wait condition under lock_sock(sk) before calling release_sock(sk)
and wait_woken(), avoiding the lockless read entirely.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
Cc: stable@vger.kernel.org
Signed-off-by: Guicai Ma <maguicai@kylinos.cn>
---
Testing:
Verified with a concurrent AF_ALG skcipher (ecb(aes)) send/recv stress
test under CONFIG_KCSAN=y (QEMU arm64, 8 vCPUs, 60s per run, ~470k rounds):
- Baseline (6.6.156): 51 af_alg KCSAN data-race reports (both the 1-byte
  bitfield race and the 8-byte ctx->used race).
- Patched (6.6.156, 2 runs): 0 af_alg KCSAN reports; roundtrip
  functional check passed and unrelated KCSAN reports remained active.
- Upstream (20eef29b7c84, arm64 defconfig + KCSAN): compile-tested
  crypto/af_alg.o, crypto/algif_skcipher.o, and crypto/algif_aead.o
  with W=1 cleanly (0 warnings/errors).

 crypto/af_alg.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7524070f26d8..000000000000 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -840,7 +840,6 @@ static int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = -ERESTARTSYS;
-	long timeout;
 
 	if (flags & MSG_DONTWAIT)
 		return -EAGAIN;
@@ -849,13 +848,15 @@ static int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	for (;;) {
-		if (signal_pending(current))
-			break;
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, af_alg_writable(sk), &wait)) {
+		if (af_alg_writable(sk)) {
 			err = 0;
 			break;
 		}
+		if (signal_pending(current))
+			break;
+		release_sock(sk);
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+		lock_sock(sk);
 	}
 	remove_wait_queue(sk_sleep(sk), &wait);
 
@@ -898,7 +900,6 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
-	long timeout;
 	int err = -ERESTARTSYS;
 
 	if (flags & MSG_DONTWAIT)
@@ -908,16 +909,15 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	for (;;) {
-		if (signal_pending(current))
-			break;
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout,
-				  ctx->init && (!ctx->more ||
-						(min && ctx->used >= min)),
-				  &wait)) {
+		if (ctx->init && (!ctx->more || (min && ctx->used >= min))) {
 			err = 0;
 			break;
 		}
+		if (signal_pending(current))
+			break;
+		release_sock(sk);
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+		lock_sock(sk);
 	}
 	remove_wait_queue(sk_sleep(sk), &wait);
 
