Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EABE37C92D;
	Fri,  9 Oct 2026 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791562416; cv=none; b=l1NBrblvOt9/Me1FDi27HZIgLp3Sy+VLbDmXQFFmLntyBSzzIM/VdSuXBpZAKTP4UFOBJ+ywQ4gDFEepCX5G7U16ITyb1KSyrUjtx1xQcObxTC+GzxdRA0JYqTy5a8qyaWMfcoh160zrmt7jFTxdgbEuaptQXTBrCy+BngPBWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791562416; c=relaxed/simple;
	bh=BXp+s1J3LebFrM2p+UKmOkxfplwaUJ9opqSciwLDUuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivaDo9yPohqESrNBxKxzSphuOxPyESI04dVxoDjxpcix5k3oIF5h7Htk/GvWIsHJRhlAGTpb/BMms1AsbF2nvARBlTiv4BHeK/t+QcSrVmZ3PBTamuY5t+jFxveFR4mboKMuTg9N95lPB5/Ol3fruNQW+7fNPQBwU2wuEzjxPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfR7CUVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfR7CUVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6C71F00893;
	Fri,  9 Oct 2026 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791562415;
	bh=AyOSgWJY/HMkCj7brjmuNGNFpEo79D8extLj/8v1jbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SfR7CUVLdeT/UfZPvAVNa7YsEIY6HJLtUlQFrA0xPpcFjqICzpMijf9sZ/vAzKy9V
	 JEmxxoSohJGdKyAajwm9/PYLdkinS2tgZRqYOMlkE9w2FG2+NSjwJvhAelHjzD689y
	 pksDxmf0L+n88SuLUjVEQtobn1yZCypuasi74H6cRi8vDrgfWOkzL7rNQQh7K8qYVa
	 Xf9Rd8nCEXlomHg5lkae7kn4gGFJACXo/XB/GwTnGDkhgDoZTutS2mxYzABdL2qOl7
	 sNBjCYIxCauGjN8eoy2q4KFss9NGRg3/0CldmgI/AYTsWQmwek8hbAhhmaTeVopqgc
	 fSqpXuInOnrMQ==
Date: Fri, 9 Oct 2026 18:13:28 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	=?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when
 resuming NEON state
Message-ID: <20261009161328.GE321175@quark>
References: <20261009125354.315476-1-ebiggers@kernel.org>
 <20261009125354.315476-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261009125354.315476-2-ebiggers@kernel.org>

On Fri, Oct 09, 2026 at 02:53:53PM +0200, Eric Biggers wrote:
> represents 2^128 + 4, so the conversion must produce the base 2^64 limbs
> h0 = 4, h1 = 0, h2 = 1.  The low 64-bit word sums to 2^64 + 4 and the
> middle 64-bit word (including the carry from the low word) sums to 2^64,
> so both carry out.  However, the carry out of the middle word goes to
> d2, leaving h2 = 0 and the value 4 instead of 2^128 + 4.

Going to change it to this instead, which should be clearer:

    represents 4 + 2^26*2^26 + (2^26-1)*2^52 + (2^26-1)*2^78 +
    (2^24-1)*2^104 = 2^128 + 4, despite the bit representing the 2^128
    term (bit 24 of h4) not being set; the extra comes from the h1 limb
    being above the normal base 2^26 range.  When this value is
    converted into the non-redundant base 2^64 form, a carry into the
    new 2^128 bit (in bit 0 of h2) is necessary to preserve the value.

> [EB: Rewrote the commit message to more clearly describe the bug and
>  its impact, and removed a lot of pointless LLM-generated text.]

Changed to

 [EB: Rewrote the commit message to more clearly describe the bug and
  its impact, and simplified explanation about why there's a carry bit.]

since Jérémy said it actually wasn't LLM generated.

- Eric
