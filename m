Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8FE18CC1C;
	Sun, 24 Nov 2024 12:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732452319; cv=none; b=j+CLJ/RalFS9E4oPxtJEFpRbvLodibfCSHC0CeH0Tln0hyLyopNC+G+wtZ12AEyaV7r0/aAqhbXkPoUA3Eg2q5brjU5SqAzyQE7+R3BlMewCdwusOViu1AZJzTJ7vBOODnfM2FN3rPJbKORTENddyjOxdPyuopobmMFFOve9skk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732452319; c=relaxed/simple;
	bh=oirgsQnHBfGFNBrWVg1xmJLEkU3WZRxplluiMQ+96mc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZQlxT+zqyDDzvz7uxwHPnt/y0+5pRJmroTcFUnDTqMxsMrkL70Ysig/0AyTHOBvLt6TXodAzYvjrjn0d4COlYNWk0tG9MXnp6ONcn96Mo49iSffq43b6pmEFTlgxSQmGASmFrzozYE4lgwKG0C1qWSmKNGbLAKiKyG8vWRYhL88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBNRls1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBNRls1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5F0C4CECC;
	Sun, 24 Nov 2024 12:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732452318;
	bh=oirgsQnHBfGFNBrWVg1xmJLEkU3WZRxplluiMQ+96mc=;
	h=From:To:Cc:Subject:Date:From;
	b=TBNRls1OTpbIZsa3DtJaC6aT9U5xvRKNhAr0lBffagq/oDK4XAyVYg9Y0tSNOHnP5
	 r/Zj6+E9zcZYk/xWQYUF30rJZ7AS+WuBsmga7u1PPl68ZYR+3J9giyh2eBl+Do8lPE
	 //yYhzn2PdrZFsYAnHhYa1NBZgbWg+HNPDmKBvhjdCZPxCts0/uexa4V8dMSa5SyUN
	 WwN4ogy1TdrnuN9Wbf2yqhYTwpcGB5+v7C2tgVK7eaPyEgWrJIc2mjx+2SK1mfyg26
	 8mUzfpC5z7XAnhPgjFEffnFnvUeC+WlJA4Qja36eyeYrnSZ/3fvnx0D/kFParBudnO
	 wiC2wDUtvSBKg==
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
Subject: [PATCH AUTOSEL 6.12 1/6] crypto: ecdsa - Avoid signed integer overflow on signature decoding
Date: Sun, 24 Nov 2024 07:45:06 -0500
Message-ID: <20241124124516.3337485-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
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

