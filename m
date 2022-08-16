Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D046C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 19:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiHPTcj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 15:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbiHPTci (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 15:32:38 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E0D876B5
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:32:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c11-20020a170902d48b00b0016f093907e0so7129568plg.20
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=cLOSl1l8YNAWhxNFx3o73beB8xM+qrlqaIO5EXRLvFo=;
        b=tgMI8er7FzLZlU+19DplrLR9MN+MPGczyrzjaZD2fVzo6thDafHrq6GbW4E8PpqeGs
         i+y9D4fPpx99JIX6ZT5p+Lozzp0CRsZldMdDop6K1Aoav9maSeUliXdub5vlMkJvyrkO
         oasQGw7n6J+jS4wb4Npsw1C2aEAsnchQZ1zbzBiTpYWJXXJ2SDznV1piFewvrhkeusMF
         vSpF6BG2XgbeLrYhOVYPy8aep67MWYNm6erJixGm11bh5mw/wiPpQ1BbaZFvvRft+l4t
         YEKWwfe0/XdF47dWpvYt51rArd0xrZ4LyY5azxWVQdp9D46h86S0aJjDOECgMf1tHmcc
         FVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=cLOSl1l8YNAWhxNFx3o73beB8xM+qrlqaIO5EXRLvFo=;
        b=utCU1xW0VW7B1+mfpa4Fv1RC+f8xhXWi9rHizuvunv1fHryXFKy64Pgzr+B7gITSEM
         oMiDzFzCryfg+w95dkHXv5yXXNj3A8sxm19BKOoZS5SvkpPHXpFSCBAvia4KqU4KevFc
         eQX6eZDvRw+MyQYwOHSG3yQCg1BH0z20kvTogHUi8Xe4D1J+UHT14EW0EUTng1tAZoGL
         9AKL+vnXVaj2/3lajjeofj5TpfFlCYSoycT1hNC2jFA773U4oN9mPkFxlbn6YX0+mZk2
         JxtC0whwO+Oh3JWaZ+GbD43ZBO368uS6bBtYtxaXdiB8jZMZXxJrQ+t7Goqj9Y+aLISq
         99hA==
X-Gm-Message-State: ACgBeo1A+U9ohyWB0hnBLH/isMTaNh5CnSSjQGDoKDEFroWlqi3MeI20
        SG+I356U6bYaOUHekTO7kL9htCAWbTM=
X-Google-Smtp-Source: AA6agR5JWvYnZnpqmFocIBolS4RXEXDNzFu8iVfVPJ8x2ZIecuDgEzoSyOU1TzPcs0oySmP1CDP49LPY0+ws
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a05:6a00:850:b0:52e:d1c1:df48 with SMTP id
 q16-20020a056a00085000b0052ed1c1df48mr22198771pfk.75.1660678356759; Tue, 16
 Aug 2022 12:32:36 -0700 (PDT)
Date:   Tue, 16 Aug 2022 19:32:08 +0000
In-Reply-To: <20220816193209.4057566-1-jackyli@google.com>
Message-Id: <20220816193209.4057566-2-jackyli@google.com>
Mime-Version: 1.0
References: <20220816193209.4057566-1-jackyli@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 1/2] crypto: ccp - Initialize PSP when reading psp data
 file failed
From:   Jacky Li <jackyli@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the OS fails the PSP initialization when the file specified at
'init_ex_path' does not exist or has invalid content. However the SEV
spec just requires users to allocate 32KB of 0xFF in the file, which can
be taken care of by the OS easily.

To improve the robustness during the PSP init, leverage the retry
mechanism and continue the init process:

Before the first INIT_EX call, if the content is invalid or missing,
continue the process by feeding those contents into PSP instead of
aborting. PSP will then override it with 32KB 0xFF and return
SEV_RET_SECURE_DATA_INVALID status code. In the second INIT_EX call,
this 32KB 0xFF content will then be fed and PSP will write the valid
data to the file.

