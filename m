Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBCBC05027
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Jan 2023 02:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjA0CxD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Jan 2023 21:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbjA0CxA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2023 21:53:00 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E7F2ED41
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2023 18:52:58 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hw16so10128493ejc.10
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2023 18:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4j4/b8H0VfIoZZXeUlO2fvMPvORV541RFGt87/AIxU=;
        b=iK/dqptLinfJiezJF6DdUdzO29dwCVB5SIvBU1ZwzCCC4nRqYP4SzRMkl4Zg2Y6gkZ
         XvPag+NHCDsdiy2NCp56ijpEkIF1kAhZ3RsESDZ5jAUkVPBBCwbKSei+ME3NuxSS2mAf
         D7+N+j6C5Z3pJN6lL0RvLj8VSp364vOhCmk/zZveW4rrigqKwcM+48XUL0V9IbG0sQ7E
         ehapxq/Pet/SbemXxFAJXUthmtttmXD7eDbCDj94e/UmLXCm6Y8JloBD3/CnAKhmuxr1
         IsiIBXqzJeKL9BOTV7llIa/LZ0bFCZRSLd5/u69lHpfUVZ/LWE6qxy6nQlSeumR9ONHZ
         sMtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4j4/b8H0VfIoZZXeUlO2fvMPvORV541RFGt87/AIxU=;
        b=QTWiaUlb4/xO0yizYSvrb7jg1mctaNOQ8QCrBC+fEq7Kphp6QX4VZvvUAel8cZG9Hh
         d2OtVK9tyj7Quvzug0zkXQ8kMOv9E+TEhcJ51kQfxb3/ISeuUmoYSs9d0mQwpW2T9tWQ
         SKgxX2MZqvO8LrJA1cLG589mWuGy2BEQsFNRWqbvqBWh7txkIMczBqY01RBwFMZzKsE4
         l3omNJwoOyBkbtkHBwqyveEJ8vZVYkffahfbEqVfOVjVzModB10j09MnuVvpqpvMzS+r
         mlFna78eRtV/q3AE+3u5okGtvIOyQ+Dk5l1nGr0nhks8s62IioJgfkusENq0BdQWu9Jg
         sf7g==
X-Gm-Message-State: AFqh2koVHUfzLKW0K13nog5AtwYsbeAgb81wNyP+NShnctK9AvRHilTy
        E9Byhijuvwl4CvgrznIY9qkaeg==
X-Google-Smtp-Source: AMrXdXvHWxudJNHWGEuzyM6Rt1AAOD4BD9Q4iY85hyE4iNz0uBLacDTQpb5Kv5zkRqyhskfp3yomuA==
X-Received: by 2002:a17:907:c712:b0:7ba:5085:869 with SMTP id ty18-20020a170907c71200b007ba50850869mr43792444ejc.9.1674787977214;
        Thu, 26 Jan 2023 18:52:57 -0800 (PST)
Received: from localhost (88-113-101-73.elisa-laajakaista.fi. [88.113.101.73])
        by smtp.gmail.com with ESMTPSA id gn19-20020a1709070d1300b008512e1379dbsm1483151ejc.171.2023.01.26.18.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:52:56 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR
        (CCP) DRIVER - SE...), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RFC 7/8] crypto: ccp: Prevent a spurious SEV_CMD_SNP_INIT triggered by sev_guest_init()
Date:   Fri, 27 Jan 2023 02:52:36 +0000
Message-Id: <20230127025237.269680-8-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127025237.269680-1-jarkko@profian.com>
References: <20230127025237.269680-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the firmware version check from sev_pci_init() to sev_snp_init().

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 drivers/crypto/ccp/sev-dev.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6c4fdcaed72b..50e73df966ec 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1381,6 +1381,12 @@ static int __sev_snp_init_locked(int *error)
 	if (sev->snp_initialized)
 		return 0;
 
+	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
+		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
+		return 0;
+	}
+
 	/*
 	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
 	 * across all cores.
@@ -2313,25 +2319,19 @@ void sev_pci_init(void)
 		}
 	}
 
+	rc = sev_snp_init(&error, true);
+	if (rc)
+		/*
+		 * Don't abort the probe if SNP INIT failed,
+		 * continue to initialize the legacy SEV firmware.
+		 */
+		dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
+
 	/*
 	 * If boot CPU supports SNP, then first attempt to initialize
 	 * the SNP firmware.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
-		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
-			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
-				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
-		} else {
-			rc = sev_snp_init(&error, true);
-			if (rc) {
-				/*
-				 * Don't abort the probe if SNP INIT failed,
-				 * continue to initialize the legacy SEV firmware.
-				 */
-				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
-			}
-		}
-
 		/*
 		 * Allocate the intermediate buffers used for the legacy command handling.
 		 */
-- 
2.38.1

