Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998AA31714A
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778166410; cv=none; b=KRsl8hRkhaJBtcYkzkAv+KVO4M9UwUGlxosghE2kT1qPxLBh2mJQdvZrsM4t+jEZbgwrBQV9hSvt9wuKVajauN9QmaFVbyRlfOiieejs6vM2dCq55Nso826VlYOnfFlOz/MSioIcjPE/5tI98QM8eRk+LZwOef4vjcOysxQOpyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778166410; c=relaxed/simple;
	bh=IP+/Fnx7QZnh8QTBFMIALzP2lGBypeoUrxgpTU306NA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nG3bndkF46l+p7zuKni2hLUpwI9NxqdAq0PvVg89QFehGING+xefsMrg204hKB2yQnQ91Dc1nVHRuJlp0EyfBenBI3yBggJPvtt4iFVe/YLESRVnXKe1Zwkd8xqhe2uN+q4RjdOn5nat0D6hR/3M5y/hJkySKa8TgKfKHauhQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FeW9jMkO; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeW9jMkO"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48910865133so836025e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778166407; x=1778771207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+BqkKYr5ktDQUipIMVSn9p1dY9rXSMM7LC0Q/JXlrw=;
        b=FeW9jMkOudobsJ7SjDTMJEqC67MkGQ+JIFV0REm4VWYy4Ykzoikqmwy2zRwaEXxoGR
         49xTJ5tiLVZbrEltn/0Pz8b5SzfIA8g2TkbHWWEZ2pFKj5TOHAcflIPimEYciOtc0NMC
         s83wvW608Cd5CWOxn5Kdw87cIuinFq7q4HIuhHgVjLOjtmm/mLFflUTIQ8vb5cOPDyJl
         lTa+VtIoM84WJ7/Ltlop0Y7TSNto8AEbBndKf+8J39JErfYyxG5SLHLQ8BMOpD3I7R5M
         EH+VVsefCrS5s+0gzeTWlLC9VE5PVA/Y314g0xjYkb9QZ5da2KvQOyDQyccot96IID4m
         08og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778166407; x=1778771207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2+BqkKYr5ktDQUipIMVSn9p1dY9rXSMM7LC0Q/JXlrw=;
        b=ShuI3Bveln+d9NjGaA4BDKHeJRXYyemRDejZLm3Mu9vgJN6f64wHF3aP73AGSxdj4s
         cF06t2d/KaYBRev2r/H5Apfp594TzfpeHmo15ZrufjCTsyaFyEQD/0wFepKn3sCV6R1V
         vDZunczS6cRb9keHkPNkxTU+5oFkmDEailOLzOGJMXLCMgCOchR+hJOhoJ5X5JDXySQA
         udXtTPYOxawwGx7D1Dq7vWWQNvbNUAmLyTQM2kszerVEfOAnjGI0jDks+gl/qO+mtMsN
         SKQBU05YJ1TzJNrQJbFoEVLBGkp0ZLQteFBSeEbQsxfvYEUNHR7VYIrYTsnawJJofn6g
         zPew==
X-Forwarded-Encrypted: i=1; AFNElJ860DySkDAjr4/izYqqvl0NbqCfjIfKt2pwuqqN9TovDQSnqo9bdXaG8CAyoTrdF4nSPnPmmfzESYq0Eo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFG54RVIFrfTLAA2Am/aLDLrOm6y2Y5jIL9+bTOTyuxNF/9l72
	otKxwpPr5ovf1LNBPg7935B0TzD0KEJrjIlKwN4ZIAVdaU03+uSum0Ck
