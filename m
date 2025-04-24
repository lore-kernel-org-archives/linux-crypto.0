Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9EA13D531;
	Thu, 24 Apr 2025 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454180; cv=none; b=UrevDruZn0UQgeeCPVUyPtFS0GFL4qhSPhR+FB5t013e6e1AAnL+HPDhsvLcwr1mr4wOS8pkMMuWBby9n6fCj2RCzsqgiuFI9bvqi7ieu74CN6UplPXl5FHIBf3NbjmwMvwoz5NsNrrieTK7mZQngZcNJW+pickNIQbVgQEc4Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454180; c=relaxed/simple;
	bh=bmNtnPkT7vfqz7VYymkCYs+RWq0I1HO9RIQ1+wDAdb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McUdC5v3CyznkYCI/46zize9EvSdAH8mLyxVrKVcCBBW74cPBq7VabNaPzuNhAWPJTVVEUZyROu4if5VriotFLRA44p/i7tkLXvT0pZhq7qm6cQ/GSKxJPrJ3mzmb/Zavefe0IIDdKT3Am+w7Wx9biR6eJ38YbY5/bTV9xL/VNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjLHst4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjLHst4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2374C4CEEF;
	Thu, 24 Apr 2025 00:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454179;
	bh=bmNtnPkT7vfqz7VYymkCYs+RWq0I1HO9RIQ1+wDAdb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjLHst4bVDcbmK2s/0yw9jwnVejn2n2RNgkYtDcj19TnSrcTNR941Nezg68ow3IGG
	 OWWvyd7GLInEMusl4tIdEBgGWvnXyC7jS/KhbQLMmxwkmC4mNAzxsnou9OH8/Rhaeo
	 yorikXu6NekPONq5K0lpepo2u9ToPhVacC0I61FsEwFspybjF+wEG4KGGqEzjivZNE
	 NDEnU7QcaQu3to8MPi6vph/yjuH35LTnDR8OtP+RRMx0Gas4KpaHV+j2zXwJ1Mcf5Z
	 jkP4vvkXCfBanEugjydAu4QeBrQbhkac5HveHAp4hgDpO3wbrngz0kXqgz19nTpu3V
	 axl/ON8oAh5Uw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 5/7] s390/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:36 -0700
Message-ID: <20250424002038.179114-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424002038.179114-1-ebiggers@kernel.org>
References: <20250424002038.179114-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The use of the term "glue" in filenames is a Crypto API-ism that does
not show up elsewhere in lib/.  I think adopting it there was a mistake.
The library just uses standard functions, so the amount of code that
could be considered "glue" is quite small.  And while often the C
functions just wrap the assembly functions, there are also cases like
crc32c_arch() in arch/x86/lib/crc32-glue.c that blur the line by
in-lining the actual implementation into the C function.  That's not
"glue code", but rather the actual code.

Therefore, let's drop "glue" from the filenames and instead use e.g.
crc32.c instead of crc32-glue.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/lib/Makefile                  | 2 +-
 arch/s390/lib/{crc32-glue.c => crc32.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/s390/lib/{crc32-glue.c => crc32.c} (100%)

diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 14bbfe50033c7..271a1c407121c 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -24,6 +24,6 @@ obj-$(CONFIG_S390_MODULES_SANITY_TEST_HELPERS) += test_modules_helpers.o
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_EXPOLINE_EXTERN) += expoline.o
 
 obj-$(CONFIG_CRC32_ARCH) += crc32-s390.o
-crc32-s390-y := crc32-glue.o crc32le-vx.o crc32be-vx.o
+crc32-s390-y := crc32.o crc32le-vx.o crc32be-vx.o
diff --git a/arch/s390/lib/crc32-glue.c b/arch/s390/lib/crc32.c
similarity index 100%
rename from arch/s390/lib/crc32-glue.c
rename to arch/s390/lib/crc32.c
-- 
2.49.0

