Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795633068;
	b=2p0pJ0Atc7TrNm4NlGmPcD3nzDtRQwZanOeayuUtm391VZtz+02qRo40760K/Q/NM6yk
	 Gf5ix93/4mV1xSV5gDCWqDTDVcjy5oPwCFGPCVZ9Rq87+hkXa2vaMnyW85pOXo5xttkfb
	 wpygiKLhIpOmiqPDHK9v1oIRKRFnn4ZRGJJSUNvVn3KIOOPZc2cX1zFuRsAVPJJHa4CZW
	 PlPBS2+b6fYxiMUBfW4LP5Jv8q5Gjk6A3qHRrlQidfl9CN2fDSxrtE97NhCTr/g6G6Gw2
	 BEmtunU2C6tCwLzgGAowktxXdUo4oiyFxRy+ZsyFch78zjiXMnEnW7SSofyekWo4ujg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795633068;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YsWJBo63s4NqS8g3cWsZjLOCVjptt4gIbSwypCCvLC4=;
	b=Gk75sJl/IXPjt9ZAVw6c/bfuuZpGwUNJE+iXN02q75UhlrWe8dBBr5VoItJ/4Ywz2jlW
	 EDj5c4i3xvwTMOQdrwCAxvPGxbMs3MptEuRmslcsxJBPDGScXHYT+vtNztPxwkkQiDg5T
	 3fGpSghj0AOpuu8KykFJ726pzYAXFWs5RhZFnDnENAse3V14OaTdKaZPG/k7q+jgUil0t
	 KxqAwArfVjusOnvZRBwPXNj/rjvIEAm+zuPxYS+NazYk2wLJP7mkwtthboDpR36g/cyEf
	 223tJCrUwpl+AYXzFJxTDNDI0fRwfxE9ek2tW2R5d+mUYu9jOE5wPAlbHPMCQVhLBXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIi+uLyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 82AEA606A31E;
	Wed, 25 Nov 2026 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIi+uLyu
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A4E291F000CF;
	Wed, 25 Nov 2026 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795633068;
	bh=YsWJBo63s4NqS8g3cWsZjLOCVjptt4gIbSwypCCvLC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lIi+uLyuquKHZOEaazGs6slxl5XQ5DrSQz8wI/BBOZ8cAMntXQFfWSKep4/kXctpV
	 pKu5QAoBKN8mW5M798V7G1ZZF6YXKFRoCek1dtRQVYaa+FuL/aO2ahoys0no1uipJ3
	 CCWOLfzeCWeqOqSz2RiqalZBh3a8iOw6L8bvtERkY4FvHkumhV6lvvKA7rVOHTmJ4C
	 Jy4YEUl0nQJoom5f10UFcmBdwiL/jNvDRqjHv8DWWWlUZDam0DOKSGdMRiHwVLezyX
	 KOo5lnLZTUS4/1e3tQN8swNoEXbyeygwfPaDEvZcMj4O9wzsLqaNYBH9tN8YWsI5xr
	 AYN63bQDNfx0A==
Date: Wed, 25 Nov 2026 20:57:44 +0200
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
Subject: Re: [PATCH v3 1/9] KEYS: Factor out opt-in KEYCTL_PKEY
Message-ID: <awcvqLlRgAoeG8iU@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-2-jarkko@kernel.org>
 <sashiko-outbox-233977@kernel.org>
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
In-Reply-To: <sashiko-outbox-233977@kernel.org>

On Wed, Nov 25, 2026 at 06:22:49PM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Medium]
> Should TURRIS_SIGNING_KEY, TURRIS_OMNIA_MCU_KEYCTL and
> TURRIS_MOX_RWTM_KEYCTL be updated to depend on KEYCTL_PKEY instead of
> ASYMMETRIC_KEY_TYPE?

Yes, and it make sense to add a level of granularity to this i.e., to
make on/off subsystem specific choice.

Br, Jarkko
