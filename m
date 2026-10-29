Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266987;
	b=Qug5EBDs4sdsrZ8XD4HOXB4O+6NViXJqbSu9LSFBtbsQUDHh2fBNnM13yGTRDdkaUZh5
	 homNTPS7RhgTvLV7xBe0vBx8IMPr9GxrNAXb0xryC+pp7+lf50K3V6n68+JGg7a04Kd95
	 gAlR1/dB+KmRwGUe/QWcMIVdJvSIxA2y6LwNPvK9NJJZCshhFgnuoHNsHoi5lWDasNAIc
	 Xnag+Z4Eo/yV+o31Ey7rK176RLMfJAQl8mVi0jmdwC8fHpVcPaYn5iMaWwoKDpBU5veC+
	 7H34IVaSJ8UVGJsGmiXE8VRvsEbmwv+eexgO28pJpPNL1ozmpePjCD2avDLn6u8P2Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266987;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=Pk4zFqn/UyIKjiaJnLG62AKImUGVwfG051wF5wLegNQ=;
	b=XvjR1UVlgg/6QE1UQpmRbdLpjVnQBr4J31YKbJhOd5wqYZk3MG/223DhQOl8FGG+nBF8
	 lBWwEcYjW5M8RgfIZ9EkLkHz2oacVXX6W7P7OsCpCXIG7wh+C47OaYlynyVsiu3cKhywB
	 iaYY43Ailru44ctP782JHiGwDPtD1xENcH8ayur+8iKCTe/36d2tUxGUu3GjsZ+J+CyIc
	 rdPFYGD6g9htLljxzWVToQlCyV9ytQ6dLh2WabCk4FppnvMqtSpwukn5zC7N5rGb2kgRB
	 Ae0PD+6q7AGtWI5w8teqnmcU/NNK5KhAKLNYTlW047OjIqBbDM9sMl6EkzHLBaXbiZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DVg4RrHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB87606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 09:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DVg4RrHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F551F031E9;
	Thu, 29 Oct 2026 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793266986;
	bh=Pk4zFqn/UyIKjiaJnLG62AKImUGVwfG051wF5wLegNQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=DVg4RrHKT2rRWKbf+UR9G77yboK9JaKBUd/jNjwyWIUyVkvQKzKFtsIBhwe4RngmT
	 vEzYZkA/nOGl0g3OhPgYN2KyZe/wYePHf+6xUHs+U1jhOclRbRwAnjtrnJBdIob836
	 /z+Zi8kB03FYQxPGodH9lREV+7fOIf9mZikMLgwvBCdAa7fdBnEvw+k1XQr9uss/H5
	 A7SmIHRbYWNL9e/34WOfBu9kY2VDUeYjwjlEMMNS4QssO2C3994jKgkzdByMS2uH3w
	 Bihfr2if3Bs/tjoPdgoCVWEAeWipDX3mQTxrh+LkUBNPmTxRiNS8t9AFUmu7535TYk
	 FKfH3eDcwCmTw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id D8AC2198003A;
	Thu, 29 Oct 2026 05:43:03 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 29 Oct 2026 05:43:03 -0400
X-ME-Sender: <xms:JRXjagBdqoCb4A901YT8uFvhfHLK_EONpxtW4IYqhzfi8XZPhpWljw>
    <xme:JRXjatVspm8iH3VjonJGNb0e7kkJau1a4GwNGwlm13iSwxJPAjfMRxbKpRTq2XhjL
    1JyIsobqhhIb0_LmAG0OqQlmr8w6RjWRUcHrWbcNMRz4ggqtC25ZP4>
