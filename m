Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7DEBA21;
	Sat, 14 Mar 2026 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773509516; cv=none; b=AlaVxQSUkquRSpgK9J3TZNoV6JgpG+DmUEejY5Af/F5YahnkLyOQIH8DQQKvlokQZTgiLNIVaEPIZQG4Yn05EIubElQstSHFdlBN8PwhNWi+S6iksN6FUVrQH/QNs98XfoUc3EYguK8aIjo460wyTF093gZvE4jdShc29INVCJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773509516; c=relaxed/simple;
	bh=IAXLSHLD6HNyjuhhwieO2BteA4MYMrah3sfxcnvOzkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iwP6DeAcxMnV2rscQxPcl/4n8c/YuCLPFnarZfjUK0EbWktrFFCb0AIqqA8xqVh5w1xNcvwzeF0zxKdwcW4Xtmh5UyJXCaj2l0q6K5U4IJMYw0GIps4YP8k2iRMjlSWjPsfbqVGw0rcGPZ5RguE7Jrdc5zef+6EJ+X1Lq9VRPXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4PwKIXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4PwKIXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8A0C116C6;
	Sat, 14 Mar 2026 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773509515;
	bh=IAXLSHLD6HNyjuhhwieO2BteA4MYMrah3sfxcnvOzkE=;
	h=From:To:Cc:Subject:Date:From;
	b=R4PwKIXh4wvTWlYTnIfuPq+qwZLyoZfebuO9LruzDhQLQlFVmtdEhPmFmCAn7hWfy
	 mU3mHJxhsAsFaLNy6j4gUM/Leqy+mocb3vmFdrNpWXwQhdw5k3LgNYK2uPxg/uAvhw
	 s1S7ovj7PmxggyOlLn2AXRXpcZaDs2vtEmlrVSkfqG/ThDAMGNGsaC7Ol+icxQ7d6u
	 wPmfPivrHdSSBln6J6KE2kElz+jCG8cCqUAYy1UhWOY6u4s0ThI5hsjGtJVHOQB1+G
	 r8PZlfPfg0jhySdGR3FQ/Vq/NAldlFZP9+f+ZMgTsLx8Ywd37Hyu6VPD3YAQYxbWX8
	 LfPbv+jwEHMAg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: crc32c - Remove more outdated usage information
Date: Sat, 14 Mar 2026 10:31:30 -0700
Message-ID: <20260314173130.16683-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove information from the crypto/crc32c.c file comment that is no
longer applicable now that nearly all users of CRC-32C are simply using
the crc32c() library function instead.  This continues the cleanup from
commit 0ef6eb10f2e0 ("crypto: Clean up help text for CRYPTO_CRC32C").

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crc-next.

 crypto/crc32c.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 1eff54dde2f74..c6c9c727b25b4 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Cryptographic API.
- *
- * CRC32C chksum
+ * crypto_shash support for CRC-32C
  *
  *@Article{castagnoli-crc,
  * author =       { Guy Castagnoli and Stefan Braeuer and Martin Herrman},
  * title =        {{Optimization of Cyclic Redundancy-Check Codes with 24
  *                 and 32 Parity Bits}},
@@ -13,20 +11,10 @@
  * volume =       {41},
  * number =       {6},
  * pages =        {},
  * month =        {June},
  *}
- * Used by the iSCSI driver, possibly others, and derived from
- * the iscsi-crc.c module of the linux-iscsi driver at
- * http://linux-iscsi.sourceforge.net.
- *
- * Following the example of lib/crc32, this function is intended to be
- * flexible and useful for all users.  Modules that currently have their
- * own crc32c, but hopefully may be able to use this one are:
- *  net/sctp (please add all your doco to here if you change to
- *            use this one!)
- *  <endoflist>
  *
  * Copyright (c) 2004 Cisco Systems, Inc.
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
  */
 

base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
-- 
2.53.0

