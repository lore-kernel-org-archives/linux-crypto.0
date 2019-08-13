Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0FEC32750
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 07:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 762A820665
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 07:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="chQd+HUw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfHMHya (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:54:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33009 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbfHMHy0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 03:54:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so51135432pfq.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2019 00:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GCl85JKs1gSecc0KTbirVsTaub6OgsM5xbDj1pFTySM=;
        b=chQd+HUw8fMvGc9VG8day9h5nefxZnRxFm4hphhm2CYpr49nSh/+ev5t9abDXDXZ9l
         kJMGGDfwB1sg+AQ905NLN2KRacZenYdeEUdA3G13T54twXmQylRjNMFCwoQuNCgHxbWB
         vxkF15V/LSZ2c8z6AWrp7vPaGMIBbl/kEoCO4rpH7QA+2wiF/ivd1t8fjoEPKxBFW9jF
         85a5ISI/Ppj9c0uuHyu8kFWE9qq5p726ukjRCEXFC0VnO+ST6bNi6vf1+E13I6UCv+VR
         9PeZozby9tnGwRViTqdAwnRa9HkdY4BQMdtL+L5IFindm9IIXEn+/AQOpv9cCMWJxhrX
         /L8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GCl85JKs1gSecc0KTbirVsTaub6OgsM5xbDj1pFTySM=;
        b=XjHAYNFlU78CMX6TSt4Z7M3arOIKCH6zLpL/nQRNa9tPhZS2dj3pn2NNBfyhi16hOY
         h30rc/PlyiPAUBJgR1la60NuKrGHIjPsAJy84Qw36jDO/abhybJKk4BNKIidN3LMJ7KY
         6arXi1QNqKbIdZvP2vtrvKWZD/G4zylrVafTiXOgQk5J45YzOSSN033aNbPBWB5ei487
         0OHtFUwa4kmsGKckdbYY0jOPZRT8d+F5mnZzvLil7n5+/aeLho60bwq3xz7BE4CJWqyA
         nSZcX2px+z3GEZIO8+waM0JKDczXw8v8mZTkOWE2+kYEQ8DXW59Gs0eAiB9ZzyLZIypj
         NuxA==
X-Gm-Message-State: APjAAAUwaqLj7Z4R2VfScO7BG+eHOcKDQSqZkuo5aVmJeSSEJ1ixq9yT
        TCwFcjqWiPxuERKD+6AcoJzW0+WnrQg=
X-Google-Smtp-Source: APXvYqytDrttQjhBpZiJ0wp89OF686JczpwzkANsCR9yusYQjXkkNjYA/qMPlWv9MWFx3nT7SdRJHQ==
X-Received: by 2002:a63:de43:: with SMTP id y3mr33723727pgi.211.1565682865908;
        Tue, 13 Aug 2019 00:54:25 -0700 (PDT)
Received: from localhost.localdomain ([45.114.72.100])
        by smtp.gmail.com with ESMTPSA id l25sm131462563pff.143.2019.08.13.00.54.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 00:54:25 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, peterhuewe@gmx.de, jgg@ziepe.ca,
        jejb@linux.ibm.com, jarkko.sakkinen@linux.intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, casey@schaufler-ca.com,
        ard.biesheuvel@linaro.org, daniel.thompson@linaro.org,
        linux-kernel@vger.kernel.org, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [RFC/RFT v4 3/5] KEYS: trusted: create trusted keys subsystem
Date:   Tue, 13 Aug 2019 13:23:02 +0530
Message-Id: <1565682784-10234-4-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
References: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move existing code to trusted keys subsystem. Also, rename files with
"tpm" as suffix which provides the underlying implementation.

Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 crypto/asymmetric_keys/asym_tpm.c                       | 2 +-
 include/keys/{trusted.h => trusted_tpm.h}               | 4 ++--
 security/keys/Makefile                                  | 2 +-
 security/keys/trusted-keys/Makefile                     | 7 +++++++
 security/keys/{trusted.c => trusted-keys/trusted-tpm.c} | 2 +-
 5 files changed, 12 insertions(+), 5 deletions(-)
 rename include/keys/{trusted.h => trusted_tpm.h} (98%)
 create mode 100644 security/keys/trusted-keys/Makefile
 rename security/keys/{trusted.c => trusted-keys/trusted-tpm.c} (99%)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 76d2ce3..ec3f309 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -13,7 +13,7 @@
 #include <crypto/sha.h>
 #include <asm/unaligned.h>
 #include <keys/asymmetric-subtype.h>
-#include <keys/trusted.h>
+#include <keys/trusted_tpm.h>
 #include <crypto/asym_tpm_subtype.h>
 #include <crypto/public_key.h>
 
diff --git a/include/keys/trusted.h b/include/keys/trusted_tpm.h
similarity index 98%
rename from include/keys/trusted.h
rename to include/keys/trusted_tpm.h
index 29e3e9b..9bdf5f4 100644
--- a/include/keys/trusted.h
+++ b/include/keys/trusted_tpm.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __TRUSTED_KEY_H
-#define __TRUSTED_KEY_H
+#ifndef __TRUSTED_TPM_H
+#define __TRUSTED_TPM_H
 
 /* implementation specific TPM constants */
 #define MAX_BUF_SIZE			1024
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 9cef540..074f275 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -28,5 +28,5 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += keyctl_pkey.o
 # Key types
 #
 obj-$(CONFIG_BIG_KEYS) += big_key.o
-obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
+obj-$(CONFIG_TRUSTED_KEYS) += trusted-keys/
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
diff --git a/security/keys/trusted-keys/Makefile b/security/keys/trusted-keys/Makefile
new file mode 100644
index 0000000..4e8963a
--- /dev/null
+++ b/security/keys/trusted-keys/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for trusted keys
+#
+
+obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
+trusted-y += trusted-tpm.o
diff --git a/security/keys/trusted.c b/security/keys/trusted-keys/trusted-tpm.c
similarity index 99%
rename from security/keys/trusted.c
rename to security/keys/trusted-keys/trusted-tpm.c
index f7134d6..66687e7 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted-keys/trusted-tpm.c
@@ -27,7 +27,7 @@
 #include <linux/tpm.h>
 #include <linux/tpm_command.h>
 
-#include <keys/trusted.h>
+#include <keys/trusted_tpm.h>
 
 static const char hmac_alg[] = "hmac(sha1)";
 static const char hash_alg[] = "sha1";
-- 
2.7.4

