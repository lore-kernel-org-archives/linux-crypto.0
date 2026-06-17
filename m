Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B95258EF9
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708515; cv=none; b=kTt9ihq53RYnuJAPOB8csLgznIx+PkN7zvYVZOdiXEWaY7WNZ8K4gPGH9PMOnRgutz4uJ7bqkZzgphgDfOwd8D0MgmbNYgBui97R890+o9b5EL2a7bxRVYQh/KZTAJL5BAglggAh7Ab+/2bv4Hp0ZVGpkLgtZ2cQSBtyV5t4I8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708515; c=relaxed/simple;
	bh=ct00qaYw5ii75+JRYMWFYEzHYJZ43EpY06/GO8XHLlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lf7H7guraYRbD5cwDlGhVUAFo+nOTj/74d4E4MBNTBxWg3jO1fGTx3gNGyH7o+ozjXrnZqnhxe4gEKhu1fq55B/l7R1I4nqZSGCoJuS1m3v4ZO+h1n2gPtPru2eKD28E2z6OadjW5L1OiXOGUJdbYLSZ7b8imf2d/3vbaLMSIlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=jTDRiVYR; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="jTDRiVYR"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4923139e940so12150375e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1781708511; x=1782313311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lK7iRm0g/GV5F49BTZJdFhoKE+hl2FJrvypxXIkXUY=;
        b=jTDRiVYRLF3Aii9Uj2fm9zTsCNSye9eoD5z3GstLa5QaXpKilH7WJIogZ/4yx7H7UD
         wEryCaLMmkUyl+UK2Z26MhQ0TWvmFsdF7xKNqP4J0qCQplA31CWm0qTrE/nOyaTr1bWO
         3LcudpEEF/kBD5lSYdm68qwDlNUA3o9iO8J/ljhFaDdsPsHho4ioJbLgTZ/0Xrw2GUMi
         6rWBQ0V0DT1y64Y9LxzxvwIDJEv42vu1JDBFZdHBBDo+2SU8Vuw7M45rzMQW7sSLUVfc
         WD2o5MwTKf7g17QDe9DyzN1KvYPbIvJZS2XmxdyoTdJeGZ9hgNOutogsMWuDP5+XZRFq
         Qgvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781708511; x=1782313311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1lK7iRm0g/GV5F49BTZJdFhoKE+hl2FJrvypxXIkXUY=;
        b=CXfzVKCfqrwvFczmjyFwFj2QRUbmb006mezitrZlMUygf07xstX+PwfuG2gnim6G5f
         LQ4eOmNFP6AKITidJuNI29JThygAC9PzIA5BgLLV/znopvwZckAjQiNm1Cy2NxDjAe1q
         FQe2pXmyD8afE4ylLvFxm2oVxq/cKg0tDany+DRJGIzwyUX1FZ1GKsXjMW7/Q/2TSZtm
         AsHkBSt6PhkVAI40wb2NFbEe+ypfxwPZRgRiFcLridP8/QqZjElyUyyNV6Arc88cjwwG
         ncr7dY5WyACh0Ti3FskCiJOFLxZONBhudBYzi+WIKn9RstFidZ3vs5EBi8jdlQCNJkMK
         6rqg==
X-Forwarded-Encrypted: i=1; AFNElJ9DwKefwdugDEjogso+NKAlCHN8xubbvS0UiHvkC34GgdqIXtGKPwW5ZbC8REhnNwRXN/6ok9xzl1+Qwrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQBM0uSHKKlsxFm71CNNjlf+N2ABkHVXzh14QDSDxk9COBjJDf
	R1/8P6DjkF/q8DPBUTjmusQybm/ZwQbGNYf/pRInWdJEVc2QRsBMEYbGeg7tTQs1mg==
