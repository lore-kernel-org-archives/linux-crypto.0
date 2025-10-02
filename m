Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5C312805
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759413834; cv=none; b=l8XJ06BeZdbXS1N29rq9x9gFFHu9e5DSG06j5g/2Kq6uY5l7+7QJgJ1f96fzdzeEcNnhHKYPbB1sG1OXD82g3aZogqSaNY22yiOR7z+2oBWkKkXvEN4JUCvxXPkZIPSWsg6JQX7tQyJ08Jvyo0PfLGXyxSVgU6jJNJ8TxaPgzyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759413834; c=relaxed/simple;
	bh=7JVOZI3VmA/bJGurezKwfa6xLrTuVpU7TBiH1BVdZ8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVYsjV/CcakpKiT3nFirEoYW7cBUeHTgKTBHNxc9d5ww84BTsBDimD02F4rL7HbmwljoCmEiHUtWPkTEwVhnKeDnHZj93e3ddpPUeic4xyhO9YSGjvizVvvV0PEPmpUg9MS9SUNcR8fMSVuxu+kI6CVa3ABrl+6xBz/TlLrjG/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T46/Ecfo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T46/Ecfo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759413831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tko8biKCUbQX+Dpp0DpdSt4WwcDqXjayhPPlC8spm3I=;
	b=T46/EcfoueCU+LzxhLGXj1Rhm2wt+1+03m8cY4SRS3Z3WOpgY19uH7n5LNddoHtQNJThK7
	KRLeIJszIzPZ2TKATPgkKoJn+O7e5FepbvGh6HL8hvb8vOhaXFc4CNSMjQ1X3StDO+2U/M
	wBSJqOaEbaxX8iSDHSftegLF9VLJ0R8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-QzUXAY5DMpaA69dxfRSK4Q-1; Thu,
 02 Oct 2025 10:03:48 -0400
X-MC-Unique: QzUXAY5DMpaA69dxfRSK4Q-1
X-Mimecast-MFC-AGG-ID: QzUXAY5DMpaA69dxfRSK4Q_1759413825
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86A5F19560AD;
	Thu,  2 Oct 2025 14:03:45 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F06E2180057A;
	Thu,  2 Oct 2025 14:03:42 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/5] lib/crypto: Move the SHA3 Iota transform into the single round function
Date: Thu,  2 Oct 2025 15:03:18 +0100
Message-ID: <20251002140321.2639064-5-dhowells@redhat.com>
In-Reply-To: <20251002140321.2639064-1-dhowells@redhat.com>
References: <20251002140321.2639064-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In crypto/sha3_generic.c, the keccakf() function calls keccakf_round() to
do most of the transforms, but not the Iota transform - presumably because
that is dependent on round number, whereas the Theta, Rho, Pi and Chi
transforms are not.

Note that the keccakf_round() function needs to be explicitly non-inlined
on certain architectures as gcc's produced output will (or used to) use
over 1KiB of stack space if inlined.

Now, this code was copied more or less verbatim into lib/crypto/sha3.c, so
that has the same aesthetic issue.  Fix this there by passing the round
number into sha3_keccakf_one_round_generic() and doing the Iota transform
there.

crypto/sha3_generic.c is left untouched as that will be converted to use
lib/crypto/sha3.c at some point.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Jason A. Donenfeld <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
---
 lib/crypto/sha3.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index 5f847a5eecdc..2c292b0b3db3 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -48,7 +48,8 @@ static const u64 sha3_keccakf_rndc[24] = {
 /*
  * Perform a single round of Keccak mixing.
  */
-static SHA3_INLINE void sha3_keccakf_one_round_generic(struct sha3_state *state)
+static SHA3_INLINE void sha3_keccakf_one_round_generic(struct sha3_state *state,
+						       int round)
 {
 	u64 *st = state->st;
 	u64 t[5], tt, bc[5];
@@ -150,15 +151,15 @@ static SHA3_INLINE void sha3_keccakf_one_round_generic(struct sha3_state *state)
 	st[22] ^= bc[ 2];
 	st[23] ^= bc[ 3];
 	st[24] ^= bc[ 4];
+
+	/* Iota */
+	state->st[0] ^= sha3_keccakf_rndc[round];
 }
 
 static void sha3_keccakf_rounds_generic(struct sha3_state *state)
 {
-	for (int round = 0; round < SHA3_KECCAK_ROUNDS; round++) {
-		sha3_keccakf_one_round_generic(state);
-		/* Iota */
-		state->st[0] ^= sha3_keccakf_rndc[round];
-	}
+	for (int round = 0; round < SHA3_KECCAK_ROUNDS; round++)
+		sha3_keccakf_one_round_generic(state, round);
 }
 
 /*

