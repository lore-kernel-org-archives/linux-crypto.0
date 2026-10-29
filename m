Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267080;
	b=LQgN9+y1oC6gLhDXQo6KBogw3Za3w1yAGrmlWE6qtgEBLe4cLZE4M+Tr5Vjtfag/nyIb
	 NGrhoOi6ul3eHlUbZE1zuBR7Reo4k67cvLIlGWauJzxKOEWX3JdFEo8AyEznJP/j3pUQh
	 t/QAF8ftNn2GJsfD3aHVlga+ASC/MMg3i6RTNjIS6wQWsjakH7VJPNxN2TmfMH5dxqU23
	 ACeyNu2V+S5Pw/vBC5Jn+jk7A4ujI4CjcRNRCAz8KdEXUBH7NhxdRT5go290mPx61y5VN
	 CrDflz5k/k3srzxjByleDKz4i/Se9UsLUD6LeUui03sMVC31KcBQmoVP74Oe+iB/KoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267080;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=uPXD7QeS0HskGZ/AVkbvcgMY9zKIqVFFNn44kIMWSxg=;
	b=iyQt2ZornvTM6bWFpuo9quDQfpzDtAhKEI4tJiXq+cMrf0jUG9DUXNw5GGIoG46Vvibr
	 HOC84DceW017fp9ryARGRGf/RCvJFxLDU60CMBBh+ldpG3Y1sotAb5z5UIBvbq+OiSlII
	 yD5L0neTXismerci1m9Hq945WwhgEZcCfXTBhYQTKnayJztQi9U3cavxODjjczJ4oSL4N
	 Rx8SirNMFU+d0Fa4wwm5m3KgQB1trmcwUrjzSjJdTWoC+OIrqAuGwQuZ9viR+xH/riKpS
	 k2QCImlycYrMxrWwxDMBvk25L2N5/1K0DMabsN3ebusq7WNfwz8NQbTqnXUkT/HfX+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsb0NUfq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7580D606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 09:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsb0NUfq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D931F01828;
	Thu, 29 Oct 2026 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793267080;
	bh=uPXD7QeS0HskGZ/AVkbvcgMY9zKIqVFFNn44kIMWSxg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gsb0NUfqD3a3jDl27uu23uCxj8v1tXsxsKAz4ieLS0DhiC8WIn7N8weaH7ONi3PZV
	 +3RqHM3NSpN6POsj3qE1Oo1tkCCKpNHOrWh/5d4IFgtWHYAG62pV37RchKZxCUyFrf
	 M7jWOleUT3gRPDjSTJA6KKh9rjXiA2GX13OuP1cgAVRXO202eNFS4uJ9seLw8Mp7vg
	 6zh1R2IYbmaQ5/ZB5/tc4uN894gVwZYeIpZzdrQVyeyEim11u153e0jkiAbGiRK/4r
	 Deu590FZTZaX54Eln8OUWIojcXAbjr+cMNB8k4aS+hI3idq9g7LLFbIsc/6j0v4re+
	 z/SaZn7vORhUg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id D5438198003A;
	Thu, 29 Oct 2026 05:44:37 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 29 Oct 2026 05:44:37 -0400
X-ME-Sender: <xms:hBXjatGMgWBzvxw1Q_lExQjz8SbfE7dNelRMuwjGP91RIsGuBe-dAQ>
    <xme:hBXjatKO52W1SFRsRKoMALUv4LtJ_-DMYFapw3CFsmRm6KNA4SbcY0UY658v-XCmT
    phO12dLK9ssbPtNEUM3yqNoGxtFWsYdnwhoeAXBgQhfywYSFF9FizqN>
X-ME-Proxy-Cause: dmFkZTGjlIgHXMKEZYBOHTsLlp7+Kzuvn3BTGybXF/g1Jzx+jT+GDp2KVjZm5736TSeq8V
    3R1aCV47VRC7j9tuumrbwSGEikDWAjsDvlom4aR8HMlh4R2mC76eHAT1e9r06VPgwkzBEB
    X3xa1khPBAIvpkkjFI8zkDLmPMBwWzV2K0pvlYLBjQyU7G4sfon1Hp3XGHnAIBWF3AeFLl
    ik5Et66z/5aiaRVbcKhaSEXqOdTulKRyquid7goHwBSqUNdljYN09vLkgFJMfMRhopDCcQ
    d/Txmq5TFv74lui9Wi+GKgCE2AeZwRdrOyzFJRKjUuWBYADDABIZp2FZF4ybF04tl8SJJK
    gOC2+U9koFWTft3jqdeTVC4lFjamdpQbJ2r6IO+zwjp9z96lXQZVJ+tbv5ff396vhRyjnK
    +P6VJ4Wt4oqvsz1SwXL2xi8heEQm3SBfJZWLhTxJQzeWtPxnsq3WbRqWEm11b/Y/CNUldn
    SoCszZrorypgJTQXDAS3HSMqtbsrG+lX5Xq5UVS5rE6EswQdvhXuJrTObu1JvAIFw4xJvC
    J24FNlYYqzT81vr9ZJpR/EDgl+Gkj8vTH2lfv3eV8T4O1e8KyoEQDROr+2GIEXpLYgKu6J
    09BwVxpN4f9OmI8388vQLGN2O3974MJio7lwYJ/uz+ymiT+PVUp2my1qyCXg
X-ME-Proxy: <xmx:hRXjauxjDQd6-erI-UCq72-LyWdP8mVBbQhK9ljHml8PNJbe-mFufQ>
    <xmx:hRXjahJ6Nul1m8rKhCOk7QPfSip_KwZkYmG5-9GWsj_ZdPb14tk0_w>
    <xmx:hRXjaoq4iAUe7Af4BYeVuqtzbkVEpKNFLzmRoZL8YrDmy4139yUZTg>
    <xmx:hRXjagK524FhhTPcgADkLuDVI-iqxUUbfsGI5f5km7C5m6c6Cci26Q>
    <xmx:hRXjatROszGHFL1ACou53I4TXasqZCUs4HoBdm4OqLcL7WDPMcuLpAOL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 94067F8008E; Thu, 29 Oct 2026 05:44:36 -0400 (EDT)
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
Date: Thu, 29 Oct 2026 10:44:16 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <5b340d9f-04c9-4ace-9983-be30c11ea75e@app.fastmail.com>
In-Reply-To: <20261029054534.68481-1-ebiggers@kernel.org>
References: <20261029054534.68481-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/3] lib/crypto: mldsa: Address some minor nits
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 29 Oct 2026, at 06:45, Eric Biggers wrote:
> A few pedantic fixes for issues found by LLMs.
>
> Eric Biggers (3):
>   lib/crypto: mldsa: Check pk_len before doing pointer arithmetic
>   lib/crypto: mldsa: Explicitly check that 'alg' is a valid value
>   lib/crypto: mldsa: Add __must_check to mldsa_verify()
>
>  include/crypto/mldsa.h         |  6 ++++--
>  lib/crypto/mldsa.c             | 15 +++++++++++----
>  lib/crypto/tests/mldsa_kunit.c |  9 +++++++++
>  3 files changed, 24 insertions(+), 6 deletions(-)
>
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
