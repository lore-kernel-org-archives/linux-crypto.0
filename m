Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A910540DB29
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787761826; cv=none; b=HeL6cX2vzEGXQBKkH3sQJN4luO3gkR4bljiTr/qLfIyHdb5gotf00dlaQA4D2l/d4XMlWFm+rktYW2K1Sv6m4o1Z4S7YzyfEFz7oGrjaux7RpqLL5L6p2EyyXo+ObnuDtFn4yMo9zbjdgSid4zd3nWCXFIIVQZM6Opz+AkwKFUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787761826; c=relaxed/simple;
	bh=RerT+o0KR5aTPU/MGbXBoEQeMb8OggILxf1MgJ8bnwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DLy9qyy2+Xb7jUYLDmPwhVMgnLiGQWULN/InzM7rTB6HVGP/PnMnbP6BNqBWg9lb+iD8iQow0KOQZWizqNrnzeQJlnpdMO5E/VJFlEbh2PDOAtP64zaCGLlvnDVtLA4QrpnuJ8zg/CkOlQU8o6DgIvXjJVKtsaCPot0Mw6f6LVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=XbOu6+Ua; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="XbOu6+Ua"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so10803115e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 09:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1787761823; x=1788366623; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MrQouyjITlfd1IzGNl6BiZWTcdxUJAaNMeQRpNhwBjk=;
        b=XbOu6+UahBMWe9jTLkeJns5ZUxmJaMd+Lc/ZcB0Vjp1bL/+MPp6RK7lMiy8vLkMbqv
         ysLvjj8PBnVYFKQGrfkPkuClKXm4tRfG+QvKFo5Dv1UsFW99WQBkND2HdyZgGWUqnw/F
         HmZWWiGKxnido21DsOQIXKENnu0KTUUnF41sUuJgHXnWcI65GQZl6isrqspD3ajY1C9S
         mlwSNKgE/Za2r3DJ4QRlaV6fg9e1ce7jIrM4z2dtmBS/8ngN5RRnGaEgXu7ZOiY+Zm/6
         x57YXtpM/4AmP3fN9ak6dnu9lpRLJhijcrZlBlgCCX7F7O+Vv6mqtEMOM89wVPm0aYtB
         bSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787761823; x=1788366623;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MrQouyjITlfd1IzGNl6BiZWTcdxUJAaNMeQRpNhwBjk=;
        b=fVtNFcbEJSHD4Jl/NsQvgdKpz33tBIRrJkBBlV4I4oP2tc1Sf224tuZ+tSO5A9ErHm
         PfkkEUspGCRfNAlxeB+KrLZxYtOONYsLUDXYCbPVizW2D6qtltZ1PX595Pn5UNZn4G9N
         nxB5yE6LIH8XFagHZGk/8JPBgrC9vGQcGSg1kp+N7Jzouvfps9pnop6vNmXP3w+vCs0n
         JsDLLtaU7tRUL3ceo0Ao7LTYJ2BGqO/Xa1CAZxY38P3jmY0uz17UF9oBJpM3jcL17SbN
         FA399KwV91OGbw/DaGKdik5MenW7W1JrZTIfp7ix2hzOH0Hb/0huoriOO42gWtriRbkm
         AZgw==
X-Gm-Message-State: AFuF++kFs1xOVd1bOv18HI24h2JOENF/o8MV3hgHEjGEu0Ho+Pxe560c
	BwymzyCjcCEUrHPhJvuVK8hJBm/HmIhxNvN97D76G2qxveufWNtA/tE+E/7cZjJMnnCBEtaKYyv
	J2FmroJsu
X-Gm-Gg: AR+sD11b7wWh+mwD2qZgQ5AX6HeIkWSnFW23FQ46uhZUqBAxnPeDKMKwyeZsRcq/ri1
	2KdVGcaZPELY/ZET9X7PbZEm0oGFnP+cU66btuWbHlGlnnhSglVjLOe3AjfmWTV7W7NWaBUUHbi
	FrwFaOYbcexnhX1ZpxopWgYKiVM0cwBSVGk2PbmlgGUm4Dv5toSBzroEmSAaFZSGHAl4bUMk8yQ
	CNHCzmvCvl4dnpv1g903QnoVRH5UsL0Rbc2OVbVs23AYrzZt5SkM9bPIHbkRk9o/oPzragzd9UF
	/GXkIkiyzhsdIyPDm2lQKWvmfJ6Nz70tm7C3JCpHLSLr6GqNz2fU6QTZXvnqsSkJvmLVtBoBtHw
	2AkUwZ/ZMfZc/8EIO6/EL61Ia/iQYLrFERXV30hXs9q7s4IxGvUXca2Lf1NIfu+mSZPgeCR5GyE
	+JjRPf3YbNN+mBMaOIOLK7ESGa9LgmVsKf/FRAqnpinpyKi70eX/D2cW3bwgTE0AfZ5KbfXi5KT
	TKTMVKLmANbV4yB+vAE2Q8QIHtzTa8bwUgA
