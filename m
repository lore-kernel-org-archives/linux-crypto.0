Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C6A2DC79C;
	Tue, 18 Nov 2025 23:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508279; cv=none; b=bDSyvgOh9fYHJUhQuLD25UpKkgcPv2hku0RS42xjqx/Qs30/NbhGCNexrMgiTJ0d5tnynNWyFv5A8ACGucQcNqZIGa/69fkECRRH1FzO44dykPx2Pk+l/RBk0dI8x81RAILGIrl/ET6DuUKcw0HUfUuFVxv4WZwCxfF/aa8aRi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508279; c=relaxed/simple;
	bh=zaA5cFeHcmLt102g6dwDoqFCpMyyY+UgU6o7AesBhSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WK1fKRT/FtSEp/WUyEKDBTvNvfHwNIyDvmQFG5ypd0lSJPkeZZXlSBilgdGyJEMQH7pkrnGobwrN4rH9qcr6tgMVybg4jt/mkeJQsqf325jHAVgm/BUfEAAD2f+urv1xDt1T4TSMmAJ+z+FntgPIyg0eouny43VtsqkHmJaH8Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhMmRTx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhMmRTx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092E9C2BC86;
	Tue, 18 Nov 2025 23:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763508278;
	bh=zaA5cFeHcmLt102g6dwDoqFCpMyyY+UgU6o7AesBhSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EhMmRTx2k4twKod9NlcVYQU+PYHWFd6iDuGCnwj4IIhvltIRTDvKTauBrKLsUNIJv
	 WMnm7ks67A83vclmh37EX1r6iyHIB3ZkcZIOp0X5Qm2qgoQQFytsT7swxJ73I5raef
	 vSkH341pQBfLl2c0fQ9rwSlBOGn6n1r5c9T4/jN+ZbiFiMcJ91JcQ0B8QWbz+I887g
	 2PL1OMBrZLm/H/Nav2obiuH29Ygnhsv/fScuw2ImenowmpCY3j4IrAL9wwqO5TcZ9T
	 jkW/BZqbW34f8tqMy3d++/MaCqAegmYdMpPDGtVsuUIy1ogXQ6ZtdglElFXWEiOj8z
	 dX9iV4eQ9RFDQ==
Date: Tue, 18 Nov 2025 15:24:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
Message-ID: <20251118232435.GA6346@quark>
References: <20251118170240.689299-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118170240.689299-1-Jason@zx2c4.com>

On Tue, Nov 18, 2025 at 06:02:39PM +0100, Jason A. Donenfeld wrote:
> diff --git a/include/linux/array_size.h b/include/linux/array_size.h
> index 06d7d83196ca..8671aee11479 100644
> --- a/include/linux/array_size.h
> +++ b/include/linux/array_size.h

I think compiler.h would be a better place?

> @@ -10,4 +10,11 @@
>   */
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  
> +/**
> + * min_array_size - parameter decoration to hint to the compiler that the
> + *                  passed array should have at least @n elements
> + * @n: minimum number of elements, after which the compiler may warn
> + */
> +#define min_array_size(n) static n

"after which" => "below which"

Anyway, I actually have a slight preference for just using 'static n'
directly, without the unnecessary min_array_size() wrapper.  But if
other people prefer min_array_size(), that's fine with me too.  At least
this is what Linus asked for
(https://lore.kernel.org/linux-crypto/CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com/).

- Eric
