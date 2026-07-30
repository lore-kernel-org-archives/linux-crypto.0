Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881323769FD;
	Thu, 30 Jul 2026 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426554; cv=none; b=FeYzq14Aa1nz0dYCTsbzGHlVs8JFtlZT83Hp7YD8s+Wx0+qEyUHgomdsZ2vD1syb42HzYsheRadmdQWug8fmFEp80MB/sTZMrko3Axxm6oyr9pbwZDdFLaRT96LqXa2ANlDBkofCvDEFCngcrm7sUG4GaC9gvEp4gQr75ekZTwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426554; c=relaxed/simple;
	bh=ef/w9yRThGeLT84r1K2pqV/vuBy7b9I3wtNWQxDZK5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uOCSQ+n1uW7W8iOqRzsa/n/anrOxd4PrCaMLoGgfgQdTpZzG4IVz/NE/bfMxi5Wjo0E45eIqdLI3d9eMDcovIkx41HamUuEDXQ3meckEPtF2uoGhcLtvIHBoM/DIjUQ40GMcwOCS9sXsrjPE/sgWj9D6qw5DrdwAG5tNRUTbibY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=iYukZoI2; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="iYukZoI2"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id A18F91A131F;
	Thu, 30 Jul 2026 15:49:09 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 75B645FFA8;
	Thu, 30 Jul 2026 15:49:09 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 57A5811C15D8B;
	Thu, 30 Jul 2026 17:49:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785426548; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=HBJafvstXRHAPGogPmUh48u4Bs2Qzb5Xi4wPh4oZ+CM=;
	b=iYukZoI2TeLIx0kb3RyuWF9NFRq0QEVo9XOXztP5DZproKsWypYPOY12FWXVb2Q7LncWDj
	Mkt5tQcYzYSetNF4DVqg7fNBc7L4xDiVYQYqRH0u2MHXcS4uatfk+9Gz5B2hXyzTT70UcQ
	WKy7HHO/5nay+OuzJfqPyV/nE17F54als+YljJfgLwV1FOtEKyGK0jIlzi3JXDebo75zQh
	azNO4ywB/6q3NNKSsxSHwb4CuiZ+a1eu1teYrcAO5f7su8hoIQa/KrxjWzj/e9IX2tCxgt
	NLPvOBzOTuLLJxLAI8pk9FFwrwOQgmtaNOxGrTmt/4wX1TgjR94FTdTOJhc7tA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 30 Jul 2026 17:48:41 +0200
Subject: [PATCH] crypto: ecdsa - Fix typo in function documentation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-fix-ecc-header-typo-v1-1-9d58356560d2@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQqDMBCE4VeRPXchiWjavkrxoHHU7UEliaUiv
 rtRjx/M/BsFeEGgd7aRx0+CTGOCfmTkhnrswdImk1GmVDZX3Mmf4RwPqFt4jus8sX0pXTw7q/P
 GUHrOHml2VT/V7bA0X7h4pmjfD04bYJN3AAAA
X-Change-ID: 20260730-fix-ecc-header-typo-790158f713b2
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785426544; l=1581;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=ef/w9yRThGeLT84r1K2pqV/vuBy7b9I3wtNWQxDZK5Q=;
 b=SdXzVkrGQkd5zHd0h7iEJOkll53Pe6L0J90T/8QSnO+ipvtFHE2w6Mghd/c5UyvJbyYkO/M2S
 K8avKKJJegsDnt80SgS3BZk0grlkmuiEYW0kK02kfaIQU+bh+VwqvPp
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Fix the misspelling of 'validate' in crypto_ecdh_shared_secret() and
ecc_is_pubkey_valid_partial() documentation.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 include/crypto/internal/ecc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index a4b48d76f53a..d67fe13a543a 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -149,7 +149,7 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
  * @curve:		elliptic curve domain parameters
  * @pk:			public key as a point
  *
- * Valdiate public key according to SP800-56A section 5.6.2.3.4 ECC Partial
+ * Validate public key according to SP800-56A section 5.6.2.3.4 ECC Partial
  * Public-Key Validation Routine.
  *
  * Note: There is no check that the public key is in the correct elliptic curve
@@ -166,7 +166,7 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
  * @curve:		elliptic curve domain parameters
  * @pk:			public key as a point
  *
- * Valdiate public key according to SP800-56A section 5.6.2.3.3 ECC Full
+ * Validate public key according to SP800-56A section 5.6.2.3.3 ECC Full
  * Public-Key Validation Routine.
  *
  * Return: 0 if validation is successful, -EINVAL if validation is failed.

---
base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
change-id: 20260730-fix-ecc-header-typo-790158f713b2

Best regards,
--  
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

