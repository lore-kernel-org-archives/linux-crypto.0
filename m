Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795561665;
	b=ZnOOxnYRMlaGTRh7UFEoPI4b2cocRoIEk8oD1Qr5YV1h67cy29WxB9ix1wyBYFeRVueX
	 6WflLrZQ0yGglSvUOpLZA2N8TQjg1mpLMyv5XlbjhLH8/1ew9fuGxWqA38x5wyDeymWzj
	 QH0Vn6dwx2caqCG/4+WUgGCDDqG1b5lIZIhJFaIGRLqE2ZgTuHz3Jet3is9aGCWrcRHxi
	 4vhXrm3tfN3Hzkl+rVSGybJGfRkqMclQdhfSw/bLFAteQdocOClcStgsQvk6gaZWn+znA
	 5xB8fGY9h7xvqlwaeF51Gbo56DHzxd4xlVqL++CxyRaZ35VAdNIb0oYblNDkgKCvIDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795561665;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+1ShINOhrETVckZgwkDQ2yDcTAY5roVvnqnqdvL+Hbk=;
	b=sTNKiREt5E7Ijj8nD5jPS62/i59+NwkTiq73IYHiDCq6sdjPmVfb34ZreB6j/eP+YzUB
	 CqCgdDLj01MQI70AOwCoDTzJ4Qaww1KXFQosz6BBl4Q+p5fcGZA6CkO3HbajkRceOpGoR
	 Ua++/EIRj9XzIBmB2+fnX1SqKuuF5uEf/X0ITYoKZpkzAOOhSEsQtCmif4pc6d25Ts1HO
	 hmB95eNe2lduJJCTmJ+rnw+nlkpn4KGPIiXJybO9mYLJck8hAt+tpRc3u5kAaau4HYA/R
	 4nNExNE27B7WSparM8mOy7N55eZj0+pWCwsFFPVZ/+Dl/bkkJGSNbQAmU88VijnWx1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVQjkdi+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B2DA4606A327;
	Tue, 24 Nov 2026 23:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVQjkdi+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BB17D1F000C0;
	Tue, 24 Nov 2026 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561665;
	bh=+1ShINOhrETVckZgwkDQ2yDcTAY5roVvnqnqdvL+Hbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dVQjkdi+8IRvs0yX8C9we8uPqfWBw4PBtDidtovyXGmo6jzND4pqoWA5i9nS9C16q
	 QmLLotzAOsH2d0e60fdXLQtsyWOyGdQCIec0Ay0nbE7jmq22QyPYcs8RZ5HwD3Xi9s
	 1qykf2nNARtiKwl0Mlk3Oa8IpONRCgo8OPbdnFl6ggM4gbpUbqOiYI0zGyt0NHq86+
	 2KqZuQppqAg996IAnB+YYMytFDCsHeqTsjq1nEzBb/xDsgy5GH137DtiREGq1+rj+V
	 J6JKuWDX6n5j3AK4UQWTIKSlrTAhrhnf/UMaJd2hHtqM/9yygrwRJ+tYb39hwxi7IN
	 HIZeeC4eAP7fw==
Date: Wed, 25 Nov 2026 01:07:41 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Subject: Re: [PATCH v2 6/9] KEYS: Factor out KEYCTL_PKEY
Message-ID: <awYYvQwk6AWHhtNU@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-7-jarkko@kernel.org>
 <20261124215035.GE2227373@google.com>
 <awYLCuCIG8--aa2Z@kernel.org>
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
In-Reply-To: <awYLCuCIG8--aa2Z@kernel.org>

On Wed, Nov 25, 2026 at 12:09:18AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 09:50:35PM +0000, Eric Biggers wrote:
> > On Tue, Nov 24, 2026 at 09:40:40PM +0200, Jarkko Sakkinen wrote:
> > > diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> > > index c73979b2e98e..1c78a9a663c5 100644
> > > --- a/crypto/asymmetric_keys/Kconfig
> > > +++ b/crypto/asymmetric_keys/Kconfig
> > > @@ -2,6 +2,7 @@
> > >  menuconfig ASYMMETRIC_KEY_TYPE
> > >  	bool "Asymmetric (public-key cryptographic) key type"
> > >  	depends on KEYS
> > > +	select KEYCTL_PKEY
> > >  	help
> > >  	  This option provides support for a key type that holds the data for
> > >  	  the asymmetric keys used for public key cryptographic operations such
> > 
> > Could we use this opportunity to give CONFIG_KEYCTL_PKEY an
> > off-by-default prompt like CONFIG_KEY_DH_OPERATIONS, please?  There are
> > a lot of systems that need ASYMMETRIC_KEY_TYPE for verifying signatures
> > but don't the KEYCTL_PKEY keyctls.  The fact that the KEYCTL_PKEY
> > keyctls get pulled in too has always been a huge problem, given the
> > additional attack surface they expose as well as other issues like the
> > kernel's RSA code not being resistant to timing attacks.
> 
> We can do that.

I'd be also interested to hear, if there are any wishes from non-TPM
trusted backend side. Thus, increased Cc-list.

Br, Jarkko
