Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446690;
	b=DnafS8Mbv9qKieYlswb/+UCTuBWGhV92TckQHRewt+oTi/2VdwaUbPEqfckxm+iDRBTs
	 +aJWdq3bH6KYNmNjt/+2rg4Wxbeaoa5gr3smXajQcj3gRN3DnBxhedkEHDRy6SiGMrQFN
	 1Si4hSULuIpo9+ZnyC1yC5stZ7YvvtXuvPD0st2w7pY2dVA+6bW34lTwh+y2sg3oUeahS
	 TuhICqwq4wWUtU4BW3GzPW1P4zm9xVuDQJtqPGx+ezzhtITNT9QBiYfo4p9YYQChmG+mp
	 etupeBfX+vydwmMLTbG/zkg9pZfrjc+vl4NkLkoHb09pNTQ8rvHlN86XZ9kd3hc0nug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=IO+/0E+TAMyUiGRvFqTT6Iz3EJ2AtWO/PWampQ+h9N0=;
	b=MLyWNqktLhYXE29mLvInMDIJ/L+ZgafIJi8qW8U4icmw4C1mFnQNf4vh8ZxsKRoRciIS
	 m8sH9VGant3RLEQHq5Jauxy9WLgnSu9hHqqydcn1EN0E1ZQlc1NUpuCC06zfD/sYAqc3D
	 ktzLD74/xeMsZeHEyFA64fsME1QU6dLbOCHh3wx5tDjgF2i6t/14EsLwUuYiH3a3z5LrN
	 dUtaPVaYizSvBZfG9aBEuwPKQin3lxgFOP2LP9V1KVpf8D6IB6n/zGBHAu0I9uhmuiGQl
	 m0FLWpQfJBWeob5nYr4oEiOUe5pgQEnvJ/YGuOs+0aQYs13sL+5P3rEFWdqgRpYmYeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTRrdDMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B77606A334;
	Mon, 23 Nov 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTRrdDMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180931F000F2;
	Mon, 23 Nov 2026 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446689;
	bh=IO+/0E+TAMyUiGRvFqTT6Iz3EJ2AtWO/PWampQ+h9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTRrdDMyjgv8vyeUaookRwA9cP3oZfnmW7KXMK/QRvONxYZMNcVasWG2N+2tLlBtu
	 +WO7jjCCxd+jcH0UN7dH5l4hZuMtZ6BuN/3Tr5s/1OWYlLPnqoE7udw387J9aguVIS
	 EORM9Qi7bTaaKBKv0ZpuGiJyU7LTprWXVQaNbgcA3v65G+TIebVydq9qkyZGnk9Cb9
	 mW9SA5+RT2xitVJvO1U6K8UhSo9uO1DubcOf2xjdO3WUcKtXv/9M8J7LJ3swv3REJD
	 +xKtuJmNNW4gsQ9jlto9q/FhjvF+mSsxU4ddUPzgJUwWrgFRKUAbzgO0R57y2QFTjb
	 VnMn5XCNhvcbg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <blum@kernel.org>,
	Bulent Abali <abali@us.ibm.com>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Dan Streetman <ddstreet@ieee.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 03/10] crypto: nx - Fix bounce buffer copy overflow in decompress()
Date: Mon, 23 Nov 2026 15:09:54 +0000
Message-ID: <20261123151055.2533735-4-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123151055.2533735-1-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When decompress() falls back to software 842 decompression and the
remaining destination capacity p->oremain is smaller than required_len,
it redirects decompression into the bounce buffer ctx->dbounce with
dlen set to BOUNCE_BUFFER_SIZE.

After sw842_decompress() completes and ignore bytes are subtracted,
decompress() copies dlen bytes from ctx->dbounce into p->out via
memcpy() before update_param() validates that dlen does not exceed
p->oremain.  A crafted compressed stream whose decompressed output
exceeds p->oremain therefore overflows the caller's destination buffer
by up to BOUNCE_BUFFER_SIZE bytes.

Validate that dlen does not exceed p->oremain and return -ENOSPC before
copying out of ctx->dbounce.

Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
Closes: https://sashiko.dev/#/bug/linux-7309787b-8efe-4919-bb31-c4d9eceb9c0f
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index b4404a138962..4f96c2b2397b 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -427,8 +427,11 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 	if (ignore)
 		pr_debug("ignoring last %x bytes\n", ignore);
 
-	if (dst == ctx->dbounce)
+	if (dst == ctx->dbounce) {
+		if (dlen > p->oremain)
+			return -ENOSPC;
 		memcpy(p->out, dst, dlen);
+	}
 
 	pr_debug("decompress slen %x padding %x dlen %x ignore %x\n",
 		 slen, padding, dlen, ignore);
-- 
2.56.1.750.gf70dc682cf-goog

