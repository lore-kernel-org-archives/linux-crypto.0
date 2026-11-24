Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795532963;
	b=MTT5tTv0rrRVeW4dOXB8E7LgPBa6PVxoN5Y0DpDOVpSDRJ+oN9pR/HsehJbPKHZuoCcf
	 RVBdwFIcOBqe4NOQ3EEN3mkbN8OHAqo0/PuLxxs3idu0B5Rl2CR97jfp6Rh43fVyED3u9
	 3Q11jP41NX/vJZFgI9Lp2cGU0mSOXQsdVDKV2pv0oiqTiUZGmrh0oigJZLsA/pBPcPoOO
	 AWpP+AG3iqQzhRml1hCzJpZD0H1Rv+TPRfnwe1XOfsH016DcSmqUpqiTCq08z5XpXQ04O
	 g+HqFE48BuYvoxMUmyZaDeW3AMhwHmhe8WXSg0dfroOecZ/BqCQ4Tk83j6y7vGPMeJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532963;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=K+IekPDE+jkqEoJ25TetgowrP8a4LUWhHnBuiLXn8A8=;
	b=D/ZQuH8RJb5ohZPVopFV6q1o+rlMLEWwXsjgY8PPSBC8YQsnnNthgHkBgZH1xymVO5+A
	 wOQsYEuDGfsnNZH4IkQVO/D8QRQOZ2FR/tm4AsmfByjRyjSxf5XUAd6S2qSAtdh9au5dO
	 L4H62+JNEH1T9yFam9BFtnOx16uKOELHA2oxAZTLAp0lMTmR0Rdmwd3px0rEQ7iSUdXZ1
	 pjtkslSLI6cxtgSIfswPF/xNH7BhNe3kf7Flds3VmRePn5jtKtZfLnZPoziHOaoJbktHG
	 c0ku1P5TgENr6lt/Mit5V1beeCjoF219CVN6SM3P2yjm5eUHpwiM+A8Fxt+LVbLz53g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AxiV7WZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3ED24606A321;
	Tue, 24 Nov 2026 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AxiV7WZS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 36FD81F000D4;
	Tue, 24 Nov 2026 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795532962;
	bh=K+IekPDE+jkqEoJ25TetgowrP8a4LUWhHnBuiLXn8A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AxiV7WZSd4PJ6njfHxHjci8C4W3rlHZiStM2FsIJxUt9/7C+Ank9ouOae768ogJKt
	 +S54ua88UepNEkPBO6qjzgCWCZWeSY7Nr1RNSJqOcNds+Ygoe+HJyxY11VPr0ZLXxk
	 iaYHYERsCjcwthMRREuWi033qD+cFkVBdv3YAl5YuA6D6WGV+a3YtT6hT9u5hLYoA8
	 02P71nq4V8c8pfqRkWRA5AXuZdmYn/SbEgClf0uNzk3s1IfiIu7l0hhXIe/KlG+hbA
	 Oj+FZwYYVRWGv5aCyggVQaFSCQHBF64t+o1e+Quhe9huy6dUrx1Rwf5Cj1zg3Ygmba
	 3b0AD2lJpQAyg==
Date: Tue, 24 Nov 2026 17:09:18 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	James Prestwood <prestwoj@gmail.com>
Subject: Re: [PATCH 9/9] KEYS: trusted: Add asymmetric key support for TPM2
Message-ID: <awWonunbfilZrzQV@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
 <20261124120044.1481752-10-jarkko@kernel.org>
 <sashiko-outbox-231131@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-231131@kernel.org>

On Tue, Nov 24, 2026 at 12:25:44PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] KEYS: trusted: 32-bit param_size overflow in
>   tpm2_asym_rsa_decrypt()

I've now learned that sometimes people expect you to fix these before
they will review, or they get upset if you fix them and iterate the
series. Someone will be rip their trousers whatever you do.

Or then, some gets pissed when some random bot gives feedback pm
the next day.

Since this is the worst of the worst I'll mark it down and let's
consider it addressed.

I like Sashiko but don't know how to dance the dance.

Br, Jarkko
