Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63094C74A35
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 21:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 292962087F
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 21:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="daN8MuF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfGJV2H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 17:28:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33537 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfGJV2G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 17:28:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so1695611pfq.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2019 14:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=2/LQ+syV8algN2h7OJBFggoQfWNkjHh3ATrB2VsxuKc=;
        b=daN8MuF1/lEGfilGDX6IF+SUiDKa9qpZAq8GG3koP/7y04fK++4Bl5JwtbyEu4fRWw
         JxFekoZVPITR2x4/Ygb4Mf1Bq3ym8zT8Nag4L/ZzC2S2E+BjL/5zdX0J2Et+TVa+GtbS
         B23SiD5fg5Vogz8Glol23Wsb0tnyEwDbE/5/QCXkstf5X9Yu8rWdcg3NImLDdqIINf0R
         /YMHnRxm0orEoeLSZzUr2MQ4Of5iIo3RNkXb+nKrQBdJdDAj/f7qqmuIdiC3/FwjWJ5u
         5MST2J+yggJWzGX50XBQteW2dBMf7SizdIQWNn8MnYROs3SW6eT0cHQ/OSOGgn08O3Ck
         E9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=2/LQ+syV8algN2h7OJBFggoQfWNkjHh3ATrB2VsxuKc=;
        b=og/Cwmt+EZ1qKQ7PH2FpmiZQQVk21J6mLSfB2ap5Q7j+Ix/g6l9EMY7SQza0GpKl9T
         aaBNDFRvkizoR/W+yG8Lp7X8PoqFZudQEZgq6v1RLCIt8vxAT7E3doOVagOaMWaIA+q8
         KYWMyxnJZdu/my590iRqQyDVOxNSfN88vdZA/5yLAesezLA2VmSUBxGD38tc+0l/rv+u
         bg1K7BmSCZHIEPKmuuJSMS2sP2m8wO+9LxROiejb5sm8NOp7PRK64tPkRumVMakOi7id
         mFHY6Gk9zpwYFrQZ1L+eEOKV7vP/XiOnTe3WRSkp0uSAaWgM9BQmH323R+RXM3LmGwBn
         ZwUw==
X-Gm-Message-State: APjAAAXB3skWBgghkDcHBTXwa0gzWGCRsGlHARE+FOuKdJ1GiX/0j5kN
        oDTAeWWxeqaPsXwjGCIC19RS7g==
X-Google-Smtp-Source: APXvYqy3KbwmvZ8Ja3wu6WerM1ugQjC9s4Qj0nEwijNHOzchNo+fuXoacPeYA+nP96bUoYEgkDaDxA==
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr558340pjt.16.1562794085970;
        Wed, 10 Jul 2019 14:28:05 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id w18sm3209783pfj.37.2019.07.10.14.28.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 14:28:05 -0700 (PDT)
Date:   Wed, 10 Jul 2019 14:28:04 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     Cfir Cohen <cfir@google.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Message-ID: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com>
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
+	if (psp_master->api_major >= maj && psp_master->api_minor >= min)
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
 
