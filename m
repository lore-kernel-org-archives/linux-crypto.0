Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B33033F9
	for <linux-crypto@vger.kernel.org>; Mon,  9 Dec 2024 10:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733739842; cv=none; b=PmCbZFcGkp6ef41V+WRooR6JxHnOngtY/56fuC4woZQ6zbxUHYtfz0M7bO2/a5tjg+73LC67pp7lbmtQC6nVwSDnJCpYhgFkdIJLEj9pyRPy1+tapHKZuqwJ8lTQ8qiBHZVeS9q+qje8tTgJleP3R+c5i1VZaW/KMjbutAmZJb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733739842; c=relaxed/simple;
	bh=jiEKnUGR5eO1b8PyAJxlkPwOzGXuzPSXcEHxulOZeRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fgq2I44J8nS6A2XRgP0xRW91D/3uxhB7/3qdj+/3eznKVQavjK1VFlIQ18YdLTzhOb8acjfKBuGsDwDpUlzgF6jjG2sJn6bVs7F/HnND+stPILF/0F3/NkAeCC4gWkq3t1EqqmkEjqNkQx1aArucMQQH33zidKHvCSp3dLgwvOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kywLXW7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kywLXW7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CF2C4CED1
	for <linux-crypto@vger.kernel.org>; Mon,  9 Dec 2024 10:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733739841;
	bh=jiEKnUGR5eO1b8PyAJxlkPwOzGXuzPSXcEHxulOZeRM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kywLXW7ZBtC5in2YkFFH8nOf/3ajrolbxvfOojRl1rttEa+tDKpMdghj4l3F3I3iY
	 N3clIbAuR/hIi3aPdWrZrmjkUk7EOuULEpLNebd/HPefuyIiilYfOGnKU0qixhyBHj
	 6U7LQ0wc9w29jQpjRPchQXIGlZ/6RSo1r25qOhYtKtnT7iiWyWBZBOrFAdnI8kGBhM
	 9QS80/qq5rAiR0NiyB37jMPvpNHMlq0PpGY7bMIjWt9+BandKYhlKufoWKqXbOABuf
	 lRqfiWKxTHSUGmb2hRRgQpSHc1ueQhf5gjcfGAmhOT8krZnAZ8kOkay2RX1Qq/lZlE
	 vyqcN9k5rTAgQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5401d3ea5a1so1042305e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Dec 2024 02:24:01 -0800 (PST)
X-Gm-Message-State: AOJu0YyUbjeiJfOJVDaKYX+KvLckHBweCC3KUsPLLeuPiuQ/n8EICkIa
	er84XHlXwXG4VIF62NBxR1UAE6ME3xLY7J/zlGMaWCJSIEbF01xoPKws83emKyHhWuzCPEp0zK0
	sdUgZybuphrZMll/p9zEAheNoQgQ=
X-Google-Smtp-Source: AGHT+IEaHqTd+7gtxtbka3xgwLh/kL39jAXgEl1nCS9fVfNuhjH7/+JoNmxUgEZS4WHRYCYBpN2Q3M5SIPLhGFlqJ/E=
X-Received: by 2002:a05:6512:b87:b0:540:1dac:c03f with SMTP id
 2adb3069b0e04-5401dacc17dmr1291059e87.37.1733739840059; Mon, 09 Dec 2024
 02:24:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241207195752.87654-1-ebiggers@kernel.org>
In-Reply-To: <20241207195752.87654-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 9 Dec 2024 11:23:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFMJOFR29G+CQZ2x9fKjtBJYrCFboYMmRpp2-mr-_Az-A@mail.gmail.com>
Message-ID: <CAMj1kXFMJOFR29G+CQZ2x9fKjtBJYrCFboYMmRpp2-mr-_Az-A@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: more alignmask cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 7 Dec 2024 at 20:58, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Remove some of the remaining uses of cra_alignmask.
>
> Eric Biggers (8):
>   crypto: anubis - stop using cra_alignmask
>   crypto: aria - stop using cra_alignmask
>   crypto: tea - stop using cra_alignmask
>   crypto: khazad - stop using cra_alignmask
>   crypto: seed - stop using cra_alignmask
>   crypto: x86 - remove assignments of 0 to cra_alignmask
>   crypto: aegis - remove assignments of 0 to cra_alignmask
>   crypto: keywrap - remove assignment of 0 to cra_alignmask
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

Is it time yet to remove anubis and khazad entirely?




>  arch/x86/crypto/aegis128-aesni-glue.c |  1 -
>  arch/x86/crypto/blowfish_glue.c       |  1 -
>  arch/x86/crypto/camellia_glue.c       |  1 -
>  arch/x86/crypto/des3_ede_glue.c       |  1 -
>  arch/x86/crypto/twofish_glue.c        |  1 -
>  crypto/aegis128-core.c                |  2 -
>  crypto/anubis.c                       | 14 ++---
>  crypto/aria_generic.c                 | 37 ++++++------
>  crypto/keywrap.c                      |  1 -
>  crypto/khazad.c                       | 17 ++----
>  crypto/seed.c                         | 48 +++++++---------
>  crypto/tea.c                          | 83 +++++++++++----------------
>  12 files changed, 82 insertions(+), 125 deletions(-)
>
>
> base-commit: b5f217084ab3ddd4bdd03cd437f8e3b7e2d1f5b6
> --
> 2.47.1
>
>
