Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CDF4F7CBB
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 12:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892915; cv=none; b=CxOHJ+hzsNokWDgLM47jHCtHhZ2DaEJNfq74NhiIloUnEeL4jWqVS8T486JlyD8/ujWonG54YWDWEoq3ztNBHvQvGJz9N8PNm4v0tfu7cmbgHbT3CYeJ6jfUPgpK6eZzBKwmpGudgpFsUGZSZwjZNNLSbGcPMKXpJOLqW5xG2yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892915; c=relaxed/simple;
	bh=0tQbZbHo8xI21dpA2bFknxB1c/WDEfciyAdGxnoZAag=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aAiUnj3muaHxkU5fxjCYtk7LdvmGj4jEiNT6RQA1OlyWRr3nuzkaT7tDsPcrqQmr1ryZOqxtcg+z97zKm72DdNJ4LiFw/Wj0JD5EavEkI7evq/vb2p7egTsMzhZdsJp3gxw2R7ik0I5aERzvcr0Vkjf5Nv/Qd80k4oq+faaJrV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=sRq/CfmN; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="sRq/CfmN"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so155568a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 05:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1791892911; x=1792497711; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wWz643dbsj/ZlYo+epLXd9Iw2Mt+qid7bAcxch49zgs=;
        b=sRq/CfmNUNf+lV5ShcFhNuChrbU0fX5HDyfQJWU+GYn+1ey5XYzE/qVLCW85+fAKg8
         IrcDv3U6GUeklbIU8+mhsf0HInXYEMupR4CZoTWyozrSYW7yDC8JK5CNw2V60GKxHWxB
         aUEAA0IbVhzDiqwDRgz25ge+o4u+UYlQbVUsjQewx5yYqQby5+/Woo11UZmkqmtKPbno
         WyR0YUSnQKTWK2IzAzjwtiVkx+Vd4KWuq6C1vM6HyTn//l3o3K6ep5o5/gfzejuH/5nf
         k5drJI7kdvzcwRNksaG34yHyGa2DcQ5DGQYvyGZIdGKAiIfrZnb04xEtoFyean+GTe4v
         HDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791892911; x=1792497711;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wWz643dbsj/ZlYo+epLXd9Iw2Mt+qid7bAcxch49zgs=;
        b=cHubqseAOzFNBLNvwvsZtZKmoXKm52co6IPEk8WKNSp/HQzqTNaxX02r5q6JxhpCKf
         fHSy72FWPT5mOcbM8vYd0oLQOLBD1ZH8cO9teeBk19m1aX3xBWLfg/kKS9bzA1h4ukKa
         86iFHGpHDZrzP1Xz9KvR3G3l4fJl7IlYc7++ph1Dax6YsmFoCXCfTEd0wrdzPQYlVfZc
         iyt9SlJOyYmOGCgUGOVMpd7V4V+ezA23IIv31kM2FFp8XDndoISMV5j9M7CJHCIJZ94K
         BjScKHr38NSZuDBcBJLoB069i8TjeXYpYAEM1w6OwtyeIANT/y+PkmReP8b3KGRSJBH9
         d1/g==
X-Forwarded-Encrypted: i=1; AKwUvBxLZTWqTb6aqVhw8Tb3DEryKav6rOH2GFbPCyufkQI8P1dAD1knaZ0a/ApkMLNtp07U6DTMa+iGGL0v3/s=@vger.kernel.org
X-Gm-Message-State: AFq9FYIRKtvs0jh+kJOrHzwzQfoH9JHCEKD7G2TSeW1OcTv8rPdp7yUm
	YKqNdifs5IE25d7NK9SwfQzsa6+gLIJX+yz6Udrm/Z4AzEARXH2MNQRINrdbsNS4rA==
X-Gm-Gg: AYBFou1QGkiGELMX8QwXWAqgbU+BO+A2O/fER95y2k33J9vFs0mKFos4IOXzpGlaGjT
	q+eqdelQb+EnK44yyT5O5vQZH8w+Nc5lJZGSDP+gzUHDAN2cKpLwet12SqZ0HOfnY/m6FANxt0+
	HQmapfSe1PvjDRhTfmtYW1oSxOu55kBW0sQ0MilQfzd+ni4gVpFBPSTFil4ViemCK00Hhof6ZNh
	DhwOKkxQItKFvxTtAhwMMqe96YeThkdr17dMah41nTpNmwUOgdeV6qJbTEBJACDn3br//0Z5WNk
	lqu+QjKUU2hwC7r0kUfCRk1BNgbWsyS54qjh8Ke/6mv9HMVkmaEhKEaf+8sO5+7QmSs4VHDQ8Ne
	6tJX8RK8RN8PAbH1SHp9wolP3w2JWnY89kwH19vBZy8OpWEQI9LrAqhiHlKt5dKdkZn82q2Gmmg
	JHdeyswF+/+DSgpfp411fLCovcaCD3MhquwGYikK/vlUPI1Xb9p1YQQ0TV97nvy19JRWFAOZ25s
	Vwy0x56Gw==
X-Received: by 2002:a17:90a:ec87:b0:3ac:5ca:c7a8 with SMTP id 98e67ed59e1d1-3ac05cac819mr3599231a91.60.1791892911131;
        Tue, 13 Oct 2026 05:01:51 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab8a393666sm16566838a91.15.2026.10.13.05.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:01:50 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 13 Oct 2026 17:30:41 +0530
Subject: [PATCH v3 3/7] rust: crc_ccitt: add CRC-CCITT abstraction
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-gb-uart-transport-v3-3-81d0a8a1acf7@beagleboard.org>
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
In-Reply-To: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
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
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqzh2DrfofpM81AoSaxkGGZjnn4Q2V0WxE8qIBk
 APPhf5gzD2JAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCas4dgwAKCRAFzvXHieVa
 dOA4D/0VHJ8iOhDb6ZudbAvG8SSKJoPnZsKjupZNYhU1O9zbcgvP9F7pUDdfyhIy7tA8scVqYy1
 63jSjAelitNXknjEaK1FnUg5BbRQXNtkpSKN4jY15josP77lepe7nF25CBLhsh3ru4mic1G6ZRc
 Mm0CpZ14mshgbIW0qnK7nwL8PE1h3Vu7dnBgn+6W78l1rsJJjpkk9oiTqklsoYckrngoZ4qO6K4
 BvFgIfOFw7wOb6hP8RjRWkdwBQ8y3sAbhbdwbcyojKJQUwqDBwhaUHJQuMqkoqlS8G1aLODh6YZ
 GLHoNWXvqMJfOZ4tACaNCWVl714mUHmnegxGOYU2HGQBJV6ciDXjB7SXEEAaz/BI2ALmXnJ/52Y
 BOmYFFwojEyO9ZpsNKi1OpZFx2jkRc46o+5wj34VrEQAkpDZZ/Se9jfB9WCTnk7jBzE8tekBbJH
 T0yB9nVZRkP6ZpjGdiBs4APRR7y1aKu3VVh1VNkzsyLZPGhYFFN1ZYSZxNjbrkjkmn7NfnFaXE6
 Bcv8HC+L8RS9LH3fGtZgUdD6NcPbw/PV0x6nvbmcPBYyaOABRznnjo2qd3z4yBgtkzrvQ5aoRlG
 mLxWX6qtx1tPUyKa2kPVX0kumqUyWm6leOnNJxtu0RVYkITHBB0MoHuP/Pr7uty2FU299Ere5F8
 CHtRGnXt0wpHCtw==
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

