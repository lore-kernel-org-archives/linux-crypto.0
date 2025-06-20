Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924D7223DCE;
	Fri, 20 Jun 2025 21:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750455628; cv=none; b=SkK4szse9hSSYKBMb9EXvg7AlbB4DM53iAhOKrl5xviqY5maBjyJEubOYgJDFe4JsQDs/pGKyzX8ODqs1D5G1X99kAlKQNx6XN4QAJ72IcgidF3rpOCjQh79uGwAGZ+9dODjhB6rDF7MrmAh2CTLMLDjLygZZBJM1zJhwAVcJRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750455628; c=relaxed/simple;
	bh=vOkHZyLMtPBwXMDFAS4zkyrcHEY/jXHN7VQLd/9O4Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BWCdLgheFFDsvCyu7EUTIP9TBviVn+9M3ZR7oy6mm4n1EXh8SrjJ/81U/faw8ALm95JiRdZEi9duHTMjZJ+Qvv06k4feK4+spDUoYvu/ypcdnzP+sD2rKedBvZ3Z1XDI95piaUcNHNzoJ8kZSzYSVeQ0Q0Kqho1RKFxvSZ26/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qN0qp6+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qN0qp6+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33584C4CEF0;
	Fri, 20 Jun 2025 21:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750455628;
	bh=vOkHZyLMtPBwXMDFAS4zkyrcHEY/jXHN7VQLd/9O4Dc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qN0qp6+df6BZ+B+rMf0PAYxV7knsZ/AsNJhpkBvLn/XSlkRg2Sg5JEE+NqA0yMvtR
	 GdrutmwMMTXKTuEwbujhAFrR8q15b2JH0FsUxK8bP8S3i6FS06zXHqjYkxzt3yRWhJ
	 lUHMuiCUrUgzZ3okZSPawN7xcCTeQQr0091nLFjq7RgesOAUYoPgMXOrvSZaRaWt2q
	 xcCC+J+GmSuONQTsfMEg+4kUt0xYBNHS4HIXNtmouFx0PAkcw7CKP7qksnYSFbd4r1
	 VCDjAugppln5BCuWyOTIS8MoxJgFtUwd4eCDh4seKV/y9EL1FWOrSO7uD/WJumIEMU
	 CVUlt/iDYnNyA==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-32b4876dfecso33749031fa.1;
        Fri, 20 Jun 2025 14:40:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWToXrWnPjEvpV5H1ww8I5GDzJ9ZUvhKgoQJw42+kvj7PcgkRUs/1rZpNIOFtz8Tf+hnRYXKDP1oEuU6Bo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRq89QZb0+dft8pjkoLQ1wbARSU2xqjcYrJQkUdJef55lecOw2
	eQgXxnoqtl8VnGVZ5bSZvVBszIJomsWZ1LdHSS53Rvp0z6rPvwmAaW7s1LvDNMrWz+PJXWEKuWR
	RGSXRLWMATMtZ4Ap2g4kuxG5Lx72Isuc=
X-Google-Smtp-Source: AGHT+IFI9Dc/mtxoJEyw3remgS2Vs1zd2get9IG8GwWneEHvRPd7iWMr9sqaK9lB5dpZqZLfPe6e4h0HJtR0dmK2ijM=
X-Received: by 2002:a05:6512:12ca:b0:553:2154:7bcc with SMTP id
 2adb3069b0e04-553e5065bfamr1187766e87.20.1750455626609; Fri, 20 Jun 2025
 14:40:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619183414.100082-1-ebiggers@kernel.org>
In-Reply-To: <20250619183414.100082-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 20 Jun 2025 23:40:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHe6pVYrbe=8ivjMgqn1kc863rEUhjuGgyqida5RR6LFg@mail.gmail.com>
X-Gm-Features: AX0GCFt-ID9wij6UhWTmoAt3-o7scGZamH61yF8jKRfK0MZ4bU9Dng5eMiKAcq0
Message-ID: <CAMj1kXHe6pVYrbe=8ivjMgqn1kc863rEUhjuGgyqida5RR6LFg@mail.gmail.com>
Subject: Re: [PATCH 0/3] lib/crc: improve docs and change crc32() to inline function
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Jun 2025 at 20:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Document crc32_le(), crc32_be(), and crc32c().  Also change crc32() from
> a macro to an inline function.
>
> Eric Biggers (3):
>   lib/crc/crc32: document crc32_le(), crc32_be(), and crc32c()
>   lib/crc/crc32: change crc32() from macro to inline function and remove
>     cast
>   lib/crc/crc64: add include/linux/crc64.h to kernel-api.rst
>

For the series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>
