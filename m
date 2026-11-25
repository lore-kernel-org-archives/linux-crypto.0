Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648821;
	b=VbJNETyfSkgkSaMfoj+7YYc0AUIZbNPxgSZA1HpdFFP2bGOn1yUL6zCgzRaJWXGZDfjr
	 o9QRREJJBsQAiT9v2Xm8MFcSl6xp6zxPfMmVR4wKCXpUdNgyvLFbUoAYTQVkbRikTdn68
	 1ni0eCI8509WOscSUrwO2LCdz2BIX0TjDimiMzm8aLoswfEunJQZ8J0jeQ3iHEnYta4k2
	 YypFlJWQV1hx0x180lZf99jjFKIbzUoAsslJwiXpZ6FaDn5opx3hM+DHzqCBcxeyctJ/1
	 b6srVPVtFlFmjbI7eTGZ8is5Mx3ku3WZQ9IePQo3R2fyDDIAyGLQuuv/QQDzqbTkszA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648821;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=xa5TxEwMSu/tHhTRii+AZOVjx00nlbMu+ZgWqbet4C4=;
	b=lw9o39n5oF9+1pA0iwCtKcxdg7hlc93kzLp/AF4QJMhiKVdDsZCDqgPMGvv5dR5QKMR7
	 8X2FmeRn/Ay1qu36FhSBL6F3tq55zzwdvbynUw8oCB+FJoE378oVH8FSmjAfx6Hpu1ka1
	 KJUryADUE6hsUKIh8Cu3JlKVOK/xloYMh0sPP3v/pcZUO3f+wKjUwlm4wbyt+cThd6/jf
	 uJIN4tyrjVcIefdN9B2JyCFgnqjO6rpbhEoYJR4B6GLIYy4WHfFSoWjjxqrl2ybY5aT9s
	 wRcJkm6AshGnmpH5a/y5lkVvHOIgkZp8/8yY27cAsOk8asYrJ92ELQZSlQxkVcnGg2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=V0Sk4CKS;
	arc=none smtp.remote-ip=79.135.106.29
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5A3606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 23:20:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC5A3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=V0Sk4CKS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795648818; x=1795908018;
	bh=xa5TxEwMSu/tHhTRii+AZOVjx00nlbMu+ZgWqbet4C4=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=V0Sk4CKSOg3l3HGKIeA0DMJUMapOoqVbZgqSbH8XiusI5ReR4wo69+7jpGfeJIab1
	 /yXVN537+U+VvT6zU24PcjwK5jQLDmEdvuYV+3T64dWPZfLFMCQrCPcGVCrrkJfkzu
	 1xB7QlMvnucsa8RbwUgZ8d027Ym77HavDw+At1wPenO6UJupq4tuSChy3SPfke7GA1
	 +/ThNj4XqIAxdzdXGqH84zYEXbXR6LAWCF3o6UjQRuHdwiKIQc9JoIV4wVG2kTi/4H
	 x5gesA06OxlwdY4ogcwex8Kg5hUvE4tApPxBNgKPF5YGWy41/jBOvbtXDJXM2FDQxb
	 o8E8kglyvYscw==
Date: Wed, 25 Nov 2026 23:20:13 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH] crypto: dh - fix missing DH public key validation on non-FIPS kernels
Message-ID: <20261125231954.1857828-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: f00976f35fe7f67c4fc029525008f206445447dc
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

dh_is_pubkey_valid() returns 0 immediately when fips_enabled is
false, so on a non-FIPS kernel dh_compute_value() never checks the
peer's public value at all before using it to derive the shared
secret.

That gating was added in the Fixes: commit because the function's
own range check (2 <=3D y <=3D p - 2) used to take a shortcut: it tested
y < p instead of y < p - 1, relying on the y^q mod p test further
down to reject y =3D=3D p - 1. That test only runs in FIPS mode, so the
range check alone wasn't safe to run unconditionally, and gating the
whole function was the simplest way to keep the two consistent.

