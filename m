Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771C3279DDB;
	Wed, 27 Aug 2025 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307698; cv=none; b=ENKvbh+1fpPxfNP/G5Vtgw/PfvXKiDD9BLvMeKt6hf7Q6btadbJq6Dg0AFTbI483+jshrD6hKWmN7hdOOaO5xa9vTzneF+5WbINm+Tk17IG+p4savOr5DdVqWr+ScYTaEx+KDb8TVuohTanNwBFHN2cLdT4j2/Db1AuegvB+lnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307698; c=relaxed/simple;
	bh=DgqLJLt/N5mdg7z1+FAS46a3j1pnJlIf4tSEAWMOUqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gi1yfak0gkzt5h8MhaYz2bgDteoy24epA/0d3hB7R/4yJFxJfOsQDVfTzMxVn8aQFhLxpfNVBMhetENXTVzLSjYZ6kuvJZfRhNDjlZXhOgBDiSLwRpPNR+dFbSDsPDzIHeo0lApzdZQlcvooieVaz11RozaP8OhX8NcHRSJzyVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdCvI0ji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdCvI0ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B71C4CEEB;
	Wed, 27 Aug 2025 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307698;
	bh=DgqLJLt/N5mdg7z1+FAS46a3j1pnJlIf4tSEAWMOUqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdCvI0jiNwjyyAG+h6jO9lVJzemAuZP8v7aD0Hzp9q8c5BtLEf1GvoHL4qyImWp6p
	 jUq44DX3bCS9q0/MbnW0P+/M/khURXkG/GcXzXSVbF3/jqOa9cfWT3/50aLZOWKmRW
	 YJAauoNQZ9Nk8Aa4SG6J41X8UwY5/xfdADWDuXs+D3PWLM84BqpOd5rQQvW5ZrZiMG
	 cCzj6OJMyAESvKePPjHxpJWkUaUFDjKDe3ZIUXRjE4EbaEhIWScv2Udjb0j17dgdMg
	 hx0mP+Ls2kvWF66F/isj70szONU8a8wgF99zQlbUo3IPTK5IV3iUij8oce03lik72J
	 xbO5SXFia10PA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/12] lib/crypto: chacha: Rename chacha.c to chacha-block-generic.c
Date: Wed, 27 Aug 2025 08:11:23 -0700
Message-ID: <20250827151131.27733-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename chacha.c to chacha-block-generic.c to free up the name chacha.c
for the high-level API entry points (chacha_crypt() and
hchacha_block()), similar to the other algorithms.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Makefile                             | 4 ++--
 lib/crypto/{chacha.c => chacha-block-generic.c} | 0
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename lib/crypto/{chacha.c => chacha-block-generic.c} (100%)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 8d91572b4d5ef..ca65924e861ff 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -13,12 +13,12 @@ obj-$(CONFIG_KUNIT)				+= tests/
 obj-$(CONFIG_CRYPTO_HASH_INFO)			+= hash_info.o
 
 obj-$(CONFIG_CRYPTO_LIB_UTILS)			+= libcryptoutils.o
 libcryptoutils-y				:= memneq.o utils.o
 
-# chacha is used by the /dev/random driver which is always builtin
-obj-y						+= chacha.o
+# chacha20_block() is used by the /dev/random driver which is always builtin
+obj-y						+= chacha-block-generic.o
 obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
 
 obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
 libaes-y					:= aes.o
 
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha-block-generic.c
similarity index 100%
rename from lib/crypto/chacha.c
rename to lib/crypto/chacha-block-generic.c
-- 
2.50.1