X-ME-Proxy-Cause: dmFkZTFdH5K86TO5l4Iy21yiAduYztn1KeEr8K0PR258Yp1mqFENX2a3vNGUa++hBrWAPu
    0WRLvg7v+HxQt60shJW1k+pFmU6UYFagGV5H14ce6bZzXkVsQfzfod1jQ+76s7B9vwRdEZ
    tNaHc5DgCi5LgLlUTABOab5QaRVVq85lbjLs6L0MNtj+S17jTWE5SAk3pG9dxs1bN8s6uC
    ehXJzkZt0d30Hj5Ib/55VJLDAHUyXPMWONrQwd2mVcLXrfS1bL5V5uP9A5hAlPaTcEGSde
    0qRe+HNBY9uLkRpzlauPohIA8tWps62V6KbZcBhLAsGp9ondLVmDAQs9hRYlMbKuuRRRMP
    bkDmNmwBeZrjzWExEVqx/xEdrpV/U+u2AKVvwHixKCKgDz25Zb4Npkb+GwJxspDVnkkgIC
    M4OYNDyeuB1OJvi9LXbHvSviqyr++5t6ICdGqA1QS0Ju5wXZhjD0jH3U0Yf8UVp4dFV6el
    ygeIu8ttuJgRPi0vlKEl+Dvv7j0eXjNzndjE9tcevdhGheyWykDJik2gfs1D9SJn88Ll88
    yByRNMzV3ARPx3Mc4n/iY2Vq8eAqoZ2G/OM4WUKaivWhpNZDVUhORSLD6ufRGswZHo1DAI
    K0Qy1znaQohPzaKd1BUuCvqhgNwLe0dbu7wEFXM14eEe1BqU0o1SAsW9p9kw
X-ME-Proxy: <xmx:JxXjatRlZFTwWB8U_hRQjhN_XctTgFUsYAO1RkOL3A2IpjJWhGq9bg>
    <xmx:JxXjatRyGT856UZEMx_0ZZixixJv-9iTuXliM4Njr67MCRgzzE6FJg>
    <xmx:JxXjag1nWgcCBjgS1Q3t5bstgPy6qt1cgrICnDWabMiQKg7s3MtZ9w>
    <xmx:JxXjanzaua3350MuK4690CF4CdcTAz58oUhBNFfAViZ2-oXYnLjlrg>
    <xmx:JxXjasxRq14-5UOlyO0LzvXvSsUKZx0Gs8ckJwLO9u_Fxe865EL2_WNF>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 3D290F8008E; Thu, 29 Oct 2026 05:43:01 -0400 (EDT)
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
Date: Thu, 29 Oct 2026 10:42:40 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani" <ritesh.list@gmail.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Message-Id: <7c8500c2-4b59-40e2-a227-b488f1336fef@app.fastmail.com>
In-Reply-To: <20261029063522.124421-1-ebiggers@kernel.org>
References: <20261029063522.124421-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: powerpc/poly1305: Remove BROKEN implementation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 29 Oct 2026, at 07:35, Eric Biggers wrote:
> The PowerPC implementation of Poly1305 has been marked as BROKEN for
> well over a year, since commit bc8169003b41 ("crypto: powerpc/poly1305 -
> add depends on BROKEN for now").  So, it's not being built or used.
>
> The justification for marking it BROKEN was that it didn't work in
> softirq context.  That still fully applies.
>
> However, it turns out the assembly file actually also contains logic
> bugs that make it compute incorrect Poly1305 values in some cases.  This
> is shown by it failing the test case test_poly1305_split_update_carry
> (if "depends on BROKEN" is removed).  The cause of that appears to be a
> lost carry bit in Carry_reduction.  However, there also appears to be a
> bug in do_final_update where it incorrectly assumes v6 is fully reduced.
>
> In addition, poly1305_emit_64 contains a secret-dependent branch.
>
> Let's just drop this code.  A fixed version can be reconsidered later.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/Kconfig                     |    6 +-
>  lib/crypto/Makefile                    |    2 -
>  lib/crypto/powerpc/poly1305-p10le_64.S | 1076 ------------------------
>  lib/crypto/powerpc/poly1305.h          |   76 --
>  4 files changed, 1 insertion(+), 1159 deletions(-)
>  delete mode 100644 lib/crypto/powerpc/poly1305-p10le_64.S
>  delete mode 100644 lib/crypto/powerpc/poly1305.h
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
