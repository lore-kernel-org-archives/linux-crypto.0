Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E523EBF10;
	Mon, 16 Feb 2026 02:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771208574; cv=none; b=FUCzlYAldLPlVZ8wmooLMxfooHbNmvbSy5iR7MmQUYNqke+AHO8/n1tV4tdTSqAgTuSbAsF6SpchRhDqIdmppXfU+vLso4GBujS6lOfiAqS5gyV0Z7PxUxeR9Gf5NJYCKAxJnqHLFX585byYSExhjUGTblUTllDHNmcSC6zKWdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771208574; c=relaxed/simple;
	bh=9PcyAaYKWFup8CH5YLUPtBnRj9L9MKnKJpJNN19ck64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nSCOBoTlV9x9XpMNxhVAsS7afLpvDaiYqWY+9aoE8WDoEEGo++K6Zd61S9yoHvSwPCkgQ4kaIDU0Wkj3HztZ7DfaK15uE3AXP8savRA9M1kzpjUb+gjTAbarAtQICSJl35uljW2WoeignFnL5jfSZwQbTem66fDTd6OKigFAEAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guWfMa7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guWfMa7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F95CC4CEF7;
	Mon, 16 Feb 2026 02:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771208574;
	bh=9PcyAaYKWFup8CH5YLUPtBnRj9L9MKnKJpJNN19ck64=;
	h=From:To:Cc:Subject:Date:From;
	b=guWfMa7dytMR+iBG6TVwpD+VfoIj72cYrSdhs9HGklYk+K5HOu5/wX+3Tn9BUcJSj
	 9BOxXBS+ZS/ShSqympgLhvLXKpgrhcL7uXKtzXde1gDo+pb/yxckRhItAneLQo77pG
	 YejxMkHQ1Axereq9F8XqNfwkOMdAIEGw8QAP+kzoA/tolWRk7xK4C7xwLCDQTOmLUD
	 QIz3aXCL2bOR/C9zl3KSJslQsWknCFZdulSAOoVReTEZbo9U7gZE4uBmPxqn2+Zq0Y
	 tXbFoKSCUEuyeZ9V1W5RM2q1K4iC0JJe2uWMI5difhR3e4l3AzEgevvfe1Mh2dJdeh
	 Bp/tgu54UydYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: powerpc/aes: Fix rndkey_from_vsx() on big endian CPUs
Date: Sun, 15 Feb 2026 18:21:04 -0800
Message-ID: <20260216022104.332991-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I finally got a big endian PPC64 kernel to boot in QEMU.  The PPC64 VSX
optimized AES library code does work in that case, with the exception of
rndkey_from_vsx() which doesn't take into account that the order in
which the VSX code stores the round key words depends on the endianness.
So fix rndkey_from_vsx() to do the right thing on big endian CPUs.

Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/powerpc/aes.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/powerpc/aes.h b/lib/crypto/powerpc/aes.h
index 42e0a993c619..f8cbd3c7578f 100644
--- a/lib/crypto/powerpc/aes.h
+++ b/lib/crypto/powerpc/aes.h
@@ -93,22 +93,24 @@ static inline bool is_vsx_format(const struct p8_aes_key *key)
 {
 	return key->nrounds != 0;
 }
 
 /*
- * Convert a round key from VSX to generic format by reflecting the 16 bytes,
- * and (if apply_inv_mix=true) applying InvMixColumn to each column.
+ * Convert a round key from VSX to generic format by reflecting all 16 bytes (if
+ * little endian) or reflecting each 4-byte word (if big endian), and (if
+ * apply_inv_mix=true) applying InvMixColumn to each column.
  *
  * It would be nice if the VSX and generic key formats would be compatible.  But
  * that's very difficult to do, with the assembly code having been borrowed from
  * OpenSSL and also targeted to POWER8 rather than POWER9.
  *
  * Fortunately, this conversion should only be needed in extremely rare cases,
  * possibly not at all in practice.  It's just included for full correctness.
  */
 static void rndkey_from_vsx(u32 out[4], const u32 in[4], bool apply_inv_mix)
 {
+	const bool be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
 	u32 k0 = swab32(in[0]);
 	u32 k1 = swab32(in[1]);
 	u32 k2 = swab32(in[2]);
 	u32 k3 = swab32(in[3]);
 
@@ -116,14 +118,14 @@ static void rndkey_from_vsx(u32 out[4], const u32 in[4], bool apply_inv_mix)
 		k0 = inv_mix_columns(k0);
 		k1 = inv_mix_columns(k1);
 		k2 = inv_mix_columns(k2);
 		k3 = inv_mix_columns(k3);
 	}
-	out[0] = k3;
-	out[1] = k2;
-	out[2] = k1;
-	out[3] = k0;
+	out[0] = be ? k0 : k3;
+	out[1] = be ? k1 : k2;
+	out[2] = be ? k2 : k1;
+	out[3] = be ? k3 : k0;
 }
 
 static void aes_preparekey_arch(union aes_enckey_arch *k,
 				union aes_invkey_arch *inv_k,
 				const u8 *in_key, int key_len, int nrounds)

base-commit: 64275e9fda3702bfb5ab3b95f7c2b9b414667164
-- 
2.53.0

