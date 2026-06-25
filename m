Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B67C2E7F20;
	Thu, 25 Jun 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410496; cv=none; b=mMoHVcoGTRZlwEPn/R4mp3jvPIRBY/BJuoaEx8qfUwghEmhR2KlKPnTvjfvwAak9/GxWkfhzZJxPH2TlSTOH+tSBSY7Flfyv+3gj+0ZFRGAP96YH7zieOzYVwdbIOdC6WA1CrQ8Akdu2KR9U+m7X4DvSMbiCg/HFt0/7bPwkzwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410496; c=relaxed/simple;
	bh=OHP+M0l/Mr9gBomA0m4cHyr//2V19xtyvblV0Kk0rxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyvl/pBW+6fWMlqbv7o7v0G4fzNGu155jMvtEghi8AY3O5ZqLSM/se0x23AmBH0D/ezgLykryxZrsDFypimxq8HBR5jcQZNI/ERP2dn69c3tPKCdmrmmrB54I0bGt+ieROImugXK62Fx/MQ2yKEvCvytRit+4fezqziocPmfhhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5CBx9dT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5CBx9dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AB01F000E9;
	Thu, 25 Jun 2026 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410495;
	bh=Q0SVLg83SG3PTPWfxPfrZg/BRkjquTSYNHGY8gQqXnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b5CBx9dTMH7bGiSEGRv81b9hUKYyqCl30M26u+2aipPWWt/jtxIoOr54+8/+6Cin7
	 3sv9MpM4PO7Hw2wbjavlAIzIeOzyC5JgCbA03OXUqYoFeamxZDgc2cs9ckJBvGh2MV
	 XUnXOi3DJLktR3bXRsgHd4FYKg7jsphWs63oAfN2xJGS88tygAdamhyby9lEChVz39
	 nhvFJ7QNmtvnh6SFn0cjV1d7JbbZMwr2Ifs2+FsNdLPoGQ/vx6ZEfpycOLKr5cdwjc
	 L/zjhG+maYjWVGLXmKIKYz34K8rDM7B0nmI/TWulM5Om7BjUWJslrEiX04zfMIgh5f
	 JBC3vYhSMoonA==
Date: Thu, 25 Jun 2026 11:01:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-nvme@lists.infradead.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 12/21] nvme-auth: common: use crypto library in
 nvme_auth_derive_tls_psk()
Message-ID: <20260625180130.GA2514@quark>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-13-ebiggers@kernel.org>
 <965a37dd-f698-46b6-9623-1099a13f7e60@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <965a37dd-f698-46b6-9623-1099a13f7e60@oracle.com>

On Thu, Jun 25, 2026 at 10:02:27AM +0100, John Garry wrote:
> On 02/03/2026 07:59, Eric Biggers wrote:
> >   int nvme_auth_derive_tls_psk(int hmac_id, const u8 *psk, size_t psk_len,
> >   			     const char *psk_digest, u8 **ret_psk)
> >   {
> > -	struct crypto_shash *hmac_tfm;
> > -	const char *hmac_name;
> > -	const char *label = "nvme-tls-psk";
> >   	static const u8 default_salt[NVME_AUTH_MAX_DIGEST_SIZE];
> > -	size_t prk_len;
> > -	const char *ctx;
> > -	u8 *prk, *tls_key;
> > +	static const char label[] = "tls13 nvme-tls-psk";
> > +	const size_t label_len = sizeof(label) - 1;
> > +	u8 prk[NVME_AUTH_MAX_DIGEST_SIZE];
> > +	size_t hash_len, ctx_len;
> > +	u8 *hmac_data = NULL, *tls_key;
> > +	size_t i;
> >   	int ret;
> > -	hmac_name = nvme_auth_hmac_name(hmac_id);
> > -	if (!hmac_name) {
> > +	hash_len = nvme_auth_hmac_hash_len(hmac_id);
> > +	if (hash_len == 0) {
> >   		pr_warn("%s: invalid hash algorithm %d\n",
> 
> ...
> 
> > +	i = 0;
> > +	hmac_data[i++] = hash_len >> 8;
> > +	hmac_data[i++] = hash_len;
> > +
> > +	/* label */
> > +	static_assert(label_len <= 255);
> 
> JFYI, this is generating a C=1 warning for me:
> 
>   CHECK   drivers/nvme/common/auth.c
> drivers/nvme/common/auth.c:746:9: error: bad constant expression
> 
> The following fixes/avoids it:
> 
> /* label */
> -       static_assert(label_len <= 255);
> +       static_assert(sizeof(label) - 1 <= 255);
> 
> Even though label_len is declared as const, label_len <= 255 is not a
> constant expression.

Only affects sparse, but I sent a patch:
https://lore.kernel.org/linux-nvme/20260625175911.35094-1-ebiggers@kernel.org

- Eric
