Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=77.75.79.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794220789;
	b=eO3nIckAvriehcFX81xg2zYHYu3fOFfl6qsUhEcEXqS5vKd73EMw6+P9rcdDdMF4iePh
	 SXCk0lPq9U41e4bHBfMBhiqqer5hH0FoczyQghfJHPiNtd4QOUCqrYwblVP0KvXdvzvLC
	 +1wvj+oy8ilvg2qbfi2PxhT/5biAaqbFA8dULOOIcygdXkuWGycQ/dvBdYx7h3Z8mmoCF
	 YvWBMPtp+zFrGqk9kzXVxB97/rIDUVKBcGJEjgoJOR/Y6nuv22nShdIi1doZKWB8ReSLn
	 sbt5eiyOSXRZDIll5oWYgIgYdg22tfdd1WERVB0h5OtCqUGCRFML7dJLL3uqu4guBNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220789;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-Id:Mime-Version:X-Mailer:Content-Type:
	 Content-Transfer-Encoding;
	bh=QAvczo67RSfalJeCsyzcJCLsA81gRzj2i73BFxVghM4=;
	b=5pozRhZ0aWnLWVc6qf7V57Pgmwa+1Hmw0JvW3KUKuiPS2q02XUu44ixxfGQCFncgI7zI
	 JI1w9fizIFJMuPY4osuUAxKF66TupMVZKEmhAgyjRug96ZdtQkdLCSocTC1pQhgnjds2c
	 SdrCz7ffXVuyF1Gc57MeosdqHABQXGx47xDWdlgHd/NHbR53y/xw3TE5WDo+PckINA44a
	 EKeY65clOWyNpSu648nhAtuZOJ2MYCNuC18jV+sV+nmftp+hpCXG52cbpxK5cjMycdGET
	 NhX6hGKjbP9Z7Sg9M4SKfRYO5B/QKZgUDqrLTCY7ZTSGlFMkqaK3DWEOkQKuhx07cZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=email.cz;
	spf=pass smtp.mailfrom=email.cz;
	dkim=pass header.d=email.cz header.i=@email.cz header.a=rsa-sha256 header.s=szn1 header.b=FlElEeVi;
	arc=none smtp.remote-ip=77.75.79.23
