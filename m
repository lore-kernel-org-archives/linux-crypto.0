Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FC5457E5D
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 20:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791750901; cv=none; b=B5CphKMJyAP0M/L+GPEmybToyVL7kvBAlogu9y55eIXq4G9a8Yp53bzPsoga0S84vsrJR98wzc/cTIRPCOevUIAm7jvFyInoSxUQAn5XmrqEQZo+imTQoJ4OqmkcZdNrUTMMRqYcZqVf1EyYbgCrMica21Jvqs7+Ovimn12qkRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791750901; c=relaxed/simple;
	bh=8pPUPEpS4/9H0EzasgtYbbVYQh+w382UIvaqr+P9H7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V+JIx1fTOIC7V+mKKnSeeFOFO344/7wHnq+AMgGDyHjl0FLdHS8+PUChtojhKNjoMKr28Xu/iCkW/VJaHBo49jqFSesrGLgkvqh1Aso+nK1SeYg+boTJhN1WuXOIAF3bmhTKvjMVG7CVaM9wvB2/xO3DDEGYePSaUjdre0C5rBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hn00dsAW; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hn00dsAW"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-917ad52d7b6so17733696d6.2
        for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 13:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791750899; x=1792355699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K5hMfMkm1g5zpUNftZ1rPfIr43hX0MYnqvDCNhs3New=;
        b=hn00dsAWdKDDfHwe/LFNImtujQEDBDLVpJWQMZJlEzXYRKxnQFR6nMoU3tU8ASFGYN
         2987sdmASY0VWIcZ7u+vMvEix0hd2ryyCAKRi4mNgxee077jTWhmwJ9IOQjIKK2vGkuP
         5Tp43lVSEt99mKkLSjznrRoaF4bVTU+S6O67AdiK7sggySAJA5fUfFx+y5DwVX9gwxje
         Pi5UZ0QMc+lE20pwiHi1BpZmLkkGks6Az/GjxsbSIIohoQ6HsBrlSwhuMKZOacS62wDq
         Uk0sKtJF4/TLNVQVGlbaCJ2Ukj62BB/dlbob1bCscwqTQbVL9XwKzYPWCseXsN7yDY95
         l/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791750899; x=1792355699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K5hMfMkm1g5zpUNftZ1rPfIr43hX0MYnqvDCNhs3New=;
        b=GGfFJ4CSF39m5YcjbBHJw/meBJ75qpbtree4lYJ8o/l+c+RVSp+O8t5iHvAl9CD6T/
         d2qPLOAOFi94+ZJTLOv65YOXTH6wUEs9QqM7AvYV+xj9LRTj8nXiQWF898lahbqIXniY
         mupghJadP6M8yTXrArfG6C1sXQsjsbimCQULFCdRll/rnwsh69Us6bUHuH6R8fQxtfLW
         47jxYmEpK1TAoC80dtCCAJV7S29bQsBjERORM0cKU6GxDjFxs2ryzv2tUC4PMKorZOuu
         AJQn5/7NLayreCCjZ9a9Fe+jV2Nd9TdUsSwFU1HnFI0Iqn6i3r4T15wEDjrHQjAWIR4D
         8oYg==
X-Forwarded-Encrypted: i=1; AKwUvBzCd17rH5t6DEhNV0BiD6NegBFSKkU59O2oblBr1PxUGwUZ43vn43MIPI7gUb436lz+ZcmEjLrXewxmvVk=@vger.kernel.org
X-Gm-Message-State: AFq9FYK27FnhN8xJWeoVGpcmIPj/CPf22HSx2mSlLs5S7SJJmKXyWO1n
	pDVpCS92+NJDoyffXZB6V8Dy4khuYqYBSPJuoudr2qn0wVHMugFKdGs=
