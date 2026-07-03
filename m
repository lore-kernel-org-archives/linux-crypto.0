Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FD82D7386
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 03:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783047668; cv=none; b=bC0M09PxiEAVAuOJVrUJymtlC/GSA9FdbGQ30hiaFUh4u9xbDg/1xxnwGM+ULqHZoQGQmjmZ6N9JP4WRrcdg265YkFcmwDttTg4cF/tci7tyZB8IkEYw/C9m139/z0YHPAMHN8cs+d9QpknuDo16D/go1+1h9robZn7tBupjW0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783047668; c=relaxed/simple;
	bh=vNMwT10aUyIs/UOUOeCfpeIMwXxkHRgS5Z5j0voWgjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SjA/Z8FQrHRqSLESKXCTCnvaSaXKhYyG0wn0gIhXfliEY51PYsNS29tU2e90lYRpB/5FwQ980xsv23OTxkG9vYDRLER1c9S4LxaE+yosaux490/YxJHLJARzQWD+zK9bX0KhyKOkLb2v4xh4/wsvk3hlNW9kssa+AYOrax0lZn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=M1JHDGGu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="M1JHDGGu"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493bc8fda98so523495e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 20:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1783047665; x=1783652465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFxVq+fsBKcws494QRfz2Vi1lFIC+br0mAAxV3ScsVg=;
        b=M1JHDGGuH/yeWD7ZoZS1518kHzSk/KMusnuNjFQuo4lYkev92pQLtL/m+i+EtlnAvH
         OEa3ALUYqHZlqITQpBH/n+3nMQI/t37TDaEbvA82RzQUQ/y7aMziyqHq3/cV5gJlQzPl
         KoDJuMWBhakcMyXmgrMFuz22d+LYYvBEztilExNfCctMXtZuled3mS8oqleRJTccLKrV
         1yy53Hj5AgMXHc4hf6BflNTzBrPUHi/s0FwII6ImdPpteBt7aS9XzfVOXqO6R4Rawhtj
         cjBlxbx/IpbqB7cepLGDkK9IdJOaiU2PzXIXlysx5Q2ziBg8iLshbkcZ1o6C7iIkz+ds
         594w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783047665; x=1783652465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vFxVq+fsBKcws494QRfz2Vi1lFIC+br0mAAxV3ScsVg=;
        b=rLu5GM8JJWekAsoloaLrxqv+eS+qZwm++91pMXVNKyz/BFWuWBcD1fHc+khgQ4rO28
         0Yb8PLfRXUp/yKwIAX8uwA7O9kER86yGJ6JA7NFxc6C/J4jBp1HAWMRTf4SumU6uT96S
         4opY+Jf5VJInbDdTVn35ziYmGEGiKcgokMDWYZq2nQ/rlVPpuW92f0CkHnIlL+CIP4G6
         M1xvZWN56v1/vfqE5dfENlAHFjzYnUm5QhHK8CB0T0K55coApUBN8mj/Yf+sZK/666BC
         cIRFBg4IAZEQCh/ptnNjmH5QPsnmLnnulyqO7IJDxS4vsmL9hzbmxgLhjGfGeXls7cDc
         Xcdg==
X-Gm-Message-State: AOJu0YypJFDiocuFVryw7O8jZuiV/ncOoChF7kmsopNME6//NVr77657
	oN7U8ahnyuao5wwfyrz/zeQm+NJUYO8QXfzMX68UGIxXCC94GAg8BpkD0W/VP/6bZQ==
X-Gm-Gg: AfdE7cmhL6cgdjrIk4uJlGSsCGArgJyR3MsVv0Z67nsZWM2hzqbq8V/Yj6jTNHwcb3r
	FKpiLHLXu25bYX/Ix7nxQrLrwWr+42AZ6xenrFziXfmuKGNP2PvINLOamA4c3AXpGMD7sLJLixY
	o3GEgw+O+ZHpdwVrPaIhfbV0WgtX2dvmHJJUibIrcNuIuV2zQNLyt5Bu+bdIEJLRgq4do9ST+Wh
	bmRou3hQqo3Av8b49d6FOoSGmKOb3K2lxKyuHVDl6sICwhIj5I8KAoy+XL4vSSY4s9sFSyozC+z
	edWAzpHc3sFP6PAmA2yjOT4Y+mqOCRUxQHc7syWzuFJ/4jGWKjX5V1Ub69f0w1EYkZdHo18GlsU
	4+vA31i1hkxBaK48X0mA0wDH0mI4gqxHAC8B6aR7JCRehZWE7DCeUIYKUnP+X6qUgtaQePj5uk3
	vALbEUZfrEanEbY4WolviwpoRa9GIUdp2zc0TEHRK0FPrczoG85aXyQhqXY3IY+ocug88=
