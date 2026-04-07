Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469F13A2572
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 07:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775548449; cv=none; b=rNXSpSm8smGDCH/jgNiDC0pjvTyrFdf5pyWW6HNOPEtRD4M4rwI/vwDHSMJfZ3R7mWvIzp/rYcF7aaCekGB7zTVPCefHIxXtm2EJ7OqFLA8rBekmTSxjDZQxQdA6IrkkqZviX3l9clnQL86OKLjSq7Mh7vHjK4u1ImW5leC7etw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775548449; c=relaxed/simple;
	bh=SA/Y5UMtIwiNf8LjDXzXrP512qUvnjOQr7Ac3bRFAlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XVf06LzfxdHUdNk/tQx2dfPF3vljJ8jL4UdCQGUs3amsUukUi/AgTiWXnVDKv1PhKWKrXDvpiOvvZSRJxLJnJENmVjWnDBkRke8h6880FV5hFtkrsk/FZOWJ5RzXMyfPsfJ6Foe72CZmjVRmOfMzagD4S5o7s36jxoqOZ8X21X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-60579e72ff9so3305840137.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 00:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775548447; x=1776153247;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S3vsOW+B7OYhYNMzQrQ+wQqHziPohNJv5TXUjsSUv1w=;
        b=XCbAZ8cq5/qS2zCHL2+Ndj0IDOUHLaqerrWooHxtwBlky5uKQs/ItCHR+gmtv9ZT6W
         uvGeX6toWisVt7oUNrm0YfXt4IYYnNnG5bSIy3jz5u6scCG4Llxkv1IwASu1hdmWNZls
         4OwKhtN8+77kObai2eWT3kgKm12ZauMmjuekI2055HXwQgqr5KCG2OAF7Z/e0I8t/lM8
         N4KjAg9ot28Apd8YW2HeX0fUXI+My7u9TploXQCppQj3RlTCZ79LSs9YbuLg3zAP+OFc
         A5bDRkRBFmO5d+QIlmH3Ql9/NWk9DVQcMb4RK/gnnjB9pQKI9s7EANFniYJtlZx7Z1vR
         p1mg==
X-Forwarded-Encrypted: i=1; AJvYcCWGaOG4ZsQ54evS1bu5ZutIYGcKCa1/XdnjCbt+5aUmk7TZsIbLftNrlspdqKW66QTGE9+x1hRu09Bv44k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/ke15kB3row8SnLIbx55EtMhnf+RuDwYigPJeQPjxcR8TUnM3
	I8JvRD+71K5ic7hui0L8uDo2d6mJ743xJVWQik/YdB4/Atv11A6ox3+bHHzFhyzP
X-Gm-Gg: AeBDietqZQGmRwiKp/XjvGmGmqvSgB6cq8+h62WLbT4/BiUuNY16L1nWrzDhWCGEBZE
	31AwMzEXgRuXZKIjX5pdFKTe3Ai36h58vbFzdchnFREoqU7+bRH95WctcxPzvv8Vmj7mCo/Me4u
	H5MYR9Rotpx8Pa+9oouZjYdNTyym18BWgdfthECBCMsOWE4AV+NT1cSeCCfkRxJy/q815Mj0NdM
	5s9xOYoY+BrjHdKiuaNe2o0F4FVgSdaDBIZBMWwcYXYyGAa7ua+uaSmrhpVlefD05/ot9U50RU+
	rPtTGILRf6lraNz9YItFgvmYojGYgbhxSI5rJ4zA0DF3bVkPTIBG9wm9vVQ1tK07cFBJA8bNPfT
	6ayZObyiPeIfPwWmxVTVcyogsoFzJobv+N2SKE6SUYrn+G48z8CfJxVX9dkNtnMzWNMTIio/Upa
	rDImkorLeO9uWJkbtv8qlX//kP4nhC/5wASyGso2L+fdsK2C6MZ1m1mq+6fLYj
X-Received: by 2002:a05:6102:4188:b0:5ff:ecd0:1d1f with SMTP id ada2fe7eead31-6058a97e0efmr6309781137.19.1775548447127;
        Tue, 07 Apr 2026 00:54:07 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-953fb4fb62esm15040201241.0.2026.04.07.00.54.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 00:54:06 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-6054aa7f6cdso4081064137.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 00:54:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXKLOSJPTxWQcoxvCFqfHF2X3PEKmVAY0oZoTmqqqDgBbONJY7Ss9/dtLGHreDQdtWxJUNREPxXZWZGRh0=@vger.kernel.org
X-Received: by 2002:a05:6102:94d:b0:600:3b3e:681a with SMTP id
 ada2fe7eead31-6058a87fc66mr6244649137.14.1775548446384; Tue, 07 Apr 2026
 00:54:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260405052734.130368-1-ebiggers@kernel.org> <20260405052734.130368-7-ebiggers@kernel.org>
In-Reply-To: <20260405052734.130368-7-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 7 Apr 2026 09:53:54 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVnC_NPH5Co--5-SCLw17hZWkq-_iz3cWhi6e6oA0iP0Q@mail.gmail.com>
X-Gm-Features: AQROBzAPn-cRMgXtKdvZnIrCSa0iIYxaxI0VYJSdnntVWbMPtn_Xq2rko4RLhk8
Message-ID: <CAMuHMdVnC_NPH5Co--5-SCLw17hZWkq-_iz3cWhi6e6oA0iP0Q@mail.gmail.com>
Subject: Re: [PATCH wireless-next 6/6] crypto: Remove michael_mic from
 crypto_shash API
To: Eric Biggers <ebiggers@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Sun, 5 Apr 2026 at 07:32, Eric Biggers <ebiggers@kernel.org> wrote:
> Remove the "michael_mic" crypto_shash algorithm, since it's no longer
> used.  Its only users were wireless drivers, which have now been
> converted to use the michael_mic() function instead.
>
> It makes sense that no other users ever appeared: Michael MIC is an
> insecure algorithm that is specific to WPA TKIP, which itself was an
> interim security solution to replace the broken WEP standard.
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

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

(although these would be removed during next defconfig refresh anyway)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
