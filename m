Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E12C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 17:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358147AbiDLRbu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358136AbiDLRbB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 13:31:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A13C54186
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 10:28:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d129-20020a254f87000000b006411bf3f331so8082599ybb.4
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 10:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9pExrAuyAU/+6FhLqziAkiz0jY/4rL5PhuNATPlrUaw=;
        b=nNXQaZyVsPm1JY0KIGCCQb+pxY/QnOTOkzkjsT9erx9FpMApCRw+AP++lL3+4fmjJl
         Luvc8c1ewnOp3JAJ6BNjqtZ3K/PnsmVgbrjAxKb+HvwYStN43gLdAszrKb3ceDQ71e+X
         OgBG4pQMboitSy9RrfvKccO7ZqFpZFl+PtyKvCmotBSKmdDtVYNRZ8rT9ZdiWIQ4Maxc
         zdp0n/rrkf2L+sQOXHg0pDmzEYPKow7PMJO73m3AkGYDFDj36Id77PMSvMhv13QHIedA
         7YGG2UoWyq4VR11WjVlldGvRuohvZEaWGXPaSxv2dNqahWbOE7Y2TF965sWgkjuvtgvg
         WK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9pExrAuyAU/+6FhLqziAkiz0jY/4rL5PhuNATPlrUaw=;
        b=UpBKjIOziH5HnV7aaHiJk06v7OCP5LkbDiwQGaH83kkK9z/vPsB3weBMoEqYl/ijbB
         1iyVbeaM8SnvJyGR8Y7hqv+mXniYO4fkyVKi7+qa9slqQxt19Oo/PyT57uQUzXpQodVZ
         RoMN0C2XeTcf3PUfkN7V2heCubk2wPBhpKdXYECCdU19LIGtnI7pXlexJQ5pslxQKYyL
         wILPunyet63Y+EattZYTeUdlwl7DoVgMwhV57m3JaDCl9zTmMAfnNU55TcKmTOLMq3pu
         fu3hmdOhhA0aW4mvJoVG/OWCL69f4x+Hm6Gg+OIS4ldrVFHOmf6eI9EdtkPjo1z/1I5N
         ZOtA==
X-Gm-Message-State: AOAM533qiwkf/mDYXeuYcj6Sltv5sgLm8atULe7i3sWR04ePk3EOx5nj
        i/S2aFQp5YYxHWT+qxrjtXPz3cDFLgMSnCzVGVAg5kmRemPzsyNTsRKnMb7chZL+/4u8wLSd/+m
        iT8KPrciOpFUE0Os0vJ8UXM3bpCpZFWwsNIoBoA1hQMYETSVt1iM1asVwOgT3LZjrl28=
X-Google-Smtp-Source: ABdhPJzkrj3zDxikqNQ5OyInOR6Eo7M02YCMnerp8SfuR72VPPKsI5TC/SWS/qcbEBYCIrc3iuBZKv03tA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6902:10c1:b0:63e:df54:7095 with SMTP id
 w1-20020a05690210c100b0063edf547095mr17311929ybu.433.1649784521194; Tue, 12
 Apr 2022 10:28:41 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:28:16 +0000
In-Reply-To: <20220412172816.917723-1-nhuck@google.com>
Message-Id: <20220412172816.917723-9-nhuck@google.com>
Mime-Version: 1.0
References: <20220412172816.917723-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 8/8] fscrypt: Add HCTR2 support for filename encryption
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HCTR2 is a tweakable, length-preserving encryption mode.  It has the
same security guarantees as Adiantum, but is intended for use on CPUs
with dedicated crypto instructions.  It fixes a known weakness with
filename encryption: when two filenames in the same directory share a
prefix of >= 16 bytes, with CTS-CBC their encrypted filenames share a
common substring, leaking information.  HCTR2 does not have this
problem.

