Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3632690EC;
	Thu,  6 Aug 2026 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786019842; cv=none; b=Q0sLyc7JfLvw6b1auJO6APT5iZcyN7sgAl+q1HFqeM/GIBvIXn72k5vV7vXFtIoPmtxOJrpk5MVpq2qYFCoP0MwftsnyzE9Uskp+P/uDG/ziTdqbTam0cC/957RCRMZ8Kmf6V+1OM3ZlUxheEhzk96Lnwsp2wuc3W+3xC82wqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786019842; c=relaxed/simple;
	bh=HjJrnZ1sAUx5ECpXHT6Mc+y5eLiS2M2X8b//E04baIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5uG8U4PbFtNg9U7omKCCj1AeTnl1ZnKQo1ZOdoYnp5b8618HEw9kSS7yhdUdmio40Q2ki7pz5HFZH/tNXSKx18AOG9UJEcuH/hUqiTOyTay3Aw60Hk5mPbvozAsVAcM3BhrCN2r2LLce8D0VUKGkQFnEFpDevIizCG0Pik9cQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbSvQ+h8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbSvQ+h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3663E1F00A3D;
	Thu,  6 Aug 2026 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786019834;
	bh=2Lei8+3SMFtIuihbCST3OrQKRguKJcgWRthMeqRNACU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AbSvQ+h820Br2zlgc0rIeio1S/6g+3DVI/AziYGVngWkD36sNyAQQVZu5Iy7RO8qz
	 HY81ZsvL4aAwd2X9ENyDgVdX9LsC6jnaVjetpD3KXu81l0lEDz4ZmFVjY19MiFEpg/
	 yQktPHltOYMySe0QenX6UGFEVAbb1Zdy/I5HHN6jX4l7vznTdHIy5c/WZubfBR/naF
	 3qVPNme6kGK60EDY1g7N0+p7W7c2S73so90oN1YzG165ksrZHJogdFiBeacKxyAMvY
	 XD1gPxTN26uptz7+wEwdtY4o/7reDXOlgtVWDZu9GGXEUF78nar7k7zf2vyCr55QYG
	 4S81XxWyRHSFQ==
Date: Thu, 6 Aug 2026 14:37:12 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 09/10] crypto: safexcel - Rework cleanup of sensitive
 structs in safexcel_aead_setkey
Message-ID: <anR_pXCLY4He5sj6@kwain>
References: <20260805115749.392672-1-thuth@redhat.com>
 <20260805115749.392672-10-thuth@redhat.com>
 <anQ9UdZqmj39hfgD@kwain>
 <7c456e18-0fff-4d06-a94d-66807b9777ad@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c456e18-0fff-4d06-a94d-66807b9777ad@redhat.com>

On Thu, Aug 06, 2026 at 10:18:12AM +0200, Thomas Huth wrote:
> On 06/08/2026 10.10, Antoine Tenart wrote:
> > On Wed, Aug 05, 2026 at 01:57:47PM +0200, Thomas Huth wrote:
> >> From: Thomas Huth <thuth@redhat.com>
> >>
> >> The crypto_authenc_keys structure only contains pointers to keys,
> >> but not the key data itself. So explicitly clearing the structure
> >> at the end of safexcel_aead_setkey() is not really necessary.
> >>
> >> On the other hand, the crypto_aes_ctx might contain sensitive information,
> >> so this structure should be cleaned up at the end instead. Do this
> >> now via the new __cleanup(aes_zeroize_ctx) marker.
> > 
> > Looking at other crypto drivers it seems zeroing the key pointers was
> > explicitly added (sometimes later) and my impression is a good chunk of
> > the users are zeroing it. I don't know whether removing that is fine or
> > not, my limited understanding is that provides in-depth defense against
> > leaking were the key reside in memory. Would love to see an explicit
> > statement from someone with that knowledge.
> 
> It has been suggested by Eric here (unless I got him wrong):
> 
>   https://lore.kernel.org/linux-crypto/20260804185402.GD2904385@google.com/
> 
> ... I should have maybe added that link to this patch description ...

Thanks for the link! Feel free to add it or not in the next revision.

> > (On the other hand mixing gotos and __cleanup is not advised but is that
> > an issue here? Or if zeroing crypto_authenc_keys is actually important
> > can we use __cleanup too?).
> > 
> >> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> >> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> >> @@ -407,17 +407,17 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
> >>   	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> >>   	struct safexcel_crypto_priv *priv = ctx->base.priv;
> >>   	struct crypto_authenc_keys keys;
> >> -	struct crypto_aes_ctx aes;
> >> -	int err = -EINVAL, i;
> >> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
> >> +	int err, i;
> >>   	const char *alg;
> > 
> >> @@ -430,25 +430,25 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
> >>   	case SAFEXCEL_DES:
> >>   		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
> >>   		if (unlikely(err))
> >> -			goto badkey;
> >> +			return err;
> >>   		break;
> >>   	case SAFEXCEL_3DES:
> >>   		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
> >>   		if (unlikely(err))
> >> -			goto badkey;
> >> +			return err;
> >>   		break;
> >>   	case SAFEXCEL_AES:
> >>   		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
> >>   		if (unlikely(err))
> >> -			goto badkey;
> >> +			return err;
> >>   		break;
> >>   	case SAFEXCEL_SM4:
> >>   		if (unlikely(keys.enckeylen != SM4_KEY_SIZE))
> >> -			goto badkey;
> >> +			return err;
> > 
> > 'err' is uninitialized here. You can use '-EINVAL' instead.
> Oops, good catch, thanks! I will fix it in the next version (assuming that 
> removing the memzero_explicit is ok and we'll keep this patch...)