drivers/nvme/common/auth.c requests "ffdheNNNN(dh)" for NVMe-oF's
in-band DH-HMAC-CHAP authentication, used by both
drivers/nvme/host/auth.c and drivers/nvme/target/auth.c. Forcing the
derived session key Ks to a known value lets an attacker who holds a
handshake transcript perform an offline brute-force attack against
the pre-shared key, which is what the DH exchange is documented to
protect against on top of plain CHAP. With bidirectional
authentication enabled, an attacker can obtain a transcript by
connecting to the target directly and requesting it without valid
credentials, exposing the target's authentication key
(dhchap_ctrl_secret).

Fixed by computing p - 2 directly and checking against that instead
of the y < p shortcut, so the range check is a complete partial
validation (SP800-56A section 5.6.2.3.2) on its own and can run
before the FIPS gate rather than behind it. The y^q mod p check
(SP800-56A section 5.6.2.3.1's additional step for safe-prime groups)
is unchanged and stays FIPS-only.

Fixes: f66a211e8c5d ("crypto: dh - Make public key test FIPS-only")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
Verified by building crypto/dh.o directly, confirming it compiles
cleanly with no new warnings or errors.

Also verified step 1 itself under AddressSanitizer/UBSan outside the
kernel, by building lib/crypto/mpi/'s arithmetic files standalone and
running the new code against mpi_sub_ui()/mpi_cmp_ui()/mpi_cmp().
Using p and b_public from crypto/testmgr.h's dh_tv_template[], y =3D 0,
1, 2, p-2, p-1, p, and p+1 all produced the expected accept/reject
result.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 crypto/dh.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -97,34 +97,44 @@
 /*
  * SP800-56A public key verification:
  *
- * * For the safe-prime groups in FIPS mode, Q can be computed
- *   trivially from P and a full validation according to SP800-56A
- *   section 5.6.2.3.1 is performed.
+ * * Step 1, the partial validation from SP800-56A section 5.6.2.3.2
+ *   (2 <=3D y <=3D p - 2), is performed unconditionally, regardless of
+ *   FIPS mode.
  *
- * * For all other sets of group parameters, only a partial validation
- *   according to SP800-56A section 5.6.2.3.2 is performed.
+ * * For the safe-prime groups in FIPS mode, Q can be computed
+ *   trivially from P, so step 2, completing the full validation
+ *   according to SP800-56A section 5.6.2.3.1, is also performed.
  */
 static int dh_is_pubkey_valid(struct dh_ctx *ctx, MPI y)
 {
-=09MPI val, q;
+=09MPI val, q, p_minus_2;
 =09int ret;

-=09if (!fips_enabled)
-=09=09return 0;
-
 =09if (unlikely(!ctx->p))
 =09=09return -EINVAL;

 =09/*
 =09 * Step 1: Verify that 2 <=3D y <=3D p - 2.
 =09 *
-=09 * The upper limit check is actually y < p instead of y < p - 1
-=09 * in order to save one mpi_sub_ui() invocation here. Note that
-=09 * p - 1 is the non-trivial element of the subgroup of order 2 and
-=09 * thus, the check on y^q below would fail if y =3D=3D p - 1.
+=09 * Unlike step 2 below, this has to hold regardless of FIPS mode, so
+=09 * the upper limit is p - 2 itself rather than the old y < p
+=09 * shortcut, which relied on step 2 to reject p - 1 and only runs
+=09 * in FIPS mode.
 =09 */
-=09if (mpi_cmp_ui(y, 1) < 1 || mpi_cmp(y, ctx->p) >=3D 0)
-=09=09return -EINVAL;
+=09p_minus_2 =3D mpi_alloc(0);
+=09if (!p_minus_2)
+=09=09return -ENOMEM;
+
+=09ret =3D mpi_sub_ui(p_minus_2, ctx->p, 2);
+=09if (!ret && (mpi_cmp_ui(y, 2) < 0 || mpi_cmp(y, p_minus_2) > 0))
+=09=09ret =3D -EINVAL;
+
+=09mpi_free(p_minus_2);
+=09if (ret)
+=09=09return ret;
+
+=09if (!fips_enabled)
+=09=09return 0;

 =09/*
 =09 * Step 2: Verify that 1 =3D y^q mod p
--=20
2.51.2

