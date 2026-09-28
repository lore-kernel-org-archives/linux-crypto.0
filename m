Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84364C8FFE;
	Mon, 28 Sep 2026 14:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604421; cv=none; b=nyufM6WaF+iihuNhY6qlOcx2ZR5yB7lDj0kfuv+Ihm2M8q1bI+bv7eoR0vQZ4u0cbNzneyVOe3DE6HruMO1XjN+LGVLm/fJO4xcBB1tPfNlregBonMM+zKS3Bc7ShbAZgm7gfXLMKlnToZaNZdnmu9AopjdFo+NmqZLAFLkqHS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604421; c=relaxed/simple;
	bh=rjb62LS2EAfHJHrEK2dlUefkAbXZgfuGW1JH8vEiC/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KT0HzUWMnwDKTLER6htPe23tlOIMr7Za78Tl7ofHkm2UUFW/ElGcpiKZyQuffgWlAtiGg9qFwwqjb/D/vfuJ0vl316EOwNWcPzCAnTCWwM61jtjQ0sHy8MG+Ot8mqS97g6iepN36+ET27MODtzcrhN1XmViN9wQzv3Tr5d22B50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApG6lPGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApG6lPGn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 417C3C4AF0B;
	Mon, 28 Sep 2026 14:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790604421;
	bh=rjb62LS2EAfHJHrEK2dlUefkAbXZgfuGW1JH8vEiC/o=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ApG6lPGnPZAdpez+ls6BEwhBXEYPByCQOjxLJ+nnfgKIniTZrfK2+JOEiRUCLPpiz
	 h/FM2ctAbGXaQCqYwJu8rYo1TcIB4SzAwbV86QWOxj7LzmkjhemGHzWfTrhIe9MIIq
	 Tt7ub51jyHxeT9dAM47hKVCt99NfPgYLbKXdlIqpGQyqkCyRQGCpc8kA72S1zFCQ5Q
	 VyR7Nlgb3kmnj+H/5yVdSNOjszmyojBdLEqKVidToMedPf+tx3lm7sXfR0uSwumcn/
	 ksp3w1qqmEbHEgappUi34aYELC2Zyp1uDT5xkXeKbHXl/XCfBEZBGE1/ZhS8vUw6iK
	 uPjtcDTxP8r0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDD6CA5FA6;
	Mon, 28 Sep 2026 14:07:01 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Date: Mon, 28 Sep 2026 16:06:56 +0200
Subject: [PATCH] crypto: caam/qi2 - reset the DPSECI at probe only when
 enabled
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-for-upstream-caam-qi2-dpseci-reset-v1-1-042be6c05472@free.fr>
X-B4-Tracking: v=1; b=H4sIAH90umoC/x2NwQ6CMBAFf4XsmU2gIgK/YjzU9hX3INRdNCaEf
 7fxMslcZnYyqMBoqnZSfMRkXYq0dUXh4ZcZLLE4ucb1zegGTqvyO9um8E8OvuAljmM2BGGFYeP
 zeGnjcErdvUtUQlmR5PufXG/H8QOy3DuhdAAAAA==
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, 
 Sahil Malhotra <sahil.malhotra@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Jardin <vjardin@free.fr>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790604419; l=1994;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=64VY4tkbF5YIprmJtGNmeGjNbSHu8M2PhnkG7m0FjNk=;
 b=CBnORxWR3872L1eaK2z5NVlQtTdwHgCmKeIvcfWveQzvlrEYka2Fl5j+x6gHK9eLxwfMa1iiL
 aqdGIkdTNQKBoNesJ+hoIHvMP10jChPM6DLySTAWTEVf6XF2i8mNMng
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr

From: Vincent Jardin <vjardin@free.fr>

Since the commit
  060ce5037d5f ("crypto: caam/qi2 - add support for dpseci_reset()")
probe resets every DPSECI.

On a DPSECI the MC has just created from the DPL, never enabled,
MC 10.40.x then logs for each of its queues:

  [E, qbman_rec_isr:396, QBMAN]  QBMAN recoverable event 0x1000000
  [E, dpmng_dump_rerr_fqid:1335, QBMAN]  REL_FQ (FQ[0]) has 1 messages, dumping up to 16:
  [W, DPSECI]  DPSECI ID[0]: Flush on queue 43 not confirmed

That is 16 error lines for an 8-queue DPSECI, at every boot, although
there is nothing to flush: a disabled DPSECI has no request in flight.

The reset at remove is unchanged.

Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
 drivers/crypto/caam/caamalg_qi2.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6b47bcc16a50..6dccbd3b27a3 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5041,11 +5041,22 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 	dev_info(dev, "dpseci v%d.%d\n", priv->major_ver, priv->minor_ver);
 
 	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
-		err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
+		int enabled;
+
+		err = dpseci_is_enabled(priv->mc_io, 0, ls_dev->mc_handle,
+					&enabled);
 		if (err) {
-			dev_err(dev, "dpseci_reset() failed\n");
+			dev_err(dev, "dpseci_is_enabled() failed\n");
 			goto err_get_vers;
 		}
+
+		if (enabled) {
+			err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
+			if (err) {
+				dev_err(dev, "dpseci_reset() failed\n");
+				goto err_get_vers;
+			}
+		}
 	}
 
 	err = dpseci_get_attributes(priv->mc_io, 0, ls_dev->mc_handle,

---
base-commit: 67aefeccc4101a93627f36abbd049f191b54f903
change-id: 20260928-for-upstream-caam-qi2-dpseci-reset-5971d83f4b4f

Best regards,
-- 
Vincent Jardin <vjardin@free.fr>