X-Gm-Gg: AeBDiesKY70oux/E3lUHwPwKmKSo8w2TJxOjvN7+EbLNPhH/1Na2+sIpVPlmzyRfLEi
	SUb+9cXgCcTq1zvQcI3ivj9UASy47pY38ScAo4FXtxIR80poW/ES/Dl80pJS+A2AOeZAxJGesDL
	Rr/EcO2UO1cSARawb3DsfdyPoZf0j7hra9Qy9OW/SBthSboo9qiPY6J96hLuyVgyRAFoI56nzL1
	XGi8SeI6FJVbR2fXZtL8JwsYj8EmyhDoX7JC2a2Dh5MByzfTxmGHA72KQVcV5y4unWhnpet6862
	Nwu6Ew/UiVfjkoueychjf4GL+vPutE9sIdNaRLJe+rhM8zhYTqDf7febDrhZs2NJiwOyQcZ+H6f
	6EqkKXbmMMm5n/QWIdMqLg5IFdKaQm/xFa+3QDC4/KITBDvujkHnBjN+BFAlaKKt9kow03ob9GZ
	QP0wrkSRVP/mQsCDCZMNteNb0G9aBHZynKaAN5BAidjkBEaRU8SsoeF9pt
X-Received: by 2002:a05:600c:3595:b0:48a:5664:f44a with SMTP id 5b1f17b1804b1-48e5325018dmr72211695e9.2.1778166406382;
        Thu, 07 May 2026 08:06:46 -0700 (PDT)
Received: from localhost.localdomain ([185.139.138.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53907e8asm127217385e9.13.2026.05.07.08.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 08:06:45 -0700 (PDT)
From: Stepan Ionichev <sozdayvek@gmail.com>
To: ashish.kalra@amd.com
Cc: thomas.lendacky@amd.com,
	aik@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stepan Ionichev <sozdayvek@gmail.com>
Subject: [PATCH v2] crypto: ccp: sev-dev-tsm: bail out early when pdev->bus is NULL
Date: Thu,  7 May 2026 19:06:08 +0500
Message-Id: <20260507140608.8612-1-sozdayvek@gmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
In-Reply-To: <20260507023619.398-1-sozdayvek@gmail.com>
References: <20260507023619.398-1-sozdayvek@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dsm_create() initially checks pdev->bus when computing segment_id:

	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;

But the next two lines unconditionally dereference pdev->bus via
pcie_find_root_port() and especially pci_dev_id(pdev), which expands
to PCI_DEVID(dev->bus->number, dev->devfn). If pdev->bus is in fact
NULL, segment_id is initialised to 0 but the very next statement
crashes the kernel.

smatch flags this:

  drivers/crypto/ccp/sev-dev-tsm.c:253 dsm_create() error: we
    previously assumed 'pdev->bus' could be null (see line 251)

Make the NULL handling consistent: if pdev->bus is NULL the device
has no PCI context to work with and SEV TIO setup cannot proceed,
so return -ENODEV before any of the bus-dependent lookups. The
remaining initialisation now runs only on the path where pdev->bus
is known to be valid.

No change for callers where pdev->bus is non-NULL, which is the
only case where dsm_create() did meaningful work before this change.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
---
v2:
- Add Fixes: tag (suggested by Tom Lendacky).
- Cc Alexey Kardashevskiy (original author of the SEV-TIO code).

 drivers/crypto/ccp/sev-dev-tsm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index b07ae529b..f303d8f55 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -248,12 +248,19 @@ static void dsm_remove(struct pci_tsm *tsm)
 static int dsm_create(struct tio_dsm *dsm)
 {
 	struct pci_dev *pdev = dsm->tsm.base_tsm.pdev;
-	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
-	struct pci_dev *rootport = pcie_find_root_port(pdev);
-	u16 device_id = pci_dev_id(pdev);
+	struct pci_dev *rootport;
+	u8 segment_id;
+	u16 device_id;
 	u16 root_port_id;
 	u32 lnkcap = 0;

+	if (!pdev->bus)
+		return -ENODEV;
+
+	segment_id = pci_domain_nr(pdev->bus);
+	rootport = pcie_find_root_port(pdev);
+	device_id = pci_dev_id(pdev);
+
 	if (pci_read_config_dword(rootport, pci_pcie_cap(rootport) + PCI_EXP_LNKCAP,
 				  &lnkcap))
 		return -ENODEV;
--
2.43.0
