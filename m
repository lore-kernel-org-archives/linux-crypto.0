Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806D629D270;
	Mon, 22 Jun 2026 14:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782139559; cv=none; b=DeKOF13+8pDFOVXPeU1GC43C8Ig/fxVXDL/lRSTgzi4bY1LdIXxxrdbbQY14/B+dVEkBzagV/Z+AkMRVw/jkWDJ9Qb0LGfuNKbBO4jpGCpw9djDRYhi7pqu4VySDgh5RpLU9bcJJ8RInRz9hzXwRH2XKaj43uU1hZBDtBZMVFKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782139559; c=relaxed/simple;
	bh=seEuGJQPHl7cpUghtZ7WZ3R5gvpd1kZRcayw8AKhYjk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oDpcaG+4mbeWthi/o3l8Biy+U51v8MVH0r5WHErz3IfoSoqO3Z3ZT/VaHV+/FrOMAJN5SGHsegfaGDXpdt2dQbhEE6CA9cysvJglD9GZjdfqSDBsCUklwxad9GdeEUFcIjnCcU8krtzLdL/jjoVkr85RDq35FneKjW142OFTLt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.74.238])
	by APP-01 (Coremail) with SMTP id qwCowAB3GtObSjlq8snAAg--.26626S2;
	Mon, 22 Jun 2026 22:45:49 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Ayush Sawal <ayush.sawal@chelsio.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: chcr - fix inflight counter leaks in multiple paths
Date: Mon, 22 Jun 2026 22:45:44 +0800
Message-Id: <20260622144544.47023-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3GtObSjlq8snAAg--.26626S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWUAw15urWDWw43Ar1DWrg_yoW8KrWDpF
	s8CrZYyryrXr17GF9Yyw1rWa43X3y29FWakrW5ta40vwsYq3ykXFsFvF1jvF1rJFWrJ3yU
	X3yqqF1rZa4DGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbSfO7UUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCREGA2o5I0xq6AABsi

In multiple functions, dev->inflight is incremented via atomic_inc()
before submitting operations. If subsequent calls fail, the functions
return without decrementing the counter, causing it to drift and
potentially stalling future operations that rely on the counter
reaching zero.

Fix the following functions with missing decrement on error paths:
- chcr_aes_encrypt()
- chcr_aes_decrypt()
- chcr_aead_op()

For chcr_aes_encrypt() and chcr_aes_decrypt(), use a common error
label to decrement the counter. For chcr_aead_op(), use the existing
chcr_dec_wrcount() helper on the invalid assoclen error path.

Cc: stable@vger.kernel.org
Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6dec42282768..b69cd46193d0 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1359,7 +1359,7 @@ static int chcr_aes_encrypt(struct skcipher_request *req)
 	err = process_cipher(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx],
 			     &skb, CHCR_ENCRYPT_OP);
 	if (err || !skb)
-		return  err;
+		goto error;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, reqctx->txqidx);
 	chcr_send_wr(skb);
@@ -1402,11 +1402,15 @@ static int chcr_aes_decrypt(struct skcipher_request *req)
 	err = process_cipher(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx],
 			     &skb, CHCR_DECRYPT_OP);
 	if (err || !skb)
-		return err;
+		goto error;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, reqctx->txqidx);
 	chcr_send_wr(skb);
 	return -EINPROGRESS;
+
+error:
+	chcr_dec_wrcount(dev);
+	return err;
 }
 static int chcr_device_init(struct chcr_context *ctx)
 {
@@ -3636,6 +3640,7 @@ static int chcr_aead_op(struct aead_request *req,
 	    crypto_ipsec_check_assoclen(req->assoclen) != 0) {
 		pr_err("RFC4106: Invalid value of assoclen %d\n",
 		       req->assoclen);
+		chcr_dec_wrcount(cdev);
 		return -EINVAL;
 	}
 
-- 
2.39.5 (Apple Git-154)