In order to do this, sev_read_init_ex_file should only be called once
for the first INIT_EX call. Calling it again for the second INIT_EX call
will cause the invalid file content overwriting the valid 32KB 0xFF data
provided by PSP in the first INIT_EX call.

Co-developed-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Jacky Li <jackyli@google.com>
Reported-by: Alper Gun <alpergun@google.com>
---
Changelog since v1:
- Add the message to indicate the possible file creation.
- Return 0 when the file does not exist in sev_read_init_ex_file().
- Move sev_read_init_ex_file() before the first call to INIT_EX.
- Rephrase the last paragraph of the commit message.

 .../virt/kvm/x86/amd-memory-encryption.rst    |  5 ++-
 drivers/crypto/ccp/sev-dev.c                  | 36 +++++++++++--------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 2d307811978c..935aaeb97fe6 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -89,9 +89,8 @@ context. In a typical workflow, this command should be the first command issued.
 
 The firmware can be initialized either by using its own non-volatile storage or
 the OS can manage the NV storage for the firmware using the module parameter
-``init_ex_path``. The file specified by ``init_ex_path`` must exist. To create
-a new NV storage file allocate the file with 32KB bytes of 0xFF as required by
-the SEV spec.
+``init_ex_path``. If the file specified by ``init_ex_path`` does not exist or
+is invalid, the OS will create or override the file with output from PSP.
 
 Returns: 0 on success, -negative on error
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9f588c9728f8..fb7ca45a2f0d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -211,18 +211,24 @@ static int sev_read_init_ex_file(void)
 	if (IS_ERR(fp)) {
 		int ret = PTR_ERR(fp);
 
-		dev_err(sev->dev,
-			"SEV: could not open %s for read, error %d\n",
-			init_ex_path, ret);
+		if (ret == -ENOENT) {
+			dev_info(sev->dev,
+				"SEV: %s does not exist and will be created later.\n",
+				init_ex_path);
+			ret = 0;
+		} else {
+			dev_err(sev->dev,
+				"SEV: could not open %s for read, error %d\n",
+				init_ex_path, ret);
+		}
 		return ret;
 	}
 
 	nread = kernel_read(fp, sev_init_ex_buffer, NV_LENGTH, NULL);
 	if (nread != NV_LENGTH) {
-		dev_err(sev->dev,
-			"SEV: failed to read %u bytes to non volatile memory area, ret %ld\n",
+		dev_info(sev->dev,
+			"SEV: could not read %u bytes to non volatile memory area, ret %ld\n",
 			NV_LENGTH, nread);
-		return -EIO;
 	}
 
 	dev_dbg(sev->dev, "SEV: read %ld bytes from NV file\n", nread);
@@ -410,17 +416,12 @@ static int __sev_init_locked(int *error)
 static int __sev_init_ex_locked(int *error)
 {
 	struct sev_data_init_ex data;
-	int ret;
 
 	memset(&data, 0, sizeof(data));
 	data.length = sizeof(data);
 	data.nv_address = __psp_pa(sev_init_ex_buffer);
 	data.nv_len = NV_LENGTH;
 
-	ret = sev_read_init_ex_file();
-	if (ret)
-		return ret;
-
 	if (sev_es_tmr) {
 		/*
 		 * Do not include the encryption mask on the physical
@@ -439,7 +440,7 @@ static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
-	int rc, psp_ret = -1;
+	int rc = 0, psp_ret = -1;
 	int (*init_function)(int *error);
 
 	if (!psp || !psp->sev_data)
@@ -450,8 +451,15 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	init_function = sev_init_ex_buffer ? __sev_init_ex_locked :
-			__sev_init_locked;
+	if (sev_init_ex_buffer) {
+		init_function = __sev_init_ex_locked;
+		rc = sev_read_init_ex_file();
+		if (rc)
+			return rc;
+	} else {
+		init_function = __sev_init_locked;
+	}
+
 	rc = init_function(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
 		/*
-- 
2.37.1.595.g718a3a8f04-goog