X-Received: by 2002:a05:600c:3103:b0:499:484a:98e7 with SMTP id 5b1f17b1804b1-499dc8307d6mr76020915e9.14.1787761822719;
        Wed, 26 Aug 2026 09:30:22 -0700 (PDT)
Received: from axion.fireburn.co.uk ([2a01:4b00:d309:1c00:caf1:6b20:8531:818c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dc981bf3sm32323615e9.8.2026.08.26.09.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 09:30:21 -0700 (PDT)
From: Mike Lothian <mike@fireburn.co.uk>
To: linux-crypto@vger.kernel.org
Cc: Mike Lothian <mike@fireburn.co.uk>,
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
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Lyude Paul <lyude@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Matthew Maurer <mmaurer@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Burak Emir <bqe@google.com>,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v3 1/2] rust: crypto: add AES-128, AES-CMAC, SHA-256, and HMAC bindings
Date: Wed, 26 Aug 2026 17:29:48 +0100
Message-ID: <20260826163004.3365-2-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826163004.3365-1-mike@fireburn.co.uk>
References: <20260826163004.3365-1-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Expose the synchronous lib/crypto AES-128, AES-CMAC, SHA-256, and
HMAC-SHA256 primitives through safe Rust APIs.

Aes128 prepares the key schedule once and reuses it for block encryption
and CMAC. The one-shot hash and HMAC helpers operate on slices, and
every API uses fixed-size outputs. C shims cover interfaces that bindgen
cannot represent and clear temporary key material before returning.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
---
 rust/bindings/bindings_helper.h |   3 +
 rust/helpers/crypto.c           |  37 ++++++++++
 rust/helpers/helpers.c          |   1 +
 rust/kernel/crypto.rs           | 115 ++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   1 +
 5 files changed, 157 insertions(+)
 create mode 100644 rust/helpers/crypto.c
 create mode 100644 rust/kernel/crypto.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2d079f278a04..8d7489b8cce8 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -28,6 +28,9 @@
  */
 #include <linux/hrtimer_types.h>
 
+#include <crypto/aes.h>
+#include <crypto/sha2.h>
+
 #include <linux/acpi.h>
 #include <linux/gpu_buddy.h>
 #include <drm/drm_device.h>
diff --git a/rust/helpers/crypto.c b/rust/helpers/crypto.c
new file mode 100644
index 000000000000..a18780231ce0
--- /dev/null
+++ b/rust/helpers/crypto.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/aes.h>
+#include <crypto/aes-cbc-macs.h>
+#include <linux/string.h>
+
+/*
+ * aes_encrypt() takes a transparent union (aes_encrypt_arg) that bindgen cannot
+ * express, so the single-block encrypt step is wrapped here. The key schedule
+ * is prepared once (aes_prepareenckey() is a plain extern bound directly) and
+ * the resulting struct aes_enckey is reused across blocks by the caller, so the
+ * key is not re-expanded per block. SHA-256 and HMAC-SHA256 are plain extern
+ * functions and are bound directly.
+ */
+__rust_helper void
+rust_helper_aes_enckey_encrypt_block(const struct aes_enckey *key, u8 *out,
+				     const u8 *in)
+{
+	aes_encrypt(key, out, in);
+}
+
+/*
+ * AES-CMAC one-shot over the in-tree library (crypto/aes-cbc-macs.h): prepares
+ * the 128-bit key, MACs @data and writes the 16-byte tag to @out. A helper
+ * because both aes_cmac_preparekey()'s struct and the aes_cmac() one-shot are
+ * not expressible from Rust directly. The key length is fixed at 128 bits, so
+ * aes_cmac_preparekey() cannot fail; the prepared key is wiped before return.
+ */
+__rust_helper void
+rust_helper_aes_cmac(const u8 *key, const u8 *data, size_t data_len, u8 *out)
+{
+	struct aes_cmac_key cmac_key;
+
+	aes_cmac_preparekey(&cmac_key, key, AES_KEYSIZE_128);
+	aes_cmac(&cmac_key, data, data_len, out);
+	memzero_explicit(&cmac_key, sizeof(cmac_key));
+}
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 0d85b5e68ec2..cb7c668bffa2 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -56,6 +56,7 @@
 #include "cpufreq.c"
 #include "cpumask.c"
 #include "cred.c"
+#include "crypto.c"
 #include "device.c"
 #include "dma.c"
 #include "dma-resv.c"
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
new file mode 100644
index 000000000000..5f7c301b2bb8
--- /dev/null
+++ b/rust/kernel/crypto.rs
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Safe wrappers over the kernel's synchronous library crypto.
+//!
+//! Exposes the one-shot `lib/crypto` primitives — AES-128 (an [`Aes128`] key
+//! prepared once for single-block encryption, the building block for modes the
+//! library does not yet provide such as AES-CTR), the in-tree AES-CMAC
+//! ([`aes_cmac`]), SHA-256 and HMAC-SHA256 — for use from Rust. They run
+//! synchronously in the calling context with no allocation; the hashes and the
+//! MAC are infallible.
+//!
+//! C headers: [`include/crypto/aes.h`](srctree/include/crypto/aes.h),
+//! [`include/crypto/aes-cbc-macs.h`](srctree/include/crypto/aes-cbc-macs.h),
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
+/// Returns `AES-CMAC-128(key, data)` (RFC 4493), computed by the in-tree
+/// AES-CMAC library ([`include/crypto/aes-cbc-macs.h`]). The 128-bit key is
+/// prepared and wiped internally; the call is infallible.
+///
+/// [`include/crypto/aes-cbc-macs.h`]: srctree/include/crypto/aes-cbc-macs.h
+pub fn aes_cmac(key: &[u8; AES128_BLOCK_SIZE], data: &[u8]) -> [u8; AES128_BLOCK_SIZE] {
+    let mut out = [0u8; AES128_BLOCK_SIZE];
+    // SAFETY: `key` is a valid 16-byte key, `data` is valid for `data.len()`
+    // reads, and `out` is a valid `AES128_BLOCK_SIZE`-byte output buffer, as the
+    // helper requires.
+    unsafe { bindings::aes_cmac(key.as_ptr(), data.as_ptr(), data.len(), out.as_mut_ptr()) };
+    out
+}
+
+/// An AES-128 key, expanded once for single-block encryption.
+///
+/// The key schedule is computed in [`Aes128::new`] and reused across every
+/// [`encrypt_block`](Aes128::encrypt_block) call, so encrypting a stream of
+/// blocks (e.g. an AES-CTR keystream) does not re-expand the key per block. This
+/// is a low-level building block: prefer a full mode of operation where the
+/// library provides one (see [`aes_cmac`]); the bare block cipher is here only
+/// for modes `lib/crypto` does not yet expose, such as AES-CTR.
+///
+/// # Examples
+///
+/// ```
+/// use kernel::crypto::Aes128;
+/// let cipher = Aes128::new(&[0u8; 16])?;
+/// let _ct = cipher.encrypt_block(&[0u8; 16]);
+/// # Ok::<(), Error>(())
+/// ```
+pub struct Aes128(bindings::aes_enckey);
+
+impl Aes128 {
+    /// Expands an AES-128 key from 16 raw key bytes.
+    pub fn new(key: &[u8; AES128_BLOCK_SIZE]) -> Result<Self> {
+        // SAFETY: `aes_enckey` is a plain-old-data key schedule (integer arrays
+        // in a union of integer arrays); an all-zero bit pattern is a valid,
+        // inert initial value, fully overwritten by `aes_prepareenckey()` below.
+        let mut enckey: bindings::aes_enckey = unsafe { core::mem::zeroed() };
+        // SAFETY: `enckey` is a valid, owned `aes_enckey`; `key` is a valid
+        // 16-byte buffer; `AES128_BLOCK_SIZE` (16) is a supported key length.
+        let ret =
+            unsafe { bindings::aes_prepareenckey(&mut enckey, key.as_ptr(), AES128_BLOCK_SIZE) };
+        to_result(ret)?;
+        Ok(Self(enckey))
+    }
+
+    /// Encrypts one 16-byte block with the prepared key: returns
+    /// `AES-128-ECB(key, block)`.
+    pub fn encrypt_block(&self, block: &[u8; AES128_BLOCK_SIZE]) -> [u8; AES128_BLOCK_SIZE] {
+        let mut out = [0u8; AES128_BLOCK_SIZE];
+        // SAFETY: `self.0` is a prepared encryption key; `block` and `out` are
+        // valid 16-byte buffers, as the helper requires.
+        unsafe { bindings::aes_enckey_encrypt_block(&self.0, out.as_mut_ptr(), block.as_ptr()) };
+        out
+    }
+}
+
+impl Drop for Aes128 {
+    fn drop(&mut self) {
+        // SAFETY: `self.0` is a valid, owned `aes_enckey`; overwriting it with
+        // an all-zero `aes_enckey` clears the expanded key schedule.
+        // `write_volatile` keeps the store from being optimised away.
+        unsafe { core::ptr::write_volatile(&mut self.0, core::mem::zeroed()) };
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index d7ced2a4c11f..3c45e4730646 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -62,6 +62,7 @@
 pub mod cpufreq;
 pub mod cpumask;
 pub mod cred;
+pub mod crypto;
 pub mod debugfs;
 pub mod device;
 pub mod device_id;
