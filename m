Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D1226B2D3
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 02:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778121389; cv=none; b=j8KZ7m8+z2kEoKVNeltiLkJ4BTTH9d/dARDcr6El5fBPf+w98Jd0AVxQ2d87GHyFuxgOVm7hEDZpZacJckKgX5BN49vBkqYZCNKcFBJ/8uGQHPNOqBwaNchfiaJSTtsJCS+EdvisIG/pXA1VQ39hQM1SPemD4TKznXmNvjWOuJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778121389; c=relaxed/simple;
	bh=d1U626EwZ8LAXQ+Z5NgkD3zwmqFubcDZxdM3aMA6aQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lNoUHt/4EwNxTb6hDIBksxgKexP/QQvt49JOJghmQtSNMFFg0tK/FWP738t6aeLkIiQNzBAKsmA89132UpVfczVHf2miv/pGJ62L4nIf938MJ4bfY5ba7fK1FfOmyc1UeC2l1INdBnd+ZFl6h8+1DbzObnAcw+A0bZCj5l8BPe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sTnjcXK3; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sTnjcXK3"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4836d9d54f6so326335e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 06 May 2026 19:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778121386; x=1778726186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gihp76l0kuHzuYjijZPJZa/c4xaQp8OJerkWdtFO7L0=;
        b=sTnjcXK3A3jxMJjtvJiq0EZSkVRtZ5/V9wy23xSlQpowR1Z+NtwSF33Z3DsPgUVrtX
         WqHHHZHOsKHIXH83J3D3atcYbfPZ7GszYyh988xRy8Xe9/WBAbMvL5LHwBKm3Kpad9ZH
         OsBlD7xHlNFDy9U1rbPqbR3qurvDDIQnreXzpqTOudSTy73JP4q6Jf62gusPXABLSfXF
         cVZ+W+7yBNnHWF7Z8uqlDGweGeKVdiqqRY+IDFzFr0grqLcwpRt73AEfxn2HqQ14zyFS
         Za+MmxAA1PdWINUBjSrlIvOsUcaE0Ykf+aSZ/7dRRT6/HJOyZ/5ZWlCcSQvS2Kk6lbyE
         Lj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778121386; x=1778726186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gihp76l0kuHzuYjijZPJZa/c4xaQp8OJerkWdtFO7L0=;
        b=HUqUr1dCtV8kA3TC/sGqd515hp6Tvj5vAZZjCyCebnqGfo5uk4YofxF1R+PbteQXW8
         mJaSDSf2IdrL7PEK6mJqoVqeXbQjnXhzSPlrpJ8KNogoAuu+/kmSFnn1RDnabyeyuE9Y
         hlpGwtdd5REzX4k94wuqiDeG15By+opIG9k9+XBjVQsVvzBbpGgGASvJX7KUkqa58bH1
         qUFEVBELKKgsYqdn6Rk1aB4ucGyE/vQYR+m9p0uK6lkpbCSfD+VMJ29UXlZnFFgc2CIv
         oyk6hwCMGkZPFyTSv12gDzGf+K/LS0Z71lRiiFlkNzo5hJaqWLYKMWyTRsDg3eVlK3dy
         Ah9g==
X-Forwarded-Encrypted: i=1; AFNElJ9I0gz1z0ChX8zbzVLp2YBZsCVofQWPAR7ft7CRfikcG6/AyEM5VY2Ra2MK00ujP6wzV07V1N/MCav8Ims=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHwDSNaJ0+RiafYOkmcp9c53gsRkT8GDg3NTdH6CgK0b3J1ATl
	TYg8xz8LMOrzh72Jgp4Shi8GtvyId9GlHcvqcpYp5lhMk+NbuijKkEuf
X-Gm-Gg: AeBDietJyD4P0XQLPEM8beJIE39U7CCFQ+VvhJuVTTb88ofEPOWsbM/v0n4UA1hDadD
	0R4m+GqDYlaourOjECcC9Ms32OFnuX3HwGuzAmOxoAP5kZQZC3v7i+G+lniOPTEcidoJwSlaCXn
	VEK1zO1EVvQI/c4ovN2guSC+A6zXQ5Hr2mpm2O3WazBKkOX6vsr28UwarJfh/LGKBhDeLa/YIbB
	Lg0QxmgOmEoJu6iXnrK6OvUXdbNQVnSC4CeaLWhita1I0QdyV/KIzdoUcj5uad7IYwyOIZLRThY
	2EpY8H2BoSGot3XthJnr108WlDP/375rGL0InoJqv6q0Yv4+ABdIaKhA2qQMdlFITy9MZSzBPaz
	g/Try0PMwLD5VLyuScewEbsWVZvmcTGVrWdSLViYFOLezXs89Q6G0l/E81QqfvribKGXoLSRy/g
	eB8JJ+Sk2Acj5zN1JOrYmBdBPsmmB4v7h7RzDwEFN2KBAxsdUKCEI3RMzZ8Mh+rg==
X-Received: by 2002:a05:600c:1c1e:b0:487:1fbb:5a28 with SMTP id 5b1f17b1804b1-48e52f6f153mr43935325e9.1.1778121385940;
        Wed, 06 May 2026 19:36:25 -0700 (PDT)
Received: from LAPTOP-9UC0RPH4.localdomain ([94.158.58.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538ca8c0sm81713225e9.13.2026.05.06.19.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 19:36:25 -0700 (PDT)
From: Stepan Ionichev <sozdayvek@gmail.com>
To: ashish.kalra@amd.com
Cc: thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stepan Ionichev <sozdayvek@gmail.com>
Subject: [PATCH] crypto: ccp: sev-dev-tsm: bail out early when pdev->bus is NULL
Date: Thu,  7 May 2026 07:36:18 +0500
Message-ID: <20260507023619.398-1-sozdayvek@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
---
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

