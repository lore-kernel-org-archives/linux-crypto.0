Received: from 10.mo583.mail-out.ovh.net (10.mo583.mail-out.ovh.net [46.105.52.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDCE3B635A
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.105.52.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154417; cv=none; b=lAv7P9d4znqACvf1DylLPQbg32wgawyuPYhpqiieZwE7JYTCOxasyCOY47z0HGJTLUMgnwIkpmlMK1mmGsES7oI4IaNVzSvPF6lBVYVYr0tm1mMaN9Fjjjp2nxmLNMQRQtVBb5LV9gCj//OdA+qMkwdlSB11Hcs2TxlBnhQLqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154417; c=relaxed/simple;
	bh=GoWEVXuz3SV+0QV9W0MsYJgQqCZkJcUhEIBaJR097YY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hZxWGBHSFkJFi9m2ZG/bk8c9bvoo27JoE7DNaYzUP6toB2J/kuJEndUOqEBBiJNKCf1pxXSsBYu2zqpCvRQX6H64al98bgvjGoFAHOfZbOIPEH+ACNAT/+txFvndTkH2dLSqGFJv8ggXc56Kk4y52BJo7bW0SMU1+wt5wAkGmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com; spf=pass smtp.mailfrom=cynove.com; dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b=A+nEdGPV; arc=none smtp.client-ip=46.105.52.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cynove.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b="A+nEdGPV"
Received: from director3.ghost.mail-out.ovh.net (unknown [10.110.0.14])
	by mo583.mail-out.ovh.net (Postfix) with ESMTP id 4j5fBH1cpGz60bY
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 09:03:51 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-4kjr4 (unknown [10.111.174.188])
	by director3.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 12AEEC04D3;
	Fri, 16 Oct 2026 09:03:49 +0000 (UTC)
Received: from cynove.com ([37.59.142.97])
	by ghost-submission-7ccd8bbbb6-4kjr4 with ESMTPSA
	id fClPE3Xo0WpZ/AEAmtFogg
	(envelope-from <stephane.debusne@cynove.com>); Fri, 16 Oct 2026 09:03:49 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-97G002c379f266-6ab0-44a4-95a2-c2dc528ae5e8,
                    49BC7871EA8B080B249AF49F55FA702C3B4DE52D) smtp.auth=Stephane.Debusne@cynove.com
X-OVh-ClientIp:176.150.47.247
From: Stephane Debusne <stephane.debusne@cynove.com>
To: herbert@gondor.apana.org.au,
	lukas@wunner.de
Cc: ignat@cloudflare.com,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stephane Debusne <stephane.debusne@cynove.com>
Subject: [PATCH 0/2] crypto: fix RSA results corrupted by non-coherent DMA
Date: Fri, 16 Oct 2026 11:03:31 +0200
Message-ID: <20261016090333.2247764-1-stephane.debusne@cynove.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 16750857342188313563
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: dmFkZTFlDJDNKLqFduT/370hRQ5dRI/SmGTr4shXvC9E/Ty9GgWmhxjv+LwCv8DAvqa3lfjgBrQNCRpCzEb/sZMLgjorAT4odv0nEzCfsLOoRAwN/8zu6f8t4h/7BZDgweRxgwPkE20XxT9nnqNpQROyldPxRoxYx3SkZP/0G/K9PsgMgdfX6ID1n9WWRVHf6PCvxnpOowfisB8qpm7mFZi+15XqRCJbSNZ3Haoz+xEdYwKTQ27dFUHzn+txv9/T1tIGElPXeKNiy+O/iLFXaGBeJgnGAXXNxjDe99gRPPmPfrhoO4bgTRe5wwJ3MABdkrhwhMU15ClpjR990esw8nLpU4wTN6e3fCg7sHasRTjAgSrswNnkou1oToWF3/L6Cr/SeSXd8Cq4a5gHfXbx5Z4KRLhqX5Q7d4DxMdwXlk5a5HqBDbf1sxjLMKMwGCX7EcIaqOSf8R5WeqC/q2Cfl4fg/Nc67cjD62UslzI0kViHqghi514muXJhut/HIT0D5Bby8/+KWMpcOIVqebj/nA+0Fhtd8d7BSH+T1NvN8KHUtcqKIgBgIPh5xelVjhi8U2/dF4LkHvpweXNaPLxWdC8ayuTDGRrIgN2v2r4okFONJnfm4yepcKerPwQe5IoaR2unuWw0f8HuzQLnQIJxPWhvpOvL0OBXofA2lwCxuZDwwTbiMg
DKIM-Signature: a=rsa-sha256; bh=edf/xAgFCHK0tt5B2Dt64h3lDrjvSXV1WHSKZFxFQ/g=;
 c=relaxed/relaxed; d=cynove.com; h=From; s=ovhmo4616632-selector1;
 t=1792141431; v=1;
 b=A+nEdGPVPnL9IQ4tUB7NPZC299CcYNgFOzRqHaSNvX3PZu5q43FPjHS+6kEs6T5BU/6Ahx+f
 afE/1JaoVAXLk6vT5WdUo/a0RDwyZAJqKOAk6lbAsRqhvm+Pb1dBvRCYpaWYBW9gcbi/4bAUtv2
 nFNZukjMzrDnX/5ludRcb2z8eyO1HOyp/DMPOiygAAlXHokbgUB+5taH0bzKiHfZkEVb3geOvzS
 nPJwJ4DiPNg9kIz1WL2q4IOPYPvdHrSmWs3XhzxnOuAF5m55vy4fBniq+9Y6YCimYC0El4V8kB7
 wiYoGoDUJbUcN6LddVrTCzk6eR0TcM/zVi02hgqySkLhg==

On i.MX8M Mini with the CAAM (rsa-caam, caam_jr loaded), PKCS#1 v1.5
signature verification fails almost every time: cfg80211 rejects
regulatory.db ("loaded regulatory.db is malformed or signature is
missing/invalid"), and a valid self-signed X.509 certificate cannot be
added to a keyring (EINVAL). Seen with the NXP BSP lf-6.18.37 and stable
updates up to 6.18.57; the code involved is identical in mainline.

crypto_akcipher_sync_prep() and rsassa_pkcs1_verify() place the data
buffer right after the request context, in the same allocation. caampkc
writes req_ctx->edesc and req_ctx->akcipher_op_done after mapping the
destination, so the cache line shared by the end of the context and the
start of the buffer is dirty while the device writes the result. On
arm64, dma_unmap_sg(DMA_FROM_DEVICE) cleans and invalidates that partial
line, and the stale CPU copy overwrites the first bytes of the result.
The self-tests pass because testmgr uses separate buffers.

A test module comparing rsa-caam with rsa-generic (2048-bit key, 200
public-key operations per case, CAAM era 9, non-coherent DMA) gives:

  destination buffer                        wrong results
  separate kmalloc() buffers                0/200
  in place, own kmalloc() buffer            0/200
  separate source, dst after req. context   200/200
  in place, after req. context (rsassa)     200/200
  crypto_akcipher_sync_encrypt()            199/200 (patch 1: 0/200)
  pkcs1(rsa-caam,sha256) verification       398/400 (patch 2: 0/200)

In the wrong results reported, bytes 0 to 23 always hold the previous
content of the buffer: the buffer starts 168 bytes into the allocation,
at offset 40 of the 64-byte line that also holds edesc and
akcipher_op_done. The rare correct results are consistent with that
line being evicted before the device writes.

Both patches give the data buffer its own allocation, as rsa-pkcs1pad
did before 6.13. The driver could instead avoid writing its request
context while the buffers are mapped, but any DMA-based akcipher on a
non-coherent platform could hit the same problem, so fixing the callers
seemed more robust. rsassa_pkcs1_verify() could also use the fixed sync
helper instead of its own allocation; I kept the change minimal, and
will gladly rework the series in either direction.

Tested on i.MX8M Mini with 6.18.57: with caam_jr loaded, regulatory.db
loads again, and the test module reports no wrong result through the
sync helper and the pkcs1 template. The test module is available if
useful.

Stephane Debusne (2):
  crypto: akcipher - use a separate buffer in the sync helpers
  crypto: rsassa-pkcs1 - use a separate buffer for the RSA output

 crypto/akcipher.c     | 21 ++++++++++++++-------
 crypto/rsassa-pkcs1.c | 16 +++++++++++++---
 2 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.43.0

