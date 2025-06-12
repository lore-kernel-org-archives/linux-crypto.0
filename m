Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047A2198851;
	Thu, 12 Jun 2025 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749753597; cv=none; b=TPyhcTB5kQI+aPKY2ekZQmwLnojjRgcvhL364ngxT8DNv+QxZDzGLZhzM9OnLHOFRoVHDWY3LbX2et1cmAoITuF5Rv4HGtspn94cNSDVKb32aBdZleFJ45h3ddHlNQfxA3TQGn+GCmVSdKyW4DqxO3fmpqAiTC5S35kCY6y9ArE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749753597; c=relaxed/simple;
	bh=AUdHu5W7PllgwG7FXZE4UVUoSuuY/27nAsnL/kArZ+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZtcZdZ9AgsEGH9KBQ2r00WiNYcPm6mRipJQ/mSzyX76iC6fjV2PmkwAJQmN6ZC1snP0Mi0Ikj7zKMLljo2jjdHKcVuVDHiBtP1pir9j5aq6FqG91Zd+vANGGfZRKay3cvOg+S5OfasU/kLrbZMdLKq4jJeoqJu9yrLN0+CXmd+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNAG+B2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNAG+B2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC33C4CEEA;
	Thu, 12 Jun 2025 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749753596;
	bh=AUdHu5W7PllgwG7FXZE4UVUoSuuY/27nAsnL/kArZ+Q=;
	h=From:To:Cc:Subject:Date:From;
	b=VNAG+B2H9oNbOAlcvLcIFI/SQR5gFPtk2VaxvTDKAgVWc+0L4kyqhTeRDzXVivgvu
	 c6IhR1lH+hPFFDouAU5p45IVF5zcNKCTeXHXXs0p1yb0WIrLLb+ZcY+BKk6AdT7bjA
	 P3BmDflhB4WMhroPrr7j7wAePE13EO9/9KX7RMonXroNwBdfsJVNl8C8orU/mr7G6m
	 h8v+z0oyYw8Bg1Vjp90Q/C7nTecCWfAHsHCBhsNbFBT9UtpL4Vsx7eAwML4ZB5RdnB
	 2fLUgU0uJhGHsx9akUognutcFpjm+95yjm7vCjC0Tn8FVbY5edjfv5EDHhPgF2d1mC
	 uZu7d/jfLgKKQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc: explicitly include <linux/export.h>
