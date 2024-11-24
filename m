Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698A11B3946;
	Sun, 24 Nov 2024 12:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732452335; cv=none; b=sDLTyGCmHdxe8iGPUwslEJ3AO3ZK7SPV5EJdSl8pi3IvP/PxdyLa5xtRFgVNgz144qNJoW4XrUJJ9fBnzgqf3opqYZB3fZsLlDhTfLdpl1ZtV9txKsn7swQf27bxd4PDsJF/otr1nbcBP6P/obaxw99aMioccUBzCALDc2FyAhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732452335; c=relaxed/simple;
	bh=oirgsQnHBfGFNBrWVg1xmJLEkU3WZRxplluiMQ+96mc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QYC5+/lOng0EN2citW3YsYKEYyPQ8V30RlqNeV+CBWwYM6UOWtjzNV3HXbonHjw+eSQPLY+O7efbgXCFsa1Xt/lDutaMiSRGTUOq9dr4MvLEqf0/d0IUuCnqyrjcRI85WeswRzjIvYivY+CZ+01LoLYkWL5fwZYM7l6D/LmGU5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9I0qmT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9I0qmT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D4EC4CECC;
	Sun, 24 Nov 2024 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732452334;
	bh=oirgsQnHBfGFNBrWVg1xmJLEkU3WZRxplluiMQ+96mc=;
	h=From:To:Cc:Subject:Date:From;
	b=G9I0qmT9s5rGsPX9Y/fN09rtpJcn7RQuoTldRL8tZTyzmS3Xq0My20QFo6WYb1p/5
	 7jQknUyNnrlCl/uo/2lgbhJJj5WlRkfBtlkgNVKiDeAqZ4nseRrnCfd3Dt47WH2wQF
	 colqjlnBjSmcErbImdSz8le8N3yf91KFiVWV8vIah2K8kBkpP8XRXLDSlDiz+8m/8Y
	 hQP1WU5eAJ/uG4QWoYMaswusLhZfNkN7MNop9IsNDsiyxxcnL084tCQwAH8DLQ7yjA
	 ZQMnDOkmOVhOFrzV9UJjH98/Xiqpx/kV46CrxY26Og5CVeuQjGnIw2x6PnU+bl57Om
	 smGQtQ4lZbddw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 1/6] crypto: ecdsa - Avoid signed integer overflow on signature decoding
Date: Sun, 24 Nov 2024 07:45:23 -0500
Message-ID: <20241124124532.3337626-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.10
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3b0565c703503f832d6cd7ba805aafa3b330cb9d ]

When extracting a signature component r or s from an ASN.1-encoded
integer, ecdsa_get_signature_rs() subtracts the expected length
"bufsize" from the ASN.1 length "vlen" (both of unsigned type size_t)
and stores the result in "diff" (of signed type ssize_t).

This results in a signed integer overflow if vlen > SSIZE_MAX + bufsize.

The kernel is compiled with -fno-strict-overflow, which implies -fwrapv,
meaning signed integer overflow is not undefined behavior.  And the
function does check for overflow:

       if (-diff >= bufsize)
               return -EINVAL;

So the code is fine in principle but not very obvious.  In the future it
might trigger a false-positive with CONFIG_UBSAN_SIGNED_WRAP=y.

Avoid by comparing the two unsigned variables directly and erroring out
if "vlen" is too large.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdsa.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index d5a10959ec281..80ef16ae6a40b 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -36,29 +36,24 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 				  const void *value, size_t vlen, unsigned int ndigits)
 {
 	size_t bufsize = ndigits * sizeof(u64);
-	ssize_t diff = vlen - bufsize;
 	const char *d = value;
 
-	if (!value || !vlen)
+	if (!value || !vlen || vlen > bufsize + 1)
 		return -EINVAL;
 
-	/* diff = 0: 'value' has exacly the right size
-	 * diff > 0: 'value' has too many bytes; one leading zero is allowed that
-	 *           makes the value a positive integer; error on more
-	 * diff < 0: 'value' is missing leading zeros
+	/*
+	 * vlen may be 1 byte larger than bufsize due to a leading zero byte
+	 * (necessary if the most significant bit of the integer is set).
 	 */
-	if (diff > 0) {
+	if (vlen > bufsize) {
 		/* skip over leading zeros that make 'value' a positive int */
 		if (*d == 0) {
 			vlen -= 1;
-			diff--;
 			d++;
-		}
-		if (diff)
+		} else {
 			return -EINVAL;
+		}
 	}
-	if (-diff >= bufsize)
-		return -EINVAL;
 
 	ecc_digits_from_bytes(d, vlen, dest, ndigits);
 
-- 
2.43.0

