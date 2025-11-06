Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AB7315D46
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 11:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428886; cv=none; b=rByvn6bXxgaUldVymQQ84XAJcxZx5esGl1ZCWq2/zUrvOPPKcIRtBQoWU9YqyZs1tNxIm2/gswiLSSB7Po4YL9xhjnpl7fRNTRuETZ0iFE/tNUzfsWS53p4egZzfF2QCGVf7iVIHDXTl5lPy99ipIDKk3i/ul8Rqe4lxNTi1W3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428886; c=relaxed/simple;
	bh=cFe80n6CGnkSaahIAQCZtzz0wK5evAcVBMMvz34diKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ArZstPzr6KjDjYRrRR9pTO/PYIqwFm9a0t7LubdK9k7BwaAkDyInlgEZHLbu/r7feCKcqXjjXT/JsC0u5ZEYL+m9PXZDEAk4+nHPwZfXZACUvANiPY20cx+CGYVyYeRdhQOEuu6+Phf26Y/gr/osziEFH2n6klEgMw+i9pG/ka0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=vP0HWqXQ; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="vP0HWqXQ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-426f1574a14so505262f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 03:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1762428882; x=1763033682; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UyOH8JFl1NlVe0Zhitp2GeDVnmO0GnspPDmH0347JrY=;
        b=vP0HWqXQ5zcPL2SjYe+qXdpa94KbXFAWMIRTrP1N2KMldr83X6t6PBwTuPpQF99hup
         taRsw2hnvUY9ZfzvFwpKnvg2sEDqHN7V953EEsEOf9C76QMySGSNxmVYO81EwPGH4ngq
         fctpl71nMS/CRSBAx5iJ1Tn+SHZ5d4Ii1G/TM+XHxgTJEHEt857X/2qQ5yAG8DIQ57+Q
         4W6J/8CdN6Oy0hyi8Q5+mXbnDI/7NtmoQWaCaa6pj4dXXs4zv0i40wktYbIZweSKXEMg
         Oi5fZp8KRq1v94bGOLE2ZZIrT/kvJlTgNJIWLkEevE4e2cbxkSJl9OQXlAlxMQftsl1w
         ep0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428882; x=1763033682;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UyOH8JFl1NlVe0Zhitp2GeDVnmO0GnspPDmH0347JrY=;
        b=UbLFNwG/hfHmxVmQwK4ipNNIZ6BNqYstposMETqgiKt7H4RKyJ3WebmQ8HHMBVDX5S
         EERJmPZQe62LYvEqSKPrmBYp58C336DXjrKUnVpeTvotVSnCBDPKWTX9ax+O0Cr1sqCk
         2+Zr2r6b8BSRCDT233gCzEGWQipUmTJcKDJlwZWqtFMvBwE1G98XD78NvAIXwZJbsdyc
         zNfX+26E5xNX84mbl56SP7ljl1iYWE+moCLliLzU1Bjxt2HfVCv/OhLGr/ccRdmKh7WD
         cKFy8o+uHteMvGv6NxPWMjcJHvXySv/BLH2w9F1M+0fq+f5oc8q6lAyKPwF1Y7ReCVd6
         OQmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHlewlua5FlIprpUZprxp9Jgk8siDoat4BAFTsQ1WjhzVQrD7ikRKbN36xUNVcRImVJeTUe4ZujX0e7+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWMIMvATAuL0ZZyHMOhLg51BXxoKoqNx74Wf/LH3Gm1aiEXy4/
	gUfnIjncUvk0zauMmRL3tYPLfH+hvJXOsfN1VLrCkmM/+oMCeLHVdpapOXlCBD2Q5cU=
