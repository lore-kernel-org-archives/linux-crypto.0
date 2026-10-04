Received: from mail-qk2-f39.google.com (mail-qk2-f39.google.com [74.125.230.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9A73E51E8
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 04:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791087999; cv=none; b=PCJafltPgM+rrmbcz0rRx7AB29ysaUW5OPMmPa3glnGVqgXVfDA+8NqpYV9T6nH7C9MQLMtxzbchHjcYAquJUaZ0nYZ8O/2BrT6VAsOD+27575PB7+WcvnlF3irKSpaSEo4ERWtXETqpBRgXrxJG4YNLIa72ojCmlGMH17Nsmec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791087999; c=relaxed/simple;
	bh=SA1v7m8+a2Ph1dwt7YN7E3qaLG1ZxbVKpYnbGXKAW/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IitG4TagZAB6d6/ywlU3/gglnmlo32UDLBkmZsszac/cR5E7NNTTvT4aH1oG0KMfzGr0TKAWEu1xtLTZOHV1qoBpKK9iQsiALIcyQHFcIvzk0lOgMUmaFWeRcKb0iUHBRs1QiOy8Pxo0QOvNiZkjkvU7Z/2JKjvlB1EA3eh5zGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4O8O7mI; arc=none smtp.client-ip=74.125.230.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4O8O7mI"
Received: by mail-qk2-f39.google.com with SMTP id af79cd13be357-93cb545be7fso60123485a.2
        for <linux-crypto@vger.kernel.org>; Sat, 03 Oct 2026 21:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791087996; x=1791692796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0rrUctqm6Dy9eiIYp5kLscMDUQowC1+vgzYg3FmL2FU=;
        b=b4O8O7mI1BxA3yZkmoIW7N5WotuhLsnSsM6erxc/kANV2lj8ADBx2JLapbXXbgmya+
         C9cdvQrf/wSNsm5awAODq7f85+hTfx05LOnzaK/UoMJZfggp30dszscPYox+As3ClNT9
         T923PF2sSVW/UXr74RlgVbmOuwVQ6cTRmiuKqHJWC7hSbwUxOPj3S1n9SQJiUAOlvEdc
         aG9SVhjlCrdEUXidhY7z9Zp+7q25OlSojwJB2quuuLyFiraYbSUy3r0MIzhKsGylHbb8
         keCCqPrgYWP1s1/kHyh2GgBdRU2qhAWjFk0T3a1nNzbvCdDVwA90AVBz+ucdjAsQoOWu
         xe7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791087996; x=1791692796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0rrUctqm6Dy9eiIYp5kLscMDUQowC1+vgzYg3FmL2FU=;
        b=cuGJn1gtLxRBKUeRLGDpUB8fz4ativhOldtnAXDbh1YZCDTSKDYZash8WqEMnEG4pB
         9qMWukhpffDPJXW9+Z2CImNZ47xiQhsxXVZ9udep7YoQrOlsJTEaKRBImx7c7ahedNZ5
         3DrH8aFKP+QdeZtRI4oN/W3kv4kMFbqHNfjedY2F6CMuDNwQonix1zZJ1WwWU8pDIYyl
         1nygpEjoY0Zypyv93lnYMibWx6n5QcLrvC2b2ru9rVDvGh0QdaCY5WkkiKQ6Cgp4NYQj
         hz00EMkCTHEjG5sVd5D+lbyj98h0PqGFxmV2oVhvH4vBuEr/GH6fUgSnPdeLHPnLKXcj
         /q9Q==
X-Forwarded-Encrypted: i=1; AKwUvBxS+2OQ2CuEo/qhTzlUZGzWsmYTz/i+G+YHVZid+3LF0ouQ3rphyQsDsI14/6gfAdknnFAJ9ypPkwzWxrY=@vger.kernel.org
X-Gm-Message-State: AFuF++l9SvT8+U+uxdSuNzsxfV5731FuClHstpuorWVd6vWXOdatjwtH
	JnNT1n3wuG5/QUW5UdIJGCMUJvc5+bQ8uhoa11mfQmZkCH2tp771QQcGL/JWKyw=
X-Gm-Gg: AYBFou0zjkt1dCOsK68Oj/MZxqncWRd/X6qZyQPjJ0sYVoxuRfWsCsr4P2gE92qroVd
	quNuXhnzptlcgrBIPkGSxEeoPPfhJbEsltPqPnxe2JWtPtO0IH3B3uU8ycx9MwlMd/HmfraBvWI
	q07sGLOJJVRFMYsjYZnAw1zlHkgeDuG1p1dd03v9TtvkMZx6hEP3vmklVr6Z/vD9eQoTzFj3bjw
	sH3BEkmbuwYVqee+Lg5a9wr8GpxrV8LUzJsj/Y5ZjjCBin0y2sJa5txat7+dQzZ65bHO1+wTiYJ
	6fhFsHCmTfeZMhbtsg7U9KjXz2kD5EDYkeAeLj81U0EMjzZBchxDD9g5004G/lTaOqryz3TmV5P
	gNFVx8IVgfq/nY6wDOrf3L/8zZDVm8eRNL/Uf11DPI5JBOp2VecCCCKRjCdQrEeyQBcVRrcFISk
	tCrnI57NcU0nFth/ouYKIhVRbVnB6IwKzpHtPesOgJAWHwCy9gvcx+xy0RXWBQj7MIjkHSCsjik
	15HkQPuSXujI7eIrWh4uykcq/Lc02itb/BUlAfPFNcd86sUgvP/Kx6GYP13sddhm8mjxFzZZxEE
	VhuX2egy5LOtxhX1AbzIFDrXdURt
X-Received: by 2002:a05:620a:2259:20b0:93c:2dae:ec5c with SMTP id af79cd13be357-93cf188f68cmr935971185a.42.1791087996607;
        Sat, 03 Oct 2026 21:26:36 -0700 (PDT)
Received: from i4-gl-tmk5904-1.ad.psu.edu ([130.203.156.90])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93e4e57b9cbsm367051985a.11.2026.10.03.21.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 21:26:35 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] crypto: marvell/octeontx - clean up VF resources when DOWN fails
Date: Sun,  4 Oct 2026 00:26:34 -0400
Message-ID: <20261004042634.1130247-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failed DOWN mailbox notification makes otx_cptvf_remove() skip all
local cleanup. The driver core still completes unbind and releases the
devm-allocated cptvf, leaving the raw IRQ handlers registered with that
object as their argument. The sysfs group, crypto device-table entry,
software queues and PCI resources also remain uncleaned.

Keep the notification error diagnostic, but run the existing local
cleanup regardless of the PF response. This removes both IRQ handlers
before killing the tasklet and releasing its resources, as on the
successful notification path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 .../crypto/marvell/octeontx/otx_cptvf_main.c  | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 159c1d290a36..27d7b094c861 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -937,22 +937,21 @@ static void otx_cptvf_remove(struct pci_dev *pdev)
 	}
 
 	/* Convey DOWN to PF */
