Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3363EEACF
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879690; cv=none; b=scdrYi3cNSRhfi55g6Poe7CJJXLHpKHnBgFwJLL66BDI6VVp2cRRCxmlSZ3UDfY6kXieDQOrC01XNmFkVI0w+pd/BU44xIy+xFC/qnxQAmFqACOc22/FPWU4O7LfWXTTpOoJ0kDw78qzAScc9rNUccUsylnAOcpFVX81+Lf00VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879690; c=relaxed/simple;
	bh=YM/w2wtPzdX3RmdPxAtDTeVwrQxqc/8DXfB4OKpz4wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd+kdQN3bXMMOXlfERlPgasXXC7Qn0x1zb1U7L/Tw8RKrWMQwVhKplIULtXBSFmMbz34P/2THK+PoeZq81ae25FdwrVaqDFmQOpoETM3pX+92jZeyKlx3ZKS/8mDMgmny4Ar6umO5V/cr/2dSrlgmhdU5UTWjikRxmO4Pf99QAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=os1ZZCh1; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="os1ZZCh1"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2f0d3e07e30so1350277eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879687; x=1779484487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LfQsLm4zjgCBkokqW/LNO8kguAx5+WYTFTmZDrk46E=;
        b=os1ZZCh1Md5gOjiBCwlPZ8Xc0AtQRHNjZE2TTlYHhwXTWbiGH1LZ28DRDrwvDjkTCh
         RF2iReOYGP8hfSbbsgWHpDOgJMDFZrrqDRHbWAZVz6+qRHDE5VimMybaJqXfo7iwu/Vu
         bL2pEabGzP2Py4vEGE+SnI+eS7oK2Z6USfzb6tHMs7uFzrK/5kqdxByPrvaKakbqzah3
         utLW/Fz+u7uCZeaSZr9GkdYoovYiDGMfK3prCTQc0Vk9DwkaxIRZct14h5X+5fvWjZd9
         4rLtBS9EMiO8Y0RlqNuQ+ckh4OomzPGg1JQ99NjlNsWLLm/r9IqF/T7RCt3ZzIRU71QN
         Y0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879687; x=1779484487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4LfQsLm4zjgCBkokqW/LNO8kguAx5+WYTFTmZDrk46E=;
        b=iHB/OT1XteEdqsskaXwVOdxnzhb+7b538EpaFgEZP1JqaIA/TdivU2bIvqVU21ipnl
         IXvEvCPSyPKcSKywKIt1QpC26SfdUpjmneaTpnJoiicfeY5kPSbo8AQXnudnLw9K0Eh2
         TfkYoNCXVXEVk9OyRHTAcv/quiB1azklUpzDa9Mv6DYjAiVZsEeXKh47cSIhj5ovAVaW
         yi3zl6qMTU7cHWP5W838F14yHCjuODXa6SJ0J+D/sep00XCg3UkC0VhaY602HhXXsIoX
         Pl7tI2Htlr/n3Jo1p3dX4u1G2oXXdYJQEjBmNbUbV4O9ALZj/Ylci/ItJQOF4GRrCcjH
         IaCw==
X-Forwarded-Encrypted: i=1; AFNElJ+3Jx971Lfq6uLaLM1rNZqgpK15Q86MDqzE9QG03p6qpQt3XOlwnuI0SEFXzzKfItMzCl9z3dUG90TVZS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAqqJz9eWhp+LjhblWQaPeYtaGwHYU3l+MFqQP5p0XHgro+yh0
	U5XVPXMF00e8suYZG1U7X8bv/pjrRWeVmsgHDAkNk8YHr55nQN7qTl20
X-Gm-Gg: Acq92OEHuo+KB/81sH9/uspWmmmpr2Ft9JpRR8fWdasBKwkTbNxFB4ZyPjVaT6EjrW7
	h1KHeWRf6yChUF850PiqOV0PUFyB1bpNF+h6He66xA3N49s1XDMtvPyjUV2KLo20fADmf9FW+5c
	P7WFjeftj4qrfURAhvRi2d6CRUtwx+/fojyUgtLTe8Ruy7+FAxR0DBqv3QO/XzuuXozPREE9+vI
	Ljt5Fq5/1/mFxEbMZ4p2A0dZj8ABIcwUrgvT1zcOImBGSKdkuSMDeGD/+MO/mTtGJgmHf4oiXKC
	fGI5zK3NPNZYSWLq8hwN4G+6RoxqaOoxX5lu8+kfqdXpX9r2hxsDqQ8baDmuohI9gjizF4JQ/ni
	zEecMEzPDs9PXJH/MH9S3zRxJ/KCoffXelvf6TL6T0A8gpnYjIdZeiUiMtDVsTL0N8lweUytQhK
	dir2Ymgdan/EhzZQp+/r3aH+jX5tnQGCs=
X-Received: by 2002:a05:7300:a907:b0:2f0:c8b5:3dc7 with SMTP id 5a478bee46e88-30398680c36mr2863934eec.22.1778879686973;
        Fri, 15 May 2026 14:14:46 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcb6c3sm9740068eec.19.2026.05.15.14.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:46 -0700 (PDT)
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
Subject: [PATCH v16 12/38] tpm/tpm_tis: Address positive localities in tpm_tis_request_locality()
Date: Fri, 15 May 2026 14:13:44 -0700
Message-ID: <20260515211410.31440-13-ross.philipson@gmail.com>
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

Validate that the input locality is within the correct range, as specified
by TCG standards, and increase the locality count also for the positive
localities.

Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm_tis_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 1fbb74a565f4..70aba05f4ee1 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -179,7 +179,8 @@ static int tpm_tis_relinquish_locality(struct tpm_chip *chip, int l)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
 	mutex_lock(&priv->locality_count_mutex);
-	priv->locality_count--;
+	if (priv->locality_count > 0)
+		priv->locality_count--;
 	if (priv->locality_count == 0)
 		__tpm_tis_relinquish_locality(priv, l);
 	mutex_unlock(&priv->locality_count_mutex);
@@ -233,10 +234,16 @@ static int tpm_tis_request_locality(struct tpm_chip *chip, int l)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int ret = 0;
 
+	if (l < 0 || l > TPM_MAX_LOCALITY) {
+		dev_warn(&chip->dev, "%s: failed to request unknown locality: %d\n",
+			 __func__, l);
+		return -EINVAL;
+	}
+
 	mutex_lock(&priv->locality_count_mutex);
 	if (priv->locality_count == 0)
 		ret = __tpm_tis_request_locality(chip, l);
-	if (!ret)
+	if (ret >= 0)
 		priv->locality_count++;
 	mutex_unlock(&priv->locality_count_mutex);
 	return ret;
-- 
2.47.3

