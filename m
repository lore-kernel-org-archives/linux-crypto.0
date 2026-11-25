Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795644633;
	b=zbINbZDTIm358XMssYkPhKrB9LMwGQf+m8rOgPoCBf1krT7sBOGRTFoF1cD+hXS8/V07
	 gBNXXkW47FLNJ4SZ0rVaLB1+4fEbszbIdJM38OxXmHAshdUI+z1lb4tIzVRHsG3bSEhUt
	 nMKYGTqaZhQ214+slxRvbRout7Gn3dDLbQCa5e5uub/FyrHZ4CSDGngACR2gJOEXO88RV
	 Xf6cxcL/KsNAdGCS3cFDdop3otvBwizXZXlSxMvg+dzuH5VD71gHgar9jvY3eaciooT3+
	 qSqm88WyLeD9lFPYQcKmc9b5QEY62yXBPXacD1vowVcm5i2n5stKkf+DWNXXph+MtXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795644633;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HSHUYSAKe2yMTBtSGFVKjWD8rNTq+HH3Hx/MlNX0q80=;
	b=bDCoraCuNjbV2N0rvC6aczeQByE3CSJu8sV1LByYU3ji28ygCF2o08NgyonH2oTl/tjV
	 pjPH8FctFl/5iz3Gn6sL7wEy0Sc4Xmvp9GH7lXyevDm8Ur0LJT/Re7BoQjFMwfV6g4XFP
	 mAmIKyhIirmB8g8Eoxx+sKLWC+7uu4CeOUpXzmoq8RA/fUfiuSlRM+93UEi1FL7INjtyY
	 0FbiLnkmI0WAOWhoydE+Q59AZjvzROXoR4wIlEhu4CsA/3z0/VEnCXC+xVYqMNKmV/f9F
	 u+WC2na/3PIWCDXJf5SIQpFYMkVEco2ttVGb+reARXRkkTZ/NsCum7OXZrY/9OHAuag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hf+8p3yj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D2ED1606A32A;
	Wed, 25 Nov 2026 22:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hf+8p3yj
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9AC521F000C4;
	Wed, 25 Nov 2026 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795644633;
	bh=HSHUYSAKe2yMTBtSGFVKjWD8rNTq+HH3Hx/MlNX0q80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hf+8p3yjBQmkFdqzDqRGCdc/Kw7VJnWjauP4BWPSdrBnME5F+/8HwAiVOwwK5FLYR
	 nxN9Rau8JRv4oGJrBX6RBc/HO9ObnB9LezNhFVoULBNWVC0czVcf0VTdeS23VxLG5n
	 xOveEKOcE8jFKJdHBIJokiTLhRU/e1DaTMYVfX0wOhOAFsX33ADJ7wSeF6tnIcYcKM
	 kkArb/irEn1RhrVBegtpBUPtjT1OsDtJQzFQAl9fJ5kZUrUMUaeHmQpUEChD03IDOU
	 BaspgZhpp689cUVYVu6ruJOowfU02VCiSLEnwUg65EGHFe7LDxpDgQBOlKEqD65eWY
	 jUh/a2jbUDX9w==
Date: Thu, 26 Nov 2026 00:10:29 +0200
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
Message-ID: <awdc1TmFwwICFmR7@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-3-jarkko@kernel.org>
 <20261125091921.4bf40279@pumpkin>
 <awcBD-bp27JCVpc-@kernel.org>
 <20261125213333.23eedef1@pumpkin>
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
In-Reply-To: <20261125213333.23eedef1@pumpkin>

On Wed, Nov 25, 2026 at 09:33:33PM +0000, David Laight wrote:
> On Wed, 25 Nov 2026 17:38:55 +0200
> Jarkko Sakkinen <jarkko@kernel.org> wrote:
> 
> > On Wed, Nov 25, 2026 at 09:19:21AM +0000, David Laight wrote:
> > > On Tue, 24 Nov 2026 21:40:36 +0200
> > > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > >   
> > > > Add a helper encoding a positive integer from a byte array in big-endian
> > > > format.  
> > > 
> > > Interesting...
> > > You allow for integer values longer than 127 bytes but don't allow for the
> > > much more common likelyhood of the encoding being 'implicit'.  
> > 
> > This is the first thing I wrote in 2024 and have not touched since
> > without further feedback :-)
> 
> I wrote an ASN.1 encoder/decoder for a tcap library a few years back.
> Pretty much everything was implicit and some of the tags exceed 5 bits.
> About the only things that needed multi-byte lengths were constructed.
> Oh - and you can't fit in a maximal length SMS if you use the indefinite
> length for constructed items between 128 and 255 bytes, you have to use
> the two-byte encoding.
> 
> There were a few functions for 'add item to buffer', but I didn't need
> this one.

TCAP/SMS has pretty much the opposite profile from crypto DER in the
kernel, which deals with big numbers.

None of the other primitives in lib/asn1_encoder.c take an IMPLICIT tag
override either, so better to leave that out until something in-tree
actually needs it.

> 
> David

Br, Jarkko