-	if (otx_cptvf_send_vf_down(cptvf)) {
+	if (otx_cptvf_send_vf_down(cptvf))
 		dev_err(&pdev->dev, "PF not responding to DOWN msg\n");
-	} else {
-		sysfs_remove_group(&pdev->dev.kobj, &otx_cptvf_sysfs_group);
-		otx_cpt_crypto_exit(pdev, THIS_MODULE, cptvf->vftype);
-		cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_DONE);
-		cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_MISC);
-		free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_DONE), cptvf);
-		free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_MISC), cptvf);
-		cptvf_sw_cleanup(cptvf);
-		pci_free_irq_vectors(cptvf->pdev);
-		pci_iounmap(pdev, cptvf->reg_base);
-		pci_release_regions(pdev);
-		pci_disable_device(pdev);
-		pci_set_drvdata(pdev, NULL);
-	}
+
+	sysfs_remove_group(&pdev->dev.kobj, &otx_cptvf_sysfs_group);
+	otx_cpt_crypto_exit(pdev, THIS_MODULE, cptvf->vftype);
+	cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_DONE);
+	cptvf_free_irq_affinity(cptvf, CPT_VF_INT_VEC_E_MISC);
+	free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_DONE), cptvf);
+	free_irq(pci_irq_vector(pdev, CPT_VF_INT_VEC_E_MISC), cptvf);
+	cptvf_sw_cleanup(cptvf);
+	pci_free_irq_vectors(cptvf->pdev);
+	pci_iounmap(pdev, cptvf->reg_base);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 }
 
 /* Supported devices */
-- 
2.53.0

