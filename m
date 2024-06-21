Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA27166311;
	Fri, 21 Jun 2024 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989217; cv=none; b=GrDV7To27KVToUNDynYa7jiTx4GF3srIgV6EM+uYM0Dm7FlGNPqyoR1qo9UJUyz4Xu3EYXmPhARwENAjufMgOMVwMnVy+eB7os69ak2K4z4AbTUv7H63/u4ZIv27JiHggeyPkeUxhTqaDo4c6sxWCLv55vnWXedK5GKbtE9EmQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989217; c=relaxed/simple;
	bh=6USdTOOyYM3FNFIuW1a3O/WfkiZlhPxeGJEgqz38Sgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5ZqXFmn11TYt4okMFOClrAkQI/TQi9Bzw/Q3Cfg9vcCf/6KEQzEBmn8cTRmNZCM80/LrxK+OJzvzmm2oepRKmg3eL3tIJoLhYPIq3N9ypgXroAhlIH9P4sz0a5zy7slzcaLjsWZeKIZayrgoMeyWFxK5I8olpSSA0qKOmkNyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8PuJMKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8PuJMKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F91C4AF0A;
	Fri, 21 Jun 2024 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989216;
	bh=6USdTOOyYM3FNFIuW1a3O/WfkiZlhPxeGJEgqz38Sgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8PuJMKnPBgqE3pbF/On9Owe+WUuzNwk0hDGwJXOtQrMk5mBHXQV6/1S7KKFuAbTr
	 ncV0uRvdKzPyfDvDs6z48a9acujSdMvHZhr2oAjGGUIvlnfWBMMUD0F5+LvBbuIWJi
	 127sxDcxkVhi2InXsKt39C2RKrKedcoyG6LKB2Rj+4PihsopUgeF4aGdH93h3wUj+1
	 vhgZxWK1axYT0huzF2/TKVXk0LFo0ovupCFQikNVaDg+n0IatuunwEbytW5eAhlpXk
	 iobRLpyA8y3shjRfpXqDGGcXYCnoP1XBAuaV1LLZ+trjiOiXbf2fcHdCzbFZwRDfKP
	 ogECHWVRCV18w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v6 02/15] crypto: testmgr - generate power-of-2 lengths more often
Date: Fri, 21 Jun 2024 09:59:09 -0700
Message-ID: <20240621165922.77672-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621165922.77672-1-ebiggers@kernel.org>
References: <20240621165922.77672-1-ebiggers@kernel.org>
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

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a780b615f8c6..f02cb075bd68 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -914,18 +914,24 @@ static unsigned int generate_random_length(struct rnd_state *rng,
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
+	if (len && prandom_u32_below(rng, 4) == 0)
+		len = rounddown_pow_of_two(len);
+	return len;
 }
 
 /* Flip a random bit in the given nonempty data buffer */
 static void flip_random_bit(struct rnd_state *rng, u8 *buf, size_t size)
 {
@@ -1017,10 +1023,12 @@ static char *generate_random_sgl_divisions(struct rnd_state *rng,
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
2.45.2

