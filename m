Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621139;
	b=aHuZsH7Y83BJg4c/t9ikJ+e7yvMpaDcaKK0s96GW1Nkhjm3/WfOkfCEQnsR0YiqgNC4i
	 RDrALxYDgzfGt0/KZLMZtn++LyKWqQoEV/M+rgFoeZmFmOlEReG+Rbr92Obd7h5vlhvzz
	 a1g64nXmdVS+g23/YETeHDfxW1t3WQ3xSvBGSIiFsbmC9yk+pa1zb6Anv4FTtnq8R0z9b
	 010fxTFrBH9tLrkd/r6kb0Zjmkrg84Pd/o89r0LimqUhLW9Rj8Qhk4x+zeBGwkrSDWvCo
	 7l4URAu1AEP1UL3nmH+abSZ/VLQOreGvTjpVcXDVukA4dSjNpAe0SL47cLHW4R+yByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621139;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LOGY0hZnpFwEaOhuB3IIZhLALqVjR5JHtYG7Io23+Jo=;
	b=R9orAIQfhCrgI9ZrgmFjx41fyLAzS91VRBl1AeoltLb+DWvfBVuHcTPzt0e+o+WKK6eF
	 zRj51/X3CNfbghEldUkywCdOf6VzcibuPTEozVlEYf+/2CwBac6XRNwo6V+F4vXwOhJDW
	 Ys6yZwHrIdDF3QKOIGSXNrW5KmbUi15oLSubTUNTNFCzU+54TFnqhroubrd84Ax8FyBcK
	 XJTpjyNE39pblF4vneUCUETCbCH2P0ufcyXkvNCw5TG4235281oMqBaDhXL18IeR4QHkH
	 a/85mlYJjYWlJKU86RMgZIvPIIOM3NVeuR6p3Cnt/BusqxDdSB81EIK1FqfKDOlkfoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INCIqH0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D3019606A321;
	Wed, 25 Nov 2026 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INCIqH0r
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E23EB1F000D2;
	Wed, 25 Nov 2026 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621139;
	bh=LOGY0hZnpFwEaOhuB3IIZhLALqVjR5JHtYG7Io23+Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=INCIqH0ryZAtM7z39Zm4RtbAYtyDGoFJQZudEZQc1DwarELaQvBjpHn0L3jLibE4f
	 Fs9VyGZBJcbvJQoHDIN0U+4Ro5XoiVng+82+0CB7Tn9gzikkFdQD1h9KKuK5HZBJiE
	 tPKwn23CuEntHzZdvApiB6FP3B0GBxjnjEQPC7IiF+cQkGToMlDjHEOUP8ShMArqII
	 TEFAHi3XqVdRc/97WJ6dDUsS1BfB5h8jB4RAx4Q4qeAnFGn1Irjy0b/fr0Bq8zrOzt
	 pWq60abFhwrsnEIonLZUJ1Mug9t/c/qQxh5bZi7Zpux2uCKPE+vnysqu5oiDf6hqKZ
	 AEuZyo/hpE4Og==
Date: Wed, 25 Nov 2026 17:38:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
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
Subject: Re: [PATCH v2 2/9] lib/asn1_encoder: Add asn1_encode_integer_bytes()
Message-ID: <awcBD-bp27JCVpc-@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-3-jarkko@kernel.org>
 <20261125091921.4bf40279@pumpkin>
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
In-Reply-To: <20261125091921.4bf40279@pumpkin>

On Wed, Nov 25, 2026 at 09:19:21AM +0000, David Laight wrote:
> On Tue, 24 Nov 2026 21:40:36 +0200
> Jarkko Sakkinen <jarkko@kernel.org> wrote:
> 
> > Add a helper encoding a positive integer from a byte array in big-endian
> > format.
> 
> Interesting...
> You allow for integer values longer than 127 bytes but don't allow for the
> much more common likelyhood of the encoding being 'implicit'.

This is the first thing I wrote in 2024 and have not touched since
without further feedback :-)


> 
> David


Br, Jarkko
