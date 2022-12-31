Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2675FC46467
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 15:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiLaPL2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 10:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbiLaPLM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 10:11:12 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299AB62FF
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 07:11:11 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id g14so24806023ljh.10
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 07:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zOGMiLTaD/ff59Zq6QF9yZlPHAdc4cQYNGmMJ/5IKpI=;
        b=jmDeKlzi/wQxFVcNgcstF7XUmY7Ghr2l6PD8MtLnUH+iyUul0nFn5XopqdIyaoS/ed
         sTDoDjzBz1o2Bx4/57G9oU+gW6j+g3BdFHJStYfjpWoepOFnESibkoUFtF9jIbHR4atg
         OffUA0LAatZei3U1yh4Q94IF2UJjeEn6+7OrXI0WoK6r95o6yC3ZzWFPMGpnO+nOLWzR
         cKsNCMq5b6UfYjfhvtfxSJfC57zAlS77Mpq2hv0/MScWtnhxsG84W4e52TE+HZQWHQG+
         CtBT46WXyTs+k2sQMnmd2+DfT6Cod9aU/qLkHHWlQV22s2DgSzVZnSuKwmP7ZvJwuaG0
         1kPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zOGMiLTaD/ff59Zq6QF9yZlPHAdc4cQYNGmMJ/5IKpI=;
        b=VbSN2k4fUgyobw3hqRsG7efgnDzhERf2ixM5mL6cpHecffqbnOOWYZZvM2e6C2BAs7
         wq404xH66qUHNpgPE4rerhPfhBvA0NPPwvTUaNnLYkzot4mXcBop8CtDFx4X+3UULlIX
         HiJbaqqjV8V6PkgtYVyN0Jl8JyfzK67Nwv9B3yvJuneX49Fz3aw6YQK1FfNMIDh7TGcG
         kAVLFUMsbrMBwIoqVrHgJIZkQQ6gyeVYYkVZCaLwMtOJShMIDlPKLzsBzXCZbpPgAaZ6
         H3yBFgUimyK8n/3hLrsvS/vUm0C2dxjU3zG31zaLiq/j+5WGZPxB+WzOwibCq+8phGaW
         2/ig==
X-Gm-Message-State: AFqh2kppaRWRH/M1e1wTs4FB79Y0weW9TnQiLvHtkpfWEbXoWEjOCZHe
        hpT51har7cOomqSvK4/G7BvYJOaQCCP9CrioVrw=
X-Google-Smtp-Source: AMrXdXu8DhLPFAw7oUek3zlieSKDARu2n7hXzH+Ij0UQWj7dK+aNwWXLTUhUKEb4ViEkYoBk97o8Wg==
X-Received: by 2002:a05:651c:38f:b0:27f:d2d2:cef2 with SMTP id e15-20020a05651c038f00b0027fd2d2cef2mr3195192ljp.46.1672499468984;
        Sat, 31 Dec 2022 07:11:08 -0800 (PST)
Received: from localhost (83-245-197-49.elisa-laajakaista.fi. [83.245.197.49])
        by smtp.gmail.com with ESMTPSA id z4-20020a2ebe04000000b0027fd65e4faesm927131ljq.108.2022.12.31.07.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 07:11:08 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     linux-crypto@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jarkko Sakkinen <jarkko@profian.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp: Improve sev_platform_init() error messages
Date:   Sat, 31 Dec 2022 15:11:06 +0000
Message-Id: <20221231151106.143121-1-jarkko@profian.com>
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
even there the error message does not specify, SEV which command failed.

Address this by printing out the SEV command errors inside
__sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
INIT_EX commands.

This extra information is particularly useful if firmware loading and/or
initialization is going to be made more robust, e.g. by allowing
firmware loading to be postponed.

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 drivers/crypto/ccp/sev-dev.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 5350eacaba3a..ac7385c12091 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -963,6 +963,7 @@ static int __sev_init_ex_locked(int *error)
 
 static int __sev_platform_init_locked(int *error)
 {
+	const char *cmd = sev_init_ex_buffer ? "SEV_CMD_INIT_EX" : "SEV_CMD_INIT";
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 	int rc = 0, psp_ret = -1;
@@ -1008,18 +1009,23 @@ static int __sev_platform_init_locked(int *error)
 	if (error)
 		*error = psp_ret;
 
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: %s failed error %#x", cmd, psp_ret);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
-		return rc;
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
+	if (error)
+		*error = psp_ret;
 
-	dev_dbg(sev->dev, "SEV firmware initialized\n");
+	if (rc) {
+		dev_err(sev->dev, "SEV: SEV_CMD_DF_FLUSH failed error %#x", psp_ret);
+		return rc;
+	}
 
 	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
@@ -2354,8 +2360,7 @@ void sev_pci_init(void)
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			error, rc);
+		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
 
 skip_legacy:
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
-- 
2.38.1

