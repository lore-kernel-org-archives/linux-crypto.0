Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505BF137939;
	Mon,  3 Jun 2024 18:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717439944; cv=none; b=MHJSvMUvANCVy4+Yps8y62XjeEhaQXy4ilpe7MMcAzU7qqzocVGqiGmdnzrm1nwjv4lARBXKMp26BQW10FJAW/YVWWq/EYBLTfxEqaAodtFs64cEYiFUHV/cP3EsMVd/zAs1vxqDRKr08LzYWJpnWY5bQJbUg/7fmUFLh3ab/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717439944; c=relaxed/simple;
	bh=x6BpOkZDth1TELblCpsyj+k4HXeki2UgF3oymt00wPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTglnGUVMi/W4htRzQFVh0hcTRHL0RNWaHIqsF7n9QPLcGJkOFlAt1iGJbHWnx/+PBTPIbNVg+0OEckUIxWW0iZz8cihaTHYmrA2C3IRcJ50p9PdHBUK4a+bn6qooPBHrwdoyfucmkpGN5wLJoMVmAvvus1U3c9RoCiv/xwLE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjygecmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjygecmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA08C4AF0C;
	Mon,  3 Jun 2024 18:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717439944;
	bh=x6BpOkZDth1TELblCpsyj+k4HXeki2UgF3oymt00wPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjygecmDtViAWcFTVGQqDXqZqubTgs2At4eNDnwjZX8B2LaBrW6cMtNEjPf65Hl4Q
	 ISdjeHXuF0nci26Q0PAlY8/Wh0A9VV1tr9MjlptBoxoqllTJ0+/vpJLB6BZ5pJrf3w
	 QhfE0m0F/W1P8eMP+TrldFQ7XMw9fJbFfWQ46tRN8XRMD5KUQZ1fgcyzaCTNRAqNXo
	 HfnRvkS3NY86oLpmB7TMWPpFCFtHQkrcH4OSNYqDQn3NTBUvsS1ogYMMMJ8pK3zZMx
	 iKhelu60NcvKydJaJoPs0S/c6HE+iZrlSWaDrW/PfhkrVmQNN5OItJ+JO6k5apuK0n
	 XjSN4bVSoqPAg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 2/8] crypto: testmgr - generate power-of-2 lengths more often
Date: Mon,  3 Jun 2024 11:37:25 -0700
Message-ID: <20240603183731.108986-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603183731.108986-1-ebiggers@kernel.org>
References: <20240603183731.108986-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Implementations of hash functions often have special cases when lengths
are a multiple of the hash function's internal block size (e.g. 64 for
SHA-256, 128 for SHA-512).  Currently, when the fuzz testing code
generates lengths, it doesn't prefer any length mod 64 over any other.
This limits the coverage of these special cases.

Therefore, this patch updates the fuzz testing code to generate
power-of-2 lengths and divide messages exactly in half a bit more often.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 00f5a6cf341a..2c57ebcaf368 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -901,18 +901,24 @@ static unsigned int generate_random_length(struct rnd_state *rng,
 {
 	unsigned int len = prandom_u32_below(rng, max_len + 1);
 
 	switch (prandom_u32_below(rng, 4)) {
 	case 0:
-		return len % 64;
+		len %= 64;
+		break;
 	case 1:
-		return len % 256;
+		len %= 256;
+		break;
 	case 2:
-		return len % 1024;
+		len %= 1024;
+		break;
 	default:
-		return len;
+		break;
 	}
+	if (prandom_u32_below(rng, 4) == 0)
+		len = rounddown_pow_of_two(len);
+	return len;
 }
 
 /* Flip a random bit in the given nonempty data buffer */
 static void flip_random_bit(struct rnd_state *rng, u8 *buf, size_t size)
 {
@@ -1004,10 +1010,12 @@ static char *generate_random_sgl_divisions(struct rnd_state *rng,
 		unsigned int this_len;
 		const char *flushtype_str;
 
 		if (div == &divs[max_divs - 1] || prandom_bool(rng))
 			this_len = remaining;
+		else if (prandom_u32_below(rng, 4) == 0)
+			this_len = (remaining + 1) / 2;
 		else
 			this_len = prandom_u32_inclusive(rng, 1, remaining);
 		div->proportion_of_total = this_len;
 
 		if (prandom_u32_below(rng, 4) == 0)
-- 
2.45.1

