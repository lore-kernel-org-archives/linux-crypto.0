Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6392F3A9638
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959397; cv=none; b=ORz2RJWCA/N9Xfis3m2Mluku4xyp7FdSy+jTXElLea+7SEMXL+Lb9Glf5rs1pvveVQhmmPO3zWDQuHnDDM6xXKZ9O/0s/QvfsBlJFsbu5bhy4KA6tc16vjPb8AQeSi4IQxM4SAOMqqgd0OYIL2djUFoR66hLmQoL71gAU9rl/d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959397; c=relaxed/simple;
	bh=T9HscMeaz6gg5XlEag5GYjUMRqxENoEO1Fp75BiOQuA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=byw6NodEPd6xmE8ZXH/NfHBnvpQeNeVj0lnqTHKFT/AmX2AdbT90jNOhzJyBUuKf9c0KX5gl5FkuAA3mjqH/YXOR5opGfiADt5jz5L1JeernrYaPJqV8Husamdf7qfthCvPB4v55Ng5AIUQ8Qcs474SG12WQqmaISbq6C8kFWEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=QHQ+zzuK; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="QHQ+zzuK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 13B9E1A36FC
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:54 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D50CE60495;
	Thu, 28 May 2026 09:09:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 728E410888C9E;
	Thu, 28 May 2026 11:09:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959393; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=XzCaY1aPlW7IrM7DEbItV1ujQEkMDOecqKFHMXBmDlY=;
	b=QHQ+zzuKvj6QMcMzTDjF13xVLJAPzBdJ2ZMOugK/w2JPe8CdaTZlOt2Bh9zeNImKrFfKPl
	Bnr0E4U31xJsuGRHMToceUMhe88uxbo7rs/2hyiNmLsI0aNzyFi/xi3ZcYu2q1Autfjeds
	eyKEqg5VaojqWnrhC77rUDKqppJNsQdCjAV2E137b4arkhJOnxrGkQmhOy5qvm29HJ3YwX
	xLESk+VD50HYhU4h7th/QKGB97ZEbTuwxjBEflB2oZwaYQj7aMTP9b9tNiZ4sn6GMpnvct
	nWyeCKGHfFLQIu3Fl+n2n1J2pD+IBbN2HXU+TQcZuwwtlNodaltghwL0wFoLkw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:39 +0200
Subject: [PATCH 26/29] crypto: talitos - Remove now-unused global pointer
 helpers
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-26-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=2854;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=T9HscMeaz6gg5XlEag5GYjUMRqxENoEO1Fp75BiOQuA=;
 b=bJzkzL7uqVWx1COxIqD4e2OU5jER24ff2d8JfgZ2rif6fiEIjUQhWRvEB//x1PMYa5tVvnoD8
 Ti1QphHRFjQAT4jXboHHHyWUT8W4UyBNjxBr5womrRe3zs9+7zvNmiE
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Remove to_talitos_ptr(), copy_talitos_ptr(), from_talitos_ptr_len(),
to_talitos_ptr_ext_set() and to_talitos_ptr_ext_or() from talitos.c
and their declarations from talitos.h, now that all callers dispatch
through the per-SEC-version ptr_ops.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 46 ----------------------------------------
 drivers/crypto/talitos/talitos.h |  8 -------
 2 files changed, 54 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index ff88f3dc3869..19e63ce6cc3e 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -40,52 +40,6 @@
 
 #include "talitos.h"
 
-void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
-		    unsigned int len, bool is_sec1)
-{
-	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	if (is_sec1) {
-		ptr->len1 = cpu_to_be16(len);
-	} else {
-		ptr->len = cpu_to_be16(len);
-		ptr->eptr = upper_32_bits(dma_addr);
-	}
-}
-
-void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
-		      struct talitos_ptr *src_ptr, bool is_sec1)
-{
-	dst_ptr->ptr = src_ptr->ptr;
-	if (is_sec1) {
-		dst_ptr->len1 = src_ptr->len1;
-	} else {
-		dst_ptr->len = src_ptr->len;
-		dst_ptr->eptr = src_ptr->eptr;
-	}
-}
-
-unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
-				    bool is_sec1)
-{
-	if (is_sec1)
-		return be16_to_cpu(ptr->len1);
-	else
-		return be16_to_cpu(ptr->len);
-}
-
-void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
-			    bool is_sec1)
-{
-	if (!is_sec1)
-		ptr->j_extent = val;
-}
-
-void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1)
-{
-	if (!is_sec1)
-		ptr->j_extent |= val;
-}
-
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 09d4e8fb0e62..54e33da03fd0 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -521,14 +521,6 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define DESC_PTR_LNKTBL_RET			0x02
 #define DESC_PTR_LNKTBL_NEXT			0x01
 
-void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
-		    unsigned int len, bool is_sec1);
-void copy_talitos_ptr(struct talitos_ptr *dst_ptr, struct talitos_ptr *src_ptr,
-		      bool is_sec1);
-unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr, bool is_sec1);
-void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val, bool is_sec1);
-void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1);
-
 void map_single_talitos_ptr(struct device *dev, struct talitos_ptr *ptr,
 			    unsigned int len, void *data,
 			    enum dma_data_direction dir);

-- 
2.54.0

