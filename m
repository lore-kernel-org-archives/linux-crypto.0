Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A10C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Apr 2022 00:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356418AbiD0Ali (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356423AbiD0Ale (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 20:41:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFD13A5DF
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 17:38:15 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f198b4e2d1so2354027b3.14
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 17:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=taiFCQsEyLDLuizopfGczE5NJmYI0SrjRrJg0wu9edk=;
        b=mtdvy8+D0GkOesIr4UHLM9Sk2sFwIamOo/7SiJyoRK8H1x2nutN6L/Fns75cy2ewXV
         O+Knm4iMIinraJbiK3+atRPAp7qYubE/KDxTtDlc4hAZAcaQxZgjFoaJqpGLOcBfwswJ
         WGNoxzIHD5Xsxe//6ZLeZxzCtnB7rBvs14wRAkiYVai05SvRW6LTFFJ/ijMhmGRc7+Xi
         qC92ojrgkQgmMe9B46srAWEFEeY/id5qTe/VE2BwDygRJaRoFBmMNZ3XlG294mpWYIIW
         z9ZKHpexM0Pa6jpd0zWA1bPkPWdrj0n8moGKLm+U1v9rvq6ImhHtCkSGCGjRx51doObC
         A80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=taiFCQsEyLDLuizopfGczE5NJmYI0SrjRrJg0wu9edk=;
        b=UQu0GBCUbd7ZWbJzIby04213O2IQ/I6+x7u42BdnpB9ZVXuIsU7AtHTXnOB6V0IXnI
         K202Mp/RRwZAsMRKvCJiX1dm4SBPNUEqds5bkfKFn61gVkkhhkJGF+q3zmg8czoRcvx9
         LZEBZPF4O2fzL34RJsT8Qprfx7JNyZzEYvEcdhQQV18R7DU2Cn6ljFYEphxP5pHJgLXf
         9MfErdhtXHFdh1oyTipQ9vz11ChUDy82j23t16QLmWBuJl7vVcpz7/mG77kNHD2b+Nvv
         hoanDyKZPnsCRSt1t82LFCZfegKLEZJn+/6+SZGzGUihq03NF1nfzRC+J+9RQ7Bvz4wq
         Upyg==
X-Gm-Message-State: AOAM533tEktSyJPFfjnaj97rgZ9RI0worbyS250ec1i2Xtbg1zr30phX
        l7hbrZBuC9ABZbi9GWnNRSEMS0K0yjHuEfYrSzzNNffOcsBlDnkzCN9heQSUD/QBv1pA+HySJ0c
        qfhhHc5XAdHZsupg+SD8XTCrVat3RiyCbngOMoQ7jVUzGvX2FKd+hnbNNtssKotBnLu0=
X-Google-Smtp-Source: ABdhPJwgG09685ieEssMId+aVCAjd8li104rEDlNNgPrfQsmOdF6WPqixleNth8irKedf0XA19+hAwPLvw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6902:1445:b0:633:7c61:1a91 with SMTP id
 a5-20020a056902144500b006337c611a91mr23673794ybv.79.1651019895083; Tue, 26
 Apr 2022 17:38:15 -0700 (PDT)
Date:   Wed, 27 Apr 2022 00:37:59 +0000
In-Reply-To: <20220427003759.1115361-1-nhuck@google.com>
Message-Id: <20220427003759.1115361-9-nhuck@google.com>
Mime-Version: 1.0
References: <20220427003759.1115361-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v5 8/8] fscrypt: Add HCTR2 support for filename encryption
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

HCTR2 is a tweakable, length-preserving encryption mode that is intended
for use on CPUs with dedicated crypto instructions.  HCTR2 has the
property that a bitflip in the plaintext changes the entire ciphertext.
This property fixes a known weakness with filename encryption: when two
filenames in the same directory share a prefix of >= 16 bytes, with
AES-CTS-CBC their encrypted filenames share a common substring, leaking
information.  HCTR2 does not have this problem.

More information on HCTR2 can be found here: "Length-preserving
encryption with HCTR2": https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 22 +++++++++++++++++-----
 fs/crypto/fscrypt_private.h           |  2 +-
 fs/crypto/keysetup.c                  |  7 +++++++
 fs/crypto/policy.c                    | 14 +++++++++++---
 include/uapi/linux/fscrypt.h          |  3 ++-
 5 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 4d5d50dca65c..324149c58bf3 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -337,6 +337,7 @@ Currently, the following pairs of encryption modes are supported:
 - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
 - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
 - Adiantum for both contents and filenames
+- AES-256-XTS for contents and AES-256-HCTR2 for filenames (v2 policies only)
 
 If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
 
@@ -357,6 +358,17 @@ To use Adiantum, CONFIG_CRYPTO_ADIANTUM must be enabled.  Also, fast
 implementations of ChaCha and NHPoly1305 should be enabled, e.g.
 CONFIG_CRYPTO_CHACHA20_NEON and CONFIG_CRYPTO_NHPOLY1305_NEON for ARM.
 
+AES-256-HCTR2 is another true wide-block encryption mode that is intended for
+use on CPUs with dedicated crypto instructions.  AES-256-HCTR2 has the property
+that a bitflip in the plaintext changes the entire ciphertext.  This property
+makes it desirable for filename encryption since initialization vectors are
+reused within a directory.  For more details on AES-256-HCTR2, see the paper
+"Length-preserving encryption with HCTR2"
+(https://eprint.iacr.org/2021/1441.pdf).  To use AES-256-HCTR2,
+CONFIG_CRYPTO_HCTR2 must be enabled.  Also, fast implementations of XCTR and
+POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
+CRYPTO_AES_ARM64_CE_BLK for ARM64.
+
 New encryption modes can be added relatively easily, without changes
 to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
@@ -404,11 +416,11 @@ alternatively has the file's nonce (for `DIRECT_KEY policies`_) or
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
index eede186b04ce..ba463eb931de 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -53,6 +53,13 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.ivsize = 32,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_ADIANTUM,
 	},
+	[FSCRYPT_MODE_AES_256_HCTR2] = {
+		.friendly_name = "AES-256-HCTR2",
+		.cipher_str = "hctr2(aes)",
+		.keysize = 32,
+		.security_strength = 32,
+		.ivsize = 32,
+	},
 };
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ed3d623724cd..5dea7b655a64 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -40,7 +40,7 @@ fscrypt_get_dummy_policy(struct super_block *sb)
 	return sb->s_cop->get_dummy_policy(sb);
 }
 
