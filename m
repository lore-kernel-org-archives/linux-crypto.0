Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202696;
	b=I+DKNk8171C+D51Tm2sayZ6KMdqEgrZ1XgFVJsycYtgbJnq2IPAi+UKV3xb89/1doj7f
	 Ok7cPS0J2HYjI+w85KTMm4mac4S49EWjPcVr3yFtUG7zTLmR1l8F53yV7cgGgLE3OmE5s
	 dQ8iwAIvLB4qtPmv0HCdVQih6mM31Dty7vMKBxkimZy2VU5rTdnKHKf7C+jqNsczMF8vA
	 yB5uUBm6ztDJctGAOUHOkZF0hooV3MWUhhXvZ30kOH5AGuIqnG23fdbP/srQ+qRaHL3hd
	 2Yd54cxaCKHtmJKIm/f1vwacI2apGIt9hyHuynvPal+gbu718pBj38/NL2ISZZjoaWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202696;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DCkxYHJcT27++FJP/Zeto/ZEYJ+1SSDdnnCZWhjVGX4=;
	b=l61Y19RZC0DmSELNoRLeQBwwWU7WH6AWyf0gcVQtKbeWtEbzGvsiBytBAw+Pd5M272uY
	 3fllS4y1rmF34/IjES0RLjAXwG7PB/4kW/vqYaTxoNX0gjG2aQg6m0BTkO0lxvIsJmuHq
	 5aJUak4zzUmMBJQ4RvXjRZ9GNOUgvaV8fFogmHKlnrlNEldyZtdOPzWbyK5Jj4+nRz8Jr
	 8ENAEvEvly2vKbr15yY3PSwd3tpkeiDOmjpLUs7QOsgfEDIEdsBrv2+daAROd2ZvVsEob
	 Xs2O2GnTj1nY4avwDeh4biTLCb5B4uMmQW2ZwVtHMOTR8URBaK9OTJNVY+LSMlLP6Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ll0JeyiH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB22606A31D;
	Wed, 28 Oct 2026 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ll0JeyiH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90301F01825;
	Wed, 28 Oct 2026 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202696;
	bh=DCkxYHJcT27++FJP/Zeto/ZEYJ+1SSDdnnCZWhjVGX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ll0JeyiH5l8RZnHaJ3llWRYbPwc1aeH8e9kYEPIeEiYLvBmhbl6PQqCNdC++RoRJi
	 v8YeIdY8CERG4/daeQsuyu1oIaYq55dSk3oD2YVqucS9yzJ3Krejxn2o2Z/NV6Zvt5
	 1oDo7x4zCuRkbOjUQWlY+LzYpB74Io4r5MtuQr6apsRw27Jv8YX6fKhHybwIHV+C8O
	 c9ZTo44tl/N5pS7M6pGBka9JtEboDMnGQTgwqhB5rLusrn8/EKMPGk/nDeoS8pY7CF
	 GOOsE099RTHZc8lJQSmVTzsUKRnIUTCn+kgp+PPH7dA1OZVD1R9cd2/on3k5qYN6T2
	 uHch8LHJdP6Kg==
Date: Wed, 28 Oct 2026 15:51:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ardb@kernel.org, Jason@zx2c4.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: aes: use memzero_explicit() instead of
 memset()
Message-ID: <20261028155134.GA4041913@google.com>
References: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
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
In-Reply-To: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>

On Wed, Oct 28, 2026 at 07:56:36PM +0530, Mohamad Raizudeen wrote:
> aes_gcm_decrypt() and aes_ccm_decrypt() use plain memset() to wipe the
> output buffer when authentication fails. But the compiler can optimize
> that wipe away, so use memzero_explicit() instead of memset().
> 
> This matches every other sensitive wipes in this file, which already
> uses memzero_explicit() for keystream blocks, tmp buffers, ctx
> teardowns.
> 
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  lib/crypto/aes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index e1c191551736..7814ef525239 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -1733,7 +1733,7 @@ int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
>  		 * Clear the inauthentic decrypted data so that callers won't
>  		 * receive it even if they fail to correctly handle errors.
>  		 */
> -		memset(dst, 0, data_len);
> +		memzero_explicit(dst, data_len);

This isn't for "zeroization" (making the data unavailable in ramdumps),
though.  It's just so the caller doesn't accidentally use the
inauthentic data, as the comment right above it states.

- Eric
