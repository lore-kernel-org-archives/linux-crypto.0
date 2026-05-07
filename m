Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A4A3F7A81;
	Thu,  7 May 2026 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778162162; cv=none; b=XXAvbsrejDM/BX3Gt3YgAvVzZJpASmRfAEZruF6TNQACfiW5x+01c7tV6PQse3tRtOA3QRGmHzTFgZ+w8DIi/r1W5lMdGbJxLPous2RTzWITR5LJUEgjdiPpN9IF5hO047snDlJq3brp6qnPNVuPAoyJgO6hRKTt3ZqS5aL2Tyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778162162; c=relaxed/simple;
	bh=aVCy1hInQ45HcL3yLOgWnhTxaxk2VpYFwSI9ioAk6Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J2y3yIXvZPdsMxrhEoM+JjGvt91ACbJinhPjrokzYqhxDQ25eotfX6f0RPcu7OOXhhJnfco3E5BnQSEEMrcuWsfHm7IFmuzVY46gZYQYhWpPO/NGehuew3m6eT+hTdtRGGnp0QaoNGdY4uriaDuuRDjIV62kRT2aRISPCB0Eqwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H3SD+9ao; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H3SD+9ao"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778162158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=et12f+JBlWCvrIykUAG98jlPA42V3ob8Dp6+bnOSQHI=;
	b=H3SD+9aorpsQgmKm9KhQNK1BtZ3U1CBgSmkr7fhAsep8OsdnD3LfhUOp0POFY9GuOZdSPP
	Hc/a39hxl+LfPkCUCbzBal1QRgiKThoTTJ86ECBSlAewFmUFo9M8fS5fyYARTFshkHY/vX
	Y9el1qMVOp614bKobm4/Cobe1wCM1II=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - replace min_t with min
Date: Thu,  7 May 2026 15:55:27 +0200
Message-ID: <20260507135525.331107-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1183; i=thorsten.blum@linux.dev; h=from:subject; bh=aVCy1hInQ45HcL3yLOgWnhTxaxk2VpYFwSI9ioAk6Bw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJl/Zp5j6TX1Ck2RDYkxvn9sel7jxkuL/e/sfFDxrdJns 4WMs9yyjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZhIAjvD/6onj37d/17GskSt UH5Ja8h04W/frGQMo8zmGRxYt7tgzVpGhsMbeg0tXq7f9+a/bGb7tOTjQr3V+jZ/P4pZbaz5EPM 7hh8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use the simpler min() macro since the values are all unsigned and
compatible.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index b6a77c8d439c..2cf53f0b6742 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -56,7 +56,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 		goto free_work_data;
 
 	/* might want less than we've got */
-	n_sz = min_t(size_t, ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
+	n_sz = min(ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
 
 	/* copy the shared secret */
 	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, n_sz),
@@ -150,7 +150,7 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
 		return -EINVAL;
 
 	/* might want less than we've got */
-	nbytes = min_t(size_t, ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
+	nbytes = min(ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
 
 	/* public key was saved at private key generation */
 	copied = sg_copy_from_buffer(req->dst,