X-Gm-Gg: Acq92OHBC1Z2JmMxsWQ3y9EhgaU3/pPfM1gBRdeXCtETqFu1M4r2/J8fcaE0cgkOi1q
	osTvFwNGAI03FpGPN6/HVTvmdmzL43wRzCpilK3isAvMr3Xn5AEXnUPoHHdVf1r2XQA00JECAk3
	STuL/6baml3a3JpoM4MYGxcLuWgVnfVWSFHE9gLbhH8Thi8PD1SctSQEamcLMe9/GISQvGIPQWT
	m4PnNXsA/nKPXURcTD2YSCDhMbgcI7QU+nqD8cNmh5LiJvcb7ydnIWHBgUBacERWaL7uNDDWqkK
	u13h6SD4Y6CN2NLM6mQWgd76qKw8fsubg4G8EAFFrfr4JlzY04L3E1r4rP+KXj1FGjSEdWKWtJz
	j1ZGXq3cZsUhHdHQRHDDqUOWmH9tf9EY/oT3i0hIv1YKo3bifTdySVupftABImquSlVb7t8OHO+
	fG0r5IqB5tj/w/UOxI/2/0rQid4TswnUe5gWACsqr7g+6AbfBIwtn2jonV
X-Received: by 2002:a05:600d:8445:10b0:492:1e36:bafc with SMTP id 5b1f17b1804b1-4923413c5e7mr44253215e9.36.1781708510548;
        Wed, 17 Jun 2026 08:01:50 -0700 (PDT)
