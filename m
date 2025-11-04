Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72E1448D5;
	Tue,  4 Nov 2025 05:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762235615; cv=none; b=UkpAJC2KGOLtsaNJYfuOj2yEHjeW84sXDJH7QAvxO3zPUhlGXdPmjUFKbpemqMsBiKfQZwvQoz1QG+HkKluNewVrPvBk+2nRl/8wzI9bd1u837ExcnG579RWxyafndXo63qiqgTvXpNmSuzcEaoxkj4+K1ZREDY9ZsZExJFH1hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762235615; c=relaxed/simple;
	bh=UbX+ByTupXtukbbi248WV95MgCPA2XgOQbkRV6jr5Ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EaTZUgw7tS+uaa92A2/R4h3ASLl5vZWoEoOKlaETjCnyq8MhPljbVsuLoYKFtJWYQ61hOJdrSQeqpkIhOnYzXcu4GSLSHpdek/4+6TqzWAVfwwYPVuSb5kmqUISR5ldbnZ4CbIusRxGgE0BwetOFEu9Fa+d3hKyZzi1Q8ygmB94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qFLkiwkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFLkiwkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C92FC4CEF7;
	Tue,  4 Nov 2025 05:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762235614;
	bh=UbX+ByTupXtukbbi248WV95MgCPA2XgOQbkRV6jr5Ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qFLkiwkbBHvYJVRFWADuiEdu4Zga+pqfgnBXx6fxKlD5HZrJr6tmhN+GcphGJ31kC
	 p92fBfyhfvQGiFGQGJiset7qMMfF+tY1TzZwjCxLCyUFu2su4i3CcSA6f3kxex88/E
	 5+DCTYb7rDN4epOtMKtt6F+pcxELgaeTkZYM7O20RdG9zQrHJU6DcNCgDrmXSLSKvD
	 JLd1q8xmahSTNaiV3S9e0pmWVko2hlWQ4miKwvKx7u/KLHXcuekpXDBtBYXFDyTHL8
	 yDzvZZS49Zt1fYRBrMqpqmuyCH8h8QzITJpHd/xrGBluouFZxhSsPrqeLUKAcAAXTZ
	 HCBjyhZU1Htzw==
Date: Mon, 3 Nov 2025 21:51:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/aes-gcm-vaes-avx2 - initialize full %rax
 return register
Message-ID: <20251104055153.GC3674@sol>
References: <20251102015256.171536-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102015256.171536-1-ebiggers@kernel.org>

On Sat, Nov 01, 2025 at 06:52:56PM -0700, Eric Biggers wrote:
> Update aes_gcm_dec_final_vaes_avx2() to be consistent with
> aes_gcm_dec_final_aesni() and aes_gcm_dec_final_vaes_avx512() by
> initializing the full %rax return register instead of just %al.
> Technically this is unnecessary, since these functions return bool.  But
> I think it's worth being extra careful with the result of the tag
> comparison and also keeping the different implementations consistent.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
