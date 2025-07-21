Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA436AA7;
	Mon, 21 Jul 2025 04:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753072276; cv=none; b=nfmHLf8UdU0HHoZOaSYAmTP3Va2wjhYK93P3lcfGOoW1doMp7z4qhcmKOlWSGCszGriLuQmG/EZMMLBY9s2sSHEmRBs2O6MIdf0Dp+zOBsA5IWVZ6qFr3uWVL+l4ABH5SYL1ESCoOw/0R4ipQ/HS4Ayrvx6plp/jvus5nEn1lb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753072276; c=relaxed/simple;
	bh=tFYIKgmLi9PqdbwsUcrQoVZQbCB8C4dQeOpodg+Y494=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mD36HX/v+YCD3D/S+IlUeW2clNazrhqLgRBKJfOBpRdpaL0mBK+Ey0OErVJnO236ZMKJtprGgUaPJn9mARfQEKizv0wUJyaTN0tv3NnzdOLn1wWSuxefv/Q+DUb0+0EDbQnjvnAPrlt4IEvHBmjkAN492hL4nmBLO+iqYE0KaEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajXAUpWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajXAUpWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AA4C4CEF6;
	Mon, 21 Jul 2025 04:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753072276;
	bh=tFYIKgmLi9PqdbwsUcrQoVZQbCB8C4dQeOpodg+Y494=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ajXAUpWmVnPkyA6BD6SW9y9AkMWKNrcQoHYuXYmEcMF1gH5/xgdlT2kvow5EzmOQY
	 ND7ssxwSg8T2euxmLIrnZTT5ZoTwZjdhRaVvZihn2w2JMN80be4kmv9DQpJvnKB3fB
	 2Nrg+6ujdRMB/ENS+0mLPzLBdlP5+Uf/J8g8prLhUq5RX5NXJxH2MaChH2r1BacXMU
	 W5SB3txysin6H+MBJAIeQFBjo4yIgrTVNUn8bnVDrH1Tjy9dqgL9xyGwpBYOJxeQIA
	 OzLYE1sjmQEX36gJNRQMz4N+y1U7uwBlA2xi20rjnh0k5KHkGjIdO1g6hUei+iQ3Sh
	 o0QXH28eJxHAw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55622414cf4so3386177e87.3;
        Sun, 20 Jul 2025 21:31:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUVHWna/kpmqEpVTRwmG9Gu0OFYti5vjbeC3GaJd9y31e5NSWeIcihZbYeAUblyNzkFwrJjB/afiu3V2eU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKmuITEtMkxA6K+N2EGdv/fPGTiuHL69UBu80MTSLm14696vEY
	DMQ3DqcqIn5DCjYyA/chE09G+xcrlREoeF+ZAITqMvNETmsdTO8ON+iRKWaufy710IS8z16H2Pi
	BCOOlmQym7SKZjWJBirW4zMMn6sz4Y0U=
X-Google-Smtp-Source: AGHT+IFxYrKPiFnquEFEjbXx7SinlBEd19ORgwxsoO+Qodlerja2zHOhZh9r9VefqvbLhskSgdCR3k4c2CB+uFe0kT4=
X-Received: by 2002:ac2:5501:0:b0:553:2e37:6945 with SMTP id
 2adb3069b0e04-55a3188ef64mr2809429e87.32.1753072274598; Sun, 20 Jul 2025
 21:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718191900.42877-1-ebiggers@kernel.org>
In-Reply-To: <20250718191900.42877-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 21 Jul 2025 14:30:57 +1000
X-Gmail-Original-Message-ID: <CAMj1kXExtd=Kyz5yLUcAa1jt1aO6SnQLHTUy0G-vdPyG9+bwsw@mail.gmail.com>
X-Gm-Features: Ac12FXyP6_FBA9Z1gYIv02BKDBFZ48NmSFlQa2GNf5zKCRg9wSpMfj4usDG1VNg
Message-ID: <CAMj1kXExtd=Kyz5yLUcAa1jt1aO6SnQLHTUy0G-vdPyG9+bwsw@mail.gmail.com>
Subject: Re: [PATCH 0/2] sha1-ni-asm.S cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Jul 2025 at 05:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series cleans up the x86_64 SHA-NI optimized SHA-1 code.
>
> This is targeting libcrypto-next.
>
> Eric Biggers (2):
>   lib/crypto: x86/sha1-ni: Minor optimizations and cleanup
>   lib/crypto: x86/sha1-ni: Convert to use rounds macros
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
