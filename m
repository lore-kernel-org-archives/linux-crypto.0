Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A2FC001DF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 10:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjGJKX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 06:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjGJKX2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 06:23:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9948A0;
        Mon, 10 Jul 2023 03:23:25 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b9d9cbcc70so1918345ad.0;
        Mon, 10 Jul 2023 03:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688984604; x=1689589404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDDML1x+MMF/uMtkdte/RNq+k0jZQz0suwas+90hCNw=;
        b=i/kva2Tak8H5rfnw0Uqy+oIWWb41reuOkAhnRN2xav0y+7O340keD8JjfrIQBgfnHe
         ahSqmyKxsM2lgJveYCslnlhpA8PViJIM7UnCMhJkcdVAFVauyTHcS21OitY5QRGFxnvL
         1NZlJ3voNwZHUn0XaZ9f4xjMrO8GyI5ceDkg0j8sXrF8nS1RDDGOHB2me1BhQYQPXQ8N
         mJ16E9HlzNOTQr8RLKGy40kXpKLLIgu53KluIoj0o5QkKrxoYJU9JNACjRwAMRTXrpWJ
         7V9ce9W3tNFj6S6XRUSliab7xaP006ko4TZYV7S8fW6WHM+EorRHPQdCmvzLoM0Lg3Fz
         c19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688984604; x=1689589404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDDML1x+MMF/uMtkdte/RNq+k0jZQz0suwas+90hCNw=;
        b=Rh1hyGLqH1dMfRmDPUHurbPeS6BBYsUK5CJeT1QZ/spN2A3n3UKW6o4bR2+uwInN98
         uvSR/xTOQwErlhm0mEWXz7Rd8phSmO0mlQWGWauIWq8yyyVKFwmmuzOzZyyu53URw5bd
         EMN5mJl8ovQ3StTRuEUP3A+UwphZ08AkHd1Avb2+0kLkhpBra0ZykobtfqJU/rw870ZP
         kgPk0JbF2D+zf0cVkVWNmDjPM3qVT76y2oJR07/u8rCnBV2POsq9aPHnglviAmmeBIzu
         9GYcgP4/xo/S+clMn+J8EE1JqXg1ZF8BC8XLwSvIPZz6jy7dizD9ByLmKIyELpJwNarX
         eE3A==
X-Gm-Message-State: ABy/qLYI5XMJoKhAloLlXH1Uj242bwzP9HctqdB8on2XELlY5kTNYfLa
        WbCgQzFXcTjFVaq9M96zSXDFFcPC2NFkp/by
X-Google-Smtp-Source: APBJJlGkdEjDl0j/ds/nznUVO/o5zJ0h1QZm/ARL0SqmBQd1HJohPk7rJICbuKtni/H2p87yYE0o6Q==
X-Received: by 2002:a17:902:ec88:b0:1ae:4567:2737 with SMTP id x8-20020a170902ec8800b001ae45672737mr15777953plg.2.1688984604096;
        Mon, 10 Jul 2023 03:23:24 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b001b5656b0bf9sm7901984plg.286.2023.07.10.03.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 03:23:23 -0700 (PDT)
From:   FUJITA Tomonori <fujita.tomonori@gmail.com>
To:     rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     alex.gaynor@gmail.com, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, benno.lossin@proton.me
Subject: [PATCH v2 2/3] rust: crypto abstractions for random number generator API
Date:   Mon, 10 Jul 2023 19:22:24 +0900
Message-Id: <20230710102225.155019-3-fujita.tomonori@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710102225.155019-1-fujita.tomonori@gmail.com>
References: <20230710102225.155019-1-fujita.tomonori@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds basic abstractions for random number generator API,
wrapping crypto_rng structure.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers.c                  |  12 ++++
 rust/kernel/crypto.rs           |   1 +
 rust/kernel/crypto/rng.rs       | 101 ++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)
 create mode 100644 rust/kernel/crypto/rng.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2f198c6d5de5..089ac38c6461 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -7,6 +7,7 @@
  */
 
 #include <crypto/hash.h>
+#include <crypto/rng.h>
 #include <linux/errname.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
diff --git a/rust/helpers.c b/rust/helpers.c
index 7966902ed8eb..e4dcd611738f 100644
--- a/rust/helpers.c
+++ b/rust/helpers.c
@@ -19,6 +19,7 @@
  */
 
 #include <crypto/hash.h>
+#include <crypto/rng.h>
 #include <linux/bug.h>
 #include <linux/build_bug.h>
 #include <linux/err.h>
@@ -52,6 +53,17 @@ int rust_helper_crypto_shash_init(struct shash_desc *desc) {
 	return crypto_shash_init(desc);
 }
 EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_init);
