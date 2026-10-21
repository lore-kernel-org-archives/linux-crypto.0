Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792582713;
	b=JDXUIaLT0D8mvWFe0/ZgJ8ZXDELEiHVUvsLL3X1RLajj9KkQCoIuEshVdS5nMVdF/cYf
	 ufXTixzYCGFWL1rnA4yqG72Ms596zMbWX66ZjfsyFfmFwvjoz/J2CFIYvTTG830roiooY
	 2JHjyJlSnqYWfEwRIlecos3HOQluYK6v9CZm3b67T135GKgKQ5PuQ5I1250ROpWvNsr6t
	 8wQj7DRL0x8rmicVBWIGggGFx6Zx6T090PloFPqX5WGaSWF2itD0fIu+83nMDxn8QzdJ5
	 Ga/zM6JncjcyOB7eKKKKdXS4zYP2+KuZtLU8v4PgCipqLyVvqf7EjYEEXJyA/rTM2jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792582713;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=wWz643dbsj/ZlYo+epLXd9Iw2Mt+qid7bAcxch49zgs=;
	b=ZwTqTKATNlONiKbCopOeXQ5FaPYUZt7F95a8Ne68IQKrxREF1T2jeW2rlHnB40Nbmfdd
	 VHodRCBhRED7V/dwU+kFQUaItDP2C7YJxjDkw6PugPbhcmPo0fg0Xi2879BxA715joIUS
	 cH2IlyiOQrD9h3PDtdQ+Gf1l8+i+As7gwiIs6rgzIGcDQPnuRMyhyK8m+1AyhhGrr+MAg
	 evJOi6wAjQG+T4GNKWNisDPTY33LMUCaLjicLR96w90D1KhQcc5QVC0R4PyiojvttC5K2
	 kGNUcBdeAP41JaQG7elGMORk+Pxi0a0pdRpgCy0jXneHrh2P8OqxRZJ2ylI0E1lz8IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=cJGv3AXp;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBCE606A31A
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 11:38:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FBCE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=cJGv3AXp
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so391824a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 04:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1792582712; x=1793187512; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wWz643dbsj/ZlYo+epLXd9Iw2Mt+qid7bAcxch49zgs=;
        b=cJGv3AXpnzoDMycDhzUQcXIqU+devmFsnBPW6LT9HviQ80FIvQmkYWpFHd13GosVs2
         cr4JCxpb4H4em4AJmgcJRsuojb+4lNxFjtK8D7tPdQD2etqm4rxd3IUV2taS52Bzc9Yw
         3FZAiD93Vwosw/TsDWpbjzwL3E6cPs4Ob23NgWRVHPwKQjmvijJjjUdggJQBnHftJ5bY
         ap01OxvPU9ubnYFda2OEqaIM5EGA6OXFBleHILh4KfexhdY8oUX7RLUwZTasWNLOxW0U
         LD8fYDIRFFxaM6wnd9SylhenQb5OcXwZwmDtBOhkPDKGJ+Y/HEdXpnIB4ro8tmxzPxNP
         eO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792582712; x=1793187512;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wWz643dbsj/ZlYo+epLXd9Iw2Mt+qid7bAcxch49zgs=;
        b=O8NQi5gQyW0G7ABlVtBaSiUYYnY7EfWypmzDtmxPyjOuxprApQFv2uKHZg1A8w+hvB
         N5jOAG8tuBzxG/ef7+K+XEaovmfYut/ct2+JB4WCXf/wbPW9jBcaY7EWH2+81PmNdJQz
         JxhF6KW82i6+WhIWIIVhUpxhy2RRMXAN0g4KjK0YSMfmw81tH73V1prwtIDNVLThBOm5
         sxBzaxTOBCFE5RuHmiD84ddvrdK7s8diz2TerQYjrJquy02Z3/9JKNqwoaMBYsDQg3xp
         XIWv/TKks1qBlal9Nmc+IIpVyw/2Oh7gd4PpLU6xi+tsEHBdiXr/VEmlyqaH58myU9zX
         DUrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwBZYjHQLFqoSnY70PILwqnP2pRLWzeg1ZkU4usg6CHy3JS2LfPciE5nS0bh8CNDbOZDb57V1QP5KLIICo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIh3sZyVpbXNddF50jJhnWgQ9kuFJ9+yY5EtNZaQ5PanvrLoRVJ
	r2OdK8Y4PvSn/2afKfz7edPRwcF+PBNT+kuVOrn7KsRgrqRYNv2AeOpUzx4mJQLerQ==
