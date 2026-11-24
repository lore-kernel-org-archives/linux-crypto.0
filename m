Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795560448;
	b=SI1Syxg4UM0Lv+SgNTnokQipIw7JDYJuoZHYidvjLSsAAhfqjXZPXQzqjGlSt+Ka7Yd1
	 yD1WGeB47w/uhf01jGj0elULDdSs7UjwP8Gqw/T15daqUPm+iWAFIWlPHICCoXzOwdFpI
	 e3HEaHsXm9GaatKrdww+EJ7imYOTw7dcgzQbRjGmtuK8Ew3D9GHFgWQq55HlZ8R+PHV9p
	 6oJG80sdGTfRBcoWOkFOAJ4Zz+CUCE+qJhA73W9gM2I4hws6Jb7kPAg7xM7gsLIvjkIHE
	 EpAkYfvIlSEuPsD4VsAcLjIUcDiVDx4tlPDlNfHv2r4xs7jFld4fb+O32eQH3QYg9yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560448;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=SZipJ1uRfsegwpLOl59l0EgTPUHU1MGS1d2i+4exJoI=;
	b=wz2XhurokGfF6xS1uiR1ENOpnEpHJUcZRDv5HYkDLMuAwBsr9DHrbZ6rP3cLFCKgxPOb
	 KNQiMwm7yAT3XPylGpJ7OCSy0nPw3I24VI+tDFqEvbVui6VVdCdB/SYZMy3Mg1Gd5SUCE
	 S8EozgS4s67u3jhOMnTrstJL+K9ANNkGhl2tVpdVr1yiFQD0twzcLT+vDNX+EoU2I2wCB
	 /qk9Jxxs0XMrgJvGaKWcnHvyFx1uir6BFlAK6z8c8M8NlaO8dTwyMvSsYCTsO6jZNNg1W
	 y6ChaBPsHCmEth7AfB13FiUu20PYrfvvxDNASxbRojN+LWAtts7O/mY17pd0l3OioVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mjX7zN3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2334606A321
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 22:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mjX7zN3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149151F0089E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560448;
	bh=SZipJ1uRfsegwpLOl59l0EgTPUHU1MGS1d2i+4exJoI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mjX7zN3gk+C77P7i4MvBWHtApt4YWglO7Cwzy7grBlL5iEADz8Yb90qGVJn5AC4t/
	 tFX6xkCC3tHGWFHxtNhpAqJpy1ygBeUINHXF2rgddFzXAd5pNgtXjDkWVJ4tW2XHZa
	 tl8BgdMgM1hIdfh/GaGm6j7CKCyp3Ts3PLL95jynC1uu3+K/Zad80C3Z/+88ghxyYc
	 rfedQV6WqlBsKrY9WDk1ISlMwVuqD/aV25shkrdeNEKp6xBsOPGcc84gvd/NeSikN/
	 SVEp9PSqsH6HtVMC/xiXJ+mgFk8QV7EHJnJps9H6Sz4+B2Dk4Tx/TX9gzO88YAG0sE
	 7eO8mG9k4OTBg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 466D0198003A;
	Tue, 24 Nov 2026 17:47:26 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 17:47:26 -0500
X-ME-Sender: <xms:_BMGa_0d5NcnoMgVBmzR6wp1gjV7vQ1r0pFbq43pmcR7l_A5uPLslw>
    <xme:_BMGa47m3MVmKnguILw9FfEzKt54CROAyd6OvkupPGAYMfqibdAhviO4xfSJUjrne
    WmZ60fXqKuXl9eNzBRGcsZsVLJMkzUKnZ0YjZouP2JHRalfZFGKI6IvtQ>
