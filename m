Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748401;
	b=iRux9uAyGQ4s1ORstxcM8039drhZslIBBePVZv+LxiU5htyb9GuZpDqwGA8s0BOdb6+P
	 DjJYDAEqL5I1vv38WTga28BUns6ExAlgTSroK9sALlJgzhEqEezZHMr2elkaFF0xAUNiT
	 hGXSwRrtsYA8K/kJPPmsfmmkItAMi0jES4Huy43Ia5kB/YTJw7pSanRfFtZWfVOej/Xdv
	 D+YvhNN/+5EBNlh7hd4TwpKXwynnrtfyikXsrtxYzvKHoNGyjC8983gaXZtVBiLTWj5uS
	 AhEqvn1WxnLnRNZ62LQk8s4xKWoVU58f1aN+8qhKIKKuB34jGVivMHZl92W6A8tEaCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748401;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=17SrpEI7CyeBE7ERFoZPLbfz/OLgDTBInD5EkatSoHg=;
	b=Fu9gsQkJDhg31mt7HLBE5qYdtWzi84FVhchCjqJDPr4mjA0VeV4ehGsf6JZdXdAiwN3N
	 5u5siUpferohKQSiKbBUWl74bfyrUhEnC83lV/yQccWcdKzSGmlReIAd6W+77X9s7JP17
	 YXOarf9FLIZaVmnHQcjBpdT19Qk2iSfJ6Izm0/acxc6XPGRl0UvxIzPZWtJpJPjAHNNRr
	 Mb31/cLU6Fc1NkUpdnIFJWTpKZYxieDZxp0RKg5qKLUk94jJAAFTzC6GMv5QIXS/SjwL0
	 eHUUunmhkv/Px+1UIZuv5qYsXMsocEQOy8OV7GqXkHW5Qr/6rnCMSZGaxCE6O1gb5gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hEua0jch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908DB606A31B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hEua0jch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497051F000C1;
	Tue,  3 Nov 2026 23:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748401;
	bh=17SrpEI7CyeBE7ERFoZPLbfz/OLgDTBInD5EkatSoHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hEua0jchx4exY2vvSOo/obkaRvKHSDtCXK/EOpGmtobbnDO+C5sYeP6btVt0yUFE6
	 A0EQ0qmfXhrsSKj2YV83O1WtzXFEbdWJMMFBnNyX4k2sLrl7RyKertqwJQnUSMHzak
	 txsTYrDzFGrxO0pfTLiDE8jM5MVxHtWGNOEQJBwQF3m0CFHDT3peyqkM+M/e2qhp7U
	 OtiiLrvfPxwi5ETD+iGOeZANG3M0apR/lZtkHQetMqnCRZLcNNSD77oZ482KtHRJfH
	 IJxMJYaNiOWduRV/o+5BIWEpCu4ZawO5JvV/OFT9JPzI9xC3D9Lp6yZ2OxeLQi1F3r
	 j/DUoSj11q6xA==
Date: Tue, 3 Nov 2026 15:26:39 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: aes-cmac: Hide selection mask value from
 compilers
Message-ID: <20261103232639.GH2281@quark>
References: <20261031052053.201779-1-ebiggers@kernel.org>
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
In-Reply-To: <20261031052053.201779-1-ebiggers@kernel.org>

On Fri, Oct 30, 2026 at 10:20:53PM -0700, Eric Biggers wrote:
> Hide selection mask values from compilers, so that they cannot see that
> they are used to select between two values and potentially generate a
> secret-dependent branch.  This is not known to be happening here, but we
> might as well be extra careful.
> 
> Since the selected values are only 0x87 and 0 here, change the type of
> the mask to 'unsigned long' so that the compiler is not forced to
> materialize it in a register pair on 32-bit architectures.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/aes.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
