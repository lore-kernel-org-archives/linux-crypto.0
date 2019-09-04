Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F70EC3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F25C22CF8
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlNICeLz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfIDCfz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:35:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42210 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbfIDCfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id y1so8822828plp.9;
        Tue, 03 Sep 2019 19:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8qVYauEaF289x3cMhI4s/1Faayix+NfSLUGn8z2s1l8=;
        b=KlNICeLzni8606fHeBg3p2Gs7jsz8W0wYZD1eNpKr8RBpEsnEK6/Vl97FcoRSEuixK
         JOhlFlN7UKvbN/xLzPQYke6bGEvG788Raxy0rUnH5evklIc6LeWgbX0N0+oMVBXE+fpj
         VbVPcBKlCaWo7xdZE5L+SmPCrDBbn0U5yAa2twIsEcAXRgsK/bpD54U4vnBIs0nSMtp0
         hPBNidHIMqeF2sG4rcKjAnxFpAoDjivJZnDfYN7g71tYc6nuW67W9a0+Lx9dW+TykGLm
         ytdI/PPaUBKWb9+xvDkNMvjDeate6YydpvgqlB997iKrl8Nye0rQkrAfj+/qiCNfypeq
         sd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8qVYauEaF289x3cMhI4s/1Faayix+NfSLUGn8z2s1l8=;
        b=rgFPqiyDIui5ZuMhEvDVAmkVrx0Dn2mDqL0E6dqrLQk2HywIYPeZ9+mni4i6HBb2GP
         Mjki1wMp8JsP2WESEj+1UFwRqCHxLARvHuzKygprWAzl9w33j+aXyCeTtgPKYKWKMqAg
         Ovvprv+P1I+2w0uIKZX3JjHUOt7W3LGEgJaBRmINr2HoUi4FCSitrIdXJXJyXBCVy+Rx
         U5yJTJl+24Up97/VMsw6+egMMbPJLOPUTl7iNEdhUyRBrTO6PEAg2soBF0lXXy8j/wbG
         RMcwZErQW+vMOfhS7rb8fO0BhtbsaqvCzQz0ycEXcGYbl2ujTOn4q+M4h3HdWlaJqaCg
         CUGQ==
X-Gm-Message-State: APjAAAX2WVmW5jKLP4pug9/GAy04TcorOQ0fPO0cwxdRrvtItwUiYM39
        nS1DnLtw8rtE2MtSbK/jfH22s43XBz0=
X-Google-Smtp-Source: APXvYqwnAGnhH5o46xWifKgP2jXR/QyoQk1BhIrYvTTHKZS9rgDcSS9ehbi5TqfWaCTe+QkEBvIwjw==
X-Received: by 2002:a17:902:7886:: with SMTP id q6mr39191212pll.78.1567564546864;
        Tue, 03 Sep 2019 19:35:46 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:46 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] crypto: caam - change JR device ownership scheme
Date:   Tue,  3 Sep 2019 19:35:15 -0700
Message-Id: <20190904023515.7107-13-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904023515.7107-1-andrew.smirnov@gmail.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Returning -EBUSY from platform device's .remove() callback won't stop
the removal process, so the code in caam_jr_remove() is not going to
have the desired effect of preventing JR from being removed.

In order to be able to deal with removal of the JR device, change the
code as follows:

  1. To make sure that underlying struct device remains valid for as
     long as we have a reference to it, add appropriate device
     refcount management to caam_jr_alloc() and caam_jr_free()

  2. To make sure that device removal doesn't happen in parallel to
      use using the device in caam_jr_enqueue() augment the latter to
      acquire/release device lock for the duration of the subroutine

  3. In order to handle the case when caam_jr_enqueue() is executed
     right after corresponding caam_jr_remove(), add code to check
     that driver data has not been set to NULL.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/jr.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 47b389cb1c62..8a30bbd7f2aa 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -124,14 +124,6 @@ static int caam_jr_remove(struct platform_device *pdev)
 	jrdev = &pdev->dev;
 	jrpriv = dev_get_drvdata(jrdev);
 
-	/*
-	 * Return EBUSY if job ring already allocated.
-	 */
-	if (atomic_read(&jrpriv->tfm_count)) {
-		dev_err(jrdev, "Device is busy\n");
-		return -EBUSY;
-	}
-
 	/* Unregister JR-based RNG & crypto algorithms */
 	unregister_algs();
 
@@ -300,7 +292,7 @@ struct device *caam_jr_alloc(void)
 
 	if (min_jrpriv) {
 		atomic_inc(&min_jrpriv->tfm_count);
-		dev = min_jrpriv->dev;
+		dev = get_device(min_jrpriv->dev);
 	}
 	spin_unlock(&driver_data.jr_alloc_lock);
 
@@ -318,13 +310,16 @@ void caam_jr_free(struct device *rdev)
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(rdev);
 
 	atomic_dec(&jrpriv->tfm_count);
+	put_device(rdev);
 }
 EXPORT_SYMBOL(caam_jr_free);
 
 /**
  * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,
  * -EBUSY if the queue is full, -EIO if it cannot map the caller's
- * descriptor.
+ * descriptor, -ENODEV if given device was removed and is no longer
+ * valid
+ *
  * @dev:  device of the job ring to be used. This device should have
  *        been assigned prior by caam_jr_register().
  * @desc: points to a job descriptor that execute our request. All
@@ -354,15 +349,32 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 				u32 status, void *areq),
 		    void *areq)
 {
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_drv_private_jr *jrp;
 	struct caam_jrentry_info *head_entry;
 	int head, tail, desc_size;
 	dma_addr_t desc_dma;
 
+	/*
+	 * Lock the device to prevent it from being removed while we
+	 * are using it
+	 */
+	device_lock(dev);
+
+	/*
+	 * If driver data is NULL, it is very likely that this device
+	 * was removed already. Nothing we can do here but bail out.
+	 */
+	jrp = dev_get_drvdata(dev);
+	if (!jrp) {
+		device_unlock(dev);
+		return -ENODEV;
+	}
+
 	desc_size = (caam32_to_cpu(*desc) & HDR_JD_LENGTH_MASK) * sizeof(u32);
 	desc_dma = dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, desc_dma)) {
 		dev_err(dev, "caam_jr_enqueue(): can't map jobdesc\n");
+		device_unlock(dev);
 		return -EIO;
 	}
 
@@ -375,6 +387,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	    CIRC_SPACE(head, tail, JOBR_DEPTH) <= 0) {
 		spin_unlock_bh(&jrp->inplock);
 		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);
+		device_unlock(dev);
 		return -EBUSY;
 	}
 
@@ -411,6 +424,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 		jrp->inpring_avail = rd_reg32(&jrp->rregs->inpring_avail);
 
 	spin_unlock_bh(&jrp->inplock);
+	device_unlock(dev);
 
 	return 0;
 }
-- 
2.21.0