X-ME-Proxy-Cause: dmFkZTGxPYnXkUCwxPBQg864Gn7kfELWjp+FEhfRzakS3VG6B5Z3Mv403RFqg3UBLQAuhM
    ubEO2eNsUM2ntB+KcF3xZ7QilGYrmpvfF6QrHFC8obqyUv9C19+/uqDloGzOPdiLsA5l94
    KKzhzxYgoBp4UvEuMx49agFsZzXImdnv3zJpE8ziyf5RnehXu+dfwVWuvr3kIB5nri0hDJ
    aNv3f0LJb9dfIXyUq26OM2/3N7lLDMoWY1oCJxep5BfqsvEzmZCrgfTXfzK1fxIiH83VHl
    /bpoYJKnfU7XkU37w+VY2napon0ijnMInzqWCPlYtLCxB7S4yT4X2v1yzrcDLBSJMVcjRE
    nLWEuW73F2qOVClNQW90YJrImt9raYf2fe2rf1IXMaQEtF7BK08jpDHCCfFMO7W+R8q7vn
    i1hB/pT5lyznLIR+anya7ZKxOf0jHbLwJLa9uYw4S01PcKukfUP+kQHN1i0zhei9AZnGe1
    IgQ0duFxOdRn9kpR8GFpSqIUlUC7LE4KdyQlzKJFW6cq8fSL8idafS1Zt3cnPlQgAOmt6N
    ZWhiWKP+r1csg0/O/SW5qEBWX7yToisoh3g2VteoLNH3YBiUetPvPYykEjZ0O+8EvhOv9e
    Q4LIpVLsBb9OFUSzeePsr6fSD4s7S+cICdM87Awm/dVjove1jWkDFTDgQNog
X-ME-Proxy: <xmx:_hMGa7I_pPkOQM7b8LxfQodCWsWGUdFjM3bhZgZzpDDoyVzAPBmp9g>
    <xmx:_hMGay1MsufBO7exgVUr7-2v5XAetQXXQwlDiNVyZrAc3G6TuBZRHg>
    <xmx:_hMGa9g3ml_mZWTjq4hIx6DrkIKtmRoxOn1QPA3QjEogzLBUxt7O-w>
    <xmx:_hMGa7VG4_Eh6lxVK-JWoZQwZ2e_nw3dkdwbVtIKx7YFw5eLK1KlRw>
    <xmx:_hMGa0WInbpBTe72jUjhjBTn2M8dQo8JE3LT8mW6cJ8C6uJh2MSJkMMm>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 89874F80093; Tue, 24 Nov 2026 17:47:24 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 23:44:52 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <ce7b9a68-8c41-4fbe-acd1-20f865d6c96e@app.fastmail.com>
In-Reply-To: <20261124203346.GC2227373@google.com>
References: <20261122022030.296468-1-ebiggers@kernel.org>
 <1a78f7c9-59de-4ac4-8adf-aee0538d813c@app.fastmail.com>
 <20261124203346.GC2227373@google.com>
Subject: Re: [PATCH 0/8] lib/crypto: De-bloat and optimize sha512-ssse3-asm.S
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 24 Nov 2026, at 21:33, Eric Biggers wrote:
> On Tue, Nov 24, 2026 at 12:27:22PM +0100, Ard Biesheuvel wrote:
>> I gave this a spin on my Sandy Bridge machine, which indeed takes a 20%
>> performance hit from removing the AVX version.
>
> Thanks for confirming the expected 20% from
> "lib/crypto: x86/sha2: Drop one-off implementations for Sandy/Ivy 
> Bridge"
> (https://lore.kernel.org/linux-crypto/20261115080900.216434-1-ebiggers@kernel.org/)
>
> I still think we should take that patch anyway, for all the reasons
> given in the commit message.  Do you agree?
>

Yes.

>> These changes regress it by another 3-4%
>
> That's unfortunate.  Would you be able to test the performance after
> just patches 1-2?  Those are the most important ones, which I think are
> worthwhile anyway even if there's a marginal throughput decrease in a
> warm cache microbenchmark loop.
>

Most of the slowdown appears to come from patch 2. Patch 1 in isolation
is roughly neutral.

However, if 20% is acceptable, then another 3-4% is not something to obsess
over. I personally don't mind at all; as you know, I'm usually quite
triggerhappy when it comes to removing stuff.