+
+void rust_helper_crypto_free_rng(struct crypto_rng *tfm) {
+	crypto_free_rng(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_free_rng);
+
+int rust_helper_crypto_rng_generate(struct crypto_rng *tfm, const u8 *src,
+	unsigned int slen, u8 *dst, unsigned int dlen) {
+	return crypto_rng_generate(tfm, src, slen, dst, dlen);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_rng_generate);
 #endif
 
 __noreturn void rust_helper_BUG(void)
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
index f80dd7bd3381..a1995e6c85d4 100644
--- a/rust/kernel/crypto.rs
+++ b/rust/kernel/crypto.rs
@@ -3,3 +3,4 @@
 //! Cryptography.
 
 pub mod hash;
+pub mod rng;
diff --git a/rust/kernel/crypto/rng.rs b/rust/kernel/crypto/rng.rs
new file mode 100644
index 000000000000..683f5ee464ce
--- /dev/null
+++ b/rust/kernel/crypto/rng.rs
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Random number generator.
+//!
+//! C headers: [`include/crypto/rng.h`](../../../../include/crypto/rng.h)
+
+use crate::{
+    error::{code::EINVAL, from_err_ptr, to_result, Result},
+    str::CStr,
+};
+
+/// Type of Random number generator.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+enum RngType {
+    /// Uses `crypto_default_rng`
+    // We don't need to keep an pointer for the default but simpler.
+    Default(*mut bindings::crypto_rng),
+
+    /// Allocated via `crypto_alloc_rng.
+    Allocated(*mut bindings::crypto_rng),
+}
+
+/// Corresponds to the kernel's `struct crypto_rng`.
+pub struct Rng(RngType);
+
+impl Drop for Rng {
+    fn drop(&mut self) {
+        match self.0 {
+            RngType::Default(_) => {
+                // SAFETY: it's safe because `crypto_get_default_rng()` was called during
+                // the initialization.
+                unsafe {
+                    bindings::crypto_put_default_rng();
+                }
+            }
+            RngType::Allocated(ptr) => {
+                // SAFETY: The type invariants of `RngType` guarantees that the pointer is valid.
+                unsafe { bindings::crypto_free_rng(ptr) };
+            }
+        }
+    }
+}
+
+impl Rng {
+    /// Creates a [`Rng`] instance.
+    pub fn new(name: &CStr, t: u32, mask: u32) -> Result<Self> {
+        // SAFETY: There are no safety requirements for this FFI call.
+        let ptr = unsafe { from_err_ptr(bindings::crypto_alloc_rng(name.as_char_ptr(), t, mask)) }?;
+        // INVARIANT: `ptr` is valid and non-null since `crypto_alloc_rng`
+        // returned a valid pointer which was null-checked.
+        Ok(Self(RngType::Allocated(ptr)))
+    }
+
+    /// Creates a [`Rng`] instance with a default algorithm.
+    pub fn new_with_default() -> Result<Self> {
+        // SAFETY: There are no safety requirements for this FFI call.
+        to_result(unsafe { bindings::crypto_get_default_rng() })?;
+        // INVARIANT: The C API guarantees that `crypto_default_rng` is valid until
+        // `crypto_put_default_rng` is called.
+        Ok(Self(RngType::Default(unsafe {
+            bindings::crypto_default_rng
+        })))
+    }
+
+    /// Get a random number.
+    pub fn generate(&mut self, src: &[u8], dst: &mut [u8]) -> Result {
+        if src.len() > u32::MAX as usize || dst.len() > u32::MAX as usize {
+            return Err(EINVAL);
+        }
+        let ptr = match self.0 {
+            RngType::Default(ptr) => ptr,
+            RngType::Allocated(ptr) => ptr,
+        };
+        // SAFETY: The type invariants of `RngType' guarantees that the pointer is valid.
+        to_result(unsafe {
+            bindings::crypto_rng_generate(
+                ptr,
+                src.as_ptr(),
+                src.len() as u32,
+                dst.as_mut_ptr(),
+                dst.len() as u32,
+            )
+        })
+    }
+
+    /// Re-initializes the [`Rng`] instance.
+    pub fn reset(&mut self, seed: &[u8]) -> Result {
+        if seed.len() > u32::MAX as usize {
+            return Err(EINVAL);
+        }
+        let ptr = match self.0 {
+            RngType::Default(ptr) => ptr,
+            RngType::Allocated(ptr) => ptr,
+        };
+        // SAFETY: The type invariants of `RngType' guarantees that the pointer is valid.
+        to_result(unsafe { bindings::crypto_rng_reset(ptr, seed.as_ptr(), seed.len() as u32) })
+    }
+}
-- 
2.34.1