-static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
+static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
 {
 	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
 	    filenames_mode == FSCRYPT_MODE_AES_256_CTS)
@@ -57,6 +57,14 @@ static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
 	return false;
 }
 
+static bool fscrypt_valid_enc_modes_v2(u32 contents_mode, u32 filenames_mode)
+{
+	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
+	    filenames_mode == FSCRYPT_MODE_AES_256_HCTR2)
+		return true;
+	return fscrypt_valid_enc_modes_v1(contents_mode, filenames_mode);
+}
+
 static bool supported_direct_key_modes(const struct inode *inode,
 				       u32 contents_mode, u32 filenames_mode)
 {
@@ -130,7 +138,7 @@ static bool supported_iv_ino_lblk_policy(const struct fscrypt_policy_v2 *policy,
 static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
 					const struct inode *inode)
 {
-	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+	if (!fscrypt_valid_enc_modes_v1(policy->contents_encryption_mode,
 				     policy->filenames_encryption_mode)) {
 		fscrypt_warn(inode,
 			     "Unsupported encryption modes (contents %d, filenames %d)",
@@ -166,7 +174,7 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 {
 	int count = 0;
 
-	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+	if (!fscrypt_valid_enc_modes_v2(policy->contents_encryption_mode,
 				     policy->filenames_encryption_mode)) {
 		fscrypt_warn(inode,
 			     "Unsupported encryption modes (contents %d, filenames %d)",
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
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

