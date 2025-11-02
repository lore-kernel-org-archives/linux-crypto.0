Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65864200BA1;
	Sun,  2 Nov 2025 01:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762048096; cv=none; b=eDA849XSc1lXqpjVHGcuQQPWBT0gRUCGQiCcel8vnZEx24jc9oBuhprd3ll8V+9G3fFGYh2nwQWviBj9pfEr2YVToHnW1AJ8gMq+oE8HgMfUQuK1XzUVsEECyu1rAu/mIkN0GyofXCcwuzQvXOtaMtqmtFu5Ag8U6Eme8pmTJ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762048096; c=relaxed/simple;
	bh=Ybw8qSmobsr6AnuhrJxqY7qIbI8MGWuX/zhkoes8ZcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LFfvDJwSCcQ2vQ1AdZP+LBNloXkMbktRkgNOn+7gZu45uZGCj7hppEchPHkFyIzCChln3R5nFM6BaJ71EEJxKi5lGy2rAK5IUYs/VoOttCv4g0nhB6AYZZO2NT9ze/3whYuCBAe+NPEz5LjaRKcRFi2upLcyVF03lXe3YG6e6+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvZZU8v5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvZZU8v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A925C4CEF1;
	Sun,  2 Nov 2025 01:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762048096;
	bh=Ybw8qSmobsr6AnuhrJxqY7qIbI8MGWuX/zhkoes8ZcU=;
	h=From:To:Cc:Subject:Date:From;
	b=FvZZU8v5fOmcOd70b4MBz3xJUZvKh36blo52ruoDCA1+YMFtr86GHBfeqLwK+A3Xv
	 5/dJjZj+KAl+ywyGx0v4VDqf7uoHD5R+O1HD9FhMTMWIQBmw2o3GkiHTT81gS6nyJV
	 7R2JIt40lWf48dbEp3b7xz/qS/Dah+79Oqahx9McwG3SpxYWaO9yHmfVhvBpAPO70N
	 9DlxQm5D1O3hmBrvyhBSm2D+XIVu6vCUh8ueKnqFj9uwYXT+SXSyCxuAI6IQggAfTV
	 retA5MItkY2WsQ5bIag4i5mDQ/sTxkD3zCLfDfA1OK1VFhVz4OTiLDWFZo0Zw3s2Fy
	 EaeXoQLIgzWUg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: arm, arm64: Drop filenames from file comments
Date: Sat,  1 Nov 2025 18:48:06 -0700
Message-ID: <20251102014809.170713-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove self-references to filenames from assembly files in
lib/crypto/arm/ and lib/crypto/arm64/.  This follows the recommended
practice and eliminates an outdated reference to sha2-ce-core.S.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 lib/crypto/arm/sha1-armv7-neon.S  | 2 +-
 lib/crypto/arm/sha1-ce-core.S     | 2 +-
 lib/crypto/arm/sha256-ce.S        | 2 +-
 lib/crypto/arm64/sha1-ce-core.S   | 2 +-
 lib/crypto/arm64/sha256-ce.S      | 2 +-
 lib/crypto/arm64/sha512-ce-core.S | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/arm/sha1-armv7-neon.S b/lib/crypto/arm/sha1-armv7-neon.S
index 6edba3ab62e8..a0323fa5c58a 100644
--- a/lib/crypto/arm/sha1-armv7-neon.S
+++ b/lib/crypto/arm/sha1-armv7-neon.S
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* sha1-armv7-neon.S - ARM/NEON accelerated SHA-1 transform function
+/* ARM/NEON accelerated SHA-1 transform function
  *
  * Copyright © 2013-2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  */
 
 #include <linux/linkage.h>
diff --git a/lib/crypto/arm/sha1-ce-core.S b/lib/crypto/arm/sha1-ce-core.S
index 2de40dd25e47..7d6b2631ca8d 100644
--- a/lib/crypto/arm/sha1-ce-core.S
+++ b/lib/crypto/arm/sha1-ce-core.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * sha1-ce-core.S - SHA-1 secure hash using ARMv8 Crypto Extensions
+ * SHA-1 secure hash using ARMv8 Crypto Extensions
  *
  * Copyright (C) 2015 Linaro Ltd.
  * Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
  */
 
diff --git a/lib/crypto/arm/sha256-ce.S b/lib/crypto/arm/sha256-ce.S
index 7481ac8e6c0d..144ee805f64a 100644
--- a/lib/crypto/arm/sha256-ce.S
+++ b/lib/crypto/arm/sha256-ce.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * sha256-ce.S - SHA-224/256 secure hash using ARMv8 Crypto Extensions
+ * SHA-224/256 secure hash using ARMv8 Crypto Extensions
  *
  * Copyright (C) 2015 Linaro Ltd.
  * Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
  */
 
diff --git a/lib/crypto/arm64/sha1-ce-core.S b/lib/crypto/arm64/sha1-ce-core.S
index 21efbbafd7d6..8fbd4767f0f0 100644
--- a/lib/crypto/arm64/sha1-ce-core.S
+++ b/lib/crypto/arm64/sha1-ce-core.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * sha1-ce-core.S - SHA-1 secure hash using ARMv8 Crypto Extensions
+ * SHA-1 secure hash using ARMv8 Crypto Extensions
  *
  * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
 #include <linux/linkage.h>
diff --git a/lib/crypto/arm64/sha256-ce.S b/lib/crypto/arm64/sha256-ce.S
index 410174ba5237..e4bfe42a61a9 100644
--- a/lib/crypto/arm64/sha256-ce.S
+++ b/lib/crypto/arm64/sha256-ce.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * sha2-ce-core.S - core SHA-224/SHA-256 transform using v8 Crypto Extensions
+ * Core SHA-224/SHA-256 transform using v8 Crypto Extensions
  *
  * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
 #include <linux/linkage.h>
diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
index 22f1ded89bc8..ffd51acfd1ee 100644
--- a/lib/crypto/arm64/sha512-ce-core.S
+++ b/lib/crypto/arm64/sha512-ce-core.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * sha512-ce-core.S - core SHA-384/SHA-512 transform using v8 Crypto Extensions
+ * Core SHA-384/SHA-512 transform using v8 Crypto Extensions
  *
  * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as

base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
-- 
2.51.2