X-Gm-Gg: ASbGncupzbUhP4mCFe8E5X52wTEBVDVU5lHzqRRiMkXYlLAbTJ+psOlTpj90sz2sn3a
	FMZahiBDdA09vfQKZejQmN5rq715GR3+INOOIsCo+k6iOoURWwVSmQDk8mxTGezXDI2Vva4EFyX
	pygeXrl2wkXnFYSlbybemTZJ71/y+HBPpQLu7BoGBcFmJu2WQqaemd4KhgoRd1P3X1yPBRu6Et7
	J0WIgHbbRDQzOfRrlDYIBeQPe3HiCq5msLOg4acOMLMtAnls7u596v7eGt4OWgayNr4Ftkhfns+
	dgLmHqfDBchiXlNVI/QXv7UQXmnLZpUqtvPb7VgaaijaH90GsEcYaF5S5RaTZIoC9KZt47hGRwP
	xMqomDeOMDY+QTehdII9CbEailmf9IxQfu4GeolcL+1xe05xfRk623jF5EO3TbvXEcLNiXT25cX
	dreiA=
X-Google-Smtp-Source: AGHT+IHfX3KK6j5bE3g7uL3YXaXuBoL2INuO9k5/m/Rcjcvro5/QwHeSw9lwF4/ngua5Nhl9Ifs+vA==
X-Received: by 2002:a05:6000:400f:b0:403:8cc:db66 with SMTP id ffacd0b85a97d-429e330622dmr5552118f8f.32.1762428882401;
        Thu, 06 Nov 2025 03:34:42 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:d9de:4038:a78:acab])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40379esm4389459f8f.9.2025.11.06.03.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 03:34:40 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 06 Nov 2025 12:34:06 +0100
Subject: [PATCH v8 10/11] crypto: qce - Add support for BAM locking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-qcom-qce-cmd-descr-v8-10-ecddca23ca26@linaro.org>
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
In-Reply-To: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Udit Tiwari <quic_utiwari@quicinc.com>, 
 Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
 Md Sadre Alam <mdalam@qti.qualcomm.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3514;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=0GwW+SMcBXkCtr2mAoPq27FNGWc61s6sW/IzW4L4/uU=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBpDIe9jxDA/CEFJAoo8UbcYKvaZaTUhBnB1quRD
 FjDe4FqVeqJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaQyHvQAKCRARpy6gFHHX
 cgaWEACUGoEPNZS7SMnPFhtoZhThZ9zEq5xOPsFo8MfrPG2r/vmc7Hw+By35x9lVneRd9IiXm7I
 U1DiVTeo5hM8FaoFVEaBp2lK+SetYXhuKxCrakz7/9RQ75UBR2pA6luqPdp14Y4vWm+Gw8P7oZ8
 sBvMPOSVifRN/GHqeCFSUIs77WnETvrzTaqNRJlfvIeC35eTfZqi2if1mgFHYcLiOmtPnKef92p
 GMugw4gfWP1AvgRT1aKo/nEWMnGmyAM0mNP/VgnC68qPkYuvlTjCX1KnjVSaS1a/ypaMIzf0GkT
 zRyApiBYc8Cwz/1M50PWvJ1FUamhUU88idKAE9kih0/Ufg7us9nfxfp3CNlOA4JqL2U1BUUaktZ
 zPMSaXLx4kRlusW/+5Mi/e6WmKseKH1YFzIo8wU72u2vADBisM9IxumkYQ7nhfxZPG+l4SpnzIW
 Rkmdzek/Zqt0CWrg6wiX8xuyEgEA13KlMi27fPLujHOnOFIpLlUzTOQmDavM/Te0ByR0NGz8gol
 Z+gPmFpUpVdNoF5GxkntlEVVpPC+gDkmB7hvzTqF5kj8Tn6Ab/HScZmZjHnmkxnAuxfip7FFZpK
 wxJILCw2LvKBefsrrUZmQvoEsICBl9Qqxg7lwGgJeE/Q6tK1OPi+q36faTuh0zxP5/cH9Mq4Xbr
 s/ZqmXoMy9Of+fQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Implement the infrastructure for using the new DMA controller lock/unlock
