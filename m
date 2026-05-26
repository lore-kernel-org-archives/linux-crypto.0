Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F7D38D6A4;
	Tue, 26 May 2026 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779811085; cv=none; b=GOus3g34JLtjDrWprl20WezMMB3qC8vTH0ol1jQQkdSJlsVhDx6blIMUBbRTil9UoNQn1iL9d636KPquS26gMeTPUGw4Pqf+O0cfVbCoQ+TmpNPBNaA3Xb6pQIMgmb2cpXKrWU09qNl85oeAc3xe/02gdCSmTNkMLesGucFefWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779811085; c=relaxed/simple;
	bh=H4n+53zUYuHpXSjLSw4e1XuvhsLJKesWY8Lmu6oKKXU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L+wp0DKx4mI141uXckKGRqqLCHNc7bJKwNFRRGGDmYWErOWx/NZXy86piOZsRshLU3XuCQkcFSmzCInnOjcCqp/lY7W9dcaZFJIJMlg8Q4TcpaZCCUBGaFaTXrx3Y30k6ZBA2pnfQWRXhgUQmhXvCeyu2ERxpLHCzn2uUuVoNts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAD3a+8AwxVq_vR7EQ--.8218S2;
	Tue, 26 May 2026 23:57:52 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Ayush Sawal <ayush.sawal@chelsio.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chelsio: fix inflight counter leak in chcr_aes_encrypt()
Date: Tue, 26 May 2026 15:57:36 +0000
Message-Id: <20260526155736.2297383-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3a+8AwxVq_vR7EQ--.8218S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw15CrW3CF1DGw48uFykZrb_yoW8Jw18pF
	45CrZYy3yrJw1fGa4ktw4rCFy5Z39xurWakFWjyw4UXrnxtFyxX3sxZFW0vF18JF1rJ3y3
	Z39ak343u3WDCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjJ73PUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAYTA2oVtuIbSAAAsi

chcr_aes_encrypt() increments dev->inflight via atomic_inc() before
submitting the cipher operation. If chcr_start_cipher() subsequently
fails, the function returns an error without decrementing dev->inflight,
causing the counter to drift and potentially stalling future operations
that rely on the counter reaching zero.

Add atomic_dec(&dev->inflight) on the chcr_start_cipher() failure path
to restore the counter.

Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6dec42282768..eece1ac1085a 100644
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
-- 
2.34.1

