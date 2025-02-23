Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31115134AB;
	Sun, 23 Feb 2025 00:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740272214; cv=none; b=WwWwVPa3UqlYY6QAwtCQM0xlTRUA1NcC5CEgs+lntfvvWPeM38uhv+NUKKKVXLeHU0L8Y9WgEuXtI8XYeykVhW1aVUP8r7fqWBQkXYzSfP7xaIBFkgbQgv5Bt8+kTnsX1ayypzYi6Wk548OpbPvYG98MTyQd9iuF2UwQGh9Q5ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740272214; c=relaxed/simple;
	bh=sUoPOiUsPKDOnzSM8Kwc5Sif5rmasA2GBktgXEXWC64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Afy1+0S+Ii0vbQ9SwPRDZzQTEYmt/gsr1hBRgyT16uvo2XNWqPVTnyUHmK6yhDEEZOZrq4+I2V6/3oZasO/bLEH6csFfQ2jzfFHVvjbZNdL5ONliaaY5UbRQGnf8LjxUcyn8TeO2pvC7/9zBhFc1OoVg+PBUBwwakHqAuugbRa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ICWIIQTQ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ICWIIQTQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=peTQ7d1ZtaITlpYSBR71h0WdnxHH1GpW/3CR8RaPHbc=; b=ICWIIQTQXyHE9sL4
	VPEyemZpfGUA3LtcSPI44uUMgXDWKe0G+dPq1GkoX0k2RVSQzdLBZXUsqRaIj4ubEmpQ0M6HO7cL1
	2QpBtUdbocMLsyPT/WnusPq8Cw7NTe9h+Xnj6ZchTvJH5ZYrb/J/24Mp8gQ+kedd09wMxTPZdmDig
	1APz68VPlZ5ZIkHL5OrUAUJSd7DByavY57BdbFqr0if/XhsNqkuwsbC8lH1UoNKokfWTgtHy3mVhM
	l3mqrTYcxAXyr9F/n+Ce0Gr1h/KySl8LImzmq8mOl9nc3W0bHQpKV3nX5UeNQm1Qe+9jkq9A67uwY
	b3KArQxTEW0BqBKdbQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tm0IZ-0008TO-0S;
	Sun, 23 Feb 2025 00:56:47 +0000
From: linux@treblig.org
To: bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: octeontx - Remove unused function otx_cpt_eng_grp_has_eng_type
Date: Sun, 23 Feb 2025 00:56:46 +0000
Message-ID: <20250223005646.86675-1-linux@treblig.org>
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

