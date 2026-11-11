Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794407165;
	b=qnCHh1blppwvwpFPz2E9pZj4Ic6xOQv7osxjf9aM7bn1eKGEV34CcZSdHuP9n/KvZAP2
	 4l9CNDMSozmVIOu0x4m9TKhc6t2BGyqME/OdVw0mUvqQWTUWtGGjYa7EuqDesGfUYGypR
	 F1UKyzOvE8vKVKTXuYHv03GMCOVabAWb1IOamjRwC/j/yZ6mtK3vPIGjksb4wjgHMUPu4
	 23ATelp/MXC3aikMK9iX98OjrxYgBwnIftI25xOexkJUWp0gfjaNoJCqMD+h+MysaMVeB
	 CVKUZFhq7I4w0x5BPRFcInlxZpvsi7LessGKsz4NZk3cqbUckW3f9DFKVn08rVI4wRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407165;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qFhH+DuXlrDIKXE31QIGluXuB3wLng0mdx3IRRiWcXE=;
	b=dnQCE7eA+BAmbTs0b9q+pS96IMJZFD7K+oXqVGF6t9qW9jwx+JuloeyZyta2tcYuMvb6
	 krDL3beQGIZwpeKouXRnsaQ2OQkKG9N8yjlCKBSjqqi+Z8KQe2XxJ+/stWaz2f31n+cC2
	 hNAt0KnL+fz3xjwotTxf8RVtFi8jWoOzGBLe4CWlg5/aXtBC/tIYtU8L3RHSYWpFG7/xu
	 vsEsPsvrV57FKtUy4d57rqnXQEVZxo5xIMBzHPHp8Pxe87xHsNOahl3Ghtv6lMx29+R6r
	 87OE6YmBTE5N5zow0jwLQiYMGpx53FLdjWO/d0HyO/CDkBaPQBB9AbpKblwALXe52EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Fj0fBxLo;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0729C606A324;
	Wed, 11 Nov 2026 14:26:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0729C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Fj0fBxLo
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AB991576;
	Wed, 11 Nov 2026 06:26:01 -0800 (PST)
Received: from NH27D9T0LF.arm.com (unknown [10.57.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 545F73F632;
	Wed, 11 Nov 2026 06:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794407164; bh=bSw9qW9XrWR9mir/DsI2CHm3KFsYSYDYES37Mt9ZnOI=;
	h=From:To:Cc:Subject:Date:From;
	b=Fj0fBxLoFm1tHSsPGEhhkk8i5k53nYoZEm2dIFOQoZepDQ6oUgLct6vuQpILIGAXj
	 xH37zDRFNC+fkGHoRMzls7HX+Ib0uDDS0dI1jwgKe9izrmJSqyXKVANDAAeqL96XqT
	 oaIh+qO3Y667KHQnpXGESPYSKvbQqHdGbuzLq0F4=
From: Emanuele Rocca <emanuele.rocca@arm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] lib/crc: arm64: use .arch_extension to enable CRC and crypto
Date: Wed, 11 Nov 2026 15:25:56 +0100
Message-ID: <20261111142556.67489-1-emanuele.rocca@arm.com>
X-Mailer: git-send-email 2.54.0
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

Use .arch_extension instead of .arch and .cpu in crc32-core.S and
crc-t10dif-core.S.

.arch and .cpu reset the assembler's feature set, dropping extensions
enabled via -march. See commit 9142c2f8f84b ("octeontx2: use
arch_extension to enable LSE"), where this caused an actual build
failure.

That is not a problem here: the instructions these files use are all
covered by the CRC and crypto extensions. Switch anyway for consistency
and to avoid surprises if the files later use instructions outside
generic+crc+crypto.

.arch_extension is supported by binutils since 2.26 and by clang since
8.0.0, both older than the minimum versions currently required to build
the kernel (2.30 and 17.0.1 respectively).

Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>
---
Changes in v2:
  - Update crc-t10dif-core.S in addition to crc32-core.S 
  - Clarify in commit message that this is not a functional change

Link to v1:
  https://lore.kernel.org/all/20261105154145.557042-1-emanuele.rocca@arm.com/
---
 lib/crc/arm64/crc-t10dif-core.S | 2 +-
 lib/crc/arm64/crc32-core.S      | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/crc/arm64/crc-t10dif-core.S b/lib/crc/arm64/crc-t10dif-core.S
index 71388466825b..e77af0aecf5e 100644
--- a/lib/crc/arm64/crc-t10dif-core.S
+++ b/lib/crc/arm64/crc-t10dif-core.S
@@ -69,7 +69,7 @@
 #include <asm/assembler.h>
 
 	.text
-	.arch		armv8-a+crypto
+	.arch_extension	crypto
 
 	init_crc	.req	w0
 	buf		.req	x1
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

