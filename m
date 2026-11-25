Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641916;
	b=sOjc/SFSv9fHr+qwVjcVkXxesevT/hUquV57Z4vc1AkMMgWa2hTtbY8H+W6dV85s2VNu
	 DNEUl8vwsBzo20jfIPTvfjK7XtNKkVnSs0lBcqRN2KlpMNNe6HGb/tn5P8Fd5Ttz3lmTM
	 k8ReqhFHjTMQOpVpRcKcYxIls/4AeypKH7V+vnNIsetwoT6PKKuN4YYk1fIkxY0BG7URo
	 g71NNQyDUDdQWus0qclNpvPRTd++UAXsIAe227BcGIcZVh9XygExc6b0SARk8t+jYoXGj
	 OF1s9Ub3Yjj3PCivGodtyISrlUWuLsP4101QUnJaF9eZLyibz+cCS+n6LNtqiuBeOSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641916;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TqW72sqF2Ix7p9Aq00fDLCTE7CkGbgZAXL0cSxjcpII=;
	b=bDDtduz66xDDiAIIFOG2HXuNlrXzHblmipNel+MJaNmpygMiws9RJvbcB42zWhKuiQyd
	 Oop7GnZJc3icF/crRsXyH1Q88Xn+d04xP8ASRIGcf02OEADdqr8H+iL4WYZ5q8+LpmVTB
	 km7gmzLbznIz6td+ijfLS4t88UNABzAzLM9BQe5QAeaY+hUa9e8inyQEF3YdX7EcDMipd
	 qYhkpj81rpJOzWneGg6w7eiLTkFFd1hgdgyvvvZuZDvb3XidKfNfyVXutphjGnAXUulaG
	 /25grYhxYM/rJcFEu/c7RSJSqHsAg5b4Cj1XzxKo1iGzvzO1XZD4Z62sk1r/900w2qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZZwbG0o5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 44C06606A321;
	Wed, 25 Nov 2026 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZZwbG0o5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 161531F000CF;
	Wed, 25 Nov 2026 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795641915;
	bh=TqW72sqF2Ix7p9Aq00fDLCTE7CkGbgZAXL0cSxjcpII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZZwbG0o5VnXPwi4yrKQKwNBYGo1ziXuMju5ZxuBT1yxn9EG0PM0wuGB27mxnfwKVw
	 OlwxUkWlP3il3XxqElvhtMpCIV5HHlOTlDReE7BDQ3D8J7BB5pk4LWX8ALhAzg0ti/
	 iVxGlxufet4uNziBy41IHO3jTqQ9zSAS9AX9UMy4YVBi6x6sX4GyPEnCGvNm8QcBfc
	 h+3wSHZL2P9com++ScpK9YrtL9hX5czW/F/XT+gOoQqa8epuPyAAT0JwQkrMjfqRYM
	 EHCfEb/ZajCX6bBp0NgLPVEWUJ6GxdycWxH0zBeciSBk4mMk3n7wjDmi2YEaG0RexU
	 T1JxT/dZvvTDA==
Date: Wed, 25 Nov 2026 23:25:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
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
Subject: Re: [PATCH v3 9/9] KEYS: trusted: Add asymmetric key support for TPM2
Message-ID: <awdSOLvJoBOmSg4h@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-10-jarkko@kernel.org>
 <awdQePZNGZQhNP5K@kernel.org>
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
In-Reply-To: <awdQePZNGZQhNP5K@kernel.org>

On Wed, Nov 25, 2026 at 11:17:49PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 25, 2026 at 08:06:15PM +0200, Jarkko Sakkinen wrote:
> > Extend the TPM 2.0 trusted key backend to load OID_TPMLoadableKey
> > (2.23.133.10.1.3) RSA (2048/3072/4096) and ECC (NIST P-256/P-384/P-521)
> > keys and expose query, sign, verify, and RSA encrypt/decrypt operations
> > through key_type_trusted.
> > 
> > The feature is enabled with opt-in CONFIG_TRUSTED_KEYS_ASYMMETRIC.
> > 
> > Co-developed-by: James Prestwood <prestwoj@gmail.com>
> > Signed-off-by: James Prestwood <prestwoj@gmail.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> It might make even sense to make TPM user space device opt-in through
> kernel command-line option in the case if these ops are useful for
> other backends.
> 
> Thinking more like embedded busybox space than enterprise systemd
> space. If it is possible rely keychains only to trusted keys, then
> the software stack can be translated between hardware platforms,
> even with different security chips.

This is actually *weakly* Turris related.

Could Turris signing key translated as trusted key subtype, if it had
these asym ops? 

This is just a good constraint to check so the right things will
be done right...

Br, Jarkko
