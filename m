Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2003D2D24B7
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 03:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783047667; cv=none; b=MpGbGb/HsODvKnIA1sUhPqyi1byt4c+NPvVdnhVl8AH3cFpA1+//warL8gKwGbaUtiD09dmUhJqR8muFj1ZKWmeKAkElMuksGB4BvqOBx3C8tsOATd7AObCi2NPuMT4jnmx9r2qkl6erGccavTtcfMNrsV5yhGXVZxY13B00iF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783047667; c=relaxed/simple;
	bh=ShOpn9kF3gVYKwCMKMLMTSxS22TbosQNRw0NgktUOnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qw9ozEzGZsdyh0dQyuZlpS9sdzqehc+2P/Emym0HDU7jZC9Zqvn3YZJlqjCZiN2O44/fPODYwArga+FqYjelItbMWcW2tWOj0neSrENhGIBBIqyUdW+Z0N4owKIWqGzqu9RCufdzbph7gTYt1WGUaJOmMzRKOfsYdZa9D3W9M64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=rlSY2hBI; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="rlSY2hBI"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso268925e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 20:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1783047664; x=1783652464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmFFr1nVwg9qMyBj4UlMZMNsqttnsXWZbsMMOlcBB2E=;
        b=rlSY2hBIPOIos4V9yAoBwJQvAg51TQWcAu4XivE7Z+B/pHxyyz16vE8mvkpwOpXqGP
         ia9s9MaBr1lEJkZCoB9ba9LN346xHwW4CYbL+SO2J/ilKrIbA3kqzz9KOf28dTQg6JGU
         YXC3jjZfNpbpdXggfaIDuoj/DG30S1OpRk9FJzcLxmMGC+MjnXjAmbAXxwm4GL4Y8rdL
         fFE4tnUZ+aAUP6g9miQss8MQNHGaBMordY81AKGnyHxpuzhof6TTl5YdJzPq6f9myJMM
         +hqdP4DUY4VfaGHAzTHiB/6g3jPfAaJSYDouxnoBYmSyfiHKqk4P8dRJLLOuRvQkqt/V
         pjog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783047664; x=1783652464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QmFFr1nVwg9qMyBj4UlMZMNsqttnsXWZbsMMOlcBB2E=;
        b=EP7VSpBoXPWP/RbGAcH0cbweN9IoEOGPzDXA9J3Q+mctjEJh3b5sP6nRZjupHJS1tv
         dxA6DL2EECM0l9ch2O9eGJ55YoOUHU1HDAoUS+oicxVNCyeVTfbYSvn57zXxfPgziEhd
         QL0NslD3HqjkXHKV/vXcdehqR4oXxTpNit83yIHsdMgXTdcy/U/JJEjJw6TJqr4LHEW6
         MMQ2D7sOuA4YMz80wfYD11WZ31OPM+MLGN03bRBoBO+tzTHadKOojWoVH1BOwFtHl3dH
         vYbAtBJ8mBdn9zhV5B1Vlt8cdTKh8Lhr+OSAUPRwv0XhDFK95BgzylmG5/z5Kgv0tran
         mn6w==
X-Gm-Message-State: AOJu0YyyCrIalmH+ok0t8nuKL9+hgXA4N7R+ChojSxZHSSvDwGjMw/sL
	2IFerPt+ExhMedhLpqG150C9ejBJRgO1IDSlOhW5xn3W9Z6KqfG+iP2xHi4GIJh7oQ==
X-Gm-Gg: AfdE7cmqgvo0ByHb9Vq+kCtwVwPcwQjxszeNal1ADD+sLV7z8zqBx6NB2tBX1XiSQ1V
	WGiM+PrjkkJRVlzAPLcjqc9sGSBR8Ulhiz9540vJYIq1IMhgK4/vJBpOaJ9YS+5SSIUO0/kynaY
	0WJ67T6YfMzcNZS3awDUrFG5iO2JRqjqYZK63sB7LqMuxTA4znbLuTO7AYMoYZqkX+EW+kWA/QF
	Q96Ir7qjROFo3OrVseAYurd3BFgW1m7xmN110GnrlRsQUqlcKJfEioA87rktj/8CVDzLfVjG8KD
	XL7ZkTMwFS7nCFwQdhH/TfKavrdLQj9o5dWTWKQ24iNBaeewLyYjyciRjslVcopdNaRTVAuf+2N
	LaXw+8qZNyLOQPph3P6L4QJaKG8Q9VmzcIO5mI+pkO2eQ+X372bjgny+4DJg1eDheCsHNPDR2Ij
	K2uOaCF7w+A4UlLSWrRbIMxWgooWQZbaIIzsa6xzpW72fu7ep+qXPYlykU
