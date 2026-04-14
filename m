Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240BB3D6463
	for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776170352; cv=none; b=QoK0iNz30T0VCp7tRaNPt4JmdH5enJkKZdbBH2fBud3TebtrW+3NihaYsI8FuIIwdApX+7ayqZtffSlgld2eiQ0QAr0eMyVQo5wiF2M46gsmLEuYz/B74/zESvFKMfoxOSquDsfQX6/AWbT8s0UwW2QnlOrUOzIyW3z4OQ37mmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776170352; c=relaxed/simple;
	bh=lNn5jvrxlKSG0/5B/U0tSygzuJ+RkoFr9+I8Xu5aVQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f1tk1X3OPuNsOJCWq8MxF2mNhCA6Mi4Kef/bQ5k4L+rqg8k1LydNcg2ENCYjb6GnLVn5D9U0Is+FwiSMnwH6zV6cSWwbZ+A+mA7hpqikrUE9JrV+SY9NKpxG8SEqeKrraIF0TFuEyOHh/aY1euNeRRv98lmCsvBgwYIPTXwK86E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h822cIK1; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h822cIK1"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so36564235ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 05:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776170350; x=1776775150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LqWzHM9f5XbHVj9TeBcnNeNR71vENRDJp955u8OEAcw=;
        b=h822cIK1k4F3eiz+mJo8fjedaC3pWXPCEdGjKfzrbS4PknOIpBU+cVVx4yj/J01wuT
         tZT1Q1wCCQa2TJXgBZWe9JP32HnTITLbOOM9D6iOOQAxecp0rAGTxywiNH7iq4U6wVD6
         KpYWadKD26DVSw+zM2hVvpDrKhyK/tQT5NULB9qAe+Kp/a/A+qdHvL8SF2tyo8D3HEja
         AxAvkhn19HXItFJC54MwqR9Qg2sOb1Bv4yXAMju9rpFDCknsQJ2sogoxzN9ZVlJ8grVE
         RhHn7+FoLU+4B2Nq8ODuxUn5vgyr1zUIBP9d28SqFKfoDuXFmeimFcbpOgmFJKAhFqtA
         9l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776170350; x=1776775150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LqWzHM9f5XbHVj9TeBcnNeNR71vENRDJp955u8OEAcw=;
        b=JsrDBR7RSqPLqYWwLN7uPiOg55N3eJuhfozuuK650EmP9ekl7/7DxjOru1p+7HEEQS
         G7ZAifdXJ1a+o3S8N68uVodtw+Pn6DrFCsKnOEqHV9uI6GoQTsURjO5GHP/zOTnTHKaL
         d5wdQehQtIaH8oHxsyTOoHuHHDgPwE6o8zE9QeTnmNzDf8OatIRELwpJCVV8aSDq3sV7
         EnHV5WG1xcggG/yDNG/T8mffSCl5TYk+n1XEFTP1AICDEh9UhWffIw5/Nrv0UyJX/iqn
         UnMRL/iAyYvc8azVk5OAGpe+4SEXPowyFgIWKywJnZt/tUqKiscnPFkurDvw1jHLwzLo
         zOJA==
X-Forwarded-Encrypted: i=1; AFNElJ9Kn2CUJIfLNHmtKT/YeD1Lpq9PJki+W3L9yJcTtQSfkjYTqxrlPMh0O16r3Li7aVgfyIOpKBtF+gH44YQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0TWOQan0r0wZsBEIVrVF3d5yE1Plg1tzSm2pweEhYG/4rErOD
	cTb3Mg5voHTze98NoeTxkkUQwBpC5XsIpuuSf/jcFUr63r12dOGY/7rv
X-Gm-Gg: AeBDieu6ViSDwU8qS3Id5kxEDpfvH1ssDvSW+jWpatsKn4YTy4I3wamBzbqbSx4YHgz
	tQq1+sE9ljJGyJdKKlV70JlPtqzWaWYBbDBHKqVd9RmRPnxty6RvC10ss3qaaSyWsB1RymQcDsN
	slm3Matmi43cTlElB4f+DnyDVERkCnCbRhEMlrwoNjtuu+FH5N3XzGjOzEuvN2Gogjigk7wKtZK
	ovi/GxcFwomhwXzkpLS26QWAfxL4NL2enlD58vTZ+HJI31NQfuM4QF1rm47z9WkG0TR32OWPGic
	VgwjPXApvpXHVUVmVulJSlksppwvikDxb1+x7WFn8v2x4LoVQ92PD/VEJuQJr4nx75kwgCotjVz
	gSRcWVymyqM0JFlz/Jjddq3+2cye5J5Wgap/E7lta/qJ8allXJ7tX4/mrEjaIkINOULw7F19bp/
	ErWceA+W4pnFGquuEGRgyl0g==
X-Received: by 2002:a17:903:3c2f:b0:2ad:d0ff:2ed4 with SMTP id d9443c01a7336-2b2d591b8cbmr174221755ad.6.1776170350383;
        Tue, 14 Apr 2026 05:39:10 -0700 (PDT)
Received: from lgs.. ([112.224.67.108])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd610esm145281365ad.20.2026.04.14.05.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 05:39:09 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	Suheil Chandran <schandran@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] crypto: octeontx2: fix IRQ vector leak in otx2_cptpf_probe()
Date: Tue, 14 Apr 2026 20:38:57 +0800
Message-ID: <20260414123857.3162673-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

otx2_cptpf_probe() allocates MSI-X vectors with pci_alloc_irq_vectors()
before initializing the AF-PF mailbox, registering mailbox interrupts
and setting up the PF device.

When cptpf_afpf_mbox_init(), cptpf_register_afpf_mbox_intr(),
cptpf_device_init(), cn10k_cptpf_lmtst_init(),
otx2_cpt_init_eng_grps(), sysfs_create_group() or
otx2_cpt_register_dl() fails after IRQ vectors have been allocated
successfully, the function unwinds mailbox, interrupt and engine group
state, but fails to free the allocated IRQ vectors.

The issue was identified by a static analysis tool I developed and
confirmed by manual review. Add a dedicated error path to call
pci_free_irq_vectors() after pci_alloc_irq_vectors() succeeds.

Fixes: 83ffcf78627f ("crypto: octeontx2 - add mailbox communication with AF")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 346d1345f11c..059f702dbf5c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -783,7 +783,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 	/* Initialize AF-PF mailbox */
 	err = cptpf_afpf_mbox_init(cptpf);
 	if (err)
-		goto clear_drvdata;
+		goto free_irq_vectors;
 	/* Register mailbox interrupt */
 	err = cptpf_register_afpf_mbox_intr(cptpf);
 	if (err)
@@ -826,6 +826,8 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 	cptpf_disable_afpf_mbox_intr(cptpf);
 destroy_afpf_mbox:
 	cptpf_afpf_mbox_destroy(cptpf);
+free_irq_vectors:
+	pci_free_irq_vectors(pdev);
 clear_drvdata:
 	pci_set_drvdata(pdev, NULL);
 	return err;
-- 
2.43.0

