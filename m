Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609364CDA37
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356571; cv=none; b=HngIsqDqBbvQVmpNoASqONApINTXD2OkYutgoPC0KjBzPagxRG6b5SfjdLwDEOqhq8nfLctSDSP9n4ZKC/ZWhTOqfV1vVyRbRh27eaMYBGGw9mOYjIz1Q8mApauMAyaPMge+6CjxoSdboCzHz3VcLGDJ45jaJ2tAmElm4Xtdi3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356571; c=relaxed/simple;
	bh=YW9anqruF5ucY3CJ6tV708cQPQYU/iBPqefi39PmqZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9tzqwFjVx5kr7FThV94fQ2jycdCc4uIg9BNbf3uWrMlbCE6xHBiiqP43mkMIwoz8VvVkaovP3cEjnzftqPZG/RFNF6xnOSDKU7OroqUx70KitlFpLw2hRqBc4/qMlS3L7PS1AvDqtba7LeJyyGl27tP2p+qOxY8OclKuBBI1E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSKd2X/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSKd2X/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0B51F000C4;
	Sun, 18 Oct 2026 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356570;
	bh=C/Qs3cJzhfXmhxmF8CqhaK6ypCfy6e+mU6b6ObVYJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSKd2X/eEbU2FH4mAqqI1JLNyP9/Cjsg/Cekgd9Adtn1NaD5wE3bARmCecHr5iCw3
	 +GGGbLSZNHXd1o0dy4Olnv9Sg8UF0tgtxq9iMvLIt+rH69xv30ti1ab+Kgh3tp6tTI
	 4FV4JGJ73+E5BqmwoYiqMmWlCa1PDw3B71wmnugOOva4pYoUWYZR1VD9FlotrjDyLb
	 MP0in7R+GmJsQSOQJ1Ic/ArsN20TzlKXyIUsJv4ujRYuVzusz8NI0ZO/WzWahnR76C
	 5O0jAQCK1849SRkCzEoE0xBNR1Wkj2JbPwewWYu4aWPPmQdlZ4YEXWa2zLGDuUMOxt
	 Zsfy3k/jWb3DA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/14] crypto: jitterentropy - Remove the kconfig prompt
Date: Sun, 18 Oct 2026 13:46:16 -0700
Message-ID: <20261018204618.104876-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no longer any need for CRYPTO_JITTERENTROPY to have a kconfig
prompt, since it's now library code that provides no functionality by
itself.

It can still be enabled by enabling CRYPTO_DRBG, which selects it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c9d842706b9ff..da7f2dca05d4a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1115,7 +1115,7 @@ config CRYPTO_DRBG
 	  It's otherwise redundant with the kernel's regular RNG.
 
 config CRYPTO_JITTERENTROPY
-	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
+	tristate
 	select CRYPTO_LIB_SHA3
 	help
 	  CPU Jitter RNG (Random Number Generator) from the Jitterentropy library
-- 
2.56.0

