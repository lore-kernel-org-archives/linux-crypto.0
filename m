Return-Path: <SRS0=+uK6=S2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BF7C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 13:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 714EC21773
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 13:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="ccuoGeyV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfDXNiS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:38:18 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:18594 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727112AbfDXNiS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Apr 2019 09:38:18 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3ODbsvm011066;
        Wed, 24 Apr 2019 15:37:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=x/yKiLZpWSZHEh01K6LDhJAkI8bKK768NfMhU3V8tNw=;
 b=ccuoGeyV09hNGm2O3hoAdpDu7f9N8kzd6jMSWIQw9GkY1NYmEmx6z76x4UH39CqJDKQN
 tp/raFqJkaYLYtV8By3Smz8PIDYLSubxgV2jnrKQHHEbcmWxvwX0GEzJhHWgZrRR8oQN
 JPldm+XA8mIgiQB5M7M2qScx84kAICE1nPycY8gUFxbFyNDiS1aSsudJh18BNAv1tauq
 4X5vvackunF2lLP1jPl6U/944q+Wt5FT6cIu4z6ZGPJar2iNftFYxVfo+jqNOHgux+Ad
 P2ihzhUQ4iva5zIFX3qiwcHf2EYZP5nFpBDQCqPmGXpsMNkL5ds8hDaQYncpYXTqeUVn Rg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2ryrj677q1-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 24 Apr 2019 15:37:55 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1E94C46;
        Wed, 24 Apr 2019 13:35:05 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id EB13326A4;
        Wed, 24 Apr 2019 13:35:04 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 24 Apr
 2019 15:35:04 +0200
Received: from localhost (10.201.23.65) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Wed, 24 Apr 2019 15:35:04
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 3/3] crypto: stm32/cryp - update to return iv_out
Date:   Wed, 24 Apr 2019 15:34:53 +0200
Message-ID: <1556112893-13116-3-git-send-email-lionel.debieve@st.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556112893-13116-1-git-send-email-lionel.debieve@st.com>
References: <1556112893-13116-1-git-send-email-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-24_09:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kernel crypto API request output the next IV data to
IV buffer for CBC implementation.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index eb525669..cddcc97 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -393,6 +393,23 @@ static void stm32_cryp_hw_write_iv(struct stm32_cryp *cryp, u32 *iv)
 	}
 }
 
+static void stm32_cryp_get_iv(struct stm32_cryp *cryp)
+{
+	struct ablkcipher_request *req = cryp->req;
+	u32 *tmp = req->info;
+
+	if (!tmp)
+		return;
+
+	*tmp++ = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0LR));
+	*tmp++ = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0RR));
+
+	if (is_aes(cryp)) {
+		*tmp++ = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1LR));
+		*tmp++ = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1RR));
+	}
+}
+
 static void stm32_cryp_hw_write_key(struct stm32_cryp *c)
 {
 	unsigned int i;
@@ -622,6 +639,9 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 		/* Phase 4 : output tag */
 		err = stm32_cryp_read_auth_tag(cryp);
 
+	if (!err && (!(is_gcm(cryp) || is_ccm(cryp))))
+		stm32_cryp_get_iv(cryp);
+
 	if (cryp->sgs_copied) {
 		void *buf_in, *buf_out;
 		int pages, len;
-- 
2.7.4

