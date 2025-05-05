Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79A8308A4B;
	Mon,  5 May 2025 22:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484100; cv=none; b=dziwq+9yoVwrG1bA2EyZFul/sPD79ALKVlGEtBMNMFwNkhvFr0zev/eA8J41oT6mQjt43pACMx3u8VUFCGTEsDJhPyZT6OOCstyXUDPBYxIj3VRKS9D9Maz2Mscmc+/zBShaxBSN8zAdQnXEm+l1KdEqQdEgi6oj54Ul78EwKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484100; c=relaxed/simple;
	bh=/Rvtccyhzv7Nv/J4EEDECJqkMCdvc+Mw1U+o3audtHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XCP224RJEv/8CR3pV2r+WS7gPWda6C5vs26D6SprAnRC9LKH823Wdanm4cefkz1UgENTY5lXWZVTXBvy+iuoSnvsBldTX+2yhr19Wz+jsfrNRfOTJlNmqfV3FhG0SF9m/YBaPav0oVivBIrAhEJ49SAfnUgm7SCO18IXBxuhU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZAHUaty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZAHUaty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20908C4CEEE;
	Mon,  5 May 2025 22:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484099;
	bh=/Rvtccyhzv7Nv/J4EEDECJqkMCdvc+Mw1U+o3audtHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZAHUatyZNF6KalM+EfgCEFs9VF1GNShpBs8UulToJ/CGRr2yrDin90bq5NfZ3y8H
	 jPafjg5eVUqyZ5Em5GIBIQNA2XONqfhpxySfA39TK1cZmkXURK2/z4tKowdqxifdmZ
	 p3bSaNjumhOouyIDC1WBnHz8wzk6Q1uDsQIERJ1W2S0pfc5jRC3NeD6gYw4AfMhPBw
	 AVl5THkhOeOc4u261jPqZNM5KFkulIWvQd0NeKNjYJzXn81FzIjZQyqDauZPBdTPSy
	 gOqFRsHBZmZ970wbGbdAAha1ssuw1ZJahX49czQg3j8ofyMPm4nTCsrLabBlC2Gaie
	 pbm6N6z3EZLzg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 350/642] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Date: Mon,  5 May 2025 18:09:26 -0400
Message-Id: <20250505221419.2672473-350-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ee509efc74ddbc59bb5d6fd6e050f9ef25f74bff ]

The type needs to be zeroed as otherwise the user could use it to
allocate an asynchronous sync skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a9eb2dcf28982..2d2b1589a0097 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -681,6 +681,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
2.39.5

