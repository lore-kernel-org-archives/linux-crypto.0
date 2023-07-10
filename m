Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36DCEB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 10:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjGJKXf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 06:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjGJKX3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 06:23:29 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D937B93;
        Mon, 10 Jul 2023 03:23:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-682eef7d752so438378b3a.0;
        Mon, 10 Jul 2023 03:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688984603; x=1689589403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eCSMJahyXmCvgvDzVjTHJgX6FPvVAG1dRHxwcI+b1M4=;
        b=Jm+G2W/vSOFtBrwWvqTPkva20krEpuoen+Jo5jFHmpYfh9RGcWNYXy/p6YHJ27G3NM
         NFiwZ8YY2dIecN6twcLi44rwS1onWTHpwueTMJQGEGTmYDI1bdJifHbDmlYyqB8xHdQN
         uiwdQagHJNFlQeUqDjiXUJAih2Yz1gNIdpqUMwGeoKBPXbmY98sTifpzcYRUZrpt6Qty
         xO9WQmtfmLVIEMJvOFO8SbB28De24yZLEeshbGfLN/1bTW8I752XJYc3BqWQN0s4ZlvT
         0fHEvtFbm8WtehwG8wJrOWckdTP0gPTiD0i0NR9Yjl8tEir7VyDcnxKSx8U6ELzzEWpg
         43EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688984603; x=1689589403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCSMJahyXmCvgvDzVjTHJgX6FPvVAG1dRHxwcI+b1M4=;
        b=mCT1Mo/efNGt307bqZE9PuxDdB4o0owuFNp68w4dL5bNgMRD1/kxhvCivr0N+FHk0q
         qXORo36oDerRWWrR0+OP2vXwX/CSRIFFuTQn7yC3f+BjF4iQ9K3gFi0JZEQjpm+p8MSz
         xW+/lzKYdYwDmvyo4h92ihTxrsVtBUYPoOxXh4qZSBUoXgn79+yvbNG50lD4GU0H3I9r
         18MjPX/6KRsUO2VLopo5IwNh+vHZeFMgBBlfnuoRE2zi4SP0Mb/KLvWXBXu7fenqsbLo
         VBV/ZSvZHvjZp5o1GB4280IDzOp55hfZM2k6CJF91JAoCnAMa04NZ1qpFLeK/tEgPWqb
         b8LA==
X-Gm-Message-State: ABy/qLYxl+oVVHUcCbGgNYS/RGYLSLU6oujOS1jX66tVLQ+9vx69ONnN
        QcFHzzp/0osHve+csevAmTT3IZY19uxe8GcM
X-Google-Smtp-Source: APBJJlExBeLEy2uKwhHfSJufN+HVdZCqOEozIFPrNAwHf9n8zDFvR21ATY8bGkw/rPI0UBVpPg109A==
X-Received: by 2002:a05:6a20:8e2a:b0:125:6443:4eb8 with SMTP id y42-20020a056a208e2a00b0012564434eb8mr16472763pzj.5.1688984602120;
        Mon, 10 Jul 2023 03:23:22 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b001b5656b0bf9sm7901984plg.286.2023.07.10.03.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 03:23:21 -0700 (PDT)
From:   FUJITA Tomonori <fujita.tomonori@gmail.com>
To:     rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     alex.gaynor@gmail.com, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, benno.lossin@proton.me
Subject: [PATCH v2 1/3] rust: crypto abstractions for synchronous message digest API
Date:   Mon, 10 Jul 2023 19:22:23 +0900
Message-Id: <20230710102225.155019-2-fujita.tomonori@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710102225.155019-1-fujita.tomonori@gmail.com>
References: <20230710102225.155019-1-fujita.tomonori@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds basic abstractions for synchronous message digest API,
wrapping crypto_shash and shash_desc structures.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers.c                  |  26 +++++++
 rust/kernel/crypto.rs           |   5 ++
 rust/kernel/crypto/hash.rs      | 128 ++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   2 +
 5 files changed, 162 insertions(+)
 create mode 100644 rust/kernel/crypto.rs
 create mode 100644 rust/kernel/crypto/hash.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 3e601ce2548d..2f198c6d5de5 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -6,6 +6,7 @@
  * Sorted alphabetically.
  */
 
+#include <crypto/hash.h>
 #include <linux/errname.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
diff --git a/rust/helpers.c b/rust/helpers.c
index bb594da56137..7966902ed8eb 100644
--- a/rust/helpers.c
+++ b/rust/helpers.c
@@ -18,6 +18,7 @@
  * accidentally exposed.
  */
 
+#include <crypto/hash.h>
 #include <linux/bug.h>
 #include <linux/build_bug.h>
 #include <linux/err.h>
@@ -28,6 +29,31 @@
 #include <linux/sched/signal.h>
 #include <linux/wait.h>
 
