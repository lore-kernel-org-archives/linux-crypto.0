Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558602;
	b=SHhWHpnpNkUrNXliwSZ6oXwapXL5HoUujZOOUgKEg2iUmNH3teJNxgzdJk92bZEV11PZ
	 PzsRL2OU4x96KM9QdZcJCV3irpUsa0wpomaOv35N37UOvVGLpji0F7egIgAjsWNo6IbOm
	 5F+C4d//MVHgCLhB+uI33pRozW60wl4aLTO6K4fhTm8cp0XMzozVhDSnXBOpO+NXYnYTJ
	 55x4DKj7Snh+VkMkqCICVwixkRku45xm6MbBMuBdLK8/l3igkYg7fx3x1N6W3LmrhzuHK
	 tizLsjExYDW4BmTMHA2PNztnqFTzVaogl+FNbxs8WiozV4NEYRsLmINFTQgGZyWyCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558602;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=rc0d/hTNAy4YMlJaV2+RQodJ4Jy6wzgWPFt/TTigtvg=;
	b=tfwHonJQOiFsNnkP8/a2R3zWFjX+weLwd0Qk6nGZYODZnAAjyZxB70XrXCbDKoQZk8E1
	 gO2u8OYEVLxXSlIdo2/8tQLPqF24FalRFMa5l8E06I9YyyBVhVLPObC2LTElbStfM1rwM
	 gy6aUEWtFTJIyax77/wz/i/aOaV4MoaB/XS5UraO8J7vEkwp75OKlx6kCc6Xyz2rWktqZ
	 KPncEtU5x7FGR/hVchi3rCsxYury/V+ZutenWMB+XzVJRMAN6JTqG3jW6VUu5NCvZC+DO
	 peCFa2R6HGaAwsoExoag15HLMu9S7Pot24Uk3D4WxW2o0+2UrCHr8mms+2t/p6HFm3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HNi11glB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D8C60A6F72
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HNi11glB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E64D1F000C4;
	Fri, 13 Nov 2026 08:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558602;
	bh=rc0d/hTNAy4YMlJaV2+RQodJ4Jy6wzgWPFt/TTigtvg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=HNi11glB+WeBQgiDjp7fov5Ob5A/Tak5GCgrByaFNhHQush0/qag3gA9NGKf1WiNo
	 BXXpuUijL3L0rt0iKf1jrS75fRN8fndq4ttT/by1rpy2LW8OmngjT9pOpQ1QabUSe5
	 2pkcgCKWYfCYMZLVNLvxLy2Fs2VGHRACdGlyhyX4NLEC1l2+tpvcmbHiQ0o14Kb3Tj
	 BF08QiCQYaSB6F6v2SVckSHCr4qRmXfeH0TC6EGURT3Ho4Kao5Fvu1+9iOJD4VuO5A
	 5SMm5dRCpoisAKnvcVa0fN2bXApFYsYP1DS9SLQftTQ3anb3KUIp+EhSgtnd7N7n7S
	 xGqalvJdAi5/g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 46FAF1980058;
	Fri, 13 Nov 2026 03:30:00 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:30:00 -0500
X-ME-Sender: <xms:hsr2aov-xCEM3Co47jT_REbGvOUzGUE5q2ICyMk4R51-j38r6AqmHw>
    <xme:hsr2agQXRGswx-30ukbG3ylNYmUq9hmX9jrmrWTJBpiMyRIGwngiMj7ch1sVW-ejH
    GH3h8vw9u7vF4J46tTUI0coDmmDciDbs1Um42HQZJLlN0M0U5c2PfbJ>
X-ME-Proxy-Cause: dmFkZTF7I4gA5Vh0jrs0kx6In8cnhayjjtWmdiYy23AJqzICxVYYStr50xMQaDihrZYDXh
    +EDY+jaqvxK4xiFCl7s2oNRfQ526Daz58mCjerQmkPVD+K3PANjm+GqwNVtANFsmdc71DB
    +X216pZ1fTkASy8dP26gX9rVygDaN0ON90KWuEOTBn/0FaZ+ChsMzbR3l8LTrj9R1/Riz4
    +shaEeJpMOrIIBgrOxj3kSbTq1J3o44gIp9GdgmoMRFjRm8hDpHc5dD7oJPYB9Qg2GmweE
    aO7G5M94Zyi5f4j2vivUcIlb/CFo3bFRmK/tPBxaPaAypmeWmE7MARhtENvKN2uJu128iw
    zq9SOXweyESlOjdK83mBLpjeIK1oS9Y4SNtwnBpoUDzXkLj2/F/Vcho2LCbqpqZEf9l3b3
    ClPK9kb6GjAnPI4ENStzL3uXIHaNH5IV0yJnjN2vF5b20gAmnkS7uXQr4X+NPLVsVxa+p0
    3kV9NlNTr0s/df+MSod4gcCyDmhJ1Vr+gkzX2OIi8oM95GKlFE/PS+SYnJSRhTyUBwPjsn
    q6QD6COXf0l78KXRP3W49uiVtkACculylJnrl9ZGiPI+pJddoDB7xHvgPk4xlhslrFyHt7
    azgiQTJ5Lphb9h7B5epnQB8J1MY8eOQDqHufZYNs5jzCQ8xd0CqLJjpJSH9w
X-ME-Proxy: <xmx:iMr2atCyl3WCloj28vLPeqD8wqNegk7Bv8ujKSvH-M0zKtOytZ6eqQ>
    <xmx:iMr2avNDb4tgUEBqK-FzepsWoayT9FKdNoUPYucXMW4Sno2t94siJA>
    <xmx:iMr2aiabM_zwfKg7Oepl2uCVdDQn1H91ppKVEQOcbSd1vSXbc-rVbQ>
    <xmx:iMr2auuiUp7W-ztUIgQEilRxXtx85dFjoaniGq9_1WIfYunKCIIcPQ>
    <xmx:iMr2akNPqAjkIlaYfCKFE2g6mtGoscnQnz-PEL_3c4gLmBqdlglJj253>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id DC873F8008E; Fri, 13 Nov 2026 03:29:58 -0500 (EST)
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
X-ThreadId: AuvPxVPbSFy3
Date: Fri, 13 Nov 2026 09:29:37 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <c5bd2f40-7aa0-4079-b898-8d49b14f19a6@app.fastmail.com>
In-Reply-To: <20261111201525.40031-1-ebiggers@kernel.org>
References: <20261111201525.40031-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: x86/poly1305: Drop redundant checks for AVX and AVX2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 11 Nov 2026, at 21:15, Eric Biggers wrote:
> Reorganize the code in poly1305_mod_init_arch() to use nesting.  This
> eliminates redundant boot_cpu_has() calls.  It also makes the code
> structure more closely match poly1305_blocks(), which has an early
> return if poly1305_use_avx isn't set.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/poly1305.h | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