X-Received: by 2002:a05:600c:524a:b0:493:af0d:484c with SMTP id 5b1f17b1804b1-493c3df2fb5mr108882145e9.34.1783047665359;
        Thu, 02 Jul 2026 20:01:05 -0700 (PDT)
Received: from axion.fireburn.co.uk ([137.220.119.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef183e7sm199495015e9.2.2026.07.02.20.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 20:01:04 -0700 (PDT)
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
Subject: [RFC PATCH v2 3/3] rust: crypto: add an RSA public-key primitive in lib/crypto
Date: Fri,  3 Jul 2026 04:00:53 +0100
Message-ID: <20260703030056.2763-4-mike@fireburn.co.uk>
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

Address the v1 RFC review (Eric Biggers): rather than binding
crypto_akcipher ("a very bad API"), add the RSA public-key operation as a
small lib/crypto primitive and bind that.

New lib/crypto/rsa.c exports

  int rsa_pubkey_encrypt(const u8 *n, size_t n_len, const u8 *e, size_t
			 e_len, const u8 *in, size_t in_len, u8 *out,
			 size_t out_len);

the bare RSAEP primitive c = m^e mod n [RFC8017 sec 5.1.1], computed with
the MPI big-integer library (the same arithmetic crypto/rsa.c uses) but
without the akcipher tfm, DER key encoding, scatterlists or async
completion. It rejects m >= n (which mpi_powm() would otherwise silently
reduce, yielding an undecryptable ciphertext), writes the result
fixed-width big-endian left zero-padded to out_len, and zeroes out on
every error path. Callers apply their own padding (RSAES-OAEP, ...).
Declared in include/crypto/rsa.h, gated by a new CONFIG_CRYPTO_LIB_RSA
(selects MPILIB).

crypto::rsa_pubkey_encrypt() wraps it directly. Because the wrapper is
compiled into and exported from the built-in kernel crate, the C symbol
must live in vmlinux: CONFIG_CRYPTO_LIB_RSA is therefore a bool (a select
forces it built-in) and the wrapper is #[cfg(CONFIG_CRYPTO_LIB_RSA)]-gated
so no vmlinux dependency is introduced for kernels that do not configure
it. A consumer (e.g. the vino driver) selects it.

A from-scratch constant-time/allocation-free RSA is out of scope; this is
the lib/crypto entry point that lets a Rust caller avoid crypto_akcipher.

Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
Assisted-by: Claude:claude-opus-4-8 [Claude-Code]
---
 include/crypto/rsa.h            |  15 +++++
 lib/crypto/Kconfig              |   9 +++
 lib/crypto/Makefile             |   3 +
 lib/crypto/rsa.c                | 102 ++++++++++++++++++++++++++++++++
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/crypto.rs           |  43 ++++++++++++++
 6 files changed, 173 insertions(+)
 create mode 100644 include/crypto/rsa.h
 create mode 100644 lib/crypto/rsa.c

diff --git a/include/crypto/rsa.h b/include/crypto/rsa.h
new file mode 100644
index 000000000000..c11d7b5cae9a
--- /dev/null
+++ b/include/crypto/rsa.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * RSA public-key primitive (RSAEP), library interface.
+ *
+ * Copyright (c) 2026 Mike Lothian <mike@fireburn.co.uk>
+ */
+#ifndef _CRYPTO_RSA_H
+#define _CRYPTO_RSA_H
+
+#include <linux/types.h>
+
+int rsa_pubkey_encrypt(const u8 *n, size_t n_len, const u8 *e, size_t e_len,
+		       const u8 *in, size_t in_len, u8 *out, size_t out_len);
+
+#endif /* _CRYPTO_RSA_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 591c1c2a7fb3..04655c104e65 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -45,6 +45,15 @@ config CRYPTO_LIB_AESGCM
 config CRYPTO_LIB_ARC4
 	tristate
 
+config CRYPTO_LIB_RSA
+	bool
+	select MPILIB
+	help
+	  The RSA public-key primitive (RSAEP, out = in^e mod n), built on the
+	  MPI big-integer library. The bare primitive only; callers apply their
+	  own padding. Bool rather than tristate: the in-kernel consumer is the
+	  built-in Rust crypto bindings, so it must live in vmlinux.
+
 config CRYPTO_LIB_GF128MUL
 	tristate
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index f1e9bf89785f..486557df59e3 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -69,6 +69,9 @@ libaesgcm-y					:= aesgcm.o
 obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
 libarc4-y					:= arc4.o
 
+obj-$(CONFIG_CRYPTO_LIB_RSA)			+= librsa.o
+librsa-y					:= rsa.o
+
 obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
 ################################################################################
diff --git a/lib/crypto/rsa.c b/lib/crypto/rsa.c
new file mode 100644
index 000000000000..21c1d6c9ea26
--- /dev/null
+++ b/lib/crypto/rsa.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA public-key primitive (RSAEP) [RFC8017 sec 5.1.1].
+ *
+ * A minimal synchronous library entry point for the RSA public-key operation,
+ * built on the MPI big-integer library (the same arithmetic the crypto_akcipher
+ * "rsa" transform uses), but without the akcipher tfm allocation, DER key
+ * encoding, scatterlists or asynchronous completion machinery. It performs only
+ * the bare RSAEP primitive; callers apply any encoding/padding (RSAES-OAEP,
+ * RSAES-PKCS1-v1_5, ...) themselves.
+ *
+ * Copyright (c) 2026 Mike Lothian <mike@fireburn.co.uk>
+ */
+
+#include <crypto/rsa.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/mpi.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+/**
+ * rsa_pubkey_encrypt() - RSA public-key operation, out = (in ^ e) mod n
+ * @n: modulus, unsigned big-endian
+ * @n_len: length of @n, in bytes
+ * @e: public exponent, unsigned big-endian
+ * @e_len: length of @e, in bytes
+ * @in: input, unsigned big-endian; already padded by the caller
+ * @in_len: length of @in, in bytes
+ * @out: output buffer; receives the result big-endian, left zero-padded to
+ *	 exactly @out_len bytes
+ * @out_len: size of @out; pass the modulus length (e.g. 128 for RSA-1024)
+ *
+ * Computes the bare RSAEP primitive c = m^e mod n, where m is @in interpreted
+ * as a big-endian integer. This is the raw public-key operation [RFC8017 sec
+ * 5.1.1]; the caller is responsible for any message encoding/padding.
+ *
+ * @in interpreted as an integer must be numerically less than @n, as RSA
+ * requires: a larger value would be silently reduced mod n by the modular
+ * exponentiation and yield a ciphertext the peer cannot decrypt, so it is
+ * rejected. On any error path @out is zeroed, so it never retains data from a
+ * partial computation.
+ *
+ * Return: 0 on success; -EINVAL on a malformed key or out-of-range input;
+ * -EOVERFLOW if the result does not fit in @out_len; -ENOMEM on allocation
+ * failure.
+ */
+int rsa_pubkey_encrypt(const u8 *n, size_t n_len, const u8 *e, size_t e_len,
+		       const u8 *in, size_t in_len, u8 *out, size_t out_len)
+{
+	MPI mn, me, mbase, mres;
+	unsigned int nbytes;
+	int ret = -ENOMEM;
+
+	if (!n_len || !e_len || !in_len || !out_len)
+		return -EINVAL;
+
+	mn = mpi_read_raw_data(n, n_len);
+	me = mpi_read_raw_data(e, e_len);
+	mbase = mpi_read_raw_data(in, in_len);
+	mres = mpi_alloc(0);
+	if (!mn || !me || !mbase || !mres)
+		goto out;
+
+	/*
+	 * RSA requires 0 <= m < n; reject m >= n rather than let mpi_powm()
+	 * silently reduce it and produce an undecryptable ciphertext.
+	 */
+	if (mpi_cmp(mbase, mn) >= 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = mpi_powm(mres, mbase, me, mn);
+	if (ret)
+		goto out;
+
+	/*
+	 * mpi_read_buffer() writes the minimal big-endian form left-aligned
+	 * (and returns -EOVERFLOW without writing if @out_len is too small);
+	 * right-align it into the fixed-width output and zero-pad the front.
+	 */
+	ret = mpi_read_buffer(mres, out, out_len, &nbytes, NULL);
+	if (ret)
+		goto out;
+	if (nbytes < out_len) {
+		memmove(out + (out_len - nbytes), out, nbytes);
+		memset(out, 0, out_len - nbytes);
+	}
+out:
+	if (ret)
+		memzero_explicit(out, out_len);
+	mpi_free(mn);
+	mpi_free(me);
+	mpi_free(mbase);
+	mpi_free(mres);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rsa_pubkey_encrypt);
+
+MODULE_DESCRIPTION("RSA public-key primitive (RSAEP)");
+MODULE_LICENSE("GPL");
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 60effaf3af16..7bb04d68f9d2 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -29,6 +29,7 @@
 #include <linux/hrtimer_types.h>
 
 #include <crypto/aes.h>
+#include <crypto/rsa.h>
 #include <crypto/sha2.h>
 
 #include <linux/acpi.h>
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
index 7d96c1c710a4..b6836e771cfa 100644
--- a/rust/kernel/crypto.rs
+++ b/rust/kernel/crypto.rs
@@ -9,8 +9,12 @@
 //! synchronously in the calling context with no allocation; the hashes and the
 //! MAC are infallible.
 //!
+//! Also exposes the `lib/crypto` RSA public-key primitive
+//! ([`rsa_pubkey_encrypt`]) for callers that do their own padding.
+//!
 //! C headers: [`include/crypto/aes.h`](srctree/include/crypto/aes.h),
 //! [`include/crypto/aes-cbc-macs.h`](srctree/include/crypto/aes-cbc-macs.h),
+//! [`include/crypto/rsa.h`](srctree/include/crypto/rsa.h),
 //! [`include/crypto/sha2.h`](srctree/include/crypto/sha2.h).
 
 use crate::{bindings, error::to_result, prelude::*};
@@ -124,3 +128,42 @@ fn drop(&mut self) {
         unsafe { core::ptr::write_volatile(&mut self.0, core::mem::zeroed()) };
     }
 }
+
+/// Computes the RSA public-key primitive `out = (input ^ exponent) mod modulus`
+/// using the in-tree `lib/crypto` RSA library (`rsa_pubkey_encrypt()` in
+/// [`lib/crypto/rsa.c`](srctree/lib/crypto/rsa.c)).
+///
+/// All buffers are unsigned big-endian. `out` is written fixed-width to exactly
+/// `out.len()` bytes (left zero-padded); pass `out.len()` equal to the modulus
+/// size (e.g. 128 for RSA-1024). This is the bare primitive: the caller applies
+/// any padding (PKCS#1 v1.5, EME-OAEP, …) to `input` first.
+///
+/// `input` interpreted as an integer must be less than `modulus`, as RSA
+/// requires; otherwise an error is returned. On any error `out` is zeroed by the
+/// library, so it never retains data from a partial computation.
+///
+/// Only available when `CONFIG_CRYPTO_LIB_RSA` is enabled (a consumer selects
+/// it); the backing library is then built into the kernel.
+#[cfg(CONFIG_CRYPTO_LIB_RSA)]
+pub fn rsa_pubkey_encrypt(
+    modulus: &[u8],
+    exponent: &[u8],
+    input: &[u8],
+    out: &mut [u8],
+) -> Result {
+    // SAFETY: each slice is valid for its stated length; the library function
+    // reads `modulus`/`exponent`/`input` and writes exactly `out.len()` bytes
+    // into `out` (left zero-padded), zeroing it on any error.
+    to_result(unsafe {
+        bindings::rsa_pubkey_encrypt(
+            modulus.as_ptr(),
+            modulus.len(),
+            exponent.as_ptr(),
+            exponent.len(),
+            input.as_ptr(),
+            input.len(),
+            out.as_mut_ptr(),
+            out.len(),
+        )
+    })
+}
-- 
2.55.0

