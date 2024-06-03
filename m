Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361936F06A;
	Mon,  3 Jun 2024 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717404955; cv=none; b=eWj9JJWPbNRTRg7sTfimyRu4sb5vdVOZLNW2PsRJyBLP78JtHJfGg0nMBIXvvkKzaJkUWXAMLKsl1EJgGPMST2nFH2WUJef1jhY0GWqfLEG/5oYLIUtWwMQuB2aq5TnewKjve2bKpjXC64glFQccEifx+GcNg3XkkI3BhMZ7/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717404955; c=relaxed/simple;
	bh=OwnINz2JiXqiq/N3LPDQSYRvitm3PIBafZoIZuqULbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lQIigPb1vMmW7TexMyv6inMKktujXGkp8QOnzAhEyHZKYx3A5zIB3/2pS6cyK+WAXIU4iCbyXFiVfO6ZBAZ5FgMJWK76+wBBb6g4TJBEn43XOoW0IR06uKjtlKS1JOGPGcMtJkN6BXno677WZQT7vZLrG80e7gEnXI+EvitZJM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmtVmiaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmtVmiaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A417EC32786;
	Mon,  3 Jun 2024 08:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717404954;
	bh=OwnINz2JiXqiq/N3LPDQSYRvitm3PIBafZoIZuqULbE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qmtVmiawn6AViWBX80CeLW2Y3ZFi8+l28joNjzXEB/LNDUzrDQYg4Fj1Pms7kBRUJ
	 nzxZf34V18Ci9togc5ByO7sshuDd/MeGCUzThXfWmuXksXpBSGglIH58p7mRckxJUs
	 bqDPWuN6Vn0wnX8O70EMbR94SxUORE8uC5gOBVWzfo1EX9GvXLCjsuRIEdzygK3e5Q
	 i05jjUJAvHHMLZINUqbW12vTcX0MXiB+Ra7EXGSA0qCGGjAZ1ROMQLDiydHRyAym5r
	 aH2Z+rGzOlm6Xhi9pCa6fec2u/8sbHhPNWqPlEVUsPs//yR7JB9ry7Zl2AILP8QiTt
	 o0EVbFt0WDxfg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5295e488248so4372211e87.2;
        Mon, 03 Jun 2024 01:55:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXXKQ2PzWJZYRrHR5Hvvz+quVqUJtAJ0ZDkaSkdYjoTw7s+tI5p03XDp53Mkn1EYo0HAZe8QMBUE5khvt6c1DTBBfTNAn+csHHpW4FK
X-Gm-Message-State: AOJu0Yx48Q9tgMEQB+WC8z4o1HyA2t9ZHdsjpLct6onMJ1BkQtvwak78
	GExvSTECOYyCkVWrIugXa03xBx7rhFDqaMXiALzEhoNn3OFEqS+1kLpz7TzsVIl01ZzRuitBcB2
	NobT2qR+ddsJhIKupnkCxjPR+jeU=
X-Google-Smtp-Source: AGHT+IFpX6zFtChaemq94o7WVW/QWeE6j3RDJTVWIyMI5MCMGU4bIgei/LinvXGexu2a3D66nfGn2cfFHVRtfx6NCLI=
X-Received: by 2002:ac2:5f81:0:b0:529:b632:ae4e with SMTP id
 2adb3069b0e04-52b89564f8amr5798647e87.2.1717404952882; Mon, 03 Jun 2024
 01:55:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240602222221.176625-1-ebiggers@kernel.org>
In-Reply-To: <20240602222221.176625-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 3 Jun 2024 10:55:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGLP7QaEcUcqKMqtKCOcTTTh9n=8hEG_24kn8k3O9bmpg@mail.gmail.com>
Message-ID: <CAMj1kXGLP7QaEcUcqKMqtKCOcTTTh9n=8hEG_24kn8k3O9bmpg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] x86_64 AES-GCM improvements
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Jun 2024 at 00:24, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This patchset adds a VAES and AVX512 / AVX10 implementation of AES-GCM
> (Galois/Counter Mode), which improves AES-GCM performance by up to 162%.
> In addition, it replaces the old AES-NI GCM code from Intel with new
> code that is slightly faster and fixes a number of issues including the
> massive binary size of over 250 KB.  See the patches for details.
>
> The end state of the x86_64 AES-GCM assembly code is that we end up with
> two assembly files, one that generates AES-NI code with or without AVX,
> and one that generates VAES code with AVX512 / AVX10 with 256-bit or
> 512-bit vectors.  There's no support for VAES alone (without AVX512 /
> AVX10).  This differs slightly from what I did with AES-XTS where one
> file generates both AVX and AVX512 / AVX10 code including code using
> VAES alone (without AVX512 / AVX10), and another file generates non-AVX
> code only.  For now this seems like the right choice for each particular
> algorithm, though, based on how much being limited to 16 SIMD registers
> and 128-bit vectors resulted in some significantly different design
> choices for AES-GCM, but not quite as much for AES-XTS.  CPUs shipping
> with VAES alone also seems to be a temporary thing, so we perhaps
> shouldn't go too much out of our way to support that combination.
>
> Changed in v5:
> - Fixed sparse warnings in gcm_setkey()
> - Fixed some comments in aes-gcm-aesni-x86_64.S
>

This version

Tested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
