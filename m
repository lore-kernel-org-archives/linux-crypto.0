Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF5F36BCE2
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773044296; cv=none; b=gvJRkiPx+Pxqki9GoEa3FDOjg+BycdZDGehZIW85Te5Ud6Csgw03+v0uc7AGtxjVRbmh/Q/enLD/d05c81sTJyg73voPUn1oPK/h9yLejGsqnW4ubP7jIz3I9GuFBGaeNDEDBL6npyIdOFmenNMva5+ybIyBsaVZiZSOMLOUy7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773044296; c=relaxed/simple;
	bh=tx9y+a/9zyDLRv4A8l8hxMlo4xYE8rdCsGn/LIQcLrI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=leJYdWGQLzS4ZL85luuoB3Ju/rQAD3s8SXnLkkthAUHFfn8wNkJAARmxKBZsTR61PRG7WSzT9vNaKqc+Ft3rw0F4t0KkWYo91B5xa2TrUF6d643E9sd51Rbp8UcixjHvE0fuBJr2XXqQPyQWJUr+t3t4vh9ceuTe/H0KcXvguDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/ZsGdd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/ZsGdd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E403C4CEF7;
	Mon,  9 Mar 2026 08:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773044296;
	bh=tx9y+a/9zyDLRv4A8l8hxMlo4xYE8rdCsGn/LIQcLrI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=E/ZsGdd92TxOAwdP/znvK6YIFs5tm7aylwHepuoxRqrE3XvZPeqCtH43JLHr9rLlh
	 cieOHpnfsSb/lT7vqZ0ueKir1nWiMWXwTFaVzJxdp6t1R6e1Numsc8WpYqsZvvxo8v
	 m+541FMh5HW0ea5ITfolyF8jSOGbNTuCJtmOEjC6rZCwfblkcrh2orKFrkdOuotcRZ
	 PLTuDd8Z9cM9tdMMAwO+zUThR4aCX5n6JjDLY/sLNzRGCtcZaZ82+S/oOzmj3DzoeS
	 12zFxfYsMvnpR7sCI3O5MUb8V3iAIixTBR0OzeY4cvBFO5mq7IiT8R26D9LshJ5KZ/
	 Peir52hnKMTxA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 86D94F40068;
	Mon,  9 Mar 2026 04:18:14 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 09 Mar 2026 04:18:14 -0400
X-ME-Sender: <xms:RoKuaW7s-6Tuk0gdbDX9-e7BsfnVFD0WkUu3qRmp3yPZxIlTYQutTw>
    <xme:RoKuaatSpcqac5woCQXZHvvbus3FegBK8M21szYXuRe1lpQVg929bZtSNsLlQap98
    eDCbpaJYGYvdV6imfqZS9P1Oi6iCl217ynv8EN7jJJ_Zs-RB7Ik0Co>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjeejieduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    udehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvvghmsegurghvvghmlh
    hofhhtrdhnvghtpdhrtghpthhtoheptdigjehfgeehgegtgeeisehgmhgrihhlrdgtohhm
    pdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruh
    dprhgtphhtthhopegvughumhgriigvthesghhoohhglhgvrdgtohhmpdhrtghpthhtohep
    khhunhhihihusehgohhoghhlvgdrtghomhdprhgtphhtthhopehntggrrhgufigvlhhlse
    hgohhoghhlvgdrtghomhdprhgtphhtthhopegushgrhhgvrhhnsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    ephhhorhhmsheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:RoKuaZ-SW6yirdn7d3YjG-selUgyFOYxSARBOYAWYWOezbDR-KPVsg>
    <xmx:RoKuaTSn_2hDwsrU6qJpZgy30JCfs1bCPfnxzaDSHD2B8Z_iF0nCFA>
    <xmx:RoKuaQlxVLVdpWUb5koxOuvMzxWbrw01i5UeoBcgem5P9CimApBhvQ>
    <xmx:RoKuaeV0VPT2Csz8Rsqctl6OvTyktmZyqofUlxYn0mpovulmJDmSzA>
    <xmx:RoKuaVefE7hxtbBV3r_ecTBbpA42iL4_wSZdwJ8jIWz_RPakfem1otI6>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5E666700065; Mon,  9 Mar 2026 04:18:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AnuwgGJK4Cyg
Date: Mon, 09 Mar 2026 09:17:36 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Eric Dumazet" <edumazet@google.com>, "Neal Cardwell" <ncardwell@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Dmitry Safonov" <0x7f454c46@gmail.com>
Message-Id: <5ed0c7d9-07e7-4011-a3a5-32d1e2b06e3f@app.fastmail.com>
In-Reply-To: <20260307224341.5644-1-ebiggers@kernel.org>
References: <20260307224341.5644-1-ebiggers@kernel.org>
Subject: Re: [RFC PATCH 0/8] Reimplement TCP-AO using crypto library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 7 Mar 2026, at 23:43, Eric Biggers wrote:
> This series can also be retrieved from:
>
>     git fetch 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> tcp-ao-v1
>
> For now this series is an RFC, since it depends on the AES-CMAC library
> API that is queued in libcrypto-next for 7.1.  So, the soonest that this
> could be applied to net-next is 7.2.  I'm sending it out now in case
> anyone has any early feedback.
>
> This series refactors the TCP-AO (TCP Authentication Option) code to do
> MAC and KDF computations using lib/crypto/ instead of crypto_ahash.
> This greatly simplifies the code and makes it much more efficient.  The
> entire tcp_sigpool and crypto_ahash cloning mechanisms become
> unnecessary and are removed, as the problems they were designed to solve
> don't exist with the library APIs.
>
> To make this possible, this series also restricts the supported
> algorithms to a reasonable set, rather than supporting arbitrary
> algorithms that don't make sense and are very likely not being used.
> Specifically, this series leaves in place the support for AES-128-CMAC
> and HMAC-SHA1 which are the only algorithms that actually have an RFC
> specifying their use in TCP-AO, along with HMAC-SHA256 which is a
> reasonable algorithm to continue supporting as a Linux extension.
>
> This passes the tcp_ao selftests (tools/testing/selftests/net/tcp_ao).
>
> To get a sense for how much more efficient this makes the TCP-AO code,
> here's a microbenchmark for tcp_ao_hash_skb() with skb->len == 128:
>
>         Algorithm       Avg cycles (before)     Avg cycles (after)
>         ---------       -------------------     ------------------
>         HMAC-SHA1       3319                    1256
>         HMAC-SHA256     3311                    1344
>         AES-128-CMAC    2720                    1107
>
> Eric Biggers (8):
>   net/tcp-ao: Drop support for most non-RFC-specified algorithms
>   net/tcp-ao: Use crypto library API instead of crypto_ahash
>   net/tcp-ao: Use stack-allocated MAC and traffic_key buffers
>   net/tcp-ao: Return void from functions that can no longer fail
>   net/tcp: Remove tcp_sigpool
>   crypto: hash - Remove support for cloning hash tfms
>   crypto: cipher - Remove support for cloning cipher tfms
>   crypto: api - Remove core support for cloning tfms
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

I wonder how widely this is being used, given that there are much cheaper options than CMAC or HMAC, and nobody bothered to ratify the HMAC-SHA256 draft.

Anybody have any insights?