Received: from axion.fireburn.co.uk ([137.220.119.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-461abb44c3dsm13769159f8f.9.2026.06.17.08.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:01:49 -0700 (PDT)
From: Mike Lothian <mike@fireburn.co.uk>
To: rust-for-linux@vger.kernel.org
Cc: Mike Lothian <mike@fireburn.co.uk>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Krishna Ketan Rai <prafulrai522@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] rust: crypto: add library AES-128 / SHA-256 / HMAC-SHA256 bindings
Date: Wed, 17 Jun 2026 16:01:32 +0100
Message-ID: <20260617150143.2152-2-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260617150143.2152-1-mike@fireburn.co.uk>
References: <20260617150143.2152-1-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a small `kernel::crypto` module exposing the kernel's synchronous
library crypto (lib/crypto) to Rust: SHA-256, HMAC-SHA256 and single-block
AES-128 ECB. These are one-shot, allocation-free and run in the calling
context, suitable for in-kernel Rust users that need a hash or a block
cipher without the full asynchronous crypto API.

SHA-256 (`sha256()`) and HMAC-SHA256 (`hmac_sha256_usingrawkey()`) are
plain exported functions and are bound directly via bindgen, so their
header `<crypto/sha2.h>` is added to bindings_helper.h. AES single-block
encryption goes through a `rust_helper_` shim because `aes_encrypt()` takes
a transparent union (`aes_encrypt_arg`) that bindgen cannot express; the
shim also zeroes the expanded key schedule before returning.

The Rust API: `crypto::sha256(&[u8]) -> [u8; 32]`,
`crypto::hmac_sha256(key, data) -> [u8; 32]`, and the `crypto::Aes128`
type, created with `Aes128::new(key)` and used via
`encrypt_block(&[u8; 16]) -> Result<[u8; 16]>`.

Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
Assisted-by: Claude:claude-opus-4-8 [Claude-Code]
---
 rust/bindings/bindings_helper.h |  2 +
 rust/helpers/crypto.c           | 25 +++++++++++
 rust/helpers/helpers.c          |  1 +
 rust/kernel/crypto.rs           | 77 +++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |  1 +
 5 files changed, 106 insertions(+)
 create mode 100644 rust/helpers/crypto.c
 create mode 100644 rust/kernel/crypto.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 1124785e210b..14671e1825bb 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -28,6 +28,8 @@
  */
 #include <linux/hrtimer_types.h>
 
+#include <crypto/sha2.h>
+
 #include <linux/acpi.h>
 #include <linux/gpu_buddy.h>
 #include <drm/drm_device.h>
diff --git a/rust/helpers/crypto.c b/rust/helpers/crypto.c
new file mode 100644
index 000000000000..dc9614f6fc8e
--- /dev/null
+++ b/rust/helpers/crypto.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/aes.h>
+#include <linux/string.h>
+
+/*
+ * AES-128 single-block ECB encryption: out = AES(key, in).
+ *
+ * A helper because aes_encrypt() takes a transparent union (aes_encrypt_arg)
+ * that bindgen cannot express. SHA-256 and HMAC-SHA256 are plain extern
+ * functions and are bound directly.
+ */
+__rust_helper int
+rust_helper_aes128_encrypt_block(const u8 *key, const u8 *in, u8 *out)
+{
+	struct aes_enckey enckey;
+	int ret;
+
+	ret = aes_prepareenckey(&enckey, key, AES_KEYSIZE_128);
+	if (ret)
+		return ret;
+	aes_encrypt(&enckey, out, in);
+	memzero_explicit(&enckey, sizeof(enckey));
+	return 0;
+}
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 4488a87223b9..45e67929251e 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -55,6 +55,7 @@
 #include "cpufreq.c"
 #include "cpumask.c"
 #include "cred.c"
+#include "crypto.c"
 #include "device.c"
 #include "dma.c"
 #include "dma-resv.c"
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
new file mode 100644
index 000000000000..c8f2cb994cfd
--- /dev/null
+++ b/rust/kernel/crypto.rs
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Safe wrappers over the kernel's synchronous library crypto.
+//!
+//! Exposes the one-shot `lib/crypto` primitives — AES-128 single-block ECB,
+//! SHA-256 and HMAC-SHA256 — for use from Rust. They run synchronously in the
+//! calling context with no allocation; the hashes are infallible.
+//!
+//! C headers: [`include/crypto/aes.h`](srctree/include/crypto/aes.h),
+//! [`include/crypto/sha2.h`](srctree/include/crypto/sha2.h).
+
+use crate::{bindings, error::to_result, prelude::*};
+
+/// Size of a SHA-256 / HMAC-SHA256 digest, in bytes.
+pub const SHA256_DIGEST_SIZE: usize = 32;
+/// AES-128 block and key size, in bytes.
+pub const AES128_BLOCK_SIZE: usize = 16;
+
+/// Returns the SHA-256 digest of `data`.
+pub fn sha256(data: &[u8]) -> [u8; SHA256_DIGEST_SIZE] {
+    let mut out = [0u8; SHA256_DIGEST_SIZE];
+    // SAFETY: `data` is valid for `data.len()` reads and `out` is a valid
+    // `SHA256_DIGEST_SIZE`-byte output buffer, as `sha256()` requires.
+    unsafe { bindings::sha256(data.as_ptr(), data.len(), out.as_mut_ptr()) };
+    out
+}
+
+/// Returns `HMAC-SHA256(key, data)`.
+pub fn hmac_sha256(key: &[u8], data: &[u8]) -> [u8; SHA256_DIGEST_SIZE] {
+    let mut out = [0u8; SHA256_DIGEST_SIZE];
+    // SAFETY: `key` and `data` are valid for their respective lengths and `out`
+    // is a valid `SHA256_DIGEST_SIZE`-byte output buffer, as required.
+    unsafe {
+        bindings::hmac_sha256_usingrawkey(
+            key.as_ptr(),
+            key.len(),
+            data.as_ptr(),
+            data.len(),
+            out.as_mut_ptr(),
+        )
+    };
+    out
+}
+
+/// An AES-128 key usable for single-block ECB encryption.
+///
+/// # Examples
+///
+/// ```
+/// use kernel::crypto::Aes128;
+/// let cipher = Aes128::new([0u8; 16]);
+/// let _ct = cipher.encrypt_block(&[0u8; 16])?;
+/// # Ok::<(), Error>(())
+/// ```
+pub struct Aes128([u8; AES128_BLOCK_SIZE]);
+
+impl Aes128 {
+    /// Creates an AES-128 key from 16 raw key bytes.
+    pub fn new(key: [u8; AES128_BLOCK_SIZE]) -> Self {
+        Self(key)
+    }
+
+    /// Encrypts one 16-byte block: returns `AES-128-ECB(key, block)`.
+    pub fn encrypt_block(
+        &self,
+        block: &[u8; AES128_BLOCK_SIZE],
+    ) -> Result<[u8; AES128_BLOCK_SIZE]> {
+        let mut out = [0u8; AES128_BLOCK_SIZE];
+        // SAFETY: `self.0`, `block` and `out` are all valid 16-byte buffers, as
+        // the helper requires.
+        let ret = unsafe {
+            bindings::aes128_encrypt_block(self.0.as_ptr(), block.as_ptr(), out.as_mut_ptr())
+        };
+        to_result(ret)?;
+        Ok(out)
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index b72b2fbe046d..3448fa3a0e9e 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -58,6 +58,7 @@
 pub mod cpufreq;
 pub mod cpumask;
 pub mod cred;
+pub mod crypto;
 pub mod debugfs;
 pub mod device;
 pub mod device_id;
-- 
2.54.0

