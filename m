Return-Path: <SRS0=68iz=XL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BDFC4CECD
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 10:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AB3206A4
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 10:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="quevloJw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfIPKe7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Sep 2019 06:34:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44953 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbfIPKe7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Sep 2019 06:34:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id k1so16733103pls.11
        for <linux-crypto@vger.kernel.org>; Mon, 16 Sep 2019 03:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jk4c4zL/SV4/PrtilS4c+jFyOdQUNqO3ciQy1rIE/SY=;
        b=quevloJw4lR3MVUUciTFxdwTWDGH8dVsv0zO3X31eKful7n7wB3M39yO6SW535tQMe
         xh3aGQZN25OyEMUmIU0k2uOymwc9vAWrL/FU20drZjUB8Zt4RDsPay3Vgzu/LLF0Szgf
         NBq76R/s9CLnmawH3+rhr44u/lIG9mODdgl4vPO94jgobvoignbJ+RjklOFVbxarqloi
         G1ehDQLxP78K21Q7R/+6+hY6vxqs59CmemKERAxt0ILhesRMmx6Yf7B988mcf7LlUPac
         8CLxzGsElZU78Dl5h0Bth6wafPySFHW1L3EBeYQQq5RQxO2flFEna13ZxDbx5aNHn+24
         4wGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jk4c4zL/SV4/PrtilS4c+jFyOdQUNqO3ciQy1rIE/SY=;
        b=rmZw5rbS+5Gwdj0r4zLFglTV9DNnxBC0009x6afLe8EOlOLIbbvFpf1jspsyUl4/xo
         CZBfexRVQ2Kbbsu/+WONi7dpYhRY1wRfbuHoeB98HNlIh0D5Ze9EheKMgMONhW5mWfiX
         1vvqm40f8SsPxchUaajpcVgtGZmOEPKCIlke0ICqI2bcqMvYhxU3eltn6yLe7oETIfx3
         QgVHq/AAgcIub2A3bpPjiOw7KX1XUPY3cQhyn+QTsSYi06FDLn4rwzMLhPpFXBrw+oZU
         l6XStiAKJTeE7RJkhCgfYLeWQKZLUW5anxBotLZ7maCQzmGWjR4Z5zoCLbw/J8dJ+DsP
         lpZA==
X-Gm-Message-State: APjAAAWrm3Gjr/miy0Z381D389fX1r8dY3Gftys5vf5czQwzt699DlAT
        K9EMpyncspJR/gMxdZs8ocAsoA==
X-Google-Smtp-Source: APXvYqxfcYkBTvJ7uuwN3uBS+HBZqwsL/gzNCNxd1XaFzZDDDNNOJaOUREQNLcpjdsfnMYNo612W+A==
X-Received: by 2002:a17:902:a983:: with SMTP id bh3mr62036620plb.311.1568630098536;
        Mon, 16 Sep 2019 03:34:58 -0700 (PDT)
Received: from localhost.localdomain ([117.252.69.68])
        by smtp.gmail.com with ESMTPSA id d14sm58256914pfh.36.2019.09.16.03.34.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Sep 2019 03:34:57 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jarkko.sakkinen@linux.intel.com, dhowells@redhat.com,
        peterhuewe@gmx.de
Cc:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        jsnitsel@redhat.com, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [Patch v6 0/4] Create and consolidate trusted keys subsystem
Date:   Mon, 16 Sep 2019 16:04:20 +0530
Message-Id: <1568630064-14887-1-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch-set does restructuring of trusted keys code to create and
consolidate trusted keys subsystem.

Also, patch #2 replaces tpm1_buf code used in security/keys/trusted.c and
crypto/asymmertic_keys/asym_tpm.c files to use the common tpm_buf code.

Changes in v6:
1. Switch TPM asymmetric code also to use common tpm_buf code. These
   changes required patches #1 and #2 update, so I have dropped review
   tags from those patches.
2. Incorporated miscellaneous comments from Jarkko.

Changes in v5:
1. Drop 5/5 patch as its more relavant along with TEE patch-set.
2. Add Reviewed-by tag for patch #2.
3. Fix build failure when "CONFIG_HEADER_TEST" and
   "CONFIG_KERNEL_HEADER_TEST" config options are enabled.
4. Misc changes to rename files.

Changes in v4:
1. Separate patch for export of tpm_buf code to include/linux/tpm.h
2. Change TPM1.x trusted keys code to use common tpm_buf
3. Keep module name as trusted.ko only

Changes in v3:

Move TPM2 trusted keys code to trusted keys subsystem.

Changes in v2:

Split trusted keys abstraction patch for ease of review.

Sumit Garg (4):
  tpm: Move tpm_buf code to include/linux/
  KEYS: Use common tpm_buf for trusted and asymmetric keys
  KEYS: trusted: Create trusted keys subsystem
  KEYS: trusted: Move TPM2 trusted keys code

 crypto/asymmetric_keys/asym_tpm.c                  | 101 +++---
 drivers/char/tpm/tpm-chip.c                        |   1 +
 drivers/char/tpm/tpm-interface.c                   |  56 ----
 drivers/char/tpm/tpm.h                             | 230 -------------
 drivers/char/tpm/tpm2-cmd.c                        | 308 +----------------
 include/Kbuild                                     |   1 -
 include/keys/{trusted.h => trusted_tpm.h}          |  49 +--
 include/linux/tpm.h                                | 270 ++++++++++++++-
 security/keys/Makefile                             |   2 +-
 security/keys/trusted-keys/Makefile                |   8 +
 .../{trusted.c => trusted-keys/trusted_tpm1.c}     |  92 +++---
 security/keys/trusted-keys/trusted_tpm2.c          | 368 +++++++++++++++++++++
 12 files changed, 728 insertions(+), 758 deletions(-)
 rename include/keys/{trusted.h => trusted_tpm.h} (77%)
 create mode 100644 security/keys/trusted-keys/Makefile
 rename security/keys/{trusted.c => trusted-keys/trusted_tpm1.c} (94%)
 create mode 100644 security/keys/trusted-keys/trusted_tpm2.c

-- 
2.7.4

