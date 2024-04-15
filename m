Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AD51E89A;
	Mon, 15 Apr 2024 21:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713217129; cv=none; b=ldDPz28+McD9A0mJ4hiQgonIXMaq/3UbL07nrbfxAvEguJrsb0SEdSToUw6IF+HoEmYif+LDiq9s5UmJ4yjOcD+UCHn/MDmdZUNlVRwf2kwAqgMSTpcvscfYRaoXlZngMPV9bszui8A2g7DxXT+ocwhv34RCEc8gUvGD99SqnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713217129; c=relaxed/simple;
	bh=7EeMhSwgfXHIxMBvok4WynVvjspAaaT/x9LSuah1mWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ao+h+ObEv9SfYU6/k6k6oUffxLAP/x4kEphUe0LoMKypV/gj+0FlzYQW6bZCALmyEyUqILZGAjB8+lTE2A8zq5T3VU4PEI4iml6126KxcqIkBR7GCPlrCSwlyMJ1r1KdRnV9XFO4VYMoNG0jwybth7Gag3jymwmFl0WqDGntT98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apE+WaJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apE+WaJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7A9C4AF07;
	Mon, 15 Apr 2024 21:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713217129;
	bh=7EeMhSwgfXHIxMBvok4WynVvjspAaaT/x9LSuah1mWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apE+WaJBVTRpZ06MLaJm1+uhetGmGUYYcBMHvgLZhO/1pHcokq4mrSb2AvKhTeRwf
	 xgQHbuWmNISyO2WTgLlgnyaC/I9K5EKor3mU1h9hb5332peW7y0H3rrDe67N7WjlDt
	 +OzW4TS+DpYD457BwLOg1/uSGFPtc6Vjv4mtI5sj01Bihh/ZF20hn5t6WwdT4n2nxF
	 NkPOvElsVJc6/AuVe2U5jUNgbV0ZvHt1pSmB5op9tfZAi7dJPtzWjCz1JcleaA7MkK
	 8CbhbEdXhWaW0PjNxvfXhtkr8JwOBZlTLXXLD55DvPoSfLNaEaaXaGiC7PneW8s5MG
	 FswQ1M7NTA0xQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [RFC PATCH 2/8] crypto: testmgr - generate power-of-2 lengths more often
Date: Mon, 15 Apr 2024 14:37:13 -0700
Message-ID: <20240415213719.120673-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415213719.120673-1-ebiggers@kernel.org>
References: <20240415213719.120673-1-ebiggers@kernel.org>
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
 crypto/testmgr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3dddd288ca02c..2200d70e2aa9d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -899,16 +899,18 @@ static inline u32 prandom_u32_inclusive(struct rnd_state *rng,
 static unsigned int generate_random_length(struct rnd_state *rng,
 					   unsigned int max_len)
 {
 	unsigned int len = prandom_u32_below(rng, max_len + 1);
 
-	switch (prandom_u32_below(rng, 4)) {
+	switch (prandom_u32_below(rng, 5)) {
 	case 0:
 		return len % 64;
 	case 1:
 		return len % 256;
 	case 2:
+		return min(1U << (len % 10), max_len);
+	case 3:
 		return len % 1024;
 	default:
 		return len;
 	}
 }
@@ -1004,10 +1006,12 @@ static char *generate_random_sgl_divisions(struct rnd_state *rng,
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
2.44.0

