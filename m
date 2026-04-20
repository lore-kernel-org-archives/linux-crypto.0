Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C083859DF
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776672480; cv=none; b=HU1apsG8YyyGQDEx461ol4xzT0C3CGZAJBlKq7/6tpQA1js9FiMg7QxJ1iFIjwwFK+EkrQj+8gR71Qi3TXkP5LEYs/e5u5kig/47SDOfWDIkR/92bpia1HdFIxfJhlX2gLQVMZ1/FBkTfik543aE6b7saAlO7vu0qeZo5+o5eGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776672480; c=relaxed/simple;
	bh=UvVP6sPvQDWa2iOA2ZnJo3XziAKNEnnW1S9OnFPOiRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ChejoT4Tb1FIobyB5XL2wovsGX/RHrapCSRhJ0wqIH7iQtdpkq/bL8DaFEZMLnatNJ2rsA0OM2X/BkJxq6h11IF2zLC5zPInO8Q/RmVqrbs9esoBAfCQP0qIij9ce8HQiQd8rHT+8EGIeaCZYi27ryhuVNqamKwbiTnm1yFEMlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-56d95bc93e3so1734978e0c.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 01:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776672478; x=1777277278;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y76piFZ+kh6lscQExu9rpbEadv8KhXej2yUq0oHuYvE=;
        b=nEzXrDIhn7GGNAfEi7hwAZvD6hgVvksGiORzuiLAGxiK5alT3B3fp5JRotn/JnOQ6m
         xfP0HLA7AuX7AG/0wbzbLjHNDtMGaa8Y8NNK9zfOPmRMhpqbrUFvC68bYqGFd6maNyrh
         J9OQ3Qii+8MOia9KO0+cQLJxFcY9B78FqN0lJAAk4KVTfIq9DNNcgkTdA1YVJl0DpV8e
         5lUi1wRGV6Dyex5Mp0IuRvAjz6FqeU4B4hX/wmHMBPkw0PUFIsoVkExN/RihMcWdP7Mw
         yKzgWHE3yTGlWE0XnLiHbZqlYwm0na64FI1vFTl0S+RquF9AykiPg0lQAXEuJNUZgPWY
         y98g==
X-Gm-Message-State: AOJu0Yz90X469qntGN4htASpd5YXnhv37kPLsvhZ411bbvSOMP3jlBte
	U+vlewO+4MJANgE2GYGYM4BDL9IRln9olTZTDEBa7kakvZkKeQQAFfIyJx3zubrz
X-Gm-Gg: AeBDieumrxjLOwD9Kvjzf0vINV0pYfPBuoAQUKa/xeioEUv5BNqm+X68sQeURK9Npr6
	51e+9as5XJdV5gva3vyeVPXnTPgBH3b8IkLwxrhaHr6jCR1It2yZJQuTg1Eupv24/Bbzx61uya6
	JOTxf+UvhB75C9E8HxqBc5ZdVMCE1WqtqVJmrEkp2fuTNnliMfDLN+iJeYNsTNi3QXCuhdG+yb2
	SwuAoh9qIElZDr/jlxL6VF+5kSGsjNkTgie52vDCV4ULNgj5h87T8MeOHpZIpE8nIgNE0R10L9K
	XlJcAh1EIsL/I/s7e5VVd2CuZYnIQp7thogKTUbwJWcKrpgknQrByowfLAIn0ny6+bUNuyobzm6
	zqSbeoFYFpa0rc3t2ovgAcBzN8btlToOTCrdqZUFcyZ4/uqntZOLiwD3br9pQc6bbbZtKZhFCB9
	FxYEV8hAO6+FezZFtuKvAylhwAQtY0oavBbmJ+ZviSP0mwr8EeG3m9DFJhV9B7hclU7ePbUs4=
X-Received: by 2002:a05:6122:3c48:b0:570:2ace:c14a with SMTP id 71dfb90a1353d-5702aceca68mr707668e0c.0.1776672478493;
        Mon, 20 Apr 2026 01:07:58 -0700 (PDT)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56fa91ea606sm5559588e0c.5.2026.04.20.01.07.57
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 01:07:57 -0700 (PDT)
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9568bae58f7so1223551241.3
        for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 01:07:57 -0700 (PDT)
X-Received: by 2002:a05:6102:5491:b0:60a:7c2f:8ecb with SMTP id
 ada2fe7eead31-616f68d7579mr5660407137.15.1776672476969; Mon, 20 Apr 2026
 01:07:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420063422.324906-1-ebiggers@kernel.org> <20260420063422.324906-13-ebiggers@kernel.org>
