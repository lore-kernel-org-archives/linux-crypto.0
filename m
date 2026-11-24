Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795512398;
	b=32NWR7ZNI+szxXsBUs4M+3x6OctUjCxYlHlZMPcDAtB+amdMd+10i6wjPl6mKNtzD73e
	 DDmFwgXbnFbpjk+GsZBcpxDT/yrobM5FlCb6zkc3ZLyyHNPE/IJpOnNgCYswNn+blQzDJ
	 rRTsDMRQDdR235qv1aE3EjlHifzdw5NUUTvqYHU0VvJRmHuIRegUbJcg5n1Oo6O/11a39
	 b2Pq30hfThyuYTJSZP45IvjmCqVV2KtoIYQEOVooJPA+aXeQXlaUBNbezCy74CkxWsVxy
	 +4mk+WJda1ZIHQGsMF70cKyAbPPrUG6i6P0klL6QChTmjUmUlhAocd0k2lELV4EY2Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795512398;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=EsMpm1UJth43Nj3MbVf0gP427Go+inFHlor0Y6StmlE=;
	b=Eoe7zx6mdgDm7vBDj6HxKPDcsRj6l7ETEMO3xM9+E/HMD5pnoPk+cDqaJsLVLc1ak8g6
	 pcSfoik2ihI7UeNWsfuhDwVLJJ2QO7M+H3lreHkpQFkPgmbEO1L1uasUH3mbwG3EVaxFy
	 Lh76X7oge+iWKV8R1NMPyyS0jvQS/LZcIQz7e4owt/dzr4c7NaJ2XsvmwuQtMg5uQ8Kv1
	 HicQOGztnSMsq/giAp8nWi+LA66OviR2nL+dQMt3f4rmS9GnpjypnpqISXgsbnpWnIQiD
	 JMl+S4dSe6rjoAej6oqg3jKBn44l52cowicb2mLrRJYwG+d4Sbe42LchsJlWAgn3COw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=PCU5Hljy;
	arc=none smtp.remote-ip=109.224.244.116
Received: from mail-244116.protonmail.ch (mail-244116.protonmail.ch [109.224.244.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335A8606A33C;
	Tue, 24 Nov 2026 09:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 335A8606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=PCU5Hljy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795512395; x=1795771595;
	bh=EsMpm1UJth43Nj3MbVf0gP427Go+inFHlor0Y6StmlE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=PCU5HljyxHIwHvmlP86n8hTt8HPvRSw+4g4zAJgD8Zbvl8KXa63LWlReTzebpgXmj
	 LfR74i/7xMhYoVrxK7CEGyEZnZ3EyBCnhUcK4qZljP3HZ44kUVnlsrBpguTczKsJAY
	 caQ3hl/eynBbj2n1PG8m0Zgpm23HbQNPBwg4/UBjI+3J4NQCi+YIXWiD6Ujqnb6s6y
	 x4/LPOLPiUJ684R0DCKB5AfZI3M4X+TwF0YdLykeh7hNEMedERBIkT+ZYpt4ZZzfUO
	 FsJuRl/GCYLi8l+WHYP4gIOl0ESOErsYhlkY69dxHG+Yr0QxVLGvkA/YBcZJD46IbB
	 r7Wh0N3FNBe2A==
Date: Tue, 24 Nov 2026 09:26:30 +0000
To: Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH 2/2] crypto: hisilicon/hpre - fix heap overflow on oversized ECDH public key
Message-ID: <20261124092546.1712228-2-rc4d5a@protonmail.com>
In-Reply-To: <20261124092546.1712228-1-rc4d5a@protonmail.com>
References: <20261124092546.1712228-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: a42234e8d5b1e140189a147438a3a048a5aac52f
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

hpre_ecdh_src_data_init() bounds the caller-supplied src length only
indirectly, via shift =3D ctx->key_sz - (len >> 1). That checks len >> 1
against ctx->key_sz, so an odd len one byte above the real limit
(2 * ctx->key_sz + 1) still passes: len >> 1 truncates down to the
same value as len =3D=3D 2 * ctx->key_sz, so shift comes out to 0.

scatterwalk_map_and_copy(ptr + tmpshift, data, 0, len, 0) then copies
all len bytes starting at tmpshift =3D=3D ctx->key_sz << 1, into a buffer
sized ctx->key_sz << 2. For P-256 (ctx->key_sz =3D=3D 32), len =3D=3D 65
writes bytes at offsets 64 through 128 into a 128-byte buffer,
overflowing the DMA-coherent allocation by one byte. The overflowing
byte's value comes from the attacker's input, not from kernel memory.

Neither of the two in-tree callers of "ecdh-nist-pNNN" can trigger
this today: net/bluetooth/ecdh_helper.c's compute_ecdh_secret() and
drivers/char/tpm/tpm2-sessions.c both hardcode the request length to
2 * key_sz at their own call sites. This is a missing bounds check in
hpre_ecdh_src_data_init().

Found during review of the DH/ECDH public key validation patch sent
as 1/2 of this series. It predates that patch and applies regardless
of whether 1/2 is installed, since nothing before this change
checked len against its upper bound directly.

Fixed by checking len against its upper bound, 2 * ctx->key_sz.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
No HiSilicon HPRE hardware was available to reproduce this. Verified
by building the modified driver against an unmodified kernel tree,
confirming the module compiles and links cleanly with no new
warnings. Separately verified the fix in a standalone test simulating
the buffer-offset arithmetic for several lengths around the boundary,
for a P-256-sized key (key_sz=3D32): len=3D65 previously wrote one byte
past the end of the 128-byte buffer and is now rejected; len=3D64 and
len=3D63 (both previously valid) are unaffected; len=3D66 (already
rejected before this change) remains rejected.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/h=
isilicon/hpre/hpre_crypto.c
index 66a276786a7d..bf55dbc0c894 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1484,6 +1484,9 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_r=
equest *hpre_req,
 =09int shift;

 =09/* Src_data include gx and gy. */
+=09if (unlikely(len > ctx->key_sz << 1))
+=09=09return -EINVAL;
+
 =09shift =3D ctx->key_sz - (len >> 1);
 =09if (unlikely(shift < 0))
 =09=09return -EINVAL;
--
2.51.2

