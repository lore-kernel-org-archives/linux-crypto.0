Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6E7847C;
	Sun, 23 Feb 2025 00:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740272095; cv=none; b=Jh9TJ/z+tXmtdF25HlY85zm1/gDKWvIVvnCPz/p3tKc23CllljfG9eKrfxnXwN+2uPVaNwf5B2RPXwk55bDeKCM27sXviH0S8xaVa2XXnh/zLWb9XxbpAR+bRpJvaDe1CalkuOaImlpI4UfPu9/Pp9+w4AFb0WxNvr2S1/petPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740272095; c=relaxed/simple;
	bh=sUoPOiUsPKDOnzSM8Kwc5Sif5rmasA2GBktgXEXWC64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFqDJ2QK49SDMSJBJKrpaiFSkMEbVHtNKvitygGr34OrQkZNqyZfNJcdoxUYC6dLQcaqyJ3doVWkUOVVrbmEGeooN/aSpMJtkKo/n5fQX+uPPhMaTbJYS8fnOMsfhFUnWmNZxyjJPR3JRwVdb5WWCQcbF7CK2EycDAOEfX7HbnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=rBU6r+V7; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="rBU6r+V7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=peTQ7d1ZtaITlpYSBR71h0WdnxHH1GpW/3CR8RaPHbc=; b=rBU6r+V70NTwndYB
	Afr3ELolCuybG3Hoj7O8k4N+BblSOws80TSNOCLx0phAPFSpnJqiPaWvN6QkHBxAcxxdlQ+vFoCU6
	OjxwfSXlw0BZZi5zAQ/DgSO0asyVbXrUmdz88yiASjJPSGkHVFm4jI0Qr6hbb3MloVLoLPFQRPT4D
	dFj6RTVkk4CuUZumXGNl3pFw7IibKJgOFIKiXwkkrVwSm8bZCYxbLUf49PiueEMblGbtOKYL2yFSa
	EFRaCSBtNlYYkgpTm92jC6P95ojeH4aT0w17RSXFtanuo2xoan0WeRcwe9Hio9kG9RCXzXGkcLZjU
	Vy4ENYm+qgYZvIv5WQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tm0Gc-0008RZ-30;
	Sun, 23 Feb 2025 00:54:46 +0000
From: linux@treblig.org
To: bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: octeontxs -: Remove unused function otx_cpt_eng_grp_has_eng_type
Date: Sun, 23 Feb 2025 00:54:43 +0000
Message-ID: <20250223005443.86343-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

otx_cpt_eng_grp_has_eng_type() was added in 2020 by
commit d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT
engine")
but has remained unused.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 11 -----------
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h |  2 --
 2 files changed, 13 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index c4250e5fcf8f..9472798678f9 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -505,17 +505,6 @@ int otx_cpt_uc_supports_eng_type(struct otx_cpt_ucode *ucode, int eng_type)
 }
 EXPORT_SYMBOL_GPL(otx_cpt_uc_supports_eng_type);
 
-int otx_cpt_eng_grp_has_eng_type(struct otx_cpt_eng_grp_info *eng_grp,
-				 int eng_type)
-{
-	struct otx_cpt_engs_rsvd *engs;
-
-	engs = find_engines_by_type(eng_grp, eng_type);
-
-	return (engs != NULL ? 1 : 0);
-}
-EXPORT_SYMBOL_GPL(otx_cpt_eng_grp_has_eng_type);
-
 static void print_ucode_info(struct otx_cpt_eng_grp_info *eng_grp,
 			     char *buf, int size)
 {
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
index 8620ac87a447..df79ee416c0d 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
@@ -174,7 +174,5 @@ int otx_cpt_try_create_default_eng_grps(struct pci_dev *pdev,
 void otx_cpt_set_eng_grps_is_rdonly(struct otx_cpt_eng_grps *eng_grps,
 				    bool is_rdonly);
 int otx_cpt_uc_supports_eng_type(struct otx_cpt_ucode *ucode, int eng_type);
-int otx_cpt_eng_grp_has_eng_type(struct otx_cpt_eng_grp_info *eng_grp,
-				 int eng_type);
 
 #endif /* __OTX_CPTPF_UCODE_H */
-- 
2.48.1