In-Reply-To: <20260420063422.324906-13-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 20 Apr 2026 10:07:45 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXUaQ2k4gY9QwO+GxRVgUZm6AJ_FMWv_8P2pAkRrYoKeg@mail.gmail.com>
X-Gm-Features: AQROBzCfGQob5s_jmfc4k5Hyr7YRG-yEyXXdAlN_u3YQ7qsotVEJLqMweG5GuRo
Message-ID: <CAMuHMdXUaQ2k4gY9QwO+GxRVgUZm6AJ_FMWv_8P2pAkRrYoKeg@mail.gmail.com>
Subject: Re: [PATCH 12/38] crypto: drbg - Remove support for CTR_DRBG
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Apr 2026 at 08:41, Eric Biggers <ebiggers@kernel.org> wrote:
> Remove the support for CTR_DRBG.  It's likely unused code, seeing as
> HMAC_DRBG is always enabled and prioritized over it unless
> NETLINK_CRYPTO is used to change the algorithm priorities.
>
> There's also no compelling reason to support more than one of
> [HMAC_DRBG, HASH_DRBG, CTR_DRBG].  By definition, callers cannot tell
> any difference in their outputs.  And all are FIPS-certifiable, which is
> the only point of the kernel's NIST DRBGs anyway.
>
> Switching to CTR_DRBG doesn't seem all that compelling, either.  While
> it's often the fastest NIST DRBG, it has several disadvantages:
>
> - CTR_DRBG uses AES.  Some platforms don't have AES acceleration at all,
>   causing a fallback to the table-based AES code which is very slow and
>   can be vulnerable to cache-timing attacks.  In contrast, HMAC_DRBG
>   uses primitives that are consistently constant-time.
>
> - CTR_DRBG is usually considered to be somewhat less cryptographically
>   robust than HMAC_DRBG.  Granted, HMAC_DRBG isn't all that great
>   either, e.g. given the negative result from Woodage & Shumow (2018)
>   (https://eprint.iacr.org/2018/349.pdf), but that can be worked around.
>
> - CTR_DRBG is more complex than HMAC_DRBG, risking bugs.  Indeed, while
>   reviewing the CTR_DRBG code, I found two bugs, including one where it
>   can return success while leaving the output buffer uninitialized.
>
> - The kernel's implementation of CTR_DRBG uses an "ctr(aes)"
>   crypto_skcipher and relies on it returning the next counter value.
>   That's fragile, and indeed historically many "ctr(aes)"
>   crypto_skcipher implementations haven't done that.  E.g. see
>   commit 511306b2d075 ("crypto: arm/aes-ce - update IV after partial final CTR block"),
>   commit fa5fd3afc7e6 ("crypto: arm64/aes-blk - update IV after partial final CTR block"),
>   commit 371731ec2179 ("crypto: atmel-aes - Fix saving of IV for CTR mode"),
>   commit 25baaf8e2c93 ("crypto: crypto4xx - fix ctr-aes missing output IV"),
>   commit 334d37c9e263 ("crypto: caam - update IV using HW support"),
>   commit 0a4491d3febe ("crypto: chelsio - count incomplete block in IV"),
>   commit e8e3c1ca57d4 ("crypto: s5p - update iv after AES-CBC op end").
>
>   I.e., there were many years where the kernel's CTR_DRBG code (if it
>   were to have actually been used) repeated outputs on some platforms.
>
>   AES-CTR also uses a 128-bit counter, which creates overflow edge cases
>   that are sometimes gotten wrong.  E.g. see commit 009b30ac7444
>   ("crypto: vmx - CTR: always increment IV as quadword").
>
> So, while switching to CTR_DRBG for performance reasons isn't completely
> out of the question (notably BoringSSL uses it), it would take quite a
> bit more work to create a solid implementation of it in the kernel,
> including a more solid implementation of AES-CTR itself (in lib/crypto/,
> with a scalar bit-sliced fallback, etc).  Since HMAC_DRBG has always
> been the default NIST DRBG variant in the kernel and is in a better
> state, let's just standardize on it for now.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

>  arch/m68k/configs/amiga_defconfig          |   1 -
>  arch/m68k/configs/apollo_defconfig         |   1 -
>  arch/m68k/configs/atari_defconfig          |   1 -
>  arch/m68k/configs/bvme6000_defconfig       |   1 -
>  arch/m68k/configs/hp300_defconfig          |   1 -
>  arch/m68k/configs/mac_defconfig            |   1 -
>  arch/m68k/configs/multi_defconfig          |   1 -
>  arch/m68k/configs/mvme147_defconfig        |   1 -
>  arch/m68k/configs/mvme16x_defconfig        |   1 -
>  arch/m68k/configs/q40_defconfig            |   1 -
>  arch/m68k/configs/sun3_defconfig           |   1 -
>  arch/m68k/configs/sun3x_defconfig          |   1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
