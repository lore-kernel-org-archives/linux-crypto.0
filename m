Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620989;
	b=giZuY6JiyvzbjRB75PoSui+/u4HeRlWKCvipBFp0KiU9hv3GuqtE1ym/hfpsCN0qTdQS
	 GIv2sP5YeRSFYQ5GkWKyGuzAWikBq2hOG66LaBEtOmNwlX1drYciQYHD1XGOmT5phtaxA
	 0ZW1/AjfMbRSqKSGSF4Zqqu4QJEPI+y6OZCV0p1ua/R/LcsQhHUUqzljrXSTUI99Yw0pZ
	 e+ItbYk02bgVJnudhzuQ2tC9ImyXYyxoWn3YC/VkkY2df9sKbNEYU+8RCX7Xm0foBao8U
	 toicpa+xsPvuCXsl3fe98UfFd0uRLoZnnO9UBgw9ZX5PEAVoV+jMQ1BPy3x3IE6IzyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620989;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dPaNfzEm8Q/pGFCJLoSAYcv2nDmTyjHZh8qs5K/cDfI=;
	b=zLdmymC3yIR4UpnRSHvBHlcYHLCP28OqJt47doc5lfaSC5YJ/QGJrln6l56GCuYTd4Ij
	 CIANMv3+42aTE1VOFa6cXKhE9mwRC5f7EtevS/W+MHSerN+kieHt8UMlA+IcosCFrZOS+
	 453R7L52KW0ZUPPXjE2nLuhN/OgP/ML4anOMOmBYT9/i/Cvpt/jmsChSrjnI+lIJ4G2qU
	 WehbKW/jqJIGTwgCfavn7S8ZvizJAwn1O7DCjLA4BofLu+qZWhsnF0Lqgy89M/tjUNmYZ
	 S3k4AMdCsycx4U2jrFhCbpzZdaPGEFA970KPaCVWJWyW+c0AHP8BtthRidhGujrIDyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NhT6m+S4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A8D15606A33C;
	Wed, 25 Nov 2026 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NhT6m+S4
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 74C111F000D4;
	Wed, 25 Nov 2026 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795620989;
	bh=dPaNfzEm8Q/pGFCJLoSAYcv2nDmTyjHZh8qs5K/cDfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NhT6m+S4ZoYbZbfWHVPSDn37Wq+Nzw9+6fj96NfG1MDhcfAxD9c5FkqacEvvK4d1K
	 vvYwfQ5ZH6qjtJzbddWJ5x0ak/mK1Tvxd23y8QeRn1nWzT/jBlYwhsBW6Xa8XCI0O5
	 7IQLGhf0WU9dvLofrG9WoIELDuvcmwnO90VKRO0rR6zEev9BMAeucG0hM+SsZJQQdW
	 Qv6YcuLfiPsKIbaM4xjQWWVuUNpILSSWEfne7L7LasoES8xdeCglYEFHp075Ye+2Mw
	 gjvPoiJVlmzel067FC64bksHdKSd1gvFOePbanAM5Mh3vaKJaiSusOWil8o7DhHP0Z
	 stOUEjdO3fEBA==
Date: Wed, 25 Nov 2026 17:36:24 +0200
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
Message-ID: <awcAeLUROL0l_g3X@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-2-jarkko@kernel.org>
 <20261125090930.698d8f1b@pumpkin>
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
In-Reply-To: <20261125090930.698d8f1b@pumpkin>

On Wed, Nov 25, 2026 at 09:09:30AM +0000, David Laight wrote:
> On Tue, 24 Nov 2026 21:40:35 +0200
> Jarkko Sakkinen <jarkko@kernel.org> wrote:
> 
> > tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
> > bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
> > 2.23.133.10.1.5) blob.
> > 
> > While kernel-generated trusted keys ("new <keylen>") and legacy old_format
> > blobs are at least 32 bytes long, external TPM2 tools allow sealing any
> > non-empty payload up to 128 bytes.
> > 
> > Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
> > bytes for ASN.1 TPMKey sealed blobs.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> > index 30188a0ec676..d7336f25b514 100644
> > --- a/security/keys/trusted-keys/trusted_tpm2.c
> > +++ b/security/keys/trusted-keys/trusted_tpm2.c
> > @@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
> >  	rc = tpm_buf_check_hmac_response(chip, buf, rc);
> >  
> >  	if (!rc) {
> > +		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;
> 
> There is no point using u16, just use unsigned int.
> 
> The same goes for data_len.

Hmm... or just int?


> 
> David


Br, Jarkko
