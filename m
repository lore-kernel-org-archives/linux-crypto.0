Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D79FC46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 03:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjAJDHx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 22:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjAJDHw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 22:07:52 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04262ADF
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 19:07:49 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b3so16216010lfv.2
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 19:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+DYi2+asV9W6N9KEmtknSVW797VmqVxg4xyqnnLbro8=;
        b=ZSzIo4TSeC5i24/bmwt9RMswJONFNFKPWuuz9o96lxdGALrVYzixbiq7JsZk62mGbt
         W4tmYyPXfUFwQrPbv0OOHNX/ayxiQyVyHfuMAE6yc3j53SRFRS29oqd2Y0CVs2JwtTe0
         auw3L1BE/ZgjicwhrajRBS3ERKmNWYKSk3eaT+whcqv42kEN7DyFJpbwkUkB5x1hnXXT
         3KD/Hat+f3fb2P1gyrUjku0fOP7vCm3pwbiNhUo6XMmeZjPskrcg692iaRz5GjyZkF9q
         DomRQBG3y/rg9ZZdz1Hurr26EwM7+O9wbEPP1DNnqYctyCspLaG9Vikjd4rKu5lP9JJK
         ufQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DYi2+asV9W6N9KEmtknSVW797VmqVxg4xyqnnLbro8=;
        b=LTyCmtVM/QjzBMnWM1H1psEfPWEwMEWKrOI0Xr+dTEwCWKTaENYJIT2kA+9QKfRqc9
         Hu2ANOkUCHtDO1kCNnCyBGZMD8aGQfd0nz3Wd291oOqprRsiy5HhvIdAWuzh/rn9Z5IH
         BdL1AUnfhVONv8F4qXYX0VcHbvLw6j9sKmBJ2XZEt2AdIZYxhc1YbXdFDzMRKd2vUgCU
         HxZIfnFcuv2y6d9s+T67vk7f3t8xSy0StpoiOLyAR6n2LefQpmu0eqtg1DytjyicQPNg
         kQL4EW3xO0l9qa8tm7+CI9oAjXp4Rbh5a/HrA+yeEIMr3UhAH2rxj1CxSKI+Ic+uT/wy
         kCLg==
X-Gm-Message-State: AFqh2kpCqo5J0jktfQ5hEfLrWwERE6J3+C5YdL0nUxs1LiLUCXlFw25o
        KadFGsSIyMU+Uj+5GwwJitphfQ==
X-Google-Smtp-Source: AMrXdXvwHoiFWvixpG1kLAAFeyCcetxpUgg4MK9HwvHEHcxOlp9VPr9fVt6XSfAgzBU1V/2AMm2e0w==
X-Received: by 2002:ac2:51a5:0:b0:4cc:8017:dee9 with SMTP id f5-20020ac251a5000000b004cc8017dee9mr2197200lfk.8.1673320068152;
        Mon, 09 Jan 2023 19:07:48 -0800 (PST)
Received: from localhost (83-245-197-49.elisa-laajakaista.fi. [83.245.197.49])
        by smtp.gmail.com with ESMTPSA id x22-20020a0565123f9600b004b52aed44besm1935752lfa.25.2023.01.09.19.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 19:07:47 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR
        (CCP) DRIVER - SE...), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] crypto: ccp: Sanitize sev_platform_init() error messages
Date:   Tue, 10 Jan 2023 03:07:45 +0000
Message-Id: <20230110030745.34831-1-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The following functions end up calling sev_platform_init() or
__sev_platform_init_locked():

* sev_guest_init()
* sev_ioctl_do_pek_csr
* sev_ioctl_do_pdh_export()
* sev_ioctl_do_pek_import()
* sev_ioctl_do_pek_pdh_gen()
* sev_pci_init()

However, only sev_pci_init() prints out the failed command error code, and
even there, the error message does not specify which SEV command failed.

Address this by printing out the SEV command errors inside
__sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
INIT_EX commands.  As a side-effect, @error can be removed from the
parameter list.

This extra information is particularly useful if firmware loading and/or
initialization is going to be made more robust, e.g. by allowing firmware
loading to be postponed.

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
v3:
* Address Tom Lendacky's feedback:
  https://lore.kernel.org/kvm/8bf6f179-eee7-fd86-7892-cdcd76e0762a@amd.com/

v2:
* Address David Rientjes's feedback:
  https://lore.kernel.org/all/6a16bbe4-4281-fb28-78c4-4ec44c8aa679@google.com/
* Remove @error.
* Remove "SEV_" prefix: it is obvious from context so no need to make klog
  line longer.
---
 drivers/crypto/ccp/sev-dev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 06fc7156c04f..a231418a5f13 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -476,19 +476,21 @@ static int __sev_platform_init_locked(int *error)
 		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
 		rc = init_function(&psp_ret);
 	}
-	if (error)
-		*error = psp_ret;
-
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: %s failed error %#x",
+			sev_init_ex_buffer ? "CMD_INIT_EX" : "CMD_INIT", psp_ret);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
+	if (rc) {
+		dev_err(sev->dev, "SEV: CMD_DF_FLUSH failed error %#x", psp_ret);
 		return rc;
+	}
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1337,8 +1339,7 @@ void sev_pci_init(void)
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			error, rc);
+		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
 
 	return;
 
-- 
2.38.1