Received: from mxc.seznam.cz (mxc.seznam.cz [77.75.79.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB1606A31C;
	Mon,  9 Nov 2026 10:39:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCFB1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=email.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=email.cz header.i=@email.cz header.a=rsa-sha256 header.s=szn1 header.b=FlElEeVi
Received: from email.seznam.cz
	by smtpc-mxc-685566bfbf-xlpnn
	(smtpc-mxc-685566bfbf-xlpnn [2a02:598:128:8a00::1000:9b3])
	id 0a2fb6b9f4db04130aa138a1;
	Mon, 09 Nov 2026 11:38:52 +0100 (CET)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=szn1;
	t=1794220732; bh=QAvczo67RSfalJeCsyzcJCLsA81gRzj2i73BFxVghM4=;
	h=From:To:Cc:Subject:Date:Message-Id:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	b=FlElEeVi/y5ot2kn+A79b9hWgIgCoDJpxEsC9bi1TycepDmisqCrPJ3rhrdnLwg6l
	 uG8WWC4ct6q2xG+QAI4fZOjj8NfdYiOts1KqRA3rlPRUFH4vhkb/ohAXKuytIyFHkd
	 RItTTrNynfnFo2WBl2ncd/sj1wzYJIN2kNJtnzJAd+LVkbm5LkEL88fEKQSxdBhY/E
	 PH3mMfDXZF6XsKDyOqEnJhy7AiC0/xvqPchvmuVG5OrHz53ZmOA2/pp9qpNvHsZYA5
	 AsHimeXL/hQewfv6VPiRXcmz3byNfqLXLVgpciP7aQxSvG+UqJ2YOKyUv8rLJhpNnV
	 AcVhEn51tpYHA==
Received: from unknown ([82.144.143.215])
	by email.seznam.cz (szn-email-ebox-5.1.30) with HTTP;
	Mon, 09 Nov 2026 11:38:39 +0100 (CET)
From: "Tomas Paukrt" <tomaspaukrt@email.cz>
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: "Shawn Guo" <shawnguo@kernel.org>,
	"Sascha Hauer" <s.hauer@pengutronix.de>,
	"Pengutronix Kernel Team" <kernel@pengutronix.de>,
	"Fabio Estevam" <festevam@gmail.com>,
	"Marek Vasut" <marex@denx.de>,
	<linux-crypto@vger.kernel.org>,
	<imx@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: mxs-dcp - Fix softirq locking and completion
Date: Mon, 09 Nov 2026 11:38:38 +0100 (CET)
Message-Id: <1qB.ZqMy.4DIhrOb2ZPx.1gyQAk@seznam.cz>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (szn-mime-2.2.19)
X-Mailer: szn-email-ebox-5.1.30
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

The request queues are protected by plain spin_lock(), but requests are
enqueued from softirq context (e.g. by ESP on packet receive) as well as=

from process context, while the channel threads dequeue them in process
context with bottom halves enabled. A softirq that runs on the same CPU
while the lock is held either deadlocks on SMP, or corrupts the queue on=

UP where the spinlock does not provide any protection.

In addition, the channel threads call the completion callbacks with
bottom halves enabled, although the crypto API requires them to be
called with bottom halves disabled. With IPsec, esp_input_done() then
runs xfrm_input() and gro_cells_receive() in plain process context,
which races with the NET_RX softirq on the per-CPU GRO cell queue and on=

the xfrm state, and defers the NAPI poll until the next interrupt.

This was observed with strongSwan on i.MX6ULL: the throughput drops
quickly and eventually no packets are decrypted at all.

Fix this by taking the queue locks with spin_lock_bh() and by calling
the completion callbacks with bottom halves disabled.

Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
---
 drivers/crypto/mxs-dcp.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index e1ff6ac8b213..b6749eb8f6f4 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -420,10 +420,10 @@ static int dcp_chan_thread_aes(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		spin_lock(&sdcp->lock[chan]);
+		spin_lock_bh(&sdcp->lock[chan]);
 		backlog =3D crypto_get_backlog(&sdcp->queue[chan]);
 		arq =3D crypto_dequeue_request(&sdcp->queue[chan]);
-		spin_unlock(&sdcp->lock[chan]);
+		spin_unlock_bh(&sdcp->lock[chan]);
 
 		if (!backlog && !arq) {
 			schedule();
@@ -432,12 +432,17 @@ static int dcp_chan_thread_aes(void *data)
 
 		set_current_state(TASK_RUNNING);
 
-		if (backlog)
+		if (backlog) {
+			local_bh_disable();
 			crypto_request_complete(backlog, -EINPROGRESS);
+			local_bh_enable();
+		}
 
 		if (arq) {
 			ret =3D mxs_dcp_aes_block_crypt(arq);
+			local_bh_disable();
 			crypto_request_complete(arq, ret);
+			local_bh_enable();
 		}
 	}
 
@@ -480,9 +485,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request=
 *req, int enc, int ecb)
 	rctx->ecb =3D ecb;
 	actx->chan =3D DCP_CHAN_CRYPTO;
 
-	spin_lock(&sdcp->lock[actx->chan]);
+	spin_lock_bh(&sdcp->lock[actx->chan]);
 	ret =3D crypto_enqueue_request(&sdcp->queue[actx->chan], &req->base);
-	spin_unlock(&sdcp->lock[actx->chan]);
+	spin_unlock_bh(&sdcp->lock[actx->chan]);
 
 	wake_up_process(sdcp->thread[actx->chan]);
 
@@ -750,10 +755,10 @@ static int dcp_chan_thread_sha(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		spin_lock(&sdcp->lock[chan]);
+		spin_lock_bh(&sdcp->lock[chan]);
 		backlog =3D crypto_get_backlog(&sdcp->queue[chan]);
 		arq =3D crypto_dequeue_request(&sdcp->queue[chan]);
-		spin_unlock(&sdcp->lock[chan]);
+		spin_unlock_bh(&sdcp->lock[chan]);
 
 		if (!backlog && !arq) {
 			schedule();
@@ -762,12 +767,17 @@ static int dcp_chan_thread_sha(void *data)
 
 		set_current_state(TASK_RUNNING);
 
-		if (backlog)
+		if (backlog) {
+			local_bh_disable();
 			crypto_request_complete(backlog, -EINPROGRESS);
+			local_bh_enable();
+		}
 
 		if (arq) {
 			ret =3D dcp_sha_req_to_buf(arq);
+			local_bh_disable();
 			crypto_request_complete(arq, ret);
+			local_bh_enable();
 		}
 	}
 
@@ -827,9 +837,9 @@ static int dcp_sha_update_fx(struct ahash_request *req=
, int fini)
 		rctx->init =3D 1;
 	}
 
-	spin_lock(&sdcp->lock[actx->chan]);
+	spin_lock_bh(&sdcp->lock[actx->chan]);
 	ret =3D crypto_enqueue_request(&sdcp->queue[actx->chan], &req->base);
-	spin_unlock(&sdcp->lock[actx->chan]);
+	spin_unlock_bh(&sdcp->lock[actx->chan]);
 
 	wake_up_process(sdcp->thread[actx->chan]);
 	mutex_unlock(&actx->mutex);
-- 
2.43.0
