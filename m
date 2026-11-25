Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795633426;
	b=U+pqE678dlvvf6wJ1AAtwfm3KhvDezasUSkyp0tEcJtZf78mTZz/0eyIWp7svk+jGF9r
	 TmEnjLrktmYExgsICExfqPF4ACFLRq28luCC7K99SL82HYf9uiDBIL78F9T9CCxrJ1qGF
	 xS9dpa0Px8YOZII56xNBUK6Dt2P0Z6kVWXxUxVSbkqUKcdWiU11SX6LgTD4neXVQ7jyGU
	 K7IFEsfyXjs5i0dXfyLuFqtsguccSJp0RSB2CSGv9c8+VTnVjmR9P1y6O8qicJMRWyASS
	 NS+7oWqqadMXYBKkLGIE3kbDHEpBVLWxkTpuY96k0A7UW9i/0+Oiw3TJROlIQwvtiqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795633426;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4MaPvgKVZCcMWDL6Ly66oZEIvRgiDQKBgthICdO2/P8=;
	b=NupHMzAEWZXe8QIoXlPja9QdeSmTtBjCu5nwLp8sBKP/slYegZvWeTiIi1kS8K/I6emR
	 an4paEq7VJ2nuHHNCHtLjdazqO4yar48jor9zurUWDwEYLoCmgIChbnfMIlyCU6wG6hjT
	 SOykveMNsSIkscWp8qtjW9SCwZGfMO3cNSpoawtS9ouRlmV4es5NwcNspfsLk+5BL8aeG
	 A+FQXMgM64XPK0wzuKfSoutDIt2QifcRCwWP4vFzT9YnXcur9ReMdw6QyeBUgTgzrfSHE
	 Rvt0/y0RmNPwykjk+IIqKRHIp/31jlwPj0+NNr33XR+PykjbkPR4r6oz+UeEBCRY2GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nWuH4KFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8978F606A323;
	Wed, 25 Nov 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nWuH4KFZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6632A1F000D2;
	Wed, 25 Nov 2026 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795633425;
	bh=4MaPvgKVZCcMWDL6Ly66oZEIvRgiDQKBgthICdO2/P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nWuH4KFZO8S0O/4SHbn2b3WK4aojvPhQmQqdgN3WtPtUITc6e1JicTF7XwBffCoKB
	 L34T+bMXzFbgqVUt9xtQyC2sz51z55oAQ5RpO/gHmj3atEbz8dsFZDsUt+SxrGHlqH
	 eZaH4ljV3XJJ0NUJZo7I2ezxwAhethZJIO8ACDTmYG1yn5lWG2qAnSCb2rNsn9JtHv
	 cP0kkiwRonsG8SwhgB8iWpxN53/fsr6EDYsEvnsKj0/NTA01Zae0nhdF9C8hVWNCYo
	 xKPXdeUpSHyjfPZCE2FpYfy8ZefYztU6RevqxAGdX74iV1dPvtNAwy3e/YhJsT9bzX
	 R7SAMPlN3N1qg==
Date: Wed, 25 Nov 2026 21:03:42 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v3 8/9] KEYS: trusted: Factor out TPM2 blob loading
Message-ID: <awcxDq7TrNmzFxjl@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-9-jarkko@kernel.org>
 <sashiko-outbox-233944@kernel.org>
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
In-Reply-To: <sashiko-outbox-233944@kernel.org>

On Wed, Nov 25, 2026 at 06:16:23PM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Low]
> This isn't a bug, but the commit message only mentions factoring out
> tpm2_key_decode(), tpm2_load_blob(), and tpm2_buf_append_key_auth(),
> without explaining why this refactoring is needed (to prepare for
> asymmetric key support in the following patch).  It also omits adding
> payload->private and trusted_payload_free() in the core trusted keys code,
> as well as the new public_len < 8 bounds check before reading pub + 4 in
> tpm2_load_cmd().

I agree with this and his has higher severity than "low" because patch
needs to be split as a consequence.

Br, Jarkko
