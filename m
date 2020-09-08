Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49134C43461
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 07:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C799221D20
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 07:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgIHHZJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 03:25:09 -0400
Received: from e2i568.smtp2go.com ([103.2.142.56]:43195 "EHLO
        e2i568.smtp2go.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIHHZH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 03:25:07 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2020 03:25:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=smtpservice.net; s=mcg8n0.a1-4.dyn; x=1599550807; h=Feedback-ID:
        X-Smtpcorp-Track:Message-Id:Date:Subject:To:From:Reply-To:Sender:
        List-Unsubscribe; bh=mjvoj2cJS3KtUSnsRTLsMSA6ltmZsG84o6Eqw/kSdDE=; b=zq5dqjSU
        ygYvCzP/ojs96OiKfJwchw2jZpVgOxTDwMBMN0GcT2WO/tyNh/+A/psMqC4aFv8eQWzWI6a9SWC2U
        jkORAuPRMb2BaxsKLL/Y4echii6SprTZ4n7M6Qen+vSucpu6rotbtGhPoRgCK5VUO1aQ2lHU93RVj
        eCHciU7/r3lTeGhegERXWbH4ymaG1zPxYtvq/K/1UH6gEdoxNl96wNoBYKsoEuTi0+DxsKQM9bOHw
        I1pjTPV5PzHUZJMjKVmXuY0LCJxSDTY15OMQuVA71sSkNDDoYv0zPtpHMpAkCW0dIHIrFJ2xTkVcs
        yG87MEEU9m+4vW9BaV5N8I5dyQ==;
Received: from [10.173.255.233] (helo=SmtpCorp)
        by smtpcorp.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-S2G)
        (envelope-from <pvanleeuwen@rambus.com>)
        id 1kFXqq-qt4FoQ-6T; Tue, 08 Sep 2020 07:15:36 +0000
Received: from [10.159.100.118] (helo=localhost.localdomain.com)
        by smtpcorp.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-S2G)
        (envelope-from <pvanleeuwen@rambus.com>)
        id 1kFXqp-IbZqRt-4e; Tue, 08 Sep 2020 07:15:35 +0000
From:   Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: [PATCH] crypto: inside-secure - Prevent missing of processing errors
Date:   Tue,  8 Sep 2020 08:10:45 +0200
Message-Id: <1599545445-5716-1-git-send-email-pvanleeuwen@rambus.com>
X-Mailer: git-send-email 1.8.3.1
X-Smtpcorp-Track: 1kFbqpmPZqRt4-.V5AWRW84e
Feedback-ID: 580919m:580919aJ_Wy3x:580919sVzW-zOjoc
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On systems with coherence issues, packet processed could succeed while
it should have failed, e.g. because of an authentication fail.
This is because the driver would read stale status information that had
all error bits initialised to zero = no error.
Since this is potential a security risk, we want to prevent it from being
a possibility at all. So initialize all error bits to error state, so
that reading stale status information will always result in errors.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
---
 drivers/crypto/inside-secure/safexcel_ring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index e454c3d..90f1503 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -236,8 +236,8 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
 
 	rdesc->particle_size = len;
 	rdesc->rsvd0 = 0;
-	rdesc->descriptor_overflow = 0;
-	rdesc->buffer_overflow = 0;
+	rdesc->descriptor_overflow = 1; /* assume error */
+	rdesc->buffer_overflow = 1;     /* assume error */
 	rdesc->last_seg = last;
 	rdesc->first_seg = first;
 	rdesc->result_size = EIP197_RD64_RESULT_SIZE;
@@ -245,9 +245,10 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
 	rdesc->data_lo = lower_32_bits(data);
 	rdesc->data_hi = upper_32_bits(data);
 
-	/* Clear length & error code in result token */
+	/* Clear length in result token */
 	rtoken->packet_length = 0;
-	rtoken->error_code = 0;
+	/* Assume errors - HW will clear if not the case */
+	rtoken->error_code = 0x7fff;
 
 	return rdesc;
 }
-- 
1.8.3.1