X-Received: by 2002:a05:600c:4f94:b0:493:adc3:cced with SMTP id 5b1f17b1804b1-493c2b9826fmr119242225e9.34.1783047663925;
        Thu, 02 Jul 2026 20:01:03 -0700 (PDT)
Received: from axion.fireburn.co.uk ([137.220.119.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef183e7sm199495015e9.2.2026.07.02.20.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 20:01:03 -0700 (PDT)
From: Mike Lothian <mike@fireburn.co.uk>
To: rust-for-linux@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-kernel@vger.kernel.org,
	Mike Lothian <mike@fireburn.co.uk>
Subject: [RFC PATCH v2 2/3] rust: crypto: use the in-tree AES-CMAC library
Date: Fri,  3 Jul 2026 04:00:52 +0100
Message-ID: <20260703030056.2763-3-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260703030056.2763-1-mike@fireburn.co.uk>
References: <20260617150143.2152-1-mike@fireburn.co.uk>
 <20260703030056.2763-1-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Address the v1 RFC review (Eric Biggers):

 - Drop the bare single-block ECB helper (`aes128_encrypt_block`), which
   re-expanded the AES key on every block and exposed bare ECB instead of a
   mode of operation. `Aes128::new()` now prepares the key schedule once (via
   `aes_prepareenckey()`) and `encrypt_block()` reuses it, so a keystream loop
   (e.g. AES-CTR, which `lib/crypto` does not yet provide) no longer re-expands
   the key per block. This stays a low-level building block for the modes the
   library is missing.

 - Add `crypto::aes_cmac()` over the in-tree AES-CMAC library
   (<crypto/aes-cbc-macs.h>) instead of building CMAC out of bare AES, so the
   one mode of operation vino needs that the library already ships comes from
   the library.

Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
Assisted-by: Claude:claude-opus-4-8 [Claude-Code]
---
 rust/bindings/bindings_helper.h |  1 +
 rust/helpers/crypto.c           | 40 ++++++++++------
 rust/kernel/crypto.rs           | 85 ++++++++++++++++++++++++++-------
 3 files changed, 94 insertions(+), 32 deletions(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 14671e1825bb..60effaf3af16 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -28,6 +28,7 @@
  */
 #include <linux/hrtimer_types.h>
 
+#include <crypto/aes.h>
 #include <crypto/sha2.h>
 
 #include <linux/acpi.h>
diff --git a/rust/helpers/crypto.c b/rust/helpers/crypto.c
index dc9614f6fc8e..a18780231ce0 100644
--- a/rust/helpers/crypto.c
+++ b/rust/helpers/crypto.c
@@ -1,25 +1,37 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <crypto/aes.h>
+#include <crypto/aes-cbc-macs.h>
 #include <linux/string.h>
 
 /*
- * AES-128 single-block ECB encryption: out = AES(key, in).
- *
- * A helper because aes_encrypt() takes a transparent union (aes_encrypt_arg)
- * that bindgen cannot express. SHA-256 and HMAC-SHA256 are plain extern
+ * aes_encrypt() takes a transparent union (aes_encrypt_arg) that bindgen cannot
+ * express, so the single-block encrypt step is wrapped here. The key schedule
+ * is prepared once (aes_prepareenckey() is a plain extern bound directly) and
+ * the resulting struct aes_enckey is reused across blocks by the caller, so the
+ * key is not re-expanded per block. SHA-256 and HMAC-SHA256 are plain extern
  * functions and are bound directly.
  */
-__rust_helper int
-rust_helper_aes128_encrypt_block(const u8 *key, const u8 *in, u8 *out)
+__rust_helper void
+rust_helper_aes_enckey_encrypt_block(const struct aes_enckey *key, u8 *out,
+				     const u8 *in)
 {
-	struct aes_enckey enckey;
-	int ret;
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
 
-	ret = aes_prepareenckey(&enckey, key, AES_KEYSIZE_128);
-	if (ret)
-		return ret;
-	aes_encrypt(&enckey, out, in);
-	memzero_explicit(&enckey, sizeof(enckey));
-	return 0;
+	aes_cmac_preparekey(&cmac_key, key, AES_KEYSIZE_128);
+	aes_cmac(&cmac_key, data, data_len, out);
+	memzero_explicit(&cmac_key, sizeof(cmac_key));
 }
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
index c8f2cb994cfd..7d96c1c710a4 100644
--- a/rust/kernel/crypto.rs
+++ b/rust/kernel/crypto.rs
@@ -2,11 +2,15 @@
 
 //! Safe wrappers over the kernel's synchronous library crypto.
 //!
-//! Exposes the one-shot `lib/crypto` primitives — AES-128 single-block ECB,
-//! SHA-256 and HMAC-SHA256 — for use from Rust. They run synchronously in the
-//! calling context with no allocation; the hashes are infallible.
+//! Exposes the one-shot `lib/crypto` primitives — AES-128 (an [`Aes128`] key
+//! prepared once for single-block encryption, the building block for modes the
+//! library does not yet provide such as AES-CTR), the in-tree AES-CMAC
+//! ([`aes_cmac`]), SHA-256 and HMAC-SHA256 — for use from Rust. They run
+//! synchronously in the calling context with no allocation; the hashes and the
+//! MAC are infallible.
 //!
 //! C headers: [`include/crypto/aes.h`](srctree/include/crypto/aes.h),
+//! [`include/crypto/aes-cbc-macs.h`](srctree/include/crypto/aes-cbc-macs.h),
 //! [`include/crypto/sha2.h`](srctree/include/crypto/sha2.h).
 
 use crate::{bindings, error::to_result, prelude::*};
@@ -42,36 +46,81 @@
     out
 }
 
-/// An AES-128 key usable for single-block ECB encryption.
+/// Returns `AES-CMAC-128(key, data)` (RFC 4493), computed by the in-tree
+/// AES-CMAC library ([`include/crypto/aes-cbc-macs.h`]). The 128-bit key is
+/// prepared and wiped internally; the call is infallible.
+///
+/// [`include/crypto/aes-cbc-macs.h`]: srctree/include/crypto/aes-cbc-macs.h
+pub fn aes_cmac(
+    key: &[u8; AES128_BLOCK_SIZE],
+    data: &[u8],
+) -> [u8; AES128_BLOCK_SIZE] {
+    let mut out = [0u8; AES128_BLOCK_SIZE];
+    // SAFETY: `key` is a valid 16-byte key, `data` is valid for `data.len()`
+    // reads, and `out` is a valid `AES128_BLOCK_SIZE`-byte output buffer, as the
+    // helper requires.
+    unsafe {
+        bindings::aes_cmac(key.as_ptr(), data.as_ptr(), data.len(), out.as_mut_ptr())
+    };
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
 ///
 /// # Examples
 ///
 /// ```
 /// use kernel::crypto::Aes128;
-/// let cipher = Aes128::new([0u8; 16]);
-/// let _ct = cipher.encrypt_block(&[0u8; 16])?;
+/// let cipher = Aes128::new(&[0u8; 16])?;
+/// let _ct = cipher.encrypt_block(&[0u8; 16]);
 /// # Ok::<(), Error>(())
 /// ```
-pub struct Aes128([u8; AES128_BLOCK_SIZE]);
+pub struct Aes128(bindings::aes_enckey);
 
 impl Aes128 {
-    /// Creates an AES-128 key from 16 raw key bytes.
-    pub fn new(key: [u8; AES128_BLOCK_SIZE]) -> Self {
-        Self(key)
+    /// Expands an AES-128 key from 16 raw key bytes.
+    pub fn new(key: &[u8; AES128_BLOCK_SIZE]) -> Result<Self> {
+        // SAFETY: `aes_enckey` is a plain-old-data key schedule (integer arrays
+        // in a union of integer arrays); an all-zero bit pattern is a valid,
+        // inert initial value, fully overwritten by `aes_prepareenckey()` below.
+        let mut enckey: bindings::aes_enckey = unsafe { core::mem::zeroed() };
+        // SAFETY: `enckey` is a valid, owned `aes_enckey`; `key` is a valid
+        // 16-byte buffer; `AES128_BLOCK_SIZE` (16) is a supported key length.
+        let ret = unsafe {
+            bindings::aes_prepareenckey(&mut enckey, key.as_ptr(), AES128_BLOCK_SIZE)
+        };
+        to_result(ret)?;
+        Ok(Self(enckey))
     }
 
-    /// Encrypts one 16-byte block: returns `AES-128-ECB(key, block)`.
+    /// Encrypts one 16-byte block with the prepared key: returns
+    /// `AES-128-ECB(key, block)`.
     pub fn encrypt_block(
         &self,
         block: &[u8; AES128_BLOCK_SIZE],
-    ) -> Result<[u8; AES128_BLOCK_SIZE]> {
+    ) -> [u8; AES128_BLOCK_SIZE] {
         let mut out = [0u8; AES128_BLOCK_SIZE];
-        // SAFETY: `self.0`, `block` and `out` are all valid 16-byte buffers, as
-        // the helper requires.
-        let ret = unsafe {
-            bindings::aes128_encrypt_block(self.0.as_ptr(), block.as_ptr(), out.as_mut_ptr())
+        // SAFETY: `self.0` is a prepared encryption key; `block` and `out` are
+        // valid 16-byte buffers, as the helper requires.
+        unsafe {
+            bindings::aes_enckey_encrypt_block(&self.0, out.as_mut_ptr(), block.as_ptr())
         };
-        to_result(ret)?;
-        Ok(out)
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
     }
 }
-- 
2.55.0

