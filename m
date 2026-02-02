Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D995434575F;
	Mon,  2 Feb 2026 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770070580; cv=none; b=baQU2+7mc1F49zvQYWq9JqIMOCsyZwAnhVMv6HRoPnw7JTzNowpebQktRlRt6nrpFJ4Xb6hSBiOJsE+iYICA4OUBOTJDsoyauNWZDt5IGTJQ8t2e9lAxUGFKVvMgogM+evzA9q+x9Rs4gUJbFz8nmyFtXf1Wtkp4VVy2dX0bT/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770070580; c=relaxed/simple;
	bh=2GizkOyVy3QoEOxeYgr3chOKBw0aO7TklCvYGRzkn9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cjHwEH9VmZbMyCHgpzN2SnYCGCfd9/l7G+8PRDRfC2EpGrj8UT40MaTW3AJt8HHgBCr+M45X+h90nMdi3584GvNNuax3AXgmAjSWt3u5QGK0WrWGLHpbJbJU8unSkTqE2iby6JtsdvgJIylPYlzShwgPYbT9AugWqev1F5Ck2RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPpj8w+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPpj8w+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC92C116C6;
	Mon,  2 Feb 2026 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770070580;
	bh=2GizkOyVy3QoEOxeYgr3chOKBw0aO7TklCvYGRzkn9Y=;
	h=From:To:Cc:Subject:Date:From;
	b=ZPpj8w+rUpjFpcJeXrok7jieCdKdf60/OQOtjwEswwsQs8Qa4u8MUNkHvOJzuAMqp
	 3M/c8Lk+10eBv8SUwlA/K5keyj6ePVDrTu1Hl+VaEivC1ahni9VpP1iwSJ8b5KUxO5
	 tKkEA9pJOAfNE1tjW+FL5VwtZROAWVcw5Su2ifvS3uzyFnXdvp9oN7lbVuV2fG+Jrp
	 axWQaXVSNwA8qM5KpR7BDyOyXI6JzexU+CeYa2hUS+U8haAWiyIJMFsXhj+dx5HYv0
	 aFa07aLlvz3zvW3d5BGcC9yCdMZ/gjWZeC7i3JZQXuzAYBDgNEDOJbE6S8r+DEw9jQ
	 TWaaL1ywvyU3A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: mldsa: Clarify the documentation for mldsa_verify() slightly
Date: Mon,  2 Feb 2026 14:15:52 -0800
Message-ID: <20260202221552.174341-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mldsa_verify() implements ML-DSA.Verify with ctx='', so document this
more explicitly.  Remove the one-liner comment above mldsa_verify()
which was somewhat misleading.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/mldsa.h | 4 +++-
 lib/crypto/mldsa.c     | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/crypto/mldsa.h b/include/crypto/mldsa.h
index cf30aef299706..3ef2676787c9e 100644
--- a/include/crypto/mldsa.h
+++ b/include/crypto/mldsa.h
@@ -37,11 +37,13 @@ enum mldsa_alg {
  * @pk_len: Length of the public key in bytes.  Should match the
  *	    MLDSA*_PUBLIC_KEY_SIZE constant associated with @alg,
  *	    otherwise -EBADMSG will be returned.
  *
  * This verifies a signature using pure ML-DSA with the specified parameter set.
- * The context string is assumed to be empty.
+ * The context string is assumed to be empty.  This corresponds to FIPS 204
+ * Algorithm 3 "ML-DSA.Verify" with the ctx parameter set to the empty string
+ * and the lengths of the signature and key given explicitly by the caller.
  *
  * Context: Might sleep
  *
  * Return:
  * * 0 if the signature is valid
diff --git a/lib/crypto/mldsa.c b/lib/crypto/mldsa.c
index ba0c0468956e2..c96fddc4e7dcf 100644
--- a/lib/crypto/mldsa.c
+++ b/lib/crypto/mldsa.c
@@ -523,11 +523,10 @@ static size_t encode_w1(u8 out[MAX_W1_ENCODED_LEN],
 			out[pos++] = w1->x[j] | (w1->x[j + 1] << 4);
 	}
 	return pos;
 }
 
-/* Reference: FIPS 204 Section 6.3 "ML-DSA Verifying (Internal)" */
 int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 		 const u8 *msg, size_t msg_len, const u8 *pk, size_t pk_len)
 {
 	const struct mldsa_parameter_set *params = &mldsa_parameter_sets[alg];
 	const int k = params->k, l = params->l;

base-commit: fbfeca74043777b48add294089cd4c4f68ed3377
-- 
2.52.0