+#ifdef CONFIG_CRYPTO
+void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
+{
+	crypto_free_shash(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);
+
+unsigned int rust_helper_crypto_shash_digestsize(struct crypto_shash *tfm)
+{
+    return crypto_shash_digestsize(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_digestsize);
+
+unsigned int rust_helper_crypto_shash_descsize(struct crypto_shash *tfm)
+{
+    return crypto_shash_descsize(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_descsize);
+
+int rust_helper_crypto_shash_init(struct shash_desc *desc) {
+	return crypto_shash_init(desc);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_init);
+#endif
+
 __noreturn void rust_helper_BUG(void)
 {
 	BUG();
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
new file mode 100644
index 000000000000..f80dd7bd3381
--- /dev/null
+++ b/rust/kernel/crypto.rs
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Cryptography.
+
+pub mod hash;
diff --git a/rust/kernel/crypto/hash.rs b/rust/kernel/crypto/hash.rs
new file mode 100644
index 000000000000..cdbc8e70e8f5
--- /dev/null
+++ b/rust/kernel/crypto/hash.rs
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Cryptographic Hash operations.
+//!
+//! C headers: [`include/crypto/hash.h`](../../../../include/crypto/hash.h)
+
+use crate::{
+    error::{
+        code::{EINVAL, ENOMEM},
+        from_err_ptr, to_result, Result,
+    },
+    str::CStr,
+};
+use alloc::alloc::{alloc, dealloc};
+use core::alloc::Layout;
+
+/// Corresponds to the kernel's `struct crypto_shash`.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+pub struct Shash(*mut bindings::crypto_shash);
+
+impl Drop for Shash {
+    fn drop(&mut self) {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe { bindings::crypto_free_shash(self.0) }
+    }
+}
+
+impl Shash {
+    /// Creates a [`Shash`] object for a message digest handle.
+    pub fn new(name: &CStr, t: u32, mask: u32) -> Result<Shash> {
+        // SAFETY: There are no safety requirements for this FFI call.
+        let ptr =
+            unsafe { from_err_ptr(bindings::crypto_alloc_shash(name.as_char_ptr(), t, mask)) }?;
+        // INVARIANT: `ptr` is valid and non-null since `crypto_alloc_shash`
+        // returned a valid pointer which was null-checked.
+        Ok(Self(ptr))
+    }
+
+    /// Sets optional key used by the hashing algorithm.
+    pub fn setkey(&mut self, data: &[u8]) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe {
+            bindings::crypto_shash_setkey(self.0, data.as_ptr(), data.len() as u32)
+        })
+    }
+
+    /// Returns the size of the result of the transformation.
+    pub fn digestsize(&self) -> u32 {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe { bindings::crypto_shash_digestsize(self.0) }
+    }
+}
+
+/// Corresponds to the kernel's `struct shash_desc`.
+///
+/// # Invariants
+///
+/// The field `ptr` is valid.
+pub struct ShashDesc<'a> {
+    ptr: *mut bindings::shash_desc,
+    tfm: &'a Shash,
+    size: usize,
+}
+
+impl Drop for ShashDesc<'_> {
+    fn drop(&mut self) {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe {
+            dealloc(
+                self.ptr.cast(),
+                Layout::from_size_align(self.size, 2).unwrap(),
+            );
+        }
+    }
+}
+
+impl<'a> ShashDesc<'a> {
+    /// Creates a [`ShashDesc`] object for a request data structure for message digest.
+    pub fn new(tfm: &'a Shash) -> Result<Self> {
+        // SAFETY: The type invariant guarantees that `tfm.0` pointer is valid.
+        let size = core::mem::size_of::<bindings::shash_desc>()
+            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize;
+        let layout = Layout::from_size_align(size, 2)?;
+        // SAFETY: It's safe because layout has non-zero size.
+        let ptr = unsafe { alloc(layout) } as *mut bindings::shash_desc;
+        if ptr.is_null() {
+            return Err(ENOMEM);
+        }
+        // INVARIANT: `ptr` is valid and non-null since `alloc`
+        // returned a valid pointer which was null-checked.
+        let mut desc = ShashDesc { ptr, tfm, size };
+        // SAFETY: `desc.ptr` is valid and non-null since `alloc`
+        // returned a valid pointer which was null-checked.
+        // Additionally, The type invariant guarantees that `tfm.0` is valid.
+        unsafe { (*desc.ptr).tfm = desc.tfm.0 };
+        desc.reset()?;
+        Ok(desc)
+    }
+
+    /// Re-initializes message digest.
+    pub fn reset(&mut self) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
+    }
+
+    /// Adds data to message digest for processing.
+    pub fn update(&mut self, data: &[u8]) -> Result {
+        if data.len() > u32::MAX as usize {
+            return Err(EINVAL);
+        }
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe {
+            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.len() as u32)
+        })
+    }
+
+    /// Calculates message digest.
+    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
+        if self.tfm.digestsize() as usize > output.len() {
+            return Err(EINVAL);
+        }
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output.as_mut_ptr()) })
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 85b261209977..3cb8bd8a17d9 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -31,6 +31,8 @@
 #[cfg(not(testlib))]
 mod allocator;
 mod build_assert;
+#[cfg(CONFIG_CRYPTO)]
+pub mod crypto;
 pub mod error;
 pub mod init;
 pub mod ioctl;
-- 
2.34.1

