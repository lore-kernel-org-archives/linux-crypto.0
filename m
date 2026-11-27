Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795815353;
	b=zLd1U1D+cNgdDTXJ8m/BtS5XMRw/t72ywK+Ut/jWDKd/io9Pv0bX1Iupm5rObe1BqPi7
	 XyDOYaJMPNvDasAHky0Jq3y1YOaPnxdt3Ew8+ZKu0JeaploZ94H31nK/srjUetVl0igHP
	 JHsjONRlqwhTXjXeuz/XoOI4nVoAZonUs75MfCtQLPCpJH9L5ebaWwHk/ZTIPPQzab+TI
	 td/Pyz2fovZtuE+RmQYZTtiJBlX6ldXBj2W4Ih4cjv8ACKIzM0phMZj4fTIxgPbCMv90G
	 NjkgZkPmU9CLan0FsQ+TVPeJWOfUSeHfaQAi7BrkNCZi4s32AWEKo+nN+qSb3ovA1eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795815353;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=63bqZkVkOjLKVFQpGMntsCT3cnQ/y4a0grXfCenbyZ0=;
	b=IqrPz8M90FYANxVpCpYjuEanqc/bYEkIucfzPlVCWcD5ajidgEJgTAXTJgc1C0KAzqVw
	 uphL6gbI13RFxRTzzqbP60FlInzy5e/PrOpT/E5hvSLFDRFy8Rebt2N0FMgU21A3pp/QI
	 EEqc1rDpYSEyyeLTpEiap7wUAkHQKG+sviHFZuD5WCG1lkTrVjHMRb6bkikAbWO9u4QmM
	 jFBYVbXdUo1yegU2xwEzfpPuNdpXgunZ6AqStl7wOjymDZUPz+9Bba37dqfqy1DSDzz3m
	 PXja7zsfJSbIzdRyBpbhxCQZXqJ37WdND6Jt5Sj8qJGo7FSEMkU5YNJT7sAWciWgZuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HCLcEL6+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4E6E9606A31E;
	Fri, 27 Nov 2026 21:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HCLcEL6+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 165441F00899;
	Fri, 27 Nov 2026 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795815352;
	bh=63bqZkVkOjLKVFQpGMntsCT3cnQ/y4a0grXfCenbyZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HCLcEL6+YgZwnaUCRjD7JdN1DITmB88m38Olac3hqmsq+oymXDsEadFvGzlhV0SBD
	 lcBW3O3JmPG5XWNkHsi8/YsTMTSEiZsNFZfU40JLGOH4SHYyYMFNuE4JapXMdJYwcC
	 o1ZTKMfCEjj9IwXXxe9A9bQCasHRUdxeRA1Rw+1UAJBwqVtvooH3/nZbZw5sBt+naB
	 3ek0K/801MEL//1QELcJUJ16IlnwCnBPzu3/6NzA+CMWVl3FnC4Suc+/vlaB/Wbxkv
	 dbHDIk68t3cHPW6TubWm0qUUGMM1/TQFxfr7r6mK3+QGQ9Sc9Hvh5xjuozFJLqMaE+
	 rUNJRJYveLW8g==
Date: Fri, 27 Nov 2026 23:35:48 +0200
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
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan McDowell <noodles@meta.com>,
	Lukas Wunner <lukas@wunner.de>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v5 00/17] KEYS: trusted: asymmetric keys
Message-ID: <awn3tIYuqM-J1tXz@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
 <20261127193133.GE8300@quark>
 <awnrj-s1qL0Bw0nI@kernel.org>
 <awnugO__1DBkLlFe@kernel.org>
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
In-Reply-To: <awnugO__1DBkLlFe@kernel.org>

