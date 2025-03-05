Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D45413D279;
	Wed,  5 Mar 2025 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741139976; cv=none; b=fLzFs80lbF1+6LW0rCDauyMt67zN6h/zEPfhnQFuxhoJ8UX7IroM9jHV7Dwsb0+g5E1hXbV40ZSwKz6lr4u6nm9D7hHfmOPL59U06lXoBte560onSWgjluQ458reuvyngGU92D1Ne2rpUO/dYJ/NjLW1N3tNomC0lzBxNiQLIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741139976; c=relaxed/simple;
	bh=b+4wjE2F7I/nJo45/YZe39pt2WvC8qcPajk0/I8YCAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nNNhOX+6+Do8k0X7J27boB7c5L/GXOMf5+1W34Zef0ERMIy/mAtbH5e9E6NnDkaNkbWaVPNZmIiFl5lbh3Ww8H+ytPWHRl7tRtchcIBJlwLCynH6/MiLjp8iOwFqrWRKamXEw/Jf1fyPmaP6RMt8QnOotAz+i5RPs4k9sXW6C2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVRHOzWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVRHOzWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8061EC4CEED;
	Wed,  5 Mar 2025 01:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741139975;
	bh=b+4wjE2F7I/nJo45/YZe39pt2WvC8qcPajk0/I8YCAM=;
	h=From:To:Cc:Subject:Date:From;
	b=kVRHOzWAJsCziv3SRI4CfDZYobzj2255VYslS/llqsxeMnCZEVvnQp25zhPBNdx7F
	 Jgj9pjPVAyHiMwvTEpAzOb1aY8x4aygBYq54Q7Pn6I/heY08O4i59/RsFFtJ9FUxZg
	 3dOXXExdIQS8QwWiYvIsQ8EdVzoGfNUDDcrLkJsgHlCU4QgC8zGb8R5xMNccdb0Y26
	 zgp5sRfZ9ZWBqez0ErdPB6u+gs/eEO/1jZxRltx4NZkmItKxTx2PNc21VJTP+VOSPa
	 U6aux1s9F9TYIEazKfLsaA2euObrIzGkiKII/AbxC6WffNl2k8wuhjxnzE4dr1FwMM
	 ohWuOQ4gc12Tg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc_kunit.c: update comment in crc_benchmark()
Date: Tue,  4 Mar 2025 17:58:30 -0800
Message-ID: <20250305015830.37813-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

None of the CRC library functions use __pure anymore, so the comment in
crc_benchmark() is outdated.  But the comment was not really correct
anyway, since the CRC computation could (in principle) be optimized out
regardless of __pure.  Update the comment to have a proper explanation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/crc_kunit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/crc_kunit.c b/lib/crc_kunit.c
index 40b4b41f2184..d5a5045fd9ab 100644
--- a/lib/crc_kunit.c
+++ b/lib/crc_kunit.c
@@ -222,12 +222,13 @@ crc_benchmark(struct kunit *test,
 	static const size_t lens_to_test[] = {
 		1, 16, 64, 127, 128, 200, 256, 511, 512, 1024, 3173, 4096, 16384,
 	};
 	size_t len, i, j, num_iters;
 	/*
-	 * Some of the CRC library functions are marked as __pure, so use
-	 * volatile to ensure that all calls are really made as intended.
+	 * The CRC value that this function computes in a series of calls to
+	 * crc_func is never actually used, so use volatile to ensure that the
+	 * computations are done as intended and don't all get optimized out.
 	 */
 	volatile u64 crc = 0;
 	u64 t;
 
 	if (!IS_ENABLED(CONFIG_CRC_BENCHMARK))

base-commit: 13f3d13d88b5dcba104a204fcbee61c75f8407d0
-- 
2.48.1

