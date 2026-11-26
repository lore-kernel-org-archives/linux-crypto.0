Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795730580;
	b=a4RyzSy4z0GxySChewTD/Aqqtjk3iQbonHGx6WiN/nbd007Oc/WXNOsl1ODTJvp6+ytU
	 NhnB5St+tSSet8lJduKUG9v9h4KXNfYrT+3EqNCxGl7ZBHTGyDtE6L199n8ww4qi4t2E6
	 PaqU6HQzCmU1Wqcm/Cf+4Kne8MMkq2GzTlqJbkZ5jcuDZ9ZrK7oC4KImW/ZdxS0PRcWt2
	 zrNX9z+W0RI8Ik6H54riP9mLG63G+K5eKW0bMHfD6aoAavFMYA+2vcA7ELEqAUrN3m3Uw
	 rM/Rkr3IwQRN7StKncH2zEfYsONqZ6gLVvSukzRHhl/FYlPrGxucB/VboDA4dEPhWDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730580;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1GBNGDQ+Fpfo32tn2P/7vFYAKjTUM17/Hl82GZJuG7w=;
	b=yyENHXM1Hpf+mf2AKZxhfTMKYumtfvuwv4MpTH0ou8n6otUJU88V/ewwxc8XcssBC1oV
	 fn27kBTgzOct+F91/m+AyjInb/0TmXRve2GOHA1FCJMwQPBlPicMCBj/J3UMNqqI7i2Ln
	 KNm6++nzORs318nNZFY3ccGYZN4rfpAooCfbOppmofIXZfVc2iI3MInGI5+jxy2Ld91Km
	 Yw4argYlqnqnpZ3V4DbVO1cFOuiYGN2/s1BeQ4D4WW8vDX9kP66ia0TtUlfvT0HeJji7b
	 YUqqmSK815qWVI3SwWGU3w2hL7ULTL3JjBoPWDkdHFYXS8kSck2ElKbG4vUPDKZbJNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kloLMIr/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A1AD0606A31E;
	Thu, 26 Nov 2026 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kloLMIr/
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5CD7A1F00893;
	Thu, 26 Nov 2026 22:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795730580;
	bh=1GBNGDQ+Fpfo32tn2P/7vFYAKjTUM17/Hl82GZJuG7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kloLMIr/z/Btp/nwC2OoOb1UbP0q6ypeSKRdfR3rE2MOQIwKwBZ5o/k2ebOyed+du
	 Fkf1Bwx0tcxg47MqWNjZlglXVda8wXy6zPPSNEjpijpc6CnOMcXPG0D7RkVyvrZtrT
	 55DUghWoZGWkrbFSq4oPr3Br9F1+gzesE3SvwQYz4Ev+FsaekI9mSMVKU07JLaHEzY
	 N+VHwAxlEiviW2tGSPUWYjRKXy5Z6Gi0/mXaWCOWBdlRVdYFD1K1BlILlcOn3pXbY6
	 QvibMQz58YXXeaRaUHyppP2R9VnCh0J2pJ1AYmYERWMvzEDR6IPdZMyI2QSH5s8tWl
	 NNM3QO68EC3Rw==
Date: Fri, 27 Nov 2026 00:02:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
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
Subject: Re: [PATCH v4 11/11] KEYS: trusted: Add asymmetric key support for
 TPM2
Message-ID: <awiskMGvLb5HINaj@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
 <20261126205021.2200819-12-jarkko@kernel.org>
 <awipQFkjoBSEXnLh@kernel.org>
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
In-Reply-To: <awipQFkjoBSEXnLh@kernel.org>

On Thu, Nov 26, 2026 at 11:48:52PM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 26, 2026 at 10:50:21PM +0200, Jarkko Sakkinen wrote:
> > Extend the TPM 2.0 trusted key backend to load OID_TPMLoadableKey
> > (2.23.133.10.1.3) RSA (2048/3072/4096) and ECC (NIST P-256/P-384/P-521)
> > keys and expose query, sign, verify, and RSA encrypt/decrypt operations
> > through key_type_trusted.
> > 
> > The feature is controlled by CONFIG_TRUSTED_KEYS_ASYMMETRIC, which
> > defaults to y when CONFIG_TRUSTED_KEYS_TPM is enabled.
> > 
> > Co-developed-by: James Prestwood <prestwoj@gmail.com>
> > Signed-off-by: James Prestwood <prestwoj@gmail.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> By rebasing this on top of these patches, I could drop tpm2_read*()
> from this and use tpm_buf_read_*():
> 
> https://lore.kernel.org/keyrings/20261115233156.1485238-1-jarkko@kernel.org/
> 
> See, also:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=tpm2-asymmetric

Also as a result of this tpm2_load_parent(), tpm2_load_blob(),
tpm2_asym_rsa_decrypt(), and tpm2_asym_sign() resolve names via
tpm2_read_public().

By combining these series pre-existing code is leveraged
to its best extent.

Br, Jarkko
