Received: from avas.easytechitalia.it (avas.easytechitalia.it [213.217.29.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE81337CD37
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.217.29.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789842912; cv=none; b=d9joBJtrYKuuINoc8TpF1DHcEucDlntpsNRri87PBuJLsC3Bg9Ds39m8R+zpiZpidNrv7rTi73fkoYgUa35/FzTowXezskd4Q32URqM6TeP9nKLVI4zCKQhX4xxQ2k9Aa250xDh4gymbRGy3/ORV/s84LIZwjIzK1uJyCXLcjKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789842912; c=relaxed/simple;
	bh=WZKqz9Pjp9IbxwKnnjJMCoDrZUGJgQLyC9UkIsSvjg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dz9le5atiQ1SeEXvH66hQZ8oROT1tlkfLaNTm8mpWTZtZbvOr516oU8A40lYAQPH2W+0IbORjy/a+EP2qBSeKAa7QtN+vTjEmP4siUJ7dcjb5nFrneXmOADl0YryZYlDnFi7EYQ7HpJw3Vl6QqSNMUSbown6rI1BiKMD3QR4KCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it; spf=pass smtp.mailfrom=mtsistemi.it; dkim=fail (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b=RLm73v33 reason="key not found in DNS"; arc=none smtp.client-ip=213.217.29.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b="RLm73v33"
X-Envelope-From: <info@mtsistemi.it>
Received: from ngmx.easytechitalia.it (unknown [185.76.140.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by avas.easytechitalia.it (Postfix) with ESMTPS id 4hnJ7f0WnjzGnvF;
	Sat, 19 Sep 2026 20:34:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 7B47817E253;
	Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10032)
 with ESMTP id JgjQGt_kBwqQ; Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 1EEAB17E25B;
	Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 ngmx.easytechitalia.it 1EEAB17E25B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mtsistemi.it;
	s=AD82E3E6-03E3-11EF-83D2-AF8217D6D3C6; t=1789842805;
	bh=69GThVRBX0y+4BCiNp+SP12TJgKM5RYrB/M45yfLKkY=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=RLm73v33vsHnRcPtDLrSLMH4qCqiEg6aIEOpZ9/TC5CTYGMZhJ6ma8WoCZg00VH84
	 Os+R/alWfK7SVmL68TQ3ZSzs2UYX/6pFqezat8GXkRT80uC4/1f7OB5r2uGRVO7XMA
	 qoP2KkNyFF4RAkGEwgzjT9cGX9j3e/EX1Ip05accJmatQyPvsBCzU/gXE8qMyve/ec
	 BP41s5G4zyjs7YWYhNi5tEanqOFygHqPc35JQuTM00/GmeVTOz4istfxgmZ984iRa/
	 dsOtSlFEeH1em0rAgSu89AL18a0dpwh3UK9VTvOGrqk9WxhnbHjlshW7sUxMJJXiq8
	 XkqlFpgIUTKcw==
X-Virus-Scanned: amavis at ngmx.easytechitalia.it
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10026)
 with ESMTP id 9mJkb6nJSa7r; Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from [192.168.56.1] (93-38-124-109.ip70.fastwebnet.it [93.38.124.109])
	by ngmx.easytechitalia.it (Postfix) with ESMTPSA id BDF5817C481;
	Sat, 19 Sep 2026 20:33:24 +0200 (CEST)
From: Mattia Tadini <info@mtsistemi.it>
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH 2/3] crypto: ccp - do not start PSP sub-devices without their vdata
Date: Sat, 19 Sep 2026 20:34:50 +0200
Message-ID: <178984289057.12336.8102552838289034525@mtsistemi.it>
In-Reply-To: <178984289056.12336.17662860552012704364@mtsistemi.it>
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Easytech-Libra-ESVA-Information: Please contact Easytech S.r.l. for more information
X-Easytech-Libra-ESVA-ID: 4hnJ7f0WnjzGnvF
X-Easytech-Libra-ESVA: No virus found
X-Easytech-Libra-ESVA-From: info@mtsistemi.it
X-Easytech-Libra-ESVA-Watermark: 1790447694.55867@xEJd4m62wola3DctfP8N5w

psp_init() decides whether to bring up SEV and TEE from the hardware
capability register alone:

	if (!psp_check_tee_support(psp)) {
		ret =3D tee_dev_init(psp);
		if (ret)
			return ret;
	}

tee_dev_init() then needs psp->vdata->tee, and fails with "tee: missing
driver data" when the vdata does not carry it. That failure is fatal to
psp_init(), so platform access, DBC and HSTI are lost along with it even
though none of them depends on the TEE.

Require both the hardware capability and the driver data before starting
a sub-device, so a psp_vdata that deliberately omits SEV or TEE gets the
rest of the PSP rather than nothing at all.

Signed-off-by: Mattia Tadini <info@mtsistemi.it>
---
 drivers/crypto/ccp/psp-dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index b14ce51..c9ab47c 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -198,13 +198,17 @@ static int psp_init(struct psp_device *psp)
 {
 	int ret;
=20
-	if (!psp_check_sev_support(psp)) {
+	/*
+	 * The capability register describes the silicon and the vdata describe=
s
+	 * what this driver was given to drive it with. Require both.
+	 */
+	if (psp->vdata->sev && !psp_check_sev_support(psp)) {
 		ret =3D sev_dev_init(psp);
 		if (ret)
 			return ret;
 	}
=20
-	if (!psp_check_tee_support(psp)) {
+	if (psp->vdata->tee && !psp_check_tee_support(psp)) {
 		ret =3D tee_dev_init(psp);
 		if (ret)
 			return ret;
--=20
2.55.0

