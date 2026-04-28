Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09013DA5B6
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370610; cv=none; b=uHeW6/MZgpnhYpdornfIZHZd/Ohd/ahkZTO6u69Wjp+VZ4lqjlPvCDnbyY6Tkpzk1UUWfW9hszei4EulcEZJSqazg9vDYd7wUwal6Bb/otA3mlP6EjHNpSfg5JHjKZ6pHk2y1a1RV1TfuugVxrbSs0dj9fOai0ypVanaVTDrLH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370610; c=relaxed/simple;
	bh=nE2kTc46EAtHp+hzkKm/fM0pnbhHAPrXksUwFRqrq6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rFTrlqRDPiSDRJDg6ZIZ6sN6rnpLEhxEmd1pJOwOltp2vf9nzkFFfXL3kfj1Qt22VradaB0JMsWerh83X4KbSrFLgfrk7EhIQpYaRRnIB0sVfLet+Uwlfb+P9wjygQlLn7hXFi6BIBs8HZlK0n/wjFJNtoRbGwodqpPUHZoTwd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-56f8c77ca6aso7620719e0c.2
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 03:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777370608; x=1777975408;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRyHSlueZ2yIa5nhGJ3DTVlj1ZKdcYhWGe6E+g/f2HU=;
        b=LN6v9e/hsc6q1R0lZaS9DtTeeru+r1xKkDXdnmJphXtCJOdzNa73NotZDhg4QR740+
         YIG3erHTIQKU7ZtmBiuUz7mj1Jh9GpYoiSu2MMEgaoyvcEaaKJWPl560LsdOOAsMwr22
         qb5tAaQA3z8pWjxJ2jsjM6X40TPcP61TQtN1EtiM1YRxh4VYr6yAFrm0wc7ABciYWj9L
         fmxzwEnPseKKZnOnycRHEONFpyUp73yHadakym6qJGWuB3GT2SXZbkIxekBenAs2SKbv
         KhDVSHL+nUc3sdA2sMKUnSLyNOdJ5rXhFOKx2Hz0aygU9Iw0krYgNNQ0Hmf9uxuDzqKr
         8Rig==
X-Forwarded-Encrypted: i=1; AFNElJ9jJp3ef9jZx8mn5jV0SbzLSEUWxUwYP6zuBAjggPQqfg3tGDcUM10DXv4N9ds1v1D8xe+nqhco2nX/LXI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8TymW0xxVrs3pd6NcUzLSU7Rs/mvhG9sUgQgPZ6mlDrf53/d+
	cC7AINnaAO/BY1H2VfWLkZBO8FLu2tlMH24sNHkch7555Pwop8deuSy5us4o2YFUQI0=
X-Gm-Gg: AeBDiesK4u6uXkDeBd7T8NtQvggTf4fAj2uyWWvZzy3SofgBzGgWrvH4/6rBbJ9U1uD
	2IAsX1Hxv+EM2RJXu5RCc9HPr++dJyM/j0BCvk61s+ptIq5FPzJ3dvtwPhnaIU7rQ1Ks1YoVbVX
	tYAd0Q7FO0EB02JVWevTpenOouWS11+G2HXgUznF+qLWfblWoBK1p6brumu05o7CJ1a9S7SvHLE
	bn0wWK3ve/k6/SvIypSBRIeoAlU3Jnaoh+ruCPcNgqZ6+21ymqc5KCgNZOxKeM3yS6xJkVzveKu
	FAJifYi1LLqZf8W+PrLZ7yX+fCyDktbd+xdDhyTS5Hs1Jevc37IZXcE9fY4FgjOWPLorV9rbph9
	0s4q2DOfpJfaqyAy71x2skrILPL4EnV8WujjkmfiWvd/qMGLBj5WKZ9nfFsMTjOBnTCS2rFC/Zp
	PlPrrRF8uXPmKw1zDHfUFahqsyvapkqYnByq9m2pMUvJz+HqkncAv/AozRnPEewgv+1I507Sg=
X-Received: by 2002:a05:6122:4d1a:b0:56b:579c:82e with SMTP id 71dfb90a1353d-573a557ef07mr1079636e0c.5.1777370607706;
        Tue, 28 Apr 2026 03:03:27 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-573a45d5075sm1304606e0c.9.2026.04.28.03.03.26
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 03:03:27 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-60fa13bde2dso7079278137.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 03:03:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8MKeaseyOXRGMzH+Ae5PhQNThY0Blqmjl/rNAWQSWvN4b4Cl/EJStf+iu48R8I8ZjZjktMm2XzihUn3RU=@vger.kernel.org
X-Received: by 2002:a05:6102:8029:b0:609:444:eda3 with SMTP id
 ada2fe7eead31-6280aab5390mr872346137.17.1777370606595; Tue, 28 Apr 2026
 03:03:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428024400.123337-1-ebiggers@kernel.org> <20260428024400.123337-5-ebiggers@kernel.org>
In-Reply-To: <20260428024400.123337-5-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 12:03:15 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVc4_1hfrX5_qTrNmz8dpe=H37i-N0xy9_M3ZkzUTO3Mg@mail.gmail.com>
X-Gm-Features: AVHnY4IhVtJeI5bzqGCht8kP6KzDoM5sv9OtFI_ZUfpavb2rJ-ZtQSNVRJUngeM
Message-ID: <CAMuHMdVc4_1hfrX5_qTrNmz8dpe=H37i-N0xy9_M3ZkzUTO3Mg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] crypto: fcrypt - Remove support for FCrypt
 block cipher
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Apr 2026 at 04:49, Eric Biggers <ebiggers@kernel.org> wrote:
> Remove the insecure FCrypt block cipher from the crypto API.  Its only
> user was net/rxrpc/, but now net/rxrpc/ implements it locally.  The
> crypto API implementation is no longer needed.
>
> For some additional context: FCrypt was designed in 1988 and is
> essentially a weakened version of DES.  It has the same 56-bit key size
> as DES, which is easily brute forced.  Moreover, it's cryptographically
> weak and doesn't even provide the intended 56-bit security level.  Its
> author considers it to be a mistake, as well
> (https://lists.openafs.org/pipermail/openafs-devel/2000-December/005320.html).
>
> But fortunately this 1980s-era homebrew block cipher was never adopted
> outside of net/rxrpc/.  So its code can just be kept there.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

>  arch/m68k/configs/amiga_defconfig           |   1 -
>  arch/m68k/configs/apollo_defconfig          |   1 -
>  arch/m68k/configs/atari_defconfig           |   1 -
>  arch/m68k/configs/bvme6000_defconfig        |   1 -
>  arch/m68k/configs/hp300_defconfig           |   1 -
>  arch/m68k/configs/mac_defconfig             |   1 -
>  arch/m68k/configs/multi_defconfig           |   1 -
>  arch/m68k/configs/mvme147_defconfig         |   1 -
>  arch/m68k/configs/mvme16x_defconfig         |   1 -
>  arch/m68k/configs/q40_defconfig             |   1 -
>  arch/m68k/configs/sun3_defconfig            |   1 -
>  arch/m68k/configs/sun3x_defconfig           |   1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
