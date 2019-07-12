Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC97C742D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 20:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43ABF217D9
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 20:42:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YyK3fGOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfGLUmB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 16:42:01 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34758 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbfGLUmB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 16:42:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so5324316plt.1
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jul 2019 13:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=UfopCKCD/U3scimCJ539JfCijiZlPDvdefwUoYerYYc=;
        b=YyK3fGOghGrzZIzEU3WLIopzhU8oX7JHvVA+pNlSBPxUFJ28vRI3SIazdlvJ0kYSB/
         lOPaRejOMaPp32GC+IprPgv61souwxkqOWQJHNSbSDZzvqSFjSKUjN3Bot0JPbgf6mBV
         QjuYxUsE6WBCvHLCqHyhNQVj7DhN19JIyZmFel2EW+YR65Uhmw1Hy/oQ99cqrdwL3DZJ
         XseB6WK0iPRXzIE0korofD3WszL17utLMo+PWvl6QJgdoWFa2Xm97+JHFNhbNdbpGFwE
         iiYc8MnCXRl0ZkvymLXDS0FfXtSwbCqPi/MdBEBO0uc5kUcM47pzBVG+qF9XwokoBeH4
         b0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=UfopCKCD/U3scimCJ539JfCijiZlPDvdefwUoYerYYc=;
        b=tq1HiSD0qM04zeN6PrEGGHyPI9eOja+3N5GSsqw7a4FWMMBJbvk4HVR+YkWTXo6CWt
         9yabjYYp2URoHZ29PIgcBtRLiQ1ALcvQUabuAoHj9yugDsTwZhzOGbu1fVvu/fi/zFp2
         N8u+QrsNJWiwKDSt2iauxFABgGOBgNUl5SVZRw/Ln0AR8x8ZyxcdalDBTs7BeyBX9DcW
         j9Dt0WA0cC9PJz43oXdx/cO4she7YsJkqiPEjiavuRxNzZ78EP1RgOCDyh2+qUhCQEvs
         QacDf6FSUzi4kVsqDWzEHyOrmv78fkEHM8W8NrofB9fBZ5ag6L9arKZKjLZ4Vm/NCa4k
         Zazg==
X-Gm-Message-State: APjAAAVyLTqeiRdnCX1WtWPVH/Zabx4qNLsEAnY4t9HOd9xBTNH7frhx
        dFboJVJkP9Dz3DZUno/BeVprbA==
X-Google-Smtp-Source: APXvYqwR1BHl6+/pg0D3KYguhMpw9SQw8mIfRIvxpw0z72hsFTLmLDChrHPgIq0Xk6MvJXN/FGdfog==
X-Received: by 2002:a17:902:6b02:: with SMTP id o2mr12833026plk.99.1562964120350;
        Fri, 12 Jul 2019 13:42:00 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id x65sm10268625pfd.139.2019.07.12.13.41.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 13:41:59 -0700 (PDT)
Date:   Fri, 12 Jul 2019 13:41:58 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Cfir Cohen <cfir@google.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v2] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
In-Reply-To: <e30eae0f-415b-842e-39c4-801227126367@amd.com>
Message-ID: <alpine.DEB.2.21.1907121341210.37390@chino.kir.corp.google.com>
References: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com> <e30eae0f-415b-842e-39c4-801227126367@amd.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SEV_VERSION_GREATER_OR_EQUAL() will fail if upgrading from 2.2 to 3.1, for
example, because the minor version is not equal to or greater than the
major.

Fix this and move to a static inline function for appropriate type
checking.

Fixes: edd303ff0e9e ("crypto: ccp - Add DOWNLOAD_FIRMWARE SEV command")
Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: no need to check api_major >= maj after checking api_major > maj
     per Thomas

 drivers/crypto/ccp/psp-dev.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -24,10 +24,6 @@
 #include "sp-dev.h"
 #include "psp-dev.h"
 
-#define SEV_VERSION_GREATER_OR_EQUAL(_maj, _min)	\
-		((psp_master->api_major) >= _maj &&	\
-		 (psp_master->api_minor) >= _min)
-
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
@@ -47,6 +43,15 @@ MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during
 static bool psp_dead;
 static int psp_timeout;
 
+static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
+{
+	if (psp_master->api_major > maj)
+		return true;
+	if (psp_master->api_major == maj && psp_master->api_minor >= min)
+		return true;
+	return false;
+}
+
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 {
 	struct device *dev = sp->dev;
@@ -588,7 +593,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	int ret;
 
 	/* SEV GET_ID is available from SEV API v0.16 and up */
-	if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
+	if (!sev_version_greater_or_equal(0, 16))
 		return -ENOTSUPP;
 
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
@@ -651,7 +656,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 	int ret;
 
 	/* SEV GET_ID available from SEV API v0.16 and up */
-	if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
+	if (!sev_version_greater_or_equal(0, 16))
 		return -ENOTSUPP;
 
 	/* SEV FW expects the buffer it fills with the ID to be
@@ -1053,7 +1058,7 @@ void psp_pci_init(void)
 		psp_master->sev_state = SEV_STATE_UNINIT;
 	}
 
-	if (SEV_VERSION_GREATER_OR_EQUAL(0, 15) &&
+	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(psp_master->dev) == 0)
 		sev_get_api_version();
 
