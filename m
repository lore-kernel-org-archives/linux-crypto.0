Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDCF36D503;
	Fri, 21 Nov 2025 03:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763696201; cv=none; b=bdxCdmw4HF+T/UcsoD4b2cyuBhxEiqumqs3E8t7WhnrtZIWWKPgyrLIEgYO68o19VPfmHNNW4fAd5LDdt70iu/Cnr4HHpLvTDSmqWZ6eHPmIxD9aTCXXOZ7JOYWNs9Wzko5tUHENxZ05gsUKKZS5PkSzDvhnT+Ratw6GjVVb0M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763696201; c=relaxed/simple;
	bh=RTGzRlhkDVgF1eYukksVbU2Pj67kpS07q4SHZcG8JME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JKYawQMddXnehBP2bPPapqAchZqWdbF2abXZFrWt05GovIO3JivpXSbS/QcoyG9m0palAnKUD6Wqlc8/UiH04HIDSZz4wfOm8+2hZ6oB2dHmN872Hs1WnAnmh7SJ9Ws/T0xw3sSV2QXvr/NgZVBo7tj0i5dQ2cv39j9osBKCBsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ld5bAgcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ld5bAgcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1FEC4CEF1;
	Fri, 21 Nov 2025 03:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763696200;
	bh=RTGzRlhkDVgF1eYukksVbU2Pj67kpS07q4SHZcG8JME=;
	h=From:To:Cc:Subject:Date:From;
	b=Ld5bAgcV+naw5iPMe9JQzP1ajedhedbX/DLy3RemRdGpvy2d1cEr1ttwwSGKb4CuJ
	 fwjVxxFF1RpJSyzpp6pTFOr6ngn43bFdTY0U3c430RRpfIWo8cSrCZ9x6NZFMe3rBA
	 +0x4lfUA710rp2+Ru9KonTkVd9maqlCBvj2uGiy4PO6stYxBQaGAUALhBo6WplypZd
	 cwBis/aZgWG+pXR/7RGG29HT6dmPa9+J+meucLqYdsZscQpka9T3gsfJiaiH3FH0nL
	 VbRhbJqwJDqGChJDr+6xB8Y3ONiCXKKdTVM254vOJ5xSOH51OHRFr1RmFBEFASxxaY
	 BMhnXbYxN+vaw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] lib/crypto: tests: Fix KMSAN warning in test_sha256_finup_2x()
Date: Thu, 20 Nov 2025 19:34:31 -0800
Message-ID: <20251121033431.34406-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fully initialize *ctx, including the buf field which sha256_init()
doesn't initialize, to avoid a KMSAN warning when comparing *ctx to
orig_ctx.  This KMSAN warning slipped in while KMSAN was not working
reliably due to a stackdepot bug, which has now been fixed.

Fixes: 6733968be7cb ("lib/crypto: tests: Add tests and benchmark for sha256_finup_2x()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/sha256_kunit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/crypto/tests/sha256_kunit.c b/lib/crypto/tests/sha256_kunit.c
index dcedfca06df6..5dccdee79693 100644
--- a/lib/crypto/tests/sha256_kunit.c
+++ b/lib/crypto/tests/sha256_kunit.c
@@ -66,10 +66,11 @@ static void test_sha256_finup_2x(struct kunit *test)
 	ctx = alloc_guarded_buf(test, sizeof(*ctx));
 
 	rand_bytes(data1_buf, max_data_len);
 	rand_bytes(data2_buf, max_data_len);
 	rand_bytes(salt, sizeof(salt));
+	memset(ctx, 0, sizeof(*ctx));
 
 	for (size_t i = 0; i < 500; i++) {
 		size_t salt_len = rand_length(sizeof(salt));
 		size_t data_len = rand_length(max_data_len);
 		const u8 *data1 = data1_buf + max_data_len - data_len;

base-commit: 10a1140107e0b98bd67d37ae7af72989dd7df00b
-- 
2.51.2