feature of the BAM driver. No functional change for now.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/crypto/qce/common.c | 18 ++++++++++++++++++
 drivers/crypto/qce/dma.c    | 19 +++++++++++++++++--
 drivers/crypto/qce/dma.h    |  4 ++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 04253a8d33409a2a51db527435d09ae85a7880af..74756c222fed6d0298eb6c957ed15b8b7083b72f 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -593,3 +593,21 @@ void qce_get_version(struct qce_device *qce, u32 *major, u32 *minor, u32 *step)
 	*minor = (val & CORE_MINOR_REV_MASK) >> CORE_MINOR_REV_SHIFT;
 	*step = (val & CORE_STEP_REV_MASK) >> CORE_STEP_REV_SHIFT;
 }
+
+int qce_bam_lock(struct qce_device *qce)
+{
+	qce_clear_bam_transaction(qce);
+	/* Dummy write to acquire the lock on the BAM pipe. */
+	qce_write(qce, REG_AUTH_SEG_CFG, 0);
+
+	return qce_submit_cmd_desc_lock(qce);
+}
+
+int qce_bam_unlock(struct qce_device *qce)
+{
+	qce_clear_bam_transaction(qce);
+	/* Dummy write to release the lock on the BAM pipe. */
+	qce_write(qce, REG_AUTH_SEG_CFG, 0);
+
+	return qce_submit_cmd_desc_unlock(qce);
+}
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 9bb9a8246cb054dd16b9ab6cf5cfabef51b1ef83..bfdc1397a289b66af1ef482f0dda7aa057a9103d 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -41,13 +41,13 @@ void qce_clear_bam_transaction(struct qce_device *qce)
 	bam_txn->pre_bam_ce_idx = 0;
 }
 
-int qce_submit_cmd_desc(struct qce_device *qce)
+static int qce_do_submit_cmd_desc(struct qce_device *qce, unsigned long flags)
 {
 	struct qce_desc_info *qce_desc = qce->dma.bam_txn->desc;
 	struct qce_bam_transaction *bam_txn = qce->dma.bam_txn;
 	struct dma_async_tx_descriptor *dma_desc;
 	struct dma_chan *chan = qce->dma.rxchan;
-	unsigned long attrs = DMA_PREP_CMD;
+	unsigned long attrs = DMA_PREP_CMD | flags;
 	dma_cookie_t cookie;
 	unsigned int mapped;
 	int ret;
@@ -76,6 +76,21 @@ int qce_submit_cmd_desc(struct qce_device *qce)
 	return 0;
 }
 
+int qce_submit_cmd_desc(struct qce_device *qce)
+{
+	return qce_do_submit_cmd_desc(qce, 0);
+}
+
+int qce_submit_cmd_desc_lock(struct qce_device *qce)
+{
+	return qce_do_submit_cmd_desc(qce, DMA_PREP_LOCK);
+}
+
+int qce_submit_cmd_desc_unlock(struct qce_device *qce)
+{
+	return qce_do_submit_cmd_desc(qce, DMA_PREP_UNLOCK);
+}
+
 static void qce_prep_dma_cmd_desc(struct qce_device *qce, struct qce_dma_data *dma,
 				  unsigned int addr, void *buf)
 {
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index f05dfa9e6b25bd60e32f45079a8bc7e6a4cf81f9..4b3ee17db72e29b9f417994477ad8a0ec2294db1 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -47,6 +47,10 @@ qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add,
 		unsigned int max_len);
 void qce_write_dma(struct qce_device *qce, unsigned int offset, u32 val);
 int qce_submit_cmd_desc(struct qce_device *qce);
+int qce_submit_cmd_desc_lock(struct qce_device *qce);
+int qce_submit_cmd_desc_unlock(struct qce_device *qce);
 void qce_clear_bam_transaction(struct qce_device *qce);
+int qce_bam_lock(struct qce_device *qce);
+int qce_bam_unlock(struct qce_device *qce);
 
 #endif /* _DMA_H_ */

-- 
2.51.0