X-Gm-Gg: AYBFou1bWIHkXcgHRtsPm0LNQ3jrFs1RDJIHyR8Shc/lBG60u+MQw3lnzOACZgoFoBC
	dr7bRkOHeBb15ujYhXrF5i2qze67Lt0FEIpPVeS+wI+JGNJ9/Z8KG5vXTMD1xoNx0YTIjNG3ETK
	LhSBHeN8s73ofiAsAxaCy6J6zEEGjzDzI/Pmu1EOUXRGn6v5E1mEe/nSr66bm9QL3QTBhbZNiDV
	2Y9DAmxVbzETi/U62QDcLgrKeZCw8xTSw356uEFxhNcxWldvr32TxHR0tf4HCUfNNnUEMcZDwIS
	zuCzSSL6HHDE1BrY46qalXJ8JJKqjdComlFiw5gli9L077kwjN0pF0Nkw8e9RgklQJOekDS1Jj5
	gvw3sDF7lQRWbfMYdx0mqyFBcXpZJC/CInbWpiGz0aS8wGuhut2BCQjcqnGUXuciFY1KcblNVuV
	EFwxbchKbjnkFeVWLpUFM0h70wJStFCnX3VK9aomXxa23IYl5AVVhX7gXTUJ9GZ3mi9NCL//6dp
	Awj5J4EKWFHxpkDWtwXvqgfnka+uLV9TvA1hvM2Kd7B8ZwXaaRvbVsNYiGfkcPr/sbc
X-Received: by 2002:a17:90b:1348:b0:39b:5622:d645 with SMTP id 98e67ed59e1d1-3ad86c8f9eemr895764a91.0.1792582711694;
        Wed, 21 Oct 2026 04:38:31 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad813eb9casm4023732a91.15.2026.10.21.04.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:38:30 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Wed, 21 Oct 2026 17:07:50 +0530
Subject: [PATCH v4 2/6] rust: crc_ccitt: add CRC-CCITT abstraction
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-gb-uart-transport-v4-2-c308ce821d45@beagleboard.org>
References: <20261021-gb-uart-transport-v4-0-c308ce821d45@beagleboard.org>
In-Reply-To: <20261021-gb-uart-transport-v4-0-c308ce821d45@beagleboard.org>
To: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Markus Probst <markus.probst@posteo.de>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3228; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=0tQbZbHo8xI21dpA2bFknxB1c/WDEfciyAdGxnoZAag=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq2KQTQnIftl+noEjMJ8/XEZ9Vw9FJN+PHvbr0D
 EGbn4VaEriJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCatikEwAKCRAFzvXHieVa
 dE0TD/9d1fp4dvMbYCOl3n2qgYzevhGpBPpkCPYapWpVAxTE5M8PjQkmlR29Aeth1obsL27ttVh
 WQvbmzZv8KCIzdbhG1R0fV0h9ZAy0c1MK/h2yhmtq2mh2Llx0kyvx9LFd8slNm6ShiL5KjYNnxb
 sqf33Ehp+eFPkR5rfD3ylQp2tnFLd91RYYO2+0logX9I0jaFJ/bcwvonOM4spZcM3zQtUegH0R9
 2JzfYvcpcn4c3zGxl3Bb0RBd8CF+aOPb6s6MqDC9ODOr9XKyO62bZmPbbOFad6mZ5mS6CqCzUYX
 wW2ukfojE7BLnHx7vMPb2W3cFi41gK8hjPsykvfGldN4PpRDUWWSidrMFFwVt7QzOWsbgoIK2gF
 1azyIH2bBi/rUcyctDvN5m0Lx7gNZyTtoAwMAZpy/tPvldsT3f5pineT1NysKg1td1OPvcwwxkj
 sTJjwS8C0ftNelnP4AeXAbew/jG/wIqx+FbskVRC7Ws+I7FQ9lSosFsrP10f9up3mZ8RjxsM4NG
 Lu5JRAJTa/z7raBgKYVXkQAXYUp7Mf/xHii/l0q5R6CFAIT+w8c/rWE29rpk7QafNRHhFMY8/0m
 DbshmxQO9B+Lv6YJcDf2VQzHLQ3hUYqhM/KrYCIWi3eCkZWH2aNQ+NIQDJJMIYeHALmtRMq8T7Q
 xkYmrZPrVWfDZYw==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

