Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEFF3C76A6;
	Sun, 27 Sep 2026 22:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549080; cv=none; b=X+1tKCmbXSKHG47kJYgjzLtW3JL20eG61GSsAxhLTo8RdcVfAwOjVoZLwIDrRHH5pWNMuJcJ7LjyEgVn18EJGQv1cd2lcCbH7unDJ06HNmrLQozcsmo8hymK9BG7Oa6sBl6tyjMfU7ICjuUR9jOhYyGQN74Y4tdCdnKzcdxHMG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549080; c=relaxed/simple;
	bh=7a+4Gt0xDDmCvGCZBY2eafOaHLdMTG7DYM9klLRu/2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmOr0J5ecX3d211s4dC67WDZT+2fSK3zp1F9T8a+Ao2pcrzvnezFrsRa6Zbd3rwxjcljfyXdnDgoIryZBY0i648pI160rH6Qf2rMgC0qA7eqa1TmAd6sN0Ih41Q8/8gZ0XGwG2dVrD6ZnROzCSfzwo3/T5zA+ZI7YhBvZw6+EHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9dd3Tz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9dd3Tz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C7C1F00898;
	Sun, 27 Sep 2026 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549079;
	bh=vnEA9cfMXmX200OnA8/EwYowZNF4bPtpzOYKNAaTVp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9dd3Tz8UrCLCCZPxMi2hKHrOe8eOGjMrsJmBJMOv6FMI7jzyUDp7BuO4UbqRJtWQ
	 qYQ04iqmrX15Yggyt1Yd7A07Al13/LHAmr5VEL1l25C1hFvVeE3wO1MZuGYtURqO3M
	 P4mqbaonb7vA5B8tpUJZMsUJXRzw7IPkvl2YAVnkKE0mSlINEe1thvC7j6BfpI9r2n
	 LQGpmoE7N4vksSHpCqSgSYuRipkyu+C0M72R9CCU8eiPl1Eaihy51MIV/vhM1epaNF
	 jU9Ok/irsiVeA404n5jaEtO003+64JF+m1TSdoOKSpRrl2sxGy1zak7A/ulPlq6znf
	 uV6j9VnYcPhyg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 02/20] lib/crypto: aes-xctr: Pass counter by value to aes_xctr_arch()
Date: Sun, 27 Sep 2026 15:42:53 -0700
Message-ID: <20260927224418.109759-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>
References: <20260927224418.109759-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the calling convention for aes_xctr_arch() to pass the counter by
value, then do the increment in generic code.  This aligns better with
the x86_64 and arm64 assembly code for XCTR, which takes the counter by
value and thus has to be paired with an increment in C code anyway.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index f1549839b3de..22f096c50242 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -1094,7 +1094,7 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif
 #ifndef aes_xctr_arch
-static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 *ctr,
+static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 ctr,
 			  const u8 iv[AES_BLOCK_SIZE],
 			  const struct aes_enckey *key)
 {
@@ -1150,8 +1150,10 @@ void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
 	__le64 aes_input[2];
 	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
 
-	if (likely(aes_xctr_arch(dst, src, len, ctr, iv, key.enc_key)))
+	if (likely(aes_xctr_arch(dst, src, len, *ctr, iv, key.enc_key))) {
+		*ctr += DIV_ROUND_UP(len, AES_BLOCK_SIZE);
 		return;
+	}
 
 	aes_input[1] = get_unaligned((const __le64 *)&iv[8]);
 	/* Handle the full blocks. */
-- 
2.55.0

