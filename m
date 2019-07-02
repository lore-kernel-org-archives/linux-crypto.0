Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C02C06514
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7FC20989
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhoauhVi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfGBPmh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:37 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40488 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGBPmg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:36 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so27725927eds.7
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kEwiHwtoRI2XeSHQxIN34tm7/ggOhDy+7WDhtwIG5fc=;
        b=DhoauhViN2DkRFOJK4d4v8EFKvKn0BBIRFbAY+vRo4/u2kH8lUaa9Z3XkYjxNa7BPy
         yaOOBzbwhlQuy1oc3DuvpkSFgUMl1YYCSebOSNvxXc8HFGIg7JV0SWNEOLPCTXEUBBRQ
         ZMn3oUickTv9K3EozCvH7fDrRwe0W8wrbdvQU9uZyiCiYEo2vDA/NG+MnjcnVA1RghIz
         uq5OTxk9YpLG4gXdY161t7fCBqFAN9S6qTg1kLTVGT9H+Cn8TvUy61eTzs+4ZCI09yL2
         SBgZYaO2wzSnsINYchNOXy+uvrHrpd65ePQl0FL62Tq7pklVWSCJv9gSqALzJuLVgs8Z
         yYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kEwiHwtoRI2XeSHQxIN34tm7/ggOhDy+7WDhtwIG5fc=;
        b=Bvtf+RZumC77oMUYxwr5jXqOWPqQ0E3rEJhZbYQyVr9kNrx924PkaHMWsitdsrQckD
         MFcnCQ21mLzw2Rfkq8tqiHtnrTVd511PdyRGTsLqULuSHsjcWOIh1HMm/pup9uytcssl
         xPoT47IdPlOsBfzRN8rGsyxXr93ixeAtdwFG2qyIok2Uvu4f92eHZt7gl6fkXgNMtq94
         kxbTn8qaN95QHD7rRmG+mtFm51bqvWG4sXmd29KR06vwehSWFBsl/x+l2OgddytVkDhL
         pAYemEbHSivK1+XQsm/qMDGb/XqwR/fzIDtnuctsIuPtU3CdrZIC6or2jdAINpN2sRfY
         i02Q==
X-Gm-Message-State: APjAAAWnLEBO07n63pcl+ULZbu4uKDFARpRDsWoOgvs6sxEV0CHcG3oc
        151MpHB0foNnV9EImseMRlb/Fcl1
X-Google-Smtp-Source: APXvYqzZ7lqF3fNhSojId30rlh8ZKNSeXOPTZkvoLf7VnEWe6nBkmkwSdVQCR6ekyawhSXcCUTT/oQ==
X-Received: by 2002:a50:8b9d:: with SMTP id m29mr36293597edm.248.1562082154823;
        Tue, 02 Jul 2019 08:42:34 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:34 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/9] crypto: inside-secure - silently return -EINVAL for input error cases
Date:   Tue,  2 Jul 2019 16:39:53 +0200
Message-Id: <1562078400-969-5-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

Driver was printing an error message for certain input error cases that
should just return -EINVAL, which caused the related testmgr extra tests
to flood the kernel message log. Ensured those cases remain silent while
making some other device-specific errors a bit more verbose.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 503fef0..8e8c01d 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -694,16 +694,31 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
 				       struct safexcel_result_desc *rdesc)
 {
-	if (likely(!rdesc->result_data.error_code))
+	if (likely((!rdesc->descriptor_overflow) &&
+		   (!rdesc->buffer_overflow) &&
+		   (!rdesc->result_data.error_code)))
 		return 0;
 
-	if (rdesc->result_data.error_code & 0x407f) {
-		/* Fatal error (bits 0-7, 14) */
+	if (rdesc->descriptor_overflow)
+		dev_err(priv->dev, "Descriptor overflow detected");
+
+	if (rdesc->buffer_overflow)
+		dev_err(priv->dev, "Buffer overflow detected");
+
+	if (rdesc->result_data.error_code & 0x4067) {
+		/* Fatal error (bits 0,1,2,5,6 & 14) */
 		dev_err(priv->dev,
-			"cipher: result: result descriptor error (0x%x)\n",
+			"result descriptor error (%x)",
 			rdesc->result_data.error_code);
+		return -EIO;
+	} else if (rdesc->result_data.error_code &
+		   (BIT(7) | BIT(4) | BIT(3))) {
+		/*
+		 * Give priority over authentication fails:
+		 * Blocksize & overflow errors, something wrong with the input!
+		 */
 		return -EINVAL;
-	} else if (rdesc->result_data.error_code == BIT(9)) {
+	} else if (rdesc->result_data.error_code & BIT(9)) {
 		/* Authentication failed */
 		return -EBADMSG;
 	}
-- 
1.8.3.1

