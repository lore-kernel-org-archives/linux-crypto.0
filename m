Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893323;
	b=Q05h1JjCI248tlKER8oMa7AAiOVhHSZ9vXCcoQ4jQDEFAXjQupUk56qDExOmvd9xG9kh
	 mxd5PpBDWKnL/CVZsafXaivDDeXjHhowyEMEhDnCZRDINLitQtc7boOjUQFwhn7+yy2RP
	 fyz4ZP3cmildB9zcXoYGJCzlLkV1EsrRXwwoCZg+83TEyBZd3X0lYidS6zS+9E1DzOYTp
	 V364jUUZt4TxhCJviA4c6/gMlVZb11yWbQoyfglGMXiD+kh0Gt9Q2Uz+hk8MCvW3TXF6r
	 MejCz5XyB4fOuHKjezFZTZBnSl7YkquvEgdukoQ26eg6bGsiQKuxPii4mQPGk62wHHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893323;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=GlcmmMw0VEWYBVWExUg4Z4y0uqORQy1/TzCdG9tpyOc=;
	b=JdXocPWy8AvjpOggXhyFn62fHxKZiLCbUKg2n51HWfD6rDYyNMm9aEHkLXRDj6SWFqHu
	 mKvV0cnFO+AMpZYjY66fcNvMPL3+CLoQQjkQe/rrzzmT8CQRVpTmzHREMOYghJKF04OYJ
	 IbrxfSFlMxdagbysfaTfULfSOk8UVKtIhmn2TBuOhrzorpg1kh3/jtvHpeP6NzhlnLXjR
	 7kZJR4/6chzLmOyV0MQynKdSiThwmL9n3fwxy1KciW7m9y6oBEIMDcnr6fs+Q213ozBe9
	 ulg2I+Jmi/mPNkisaBJReTOexWoQVaswrMkslRizoCfKF2vj6ooRxaQFCzHz2YlHZ/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="l/FSqWfJ";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777E0606A31B;
	Thu,  5 Nov 2026 15:42:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 777E0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l/FSqWfJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59D7E168F;
	Thu,  5 Nov 2026 07:41:58 -0800 (PST)
Received: from codex (cesw-amp-gbt-1s-m12830-04.lab.cambridge.arm.com [10.7.13.207])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEB4B3F628;
	Thu,  5 Nov 2026 07:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793893321; bh=fnLioyWONSbXXhHoNkt//42M5iMN0IhDhO3m4HNSIoI=;
	h=From:To:Cc:Subject:Date:From;
	b=l/FSqWfJnWDH8hcCjXXBU6FLEzLTxgT5hIT6ZBElnjTZ/eldv+wcbD0BzTUlt6XAQ
	 NzSYXwwXuTSseZXZlDH1dDp3+vbxfCAtoNyeLcFlmV8XsMMS19W+KDeS1HtkBRtsjH
	 8eu43wwl5+1qQxrrzdczlVWwz1GYpi4o/nCPgeYg=
From: Emanuele Rocca <emanuele.rocca@arm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crc: arm64: use .arch_extension to enable CRC and crypto
Date: Thu,  5 Nov 2026 15:41:45 +0000
Message-ID: <20261105154145.557042-1-emanuele.rocca@arm.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using ".cpu generic+crc+crypto", use ".arch_extension crc" and
".arch_extension crypto" to enable the required instructions.

The ".cpu generic+crc+crypto" directive replaces the assembler's current
feature set with generic+crc+crypto, dropping any other features that were
previously enabled, for example by -march or by a toolchain configured with
--with-arch=armv9-a. In contrast, ".arch_extension" enables the requested
extensions while preserving the current feature set.

This is not a functional change: crc32-core.S only uses base A64
instructions plus CRC32 and PMULL, which remain available, and BTI landing
pads are emitted as HINT instructions. However, using .arch_extension
avoids the pitfall of silently disabling features. See commit 9142c2f8f84b
("octeontx2: use arch_extension to enable LSE").

Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>
---
 lib/crc/arm64/crc32-core.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/crc/arm64/crc32-core.S b/lib/crc/arm64/crc32-core.S
index 49d02cc485b3..0877d07ed1bf 100644
--- a/lib/crc/arm64/crc32-core.S
+++ b/lib/crc/arm64/crc32-core.S
@@ -11,7 +11,8 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.cpu		generic+crc+crypto
+	.arch_extension	crc
+	.arch_extension	crypto
 
 	.macro		bitle, reg
 	.endm
-- 
2.55.0

