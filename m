Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D83C46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 19:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbjAJTMc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 14:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239781AbjAJTMX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 14:12:23 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689CA3FC9D
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:12:09 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id x37so13594310ljq.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xNobJ3nZuiPugokCLRX+KyNGtVaPTaaSHxMzrfuXSEY=;
        b=ryoN2Ny7+WEqwOGkcq3nQtUedHAY/AszZB5WJ/FnTnKmcyBDM4mICEt89JOQaOacz8
         AOToZKFCF+mcCxveuXZOzQfOKHBkVGHfCagCBpEAy2LSQ5ZPL3NOwlArm/rZ2SVEE9lq
         iasDg1Nvn452wt1VY7sf7TGNPiZ/QpDhJA58MS15N/YaclN1naQZ9THYswTJkCG5iMjA
         gkfGXDIIW171QalbKg7cdjAozyeX8rC660TJfelo+WaXhcS2JlPYvuJOqVkTP4BOGkIZ
         Ik2Nl3VOu+Fb30bUqSh5UWx1QofgjLoU+ZtyeyTOpT4b4qBIiLYnHl4muKCByCF3Eo+o
         XW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xNobJ3nZuiPugokCLRX+KyNGtVaPTaaSHxMzrfuXSEY=;
        b=jS+Se0OEOd1Rw26X1N/SHp2la8vL/IbS3FHDGfuw2nVVpLgn4papctrrfHp72yFSUk
         l4Ut+2hnU14mnWF8Lg7GuQGTnvHFLsX1Smzxyt9VEgi5oWKw7uxwONIKS+ZGUL9mE+1f
         I1Y2irV9ztRXytRX3vy9aonPH6L0URahBf8PS+q8airINc9l7G0Pnir9yuZiG1iW1m6m
         JIrFLliFpIK3u2EmOI9ZjFNsLc6TxvmYg0bRRGa//uiZFgo6aRMt99W7wJ+bTKQ9YfAI
         ZZO4vlxp4p2xPj7WSDY8HVUar7QBQRSXnsfdqK6Nq593sY5rcfCNrcAkJzIlRwMVIx1u
         tbKw==
X-Gm-Message-State: AFqh2krQcfna8fWNV08mIBuWzhFx03g88EEN/g8IN30KMQTx0VZTETDa
        ddp8gqlUdcusSIkSyVy5xk4M4A==
X-Google-Smtp-Source: AMrXdXvewDrfCChQeiomO+ak4GXBow58Itln9BReZmgOMoOnBWpnJ2N2qYWnn9eQfyaibvH1LaovWQ==
X-Received: by 2002:a05:651c:2006:b0:284:53cd:74d0 with SMTP id s6-20020a05651c200600b0028453cd74d0mr2381041ljo.14.1673377927735;
        Tue, 10 Jan 2023 11:12:07 -0800 (PST)
Received: from localhost (83-245-197-49.elisa-laajakaista.fi. [83.245.197.49])
        by smtp.gmail.com with ESMTPSA id bj36-20020a2eaaa4000000b0027ff2fabcb5sm1381573ljb.104.2023.01.10.11.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:12:07 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR
        (CCP) DRIVER - SE...), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5] crypto: ccp: Sanitize sev_platform_init() error messages
Date:   Tue, 10 Jan 2023 19:12:00 +0000
Message-Id: <20230110191201.29666-1-jarkko@profian.com>
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
v5:
* Address Tom's feedback:
  https://lore.kernel.org/all/ddbb4b2f-3eb8-64da-bce9-3cfd66d7729a@amd.com/
* "failed error" -> "error"
* "SEV_CMD_" -> ""

v4:
* Sorry, v3 was malformed. Here's a proper patch.

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
 drivers/crypto/ccp/sev-dev.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 06fc7156c04f..3f80cd39cbdf 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -478,17 +478,23 @@ static int __sev_platform_init_locked(int *error)
 	}
 	if (error)
 		*error = psp_ret;
-
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: %s error %#x",
+			sev_init_ex_buffer ? "INIT_EX" : "INIT", psp_ret);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
+	if (error)
+		*error = psp_ret;
+	if (rc) {
+		dev_err(sev->dev, "SEV: DF_FLUSH error %#x", psp_ret);
 		return rc;
+	}
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1337,8 +1343,7 @@ void sev_pci_init(void)
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			error, rc);
+		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
 
 	return;
 
-- 
2.38.1