X-Gm-Gg: AYBFou0BKRLQe0rh54TvJBctYZ6Y4bDhFqw5DFvrNddabq1UDTQnhIhB59LIBh9zUBU
	4YUEwkECVG65xtH9xGa2QbVRbJjnthsBgO8+fT9+LSx+dblmBOlOrkieDbzbfwhQaMfU/jbOOXJ
	b8dEiEY8CUfs4YSwz6IUuRhUvSysN0Gi3ZBporhSo8DDyvshEToPd9kuA4+qi/DvpXjrbfg4165
	yMWjhpY6PmR6BIUTcuff19RR9pTfsU1ZwLSBY5DNzg8gSEeBa14/d+YhILN089gg4r0/AY9UWLB
	q8uEnuDIUpFsGsnANMCuZ2ytwdbYHX6Lzqahsz8qqbaBml4NYv9oXz4ACN0IKQCZqqZaYeEsH2y
	awSbpZGzX4iany9x2bGKuRL+qhF4l7SLN3EFuiwKTFaLQwWJ+4wT0T3ywBbqCjN7dIJu8FWE0Ap
	RU1VeYOCyYHvLATCDsHa8jJ08Mj6hbZ6vtal5sEYMvk/hAv9bhkkVD1NqBWey+J4fh8QqamGYD3
	BB7an/8Ib4XJreZUucuzQFkk6kVnRZ7NjgkhzuZQr3fsuPN1jBgI8beVfoPWAIkI32VFNUUUJ4x
	3t2Cnc+bwO0M5bbqF6DQcAEWVNqk
X-Received: by 2002:a05:6214:5904:b0:91b:7f54:8db3 with SMTP id 6a1803df08f44-91b7f548fa1mr27453476d6.47.1791750899068;
        Sun, 11 Oct 2026 13:34:59 -0700 (PDT)
Received: from i4-gl-tmk5904-1.ad.psu.edu ([130.203.156.90])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b5501f2e3sm78200556d6.8.2026.10.11.13.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 13:34:58 -0700 (PDT)
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
Subject: [PATCH v2] crypto: marvell/octeontx - clean up VF resources when DOWN fails
Date: Sun, 11 Oct 2026 16:34:56 -0400
Message-ID: <20261011203456.1879639-1-mhun512@gmail.com>
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

Keep the notification error diagnostic, but run local cleanup regardless
of the PF response. The PF only acknowledges DOWN; it does not disable the
VF queue. Disable the VQ locally and poll its INFLIGHT count for up to one
second before releasing the DMA command queues. Warn if the queue does
not become idle, but continue local teardown. Clear PCI bus mastering
before freeing resources. Remove both IRQ handlers before killing the
tasklet and releasing its resources.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
Changes in v2:
- Disable the local VQ and poll INFLIGHT for up to one second before
  freeing DMA command queues.
- Warn on an idle timeout and continue local cleanup.
- Clear PCI bus mastering before releasing resources.

v1: https://lore.kernel.org/r/20261004042634.1130247-1-mhun512@gmail.com
Review: https://sashiko.dev/#/patchset/20261004042634.1130247-1-mhun512%40gmail.com

 .../crypto/marvell/octeontx/otx_cptvf_main.c  | 44 ++++++++++++-------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 159c1d2..047bfc0 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include "otx_cptvf.h"
 #include "otx_cptvf_algs.h"
@@ -930,6 +931,8 @@ clear_drvdata:
 static void otx_cptvf_remove(struct pci_dev *pdev)
 {
 	struct otx_cptvf *cptvf = pci_get_drvdata(pdev);
+	union otx_cptx_vqx_inprog vqx_inprog;
+	int ret;
 
 	if (!cptvf) {
 		dev_err(&pdev->dev, "Invalid CPT-VF device\n");
@@ -937,22 +940,33 @@ static void otx_cptvf_remove(struct pci_dev *pdev)
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
+
+	/* Disable the VQ and wait for in-flight instructions to complete. */
+	cptvf_write_vq_ctl(cptvf, 0);
+	ret = readq_poll_timeout(cptvf->reg_base + OTX_CPT_VQX_INPROG(0),
+				 vqx_inprog.u, !vqx_inprog.s.inflight,
+				 10, 1000000);
+	if (ret)
+		dev_warn(&pdev->dev, "Timed out waiting for VQ to become idle\n");
+
+	/* Disable PCI bus mastering before releasing resources. */
+	pci_clear_master(pdev);
+
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
