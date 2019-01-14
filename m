Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726534AbfANNxH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 08:53:07 -0500
From: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth Jampala" <jsrikanth@marvell.com>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Invoke callback after DMA unmap
Date: Mon, 14 Jan 2019 13:52:24 +0000
Message-ID: <20190114135204.20693-1-rnagadheeraj@marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In process_response_list() invoke the callback handler after unmapping
the DMA buffers. It ensures DMA data is synced form device to cpu
before the client code access the data from callback handler.

Fixes: c9613335bf4f ("crypto: cavium/nitrox - Added AEAD cipher support")
Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/=
cavium/nitrox/nitrox_reqmgr.c
index fe070d75c842..4c97478d44bd 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -537,6 +537,8 @@ static void process_response_list(struct nitrox_cmdq *c=
mdq)
 	struct nitrox_device *ndev =3D cmdq->ndev;
 	struct nitrox_softreq *sr;
 	int req_completed =3D 0, err =3D 0, budget;
+	completion_t callback;
+	void *cb_arg;
=20
 	/* check all pending requests */
 	budget =3D atomic_read(&cmdq->pending_count);
@@ -564,13 +566,13 @@ static void process_response_list(struct nitrox_cmdq =
*cmdq)
 		smp_mb__after_atomic();
 		/* remove from response list */
 		response_list_del(sr, cmdq);
-
 		/* ORH error code */
 		err =3D READ_ONCE(*sr->resp.orh) & 0xff;
-
-		if (sr->callback)
-			sr->callback(sr->cb_arg, err);
+		callback =3D sr->callback;
+		cb_arg =3D sr->cb_arg;
 		softreq_destroy(sr);
+		if (callback)
+			callback(cb_arg, err);
=20
 		req_completed++;
 	}
--=20
2.13.6