On Fri, Nov 27, 2026 at 10:56:37PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 27, 2026 at 10:44:03PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Nov 27, 2026 at 11:31:33AM -0800, Eric Biggers wrote:
> > > On Fri, Nov 27, 2026 at 07:55:45AM +0200, Jarkko Sakkinen wrote:
> > > > OVERVIEW
> > > > ========
> > > > 
> > > > Extend TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
> > > > (OID_TPMLoadableKey, 2.23.133.10.1.3) and expose keyctl pkey-operations
> > > > directly on key_type_trusted. In addition there are some TPMKey
> > > > interoperability fixes.
> > > > 
> > > > I.e. this my old series with a twist: instead of introducing a separate
> > > > subtype for asymmetric keys, factor out pkey-operations into a separate
> > > > CONFIG_KEYCTL_PKEY-feature, and wire asymmetric operations to
> > > > key_type_trusted.
> > > > 
> > > > This work was originally derived from [3], is direct offspring of [2],
> > > > and folds in the prerequisite tpm2-sessions and tpm-buf cleanups from
> > > > [4].
> > > > 
> > > > [1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html
> > > > [2] https://lore.kernel.org/linux-integrity/20240520184727.22038-1-jarkko@kernel.org/
> > > > [3] https://lore.kernel.org/all/20200518172704.29608-1-prestwoj@gmail.com/
> > > > [4] https://lore.kernel.org/linux-integrity/20261116005105.1573016-1-jarkko@kernel.org/
> > > 
> > > Could you describe the motivation for these changes here?  And also
> > > include more context directly, for people who aren't already familiar
> > > with all the earlier patches linked to above.
> > > 
> > > Also, this series is missing a base-commit, and I don't know how to
> > > apply it for review.
> > 
> > Sure, I'll do that if this moves forward.
> > 
> > The feature allows to provision an external key so that private portion
> > is secured by TPM, and used for e.g., signing and authentication. One
> > example of a program that might use this is iwd.
> > 
> > First, a parent is needed.
> > 
> > 0x40000001 (Owner) primary following TCG H-2 ECC P-256 template:
> > 
> > 	tpm2_createprimary -C o -g sha256 -G ecc256:null:aes128cfb \
> >       		-a "fixedtpm|fixedparent|sensitivedataorigin|userwithauth|noda|restricted|decrypt" \
> >       		-c primary.ctx
> > 
> >     	tpm2_import -C primary.ctx -G ecc -i key.pem -u key.pub -r key.priv
> >     	tpm2_encodeobject -C primary.ctx -u key.pub -r key.priv -o key.tpm.pem
> >     	tpm2_flushcontext primary.ctx
> > 	
> > Alternatively, a persistent handle can be used. This follows TPMKey
> > specification recommendations.
> > 
> > Then external key can be imported an used as follows:
> > 
> > 	openssl ecparam -name prime256v1 -genkey -noout -out key.pem
> >     	openssl pkey -in key.pem -pubout -out pub.pem
> >  	openssl asn1parse -in key.tpm.pem -out key.tpm.der -noout
> >     	HEX=$(xxd -p -c 0 key.tpm.der)
> >     	TPM_KEY=$(keyctl add trusted tpm-key "load $HEX" @u)
> >     	keyctl pkey_query "$TPM_KEY" 0 enc=x962 hash=sha256
> > 
> > 	echo "secret sauce" > plain.txt
> > 	openssl dgst -sha256 -binary -out plain.sha256 plain.txt
> > 	keyctl pkey_sign "$TPM_KEY" 0 plain.sha256 enc=x962 hash=sha256 > plain.sig
> > 
> > > 
> > > - Eric
> > 
> > Another document that is source for what should be supported is:
> > 
> > https://datatracker.ietf.org/doc/draft-woodhouse-cert-best-practice/
> > 
> > Althought, I'm not sure how relevant this is anymore.
> 
> One other thing in addition to decoupling pkey operations that could be
> done as part of this would be to modularize the documentation, and use
> rst file at Documentation/ to include the snippets.
> 
> I left documentation part a bit stub as I started considering whether
> to do this or not. I.e., do it like some of the GPU drivers manage
> documentation.
> 
> With all these backends it's getting messy.

For tying in PCRs or system state in general it would be best to
implement policy command intepreter, which is a blob than can be
supplied with TPMKey. It's not a big leap from this.

It could be also used for regular trusted keys and benefit over
special parameters would be that it keeps the keyctl interface
backend agnostic (as e.g., PCRs bindings come with the data).

Br, Jarkko