Date: Thu, 12 Jun 2025 11:38:52 -0700
Message-ID: <20250612183852.114878-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix build warnings with W=1 that started appearing after
commit a934a57a42f6 ("scripts/misc-check: check missing #include
<linux/export.h> when W=1").  While at it, sort the include lists
alphabetically.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this via the crc-next tree.

 lib/crc/crc-ccitt.c       | 5 +++--
 lib/crc/crc-itu-t.c       | 5 +++--
 lib/crc/crc-t10dif-main.c | 5 +++--
 lib/crc/crc16.c           | 5 +++--
 lib/crc/crc32-main.c      | 1 +
 lib/crc/crc4.c            | 1 +
 lib/crc/crc64-main.c      | 4 +++-
 lib/crc/crc7.c            | 5 +++--
 lib/crc/crc8.c            | 3 ++-
 9 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/lib/crc/crc-ccitt.c b/lib/crc/crc-ccitt.c
index 8d2bc419230b3..f8692c3de101a 100644
--- a/lib/crc/crc-ccitt.c
+++ b/lib/crc/crc-ccitt.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
-#include <linux/types.h>
-#include <linux/module.h>
 #include <linux/crc-ccitt.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/types.h>
 
 /*
  * This mysterious table is just the CRC of each possible byte. It can be
  * computed using the standard bit-at-a-time methods. The polynomial can
  * be seen in entry 128, 0x8408. This corresponds to x^0 + x^5 + x^12.
diff --git a/lib/crc/crc-itu-t.c b/lib/crc/crc-itu-t.c
index 1d26a1647da53..6e413a290f54f 100644
--- a/lib/crc/crc-itu-t.c
+++ b/lib/crc/crc-itu-t.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  *      crc-itu-t.c
  */
 
-#include <linux/types.h>
-#include <linux/module.h>
 #include <linux/crc-itu-t.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/types.h>
 
 /* CRC table for the CRC ITU-T V.41 0x1021 (x^16 + x^12 + x^5 + 1) */
 const u16 crc_itu_t_table[256] = {
 	0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
 	0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
diff --git a/lib/crc/crc-t10dif-main.c b/lib/crc/crc-t10dif-main.c
index 08f1f1042a712..0c595cb0d4c1c 100644
--- a/lib/crc/crc-t10dif-main.c
+++ b/lib/crc/crc-t10dif-main.c
@@ -4,13 +4,14 @@
  *
  * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
  * Written by Martin K. Petersen <martin.petersen@oracle.com>
  */
 
-#include <linux/types.h>
-#include <linux/module.h>
 #include <linux/crc-t10dif.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/types.h>
 
 /*
  * Table generated using the following polynomial:
  * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
  * gt: 0x8bb7
diff --git a/lib/crc/crc16.c b/lib/crc/crc16.c
index 9c71eda9bf4b9..931660a8cbaaa 100644
--- a/lib/crc/crc16.c
+++ b/lib/crc/crc16.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  *      crc16.c
  */
 
-#include <linux/types.h>
-#include <linux/module.h>
 #include <linux/crc16.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/types.h>
 
 /** CRC table for the CRC-16. The poly is 0x8005 (x^16 + x^15 + x^2 + 1) */
 static const u16 crc16_table[256] = {
 	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
 	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
diff --git a/lib/crc/crc32-main.c b/lib/crc/crc32-main.c
index b86ee66075d0e..70c4ef170526d 100644
--- a/lib/crc/crc32-main.c
+++ b/lib/crc/crc32-main.c
@@ -23,10 +23,11 @@
  */
 
 /* see: Documentation/staging/crc32.rst for a description of algorithms */
 
 #include <linux/crc32.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
 #include "crc32table.h"
 
diff --git a/lib/crc/crc4.c b/lib/crc/crc4.c
index e7e1779c67d91..8e83fbe60bdc9 100644
--- a/lib/crc/crc4.c
+++ b/lib/crc/crc4.c
@@ -2,10 +2,11 @@
 /*
  * crc4.c - simple crc-4 calculations.
  */
 
 #include <linux/crc4.h>
+#include <linux/export.h>
 #include <linux/module.h>
 
 static const uint8_t crc4_tab[] = {
 	0x0, 0x7, 0xe, 0x9, 0xb, 0xc, 0x5, 0x2,
 	0x1, 0x6, 0xf, 0x8, 0xa, 0xd, 0x4, 0x3,
diff --git a/lib/crc/crc64-main.c b/lib/crc/crc64-main.c
index e4a6d879e84c3..aef8282b63fba 100644
--- a/lib/crc/crc64-main.c
+++ b/lib/crc/crc64-main.c
@@ -31,13 +31,15 @@
  *
  * Copyright 2018 SUSE Linux.
  *   Author: Coly Li <colyli@suse.de>
  */
 
+#include <linux/crc64.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/crc64.h>
+
 #include "crc64table.h"
 
 static inline __maybe_unused u64
 crc64_be_generic(u64 crc, const u8 *p, size_t len)
 {
diff --git a/lib/crc/crc7.c b/lib/crc/crc7.c
index 8dd991cc61146..46b95d7ac6ce0 100644
--- a/lib/crc/crc7.c
+++ b/lib/crc/crc7.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  *      crc7.c
  */
 
-#include <linux/types.h>
-#include <linux/module.h>
 #include <linux/crc7.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/types.h>
 
 /*
  * Table for CRC-7 (polynomial x^7 + x^3 + 1).
  * This is a big-endian CRC (msbit is highest power of x),
  * aligned so the msbit of the byte is the x^6 coefficient
diff --git a/lib/crc/crc8.c b/lib/crc/crc8.c
index 1ad8e501d9b69..329c52158c455 100644
--- a/lib/crc/crc8.c
+++ b/lib/crc/crc8.c
@@ -14,12 +14,13 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
-#include <linux/module.h>
 #include <linux/crc8.h>
+#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/printk.h>
 
 /**
  * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
  *

base-commit: 7234baeec076d4c2ac05d160ed8cdb2f2d033069
-- 
2.49.0

