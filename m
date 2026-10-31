Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793420811;
	b=eNbyRT2n1As/QgtUpRKwuJWcoim616rf6+v4ok/5lhfjm3VXOE64GKAwXiHU7Ym22zkR
	 GSwYyiaoItk3EvzDW2JeCsplGL5C8UtStlnHVYCyIFmcnVbic/Tf0pSkY/IYkE9ntqP3z
	 c8UWZo6yqDkdm9x2/EbQWxrCbZnaW7piyjsQTmmK4q3ant+C1XaAtdYbUIIuu7xEk5okK
	 xiL24ZLaMG2mHF3pY2aCojM8InEGqjqepUMqY0QewFgJmoA//W7fuMkZFgRaRIJxVf8T2
	 /zIqakl4QUT0fhnQ0Op4xRZfRrV8DZi4RTajr9FjB+dYKRWnoXECU2mJqAOAV7QSLCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793420811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wPJmodA+23ROZ5yb6R0Hb7n/yva83Q1PBs3ZcTJXWyQ=;
	b=Ma+gix2H5EdpVefA+1ig/OTEsZ9Qi0AAOdR5vdH/oIzS3CyiAsG9gugohABCNSnB7c8g
	 95v0uEsZI76xzY08o3ctboGXdOhEFxY8dwInHYyCG6GnTJvGtklZp5rH5NuVSFoV+n1PR
	 xS/g0cxuFDc6wqy3Uqd+kMD0r1oWz00YB7kHzMt7oxrdc7ItJHGP1PDimhfcewmVNH+W/
	 WltMB61a2Uhb3o2YuctdnV38s3vVeFOJeqQ2H8vRtQXZUZmddOzsWCjIkdYDlwskYQTTv
	 j5frc1f47gNpze8fiYdl2Re/6hJWsQ9m8rKrudI2rd0pbTNSF75XsFQsEFRNy7HddGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AtEQI9Qx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F68D606A31A
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2026 04:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AtEQI9Qx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027CE1F00A16;
	Sat, 31 Oct 2026 04:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420811;
	bh=wPJmodA+23ROZ5yb6R0Hb7n/yva83Q1PBs3ZcTJXWyQ=;
	h=From:To:Cc:Subject:Date;
	b=AtEQI9Qx/0GBuXN+fL/jRJ2Lwn5+5eWcZnIO0R8a51wxhQUyA2D4jDbLu/ax2xc6l
	 zQnOZnGB5pvYyjsNUY2mtmLXt6BbiZYEEzFunm1WJ2IODQOYdCCQTJrBgiGpTdZNBI
	 wdCyEV00sft5xiI1Swv73jSeX3Qc1yTNfjuVZQd6ClIJPVtVJG4qJZ3QIvOOvpCdAd
	 3tcz/TTxLRX8mZ/CkN0/++tnl5OV5X/Nqxq19j3gEs3Hudbv4mgjxTtV3M8khC6XxA
	 dfHWWfGdzx4q+gtVVWsh3WQplb9uNaNfOOBnBJxFO4PiWLdGSNrihGns8B58zUkGIV
	 xnVPTuc5Y6MNg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: poly1305: Hide the mask value from compilers
Date: Fri, 30 Oct 2026 21:26:37 -0700
Message-ID: <20261031042637.68815-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

poly1305_core_emit() does a constant-time select between h and h - p,
where h is the accumulator and p is the Poly1305 prime of 2^130 - 5.

The mask used in this select isn't hidden from the compiler, though, so
the compiler can infer that it's either all 0's or all 1's.

In theory, the compiler could then use that to recognize the select, and
"optimize" it with a branch.

Fortunately, in practice, I couldn't find any gcc or clang options that
made that happen.

Regardless, add OPTIMIZER_HIDE_VAR() to "hide" the value of the mask for
safety against any future compiler optimizations.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/poly1305-donna32.c | 1 +
 lib/crypto/poly1305-donna64.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/crypto/poly1305-donna32.c b/lib/crypto/poly1305-donna32.c
index 5977785cd76e..73fe9181296c 100644
--- a/lib/crypto/poly1305-donna32.c
+++ b/lib/crypto/poly1305-donna32.c
@@ -167,6 +167,7 @@ void poly1305_core_emit(const struct poly1305_state *state, const u32 nonce[4],
 
 	/* select h if h < p, or h + -p if h >= p */
 	mask = (g4 >> ((sizeof(u32) * 8) - 1)) - 1;
+	OPTIMIZER_HIDE_VAR(mask);
 	g0 &= mask;
 	g1 &= mask;
 	g2 &= mask;
diff --git a/lib/crypto/poly1305-donna64.c b/lib/crypto/poly1305-donna64.c
index d0e4234c1c4c..402a3459ca49 100644
--- a/lib/crypto/poly1305-donna64.c
+++ b/lib/crypto/poly1305-donna64.c
@@ -152,6 +152,7 @@ void poly1305_core_emit(const struct poly1305_state *state, const u32 nonce[4],
 
 	/* select h if h < p, or h + -p if h >= p */
 	c = (g2 >> ((sizeof(u64) * 8) - 1)) - 1;
+	OPTIMIZER_HIDE_VAR(c);
 	g0 &= c;
 	g1 &= c;
 	g2 &= c;

base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
-- 
2.56.0

