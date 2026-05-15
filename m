Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208AA3EDACD
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879686; cv=none; b=j0Puy9wNSDmZxLzFzEzjmGMogG4Sdb5ADyGOBni5tnCjFmO6QXZyrWM39W8V9LRs6ZU1/CnSgzEGNmFD9OXncjzd1p6DQi/08fMxn007pN/a5e649T5MZxV75gavFZPo7cgPEfN0XCqR/XerzmahZLILqG4heid6f4SwGsB9czo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879686; c=relaxed/simple;
	bh=Ty5sURnTFWVnfbnIBPkCCksC+Y0itcL3NCDAmhozFyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+QB3G29ts29gyr+JosB10Ymacifa093MIRago14kvo4+1w+ZXXNSQSSXj1w/6uesSSGQYu5jfb6X/5w9UkvLuBHUd8dimb/yjkJZkLmIe04NY7ax5F4zvqhC/k3vtUG9+vV776ZSkfYZf3Z8IN2mygVVCja2zJKLzL6+9+6j74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLVei2OK; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLVei2OK"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1329fc4bf77so360449c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879684; x=1779484484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWgkYkzNwtEfRsNqnMWcy72BtOHvVyAwK+VJB1q1fiM=;
        b=KLVei2OKgLlVbyE5IdOmusvNTPkfJwn3fij9b7ObCFleGFkdpcXRFdMUq/VyKNaknc
         SycDyYTf5pW+1obDdaJCDNorLVWlM/gWhFNomolW60ut0gTEtjt7d88Ok7bK1KPJc2pk
         OcHWM9tF7izGnrarj96Bm0zFPjqszojR+nShHoiUw/R71rO1+tlz4EwBCz29nX+9g2Iy
         07TE0jykFzYdtS7a/8cjPTimcxOYYFoL1CoIKQTaVgz0ALK9BkAH5lpIRaHgkqCtj9Qj
         MDcy53FNoSF0UP1EEQKKbMel7vzhhXIG/sftDh9E2lIlvznng+81oqD1Xz719k5aZmQy
         CrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879684; x=1779484484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MWgkYkzNwtEfRsNqnMWcy72BtOHvVyAwK+VJB1q1fiM=;
        b=exfx8jlSmqjOrvkSE6YsT40U4jWx6JENZV6+QaZVGV47CznbHJzmKayK9Y33b1XOPk
         GEeTcR/tSNkUvV5ATv/iI3lvwIB4tPK++hyWZRBhI+NZEpEJ/RqMJ3FljJV3B3Vvcmm5
         CRdefvEcksTN3J8IF7HDfm5V35AiRJDjw59O9jlFvRPJ2OeHBoA7CKgPLBOjzO0U2uR2
         0bMpHmw4hiojhL1CU0TTznkXtVDOuU/XH3JbTrOEPEnpxJik8c6+FUOB7QWGwORtUnVr
         pvzhqcCd8y9tqXXRQLbfllhqXks+IOT6EeMiu6edDd6gVYlHZ2SDmkiHOldngGzRYkpk
         tdug==
X-Forwarded-Encrypted: i=1; AFNElJ9NMKX5XKaZczTcN3QMzMgW8wwvUlnQmJ914bg2rUMTwVQaJJF7kgDQ6vFl32tgn+ggjHuYedu2Gj3Ht4k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9IHWIqTdbWMCdtr7ss7fIB4fNYpsQ/j9GfeDPrLOhRsUWsNc+
	asaKlyvBXIl9EQhtrj02Lixee3y8FlBM8EPigz2U+zY7yKwsNTzG0whN
X-Gm-Gg: Acq92OF7Xh2TYfvKcyyTJ5gdchhIQcHeyzyKbZGW+EogHB8X09SWZsNSxaEh8UkDE8B
	6BRDpEBCy3tlp4xUPPKKG5bUaVjoSRWuAFcRw2QSbDs7IpV9Im1yo2BSx/OwLuBtHbRGooRzpVt
	fPnSNJoFErN5XDo2piNUl3wkLrrZ+6WhX7TtJDTzuv+jJuAfMPAR8+8mHExJ5DVnHDIT9949rRZ
	OxRU4hk6PxEqQmQ0p68h0BMwkZ+N5dSjjz2vdukQxP491krsa7XWKIUh1Sq2q5rw4PQZoEuvAFB
	hNOadMAdNmW+BoFTpp9i7Kid1zld92qCmQr6FFlo+Y+O5La4mJxfJCp/mRWbaYG2awNyfcG/NwD
	ARbtkr36yjlVyaujNlyyRPByLsB5L8JUxVKubZjABCPB5js3MkHB8O63MWgNuhfMONbSOCeUmw6
	Is1rwVT/uWyJeB8u6WJ3yQ/5ID/lbE19gC56mAyaZeQA==
X-Received: by 2002:a05:7022:928:b0:130:ca3d:fa74 with SMTP id a92af1059eb24-13504a545d4mr2603120c88.42.1778879684210;
        Fri, 15 May 2026 14:14:44 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbdcf140sm11364153c88.5.2026.05.15.14.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:43 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 11/38] tpm/tpm_tis: Close all localities
Date: Fri, 15 May 2026 14:13:43 -0700
Message-ID: <20260515211410.31440-12-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Daniel P. Smith" <dpsmith@apertussolutions.com>

Close all the localities while initializing the TPM driver. The addition
of TCG DRTM support requires this.

Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm_tis_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e2a1769081b1..1fbb74a565f4 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1111,7 +1111,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	u32 intmask;
 	u32 clkrun_val;
 	u8 rid;
-	int rc, probe;
+	int rc, probe, i;
 	struct tpm_chip *chip;
 
 	chip = tpmm_chip_alloc(dev, &tpm_tis);
@@ -1176,6 +1176,15 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		goto out_err;
 	}
 
+	/*
+	 * In order to comply with the TCG DRTM specification, relinquish all
+	 * the localities.
+	 */
+	for (i = 0; i <= TPM_MAX_LOCALITY; i++) {
+		if (check_locality(chip, i))
+			tpm_tis_relinquish_locality(chip, i);
+	}
+
 	/* Take control of the TPM's interrupt hardware and shut it off */
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
-- 
2.47.3