The module is gated behind the new RUST_CRC_CCITT_ABSTRACTIONS Kconfig
symbol, which selects CRC_CCITT, so the C library is only built when a
Rust user actually needs it.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 MAINTAINERS                     |  1 +
 lib/crc/Kconfig                 |  7 +++++++
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/crc_ccitt.rs        | 26 ++++++++++++++++++++++++++
 rust/kernel/lib.rs              |  2 ++
 5 files changed, 37 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 252b6d7ee163..772023e0e5a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7036,6 +7036,7 @@ T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-ne
 F:	Documentation/staging/crc*
 F:	include/linux/crc*
 F:	lib/crc/
+F:	rust/kernel/crc*
 F:	scripts/gen-crc-consts.py
 
 CREATIVE SB0540
diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 927fc6a6b2b9..628da2d30fc8 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -32,6 +32,13 @@ config CRC_CCITT
 	  The CRC-CCITT library functions.  Select this if your module uses any
 	  of the functions from <linux/crc-ccitt.h>.
 
+config RUST_CRC_CCITT_ABSTRACTIONS
+	bool
+	depends on RUST
+	select CRC_CCITT
+	help
+	  This enables the Rust abstraction for the CRC-CCITT API.
+
 config CRC_ITU_T
 	tristate
 	help
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 3791af0aadc7..55d1a2d7655a 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -49,6 +49,7 @@
 #include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
+#include <linux/crc-ccitt.h>
 #include <linux/cred.h>
 #include <linux/debugfs.h>
 #include <linux/device/faux.h>
diff --git a/rust/kernel/crc_ccitt.rs b/rust/kernel/crc_ccitt.rs
new file mode 100644
index 000000000000..6042ada16967
--- /dev/null
+++ b/rust/kernel/crc_ccitt.rs
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! CRC-CCITT computation.
+//!
+//! C header: [`include/linux/crc-ccitt.h`](srctree/include/linux/crc-ccitt.h)
+
+/// Computes the CRC-CCITT of `data`, starting from the seed value `crc`.
+///
+/// Pass the result back in as `crc` to compute the checksum of a buffer
+/// incrementally.
+///
+/// # Examples
+///
+/// ```
+/// use kernel::crc_ccitt::crc_ccitt;
+///
+/// let one_shot = crc_ccitt(0xffff, b"hello world");
+/// let split = crc_ccitt(crc_ccitt(0xffff, b"hello "), b"world");
+/// assert_eq!(one_shot, split);
+/// ```
+#[inline]
+pub fn crc_ccitt(crc: u16, data: &[u8]) -> u16 {
+    // SAFETY: `data.as_ptr()` is valid for reads of `data.len()` bytes for the
+    // duration of the call, since it is derived from a live shared slice.
+    unsafe { bindings::crc_ccitt(crc, data.as_ptr(), data.len()) }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index f9ef36217bb5..637442761d34 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -61,6 +61,8 @@
 #[cfg(CONFIG_CPU_FREQ)]
 pub mod cpufreq;
 pub mod cpumask;
+#[cfg(CONFIG_RUST_CRC_CCITT_ABSTRACTIONS)]
+pub mod crc_ccitt;
 pub mod cred;
 pub mod debugfs;
 pub mod device;

-- 
2.56.0

