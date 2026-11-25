Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642126;
	b=w+xry4F5Ydd+ttylIN27if7gTgKL58kMn5QvngM6Ym2Qj9vM2YBhIu43dsU1x1y5tqZ8
	 Ro6uzZUG6+VuJqdbEZg/VMZmzb7TJty51fR0NUmBHkmzSAFWCIuzVvZW9d1/wbtrM9YD2
	 Zdnagl1bYoeUR1SPx5GE4YgGpZ9hyQ1e7CUFi1AhcD/lPRhvLne5odrFcxaWauD2Oblwy
	 uOnSGSvwafmkT2Do9t8YZD9OCOKmOHE0GppoVIz2leAIdTI1cmffPtrDOadVrN2VNMJbJ
	 V0iAKCIvlC5PDXvVEizor50YKUBwdro+v2j8A7uEb0X6ZiljFaprdtIi3uLBHMwiElg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642126;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UkuehG/5TT/D6FQ9os1MRdpr+7rTrdbnhuKF65CDUEc=;
	b=nSWnHLsXQVrNmSmgRJEiRezk3UzJ3xwqP4LuS6+8uwlKO8qGRU2Pf0Q3OIQwqQwgfi9b
	 /oO41I7rJh2Dq1VPHQWK0zuRVt975oQEnfhW9+MZVp7K1RfphvTkYYH30gHUxxLXI+S6i
	 ZpO2Tf4rt7g7tahdgADJDu+Fb3tH31EqBWPVpjnLDa2wubawJHyYQ1cuQH5XYDJYQAGal
	 4j6gxX9ZEmkACt0ke8TZIfEm/p2Mlo+qeyWAM2FDr7FA4yc3fVHgIoJf6GJuBCL3WGTc5
	 VGpPa+xHGr2oCi86aiV6qrZqFDJ4OmgxjEcGRmsOpSEtTIMZrHBXOs+WPSnkdABxhvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZQIPYGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 66196606A32E;
	Wed, 25 Nov 2026 21:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZQIPYGD
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 09DCA1F000CA;
	Wed, 25 Nov 2026 21:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642125;
	bh=UkuehG/5TT/D6FQ9os1MRdpr+7rTrdbnhuKF65CDUEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FZQIPYGDb1o0kLORFON4oH4idnFolPzmggTC3M01X1BJQr6Qo4xV9kI6dtNDNlVAn
	 /rRmop/gaX/iXEsvG0SmIgrT39XcS56ADn71JnR4oGy6n1D5tHaqt5sER1UecVGwxb
	 z1fHwCbuHmWR37Lu0D9sG4FnACsL+J1Yv/Vht8qwRm9CZOKwj46/3CcFld0mjLaiiJ
	 pxEydeg25q98X6zLisvAhsp4sVh+SIUyl3FQ4jgvufoPaJILBv6f7VmKAeoh9QRkRY
	 u7iDN4K1pUE4238Lvb3/J0J8mBi3dDhSM5CO/ulCfKZYWHW587LZ9swvr4aRGuZK+y
	 Dz6Z8TdKrLFDQ==
Date: Wed, 25 Nov 2026 23:28:42 +0200
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
Subject: Re: [PATCH v2 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data
 shorter than MIN_KEY_SIZE
Message-ID: <awdTChkSGKVF48xL@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-2-jarkko@kernel.org>
 <20261125090930.698d8f1b@pumpkin>
 <awcAeLUROL0l_g3X@kernel.org>
 <20261125212650.479bea7c@pumpkin>
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
In-Reply-To: <20261125212650.479bea7c@pumpkin>

On Wed, Nov 25, 2026 at 09:26:50PM +0000, David Laight wrote:
> On Wed, 25 Nov 2026 17:36:24 +0200
> Jarkko Sakkinen <jarkko@kernel.org> wrote:
> 
> > On Wed, Nov 25, 2026 at 09:09:30AM +0000, David Laight wrote:
> > > On Tue, 24 Nov 2026 21:40:35 +0200
> > > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > >   
> > > > tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
> > > > bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
> > > > 2.23.133.10.1.5) blob.
> > > > 
> > > > While kernel-generated trusted keys ("new <keylen>") and legacy old_format
> > > > blobs are at least 32 bytes long, external TPM2 tools allow sealing any
> > > > non-empty payload up to 128 bytes.
> > > > 
> > > > Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
> > > > bytes for ASN.1 TPMKey sealed blobs.
> > > > 
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > ---
> > > >  security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> > > > index 30188a0ec676..d7336f25b514 100644
> > > > --- a/security/keys/trusted-keys/trusted_tpm2.c
> > > > +++ b/security/keys/trusted-keys/trusted_tpm2.c
> > > > @@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
> > > >  	rc = tpm_buf_check_hmac_response(chip, buf, rc);
> > > >  
> > > >  	if (!rc) {
> > > > +		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;  
> > > 
> > > There is no point using u16, just use unsigned int.
> > > 
> > > The same goes for data_len.  
> > 
> > Hmm... or just int?
> 
> Unsigned int can generate slightly better code - especially for
> array indexes.
> I sort of prefer it for values that can never be negative.

Agreed and I changed it as unsigned int in v3 :-)

> 
> David

Br, Jarkko

