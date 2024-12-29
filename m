Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7C62C1A2
	for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2024 07:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735458896; cv=none; b=ML3Vz8QgqCCWQNjd67OumQ36CZ/I96XMzZImQfKQHUPcpuI/gGaPbjRB5peYOl+hKc1YoJqgIlowD1I6+HNmaLSsWRy2SPAp5k22wFjWf8OkND0UE/NwoHjiXo10cysZ3QgMAd/jMdSVALFtpwfvx+240BIjDTH/2k6H7b7Zh5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735458896; c=relaxed/simple;
	bh=j85502hXrdOFXRJLuJErtPkQ6vcFD6sZhFZCBfYpY4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJ16u3V7FMF6X98RjB6os7KM1g5FpdwZs9bC9sDPlamDp1xkFebZwiIMsVYh2ix3AaftUoIsP6CYkJNETYEIbMvCpmkps/Kj4Cb4ae/0PdZP/v+vx+Fcoq7Jf+lB7StUqX1MfCVzbOqM/v/VkW8lJ6wq+Vkl57antQg47on3V1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+vKXacg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+vKXacg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0345C4CED1
	for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2024 07:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735458895;
	bh=j85502hXrdOFXRJLuJErtPkQ6vcFD6sZhFZCBfYpY4k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s+vKXacgbiSFEZ56soNgSgPpE+hMOQNCAEiHOcs0pcq/RBAoN2uqWwh5j4c4mCCzM
	 uwc2zgANMusy5KESHUu7ErYaBGGfaO4jWJ433ceuvspHmgUPxKpYA/RQciDNv3X5/s
	 4vfzpiFSQ8/26vXe+FfBWc/DzGE/W0jUW97/jnfdXaFLaPBIV/OzMfmho/oCsTDCQT
	 OB6UmK8DgAsh3h7mvYswkVNjbliuySdjjj9jxovlDrDYKII/oadO9dUIY5CV/AyW7G
	 jdCeOFXeOfX9A4+QGx4LmlOlkoJdDFw2AIXU/+/IxikRI7k/yTaPthklrsByQBIM63
	 EE7kxTkP0ubvA==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3002c324e7eso95446271fa.3
        for <linux-crypto@vger.kernel.org>; Sat, 28 Dec 2024 23:54:55 -0800 (PST)
X-Gm-Message-State: AOJu0Yy0jjKa/8ZpbUNevySgqWCIO4E0rwuW9GVIocTnkLfTBtoLrqJB
	xeRj0S2tRn/u3WxR4wUWs0EnDh7PPhUxTXpxmzxVtKKzTm2gKH2UJFebdvd+/EVmzqjLum5o1Fr
	yaQI8WmPpkhErgQpuEE6p5rsUrME=
X-Google-Smtp-Source: AGHT+IEVD2/rtBFqhlWHir33yUHdmuYVFZfCAIfURepO5vcDkxSIZStJmEnSQ/PTRiROlsW2msipXXy4kqDVE0xj79g=
X-Received: by 2002:a05:651c:506:b0:302:1b18:2c09 with SMTP id
 38308e7fff4ca-304685f763amr110996181fa.27.1735458894160; Sat, 28 Dec 2024
 23:54:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241227224829.179554-1-ebiggers@kernel.org>
In-Reply-To: <20241227224829.179554-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 29 Dec 2024 08:54:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGFY3CfXptQZt85rV4fHO2Y2roVRs3NxTELzz+RyhO6WA@mail.gmail.com>
Message-ID: <CAMj1kXGFY3CfXptQZt85rV4fHO2Y2roVRs3NxTELzz+RyhO6WA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ahash - make hash walk functions private to ahash.c
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Dec 2024 at 23:48, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Due to the removal of the Niagara2 SPU driver, crypto_hash_walk_first(),
> crypto_hash_walk_done(), crypto_hash_walk_last(), and struct
> crypto_hash_walk are now only used in crypto/ahash.c.  Therefore, make
> them all private to crypto/ahash.c.  I.e. un-export the two functions
> that were exported, make the functions static, and move the struct
> definition to the .c file.  As part of this, move the functions to
> earlier in the file to avoid needing to add forward declarations.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/ahash.c                 | 158 ++++++++++++++++++---------------
>  include/crypto/internal/hash.h |  23 -----
>  2 files changed, 87 insertions(+), 94 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