More information on HCTR2 can be found here: Length-preserving
encryption with HCTR2: https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 Documentation/filesystems/fscrypt.rst | 19 ++++++++++++++-----
 fs/crypto/fscrypt_private.h           |  2 +-
 fs/crypto/keysetup.c                  |  7 +++++++
 fs/crypto/policy.c                    |  4 ++++
 include/uapi/linux/fscrypt.h          |  3 ++-
 tools/include/uapi/linux/fscrypt.h    |  3 ++-
 6 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 4d5d50dca65c..09915086abd8 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -337,6 +337,7 @@ Currently, the following pairs of encryption modes are supported:
 - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
 - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
 - Adiantum for both contents and filenames
+- AES-256-XTS for contents and AES-256-HCTR2 for filenames
 
 If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
 
@@ -357,6 +358,14 @@ To use Adiantum, CONFIG_CRYPTO_ADIANTUM must be enabled.  Also, fast
 implementations of ChaCha and NHPoly1305 should be enabled, e.g.
 CONFIG_CRYPTO_CHACHA20_NEON and CONFIG_CRYPTO_NHPOLY1305_NEON for ARM.
 
+AES-256-HCTR2 is another true wide-block encryption mode.  It has the same
+security guarantees as Adiantum, but is intended for use on CPUs with dedicated
+crypto instructions. See the paper "Length-preserving encryption with HCTR2"
+(https://eprint.iacr.org/2021/1441.pdf) for more details. To use HCTR2,
+CONFIG_CRYPTO_HCTR2 must be enabled. Also, fast implementations of XCTR and
+POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
+CRYPTO_AES_ARM64_CE_BLK for ARM64.
+
 New encryption modes can be added relatively easily, without changes
 to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
@@ -404,11 +413,11 @@ alternatively has the file's nonce (for `DIRECT_KEY policies`_) or
 inode number (for `IV_INO_LBLK_64 policies`_) included in the IVs.
 Thus, IV reuse is limited to within a single directory.
 
-With CTS-CBC, the IV reuse means that when the plaintext filenames
-share a common prefix at least as long as the cipher block size (16
-bytes for AES), the corresponding encrypted filenames will also share
-a common prefix.  This is undesirable.  Adiantum does not have this
-weakness, as it is a wide-block encryption mode.
+With CTS-CBC, the IV reuse means that when the plaintext filenames share a
+common prefix at least as long as the cipher block size (16 bytes for AES), the
+corresponding encrypted filenames will also share a common prefix.  This is
+undesirable.  Adiantum and HCTR2 do not have this weakness, as they are
+wide-block encryption modes.
 
 All supported filenames encryption modes accept any plaintext length
 >= 16 bytes; cipher block alignment is not required.  However,
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5b0a9e6478b5..d8617d01f7bd 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -31,7 +31,7 @@
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
-#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_ADIANTUM
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index eede186b04ce..ae24b581d3d7 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -53,6 +53,13 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.ivsize = 32,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_ADIANTUM,
 	},
+	[FSCRYPT_MODE_AES_256_HCTR2] = {
+		.friendly_name = "HCTR2",
+		.cipher_str = "hctr2(aes)",
+		.keysize = 32,
+		.security_strength = 32,
+		.ivsize = 32,
+	},
 };
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ed3d623724cd..fa8bdb8c76b7 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -54,6 +54,10 @@ static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
 	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
 		return true;
 
+	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
+	    filenames_mode == FSCRYPT_MODE_AES_256_HCTR2)
+		return true;
+
 	return false;
 }
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 9f4428be3e36..a756b29afcc2 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -27,7 +27,8 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_AES_256_HCTR2		10
+/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
index 9f4428be3e36..a756b29afcc2 100644
--- a/tools/include/uapi/linux/fscrypt.h
+++ b/tools/include/uapi/linux/fscrypt.h
@@ -27,7 +27,8 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_AES_256_HCTR2		10
+/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
-- 
2.35.1.1178.g4f1659d476-goog

