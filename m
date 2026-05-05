Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA773C062A
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003634; cv=none; b=U3LNRAJycNJv/CM+OVIFpdPAIB9hOxTvOymb7LtJWnWklvheqrPb1qjWClbMHZZF+CNL2sgg1IFgc4/3+TNIa84N2eKuZcjjhyiZ7CnZU6nByle3ZTmQzbDUAxYTHLSyVZ2jKxDrl+yoBVJom6fIveCBdd+/G31+V/cidX/tSvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003634; c=relaxed/simple;
	bh=d7l8rMF/C3s/JG8I/gsuys9MS5oeVq+HHK5mTKkji48=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JeAl90CGpYlEkNpVTyid+M7xS06zgemprhmshbEnlky8oGHiR/4lIEVR060nrlS0TM5JMTfJGWCcDOfTL5wssNDvL5kEnzZ4TpV9KW9bSv2rtS6UrIIAc1W96/e9Z2ENn8qUge+EdAfQ+UUBGngOXXKnYoXUgJHhCs/eVJK6KVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=HPxPnauu; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="HPxPnauu"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id EFEA74E42BD3;
	Tue,  5 May 2026 17:53:50 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B6ADC6053C;
	Tue,  5 May 2026 17:53:50 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9EEAB11AD040F;
	Tue,  5 May 2026 19:53:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003629; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=dxldTbtOSAyaheeA24Yh7elO+quNlogPqqRD2eUj6Dg=;
	b=HPxPnauuBFBE2L9olxdPuklSRsDxrywpYhKd5ByuOCMQexQo/ZtFcf4rpv2hUsE/Dd/zyp
	VL6/g5Ovw6ru9f8QAymtmLc2dL9J0aTmc/EucEMt20HTjFYe3u2MXIjJrt3cAzrpXlpKaN
	ZWU0c1i9yLdnTYYoSc+HqX+0CwaUSzdjBNAA13FRh9qQhGZDAzDLZU54lxN1DzKzdzO5m0
	ivaHGdpddvw8mOxwFIElG3Dpi/FEcAOKvKLdF/PatLQXJtWgDhjIJtP/8ptaFQSHuQmJ4u
	26tJtfttOckOqoe311tjvmyU1O4zj0+VU+PvwtoPYUPwt+R6OhO/WE0Hrag6pQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:02 +0200
Subject: [PATCH v2 01/12] crypto: talitos - use dma_sync_single_for_cpu()
 before reading descriptor header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-1-5818064bd190@bootlin.com>
References: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
In-Reply-To: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=2033;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=d7l8rMF/C3s/JG8I/gsuys9MS5oeVq+HHK5mTKkji48=;
 b=z+vo3HqZrvGx5O0cPhVMj2jvHx6+5eZVJJ84tzraSuGzKlVgfEYwAwndK6S7abyBc5f9JKXZS
 oOTXXRR1b4UAH+JzbymHjIfifcybmRLLpPiloJLIFuEJoYHI1FllNeb
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

In order to know if a descriptor has been processed by the device,
the driver polls the FIFO to see if DESC_HDR_DONE is set on a descriptor
header to confirm completion.
The current code does not make sure that the CPU gets up to date data
before reading the descriptor.

Fix this by calling dma_sync_single_for_cpu() before reading memory
written by the device.

Cc: stable@vger.kernel.org
Fixes: 58cdbc6d2263 ("crypto: talitos - fix hash on SEC1.")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bc61d0fe3514..303640e64717 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -322,15 +322,25 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	return -EINPROGRESS;
 }
 
-static __be32 get_request_hdr(struct talitos_request *request, bool is_sec1)
+static __be32 get_request_hdr(struct device *dev, struct talitos_request *request, bool is_sec1)
 {
 	struct talitos_edesc *edesc;
+	dma_addr_t dma_desc;
+
+	if (!is_sec1) {
+		dma_sync_single_for_cpu(dev, request->dma_desc,
+					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 
-	if (!is_sec1)
 		return request->desc->hdr;
+	}
 
 	if (!request->desc->next_desc)
-		return request->desc->hdr1;
+		dma_desc = request->dma_desc;
+	else
+		dma_desc = be32_to_cpu(request->desc->next_desc);
+
+	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
+				DMA_BIDIRECTIONAL);
 
 	edesc = container_of(request->desc, struct talitos_edesc, desc);
 
@@ -358,7 +368,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		hdr = get_request_hdr(request, is_sec1);
+		hdr = get_request_hdr(dev, request, is_sec1);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;

-- 
2.53.0

