Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70848225A32;
	Mon, 17 Feb 2025 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739818306; cv=none; b=EExDBrvYbf49tuyo7UBfATZ2vepS+Vj3O3YpZaonnWZKgcrCB16gxZ0vNJfiYHA+Enp+DoZQ58l4DUpRbtsaDWKHKYQJ3dfivLSQiuljpgEfKpehNCV83MuI0kKun3TtZ1IeQXgrBFZqjIQ+LdBUwX0gh5kCxq/7TMATkeMeVmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739818306; c=relaxed/simple;
	bh=4UetnDp/IjG2cLYw6HtQVxgGl/nS4VUSWoWAf/niGso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jciXjrKNOBlGt7YKSW10M3LyFVmANLKQaCvlj62yMzSZx9xDyxqh2F5nAeonyrHC2d7lcCVYJ4dXxE4rzqdGtKHpFXrPPA9MrQAaoSgSasoecOrKLVnaVmtLsKE/RDYj/ilLTgqXKVvmJ3HRqUubp9Ax7cLV3nLNUZPnJEwsKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjHfMYiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjHfMYiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD80C4CED1;
	Mon, 17 Feb 2025 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739818306;
	bh=4UetnDp/IjG2cLYw6HtQVxgGl/nS4VUSWoWAf/niGso=;
	h=From:To:Cc:Subject:Date:From;
	b=RjHfMYiW5A/fk8zL3VSABNTxhXk3MFxWepC30kCBJjEbu0HNUhcdGmxZv73/+QUrS
	 YZR7bQe3XrzHyPg6Hj3EIY1JwaGhJAX8wPbPhmzaQZRtljfqt3ckW6uVTouoQP77y2
	 7huLAb76SR/OmbR0g6YOvxhjIi0Pd1oSCPTMWtDFZDcflHjd2KvLzPXv8uDwzgWkqm
	 ghjzfGRuFhm/E+PwgVXUu2CTMsTamMl0FnK4ghCGrnhzi/qBwbi/0+lsliE3csjZ0d
	 RuBF4wMoB04g4PuWG8uIfh8EuWXG5ZcFukkUvdBGjYvEnLCbU/J8+LBZfuRK4VOaFe
	 KqAjWjHlg5OYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: fsverity@lists.linux.dev
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] Revert "fsverity: relax build time dependency on CRYPTO_SHA256"
Date: Mon, 17 Feb 2025 10:51:05 -0800
Message-ID: <20250217185105.26751-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This reverts commit e3a606f2c544b231f6079c8c5fea451e772e1139 because it
allows people to create broken configurations that enable FS_VERITY but
not SHA-256 support.

The commit did allow people to disable the generic SHA-256
implementation when it's not needed.  But that at best allowed saving a
bit of code.  In the real world people are unlikely to intentionally and
correctly make such a tweak anyway, as they tend to just be confused by
what all the different crypto kconfig options mean.

Of course we really need the crypto API to enable the correct
implementations automatically, but that's for a later fix.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/Kconfig | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index e1036e5353521..40569d3527a71 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,17 +2,13 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
 	select CRYPTO
 	select CRYPTO_HASH_INFO
-	# SHA-256 is implied as it's intended to be the default hash algorithm.
+	# SHA-256 is selected as it's intended to be the default hash algorithm.
 	# To avoid bloat, other wanted algorithms must be selected explicitly.
-	# Note that CRYPTO_SHA256 denotes the generic C implementation, but
-	# some architectures provided optimized implementations of the same
-	# algorithm that may be used instead. In this case, CRYPTO_SHA256 may
-	# be omitted even if SHA-256 is being used.
-	imply CRYPTO_SHA256
+	select CRYPTO_SHA256
 	help
 	  This option enables fs-verity.  fs-verity is the dm-verity
 	  mechanism implemented at the file level.  On supported
 	  filesystems (currently ext4, f2fs, and btrfs), userspace can
 	  use an ioctl to enable verity for a file, which causes the

base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.48.1

