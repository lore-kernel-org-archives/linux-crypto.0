Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2005924469C;
	Wed, 23 Apr 2025 06:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745390979; cv=none; b=XfyVeYYS+FOfIJBPuVyEAqgh0r9sRiJurhpnexs9WMgvK6R8uopHPp4JeNPEX1SSYLHmS9MciYq2qW7wBpmxvvN+klMwoG/Z84PYcxCcYbXVlyioWhTviDxObqIOUq6wg4CA2GiT81MNNzCXw7BODchY9dUC/au6bkfdaGrR8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745390979; c=relaxed/simple;
	bh=Ehl+NZ5t+pJ2LNM/Rfo49VgfOcUOeoweEA2Yw0BSsa4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCW87now6n8rG/fDFJKFeNL9mK52Y377w5NIuut7wCb0VHPP9GFaE1OYQivfxgBVDxyy0LvPsBxs+YCcWwq59l7pMtOCBc/6Jh3P31T0Q/+NNe2BWgrNvL0AerA/kZdYMPlHHqG1LQ9xfoKJeaA6NYlh8ISemJCqgr1YwIv0QEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-86ba07fe7a4so5073304241.2;
        Tue, 22 Apr 2025 23:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745390976; x=1745995776;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hSW0k6Kn+DUsfXSh67UZRXiF1tiHa2nJAbebOAWkBg=;
        b=d0cff2w7o5LwIpPGL989YmPKb+rKBYj3I9vjp3xp5L5l6lQeOuqKozqRAFhawyd7b1
         z7BNppcekQFksF6Tna2jo5k0SotD+IPi0R57fnK3fvKYe8h1Lgxv/jnRY7mHPOkyHsks
         06KM6lrmqFZxbfvnrrHxXLbCMTjMxp0Hh3TjDmjBslBaGgl5PjbvqTHz1ukZ+0fZQ1wK
         hpdJZFm2RxdIms7fUjn9pUIowfTt/hqwLbjTQU84J3oJyQ/zeYaVmXSxREFHdL1F4Pnb
         X5xlCo+7yCNROgdVeFyGposlPH9AHqYRi7zdyff01fiNNR4d+KyGrHr0wTJfzmd0gkzF
         WB/w==
X-Forwarded-Encrypted: i=1; AJvYcCUedTC2ACK0OWPGCuajbdq5+1hQiD6QgBJMhOyKX8yfo1vVRZzYGiuIBfOb3klietHUfpLfLylWgGKeo/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdZEL5bUgZfGg2OHWv9yji01UpzNWTJ9ItKU9zxd4ENQnKhDkS
	D8049t2DBV3kWvwRhoc1/RiBiCGIve6Wk0gRl2zME3q7Z49qWsNsH5trza3C
X-Gm-Gg: ASbGncshhRZOEeiIy9+/QRp30r1NyUnkEvjQV1SetLZ9PMNVdziByWSW/gdJVlq6iDU
	SMwj336oTJvcM4P+e12B8MW2Su8Cn1UeYtFegbPSdHWGI8SVCeUtN5O/eR0/h3F0kL24toRMpGC
	1FDEB32UF3fWtUH2FXZS2ATDjZyIvIRpZcThmDyd3ao3tNNayyRv0hER5rOlbovLOw2KqgTEjRk
	Uhb2DvsKiuE4gSVJ9EsZ2DfDfWY4E5vO3m27Mj29wNOkCwrz6VPvO8DZUZoH4UShVNj2bIvobcY
	QclcwOhx320QGoFsPmnEIJaDkoVMgwNytlTwu36mum3iuGmR1LG3w25EEEJf/39E6IRAECV8WgR
	eU5kI8JIjJpZwKhvepg==
X-Google-Smtp-Source: AGHT+IGjkOfAP80YpT1m7QM2cmRT0iKbVwjUvE44/jQWygz8By67h2dGRjrqnvVu6f73IAQqeX/CEg==
X-Received: by 2002:a05:6102:5617:b0:4c1:a15c:ab5c with SMTP id ada2fe7eead31-4cb801f650dmr10630970137.20.1745390976600;
        Tue, 22 Apr 2025 23:49:36 -0700 (PDT)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com. [209.85.221.178])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4cb7dde0c01sm2428670137.15.2025.04.22.23.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 23:49:36 -0700 (PDT)
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-524125f6cadso5565303e0c.2;
        Tue, 22 Apr 2025 23:49:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV3Jg2CwWUIQZNUX79u1yhR9lNxj3DqmhnALqUuckdRE0GriCjASioQoFi0exxeo5oh9/8qDI2ZWEq2ePc=@vger.kernel.org
X-Received: by 2002:a05:6122:1da3:b0:526:2356:f3fb with SMTP id
 71dfb90a1353d-5292553a2ccmr15460813e0c.11.1745390976260; Tue, 22 Apr 2025
 23:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422152151.3691-1-ebiggers@kernel.org> <20250422152151.3691-2-ebiggers@kernel.org>
In-Reply-To: <20250422152151.3691-2-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 23 Apr 2025 08:49:24 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX5XKmeVABxeDv4shrUy2yt6WrMV2hxVPZ5OUe0uWUY6w@mail.gmail.com>
X-Gm-Features: ATxdqUEFJjPY_GH_V1Wtm4vTwomP9pH6In_aOmU8a_vCcnhN_8V_tOs01nzly4A
Message-ID: <CAMuHMdX5XKmeVABxeDv4shrUy2yt6WrMV2hxVPZ5OUe0uWUY6w@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] crypto: tcrypt - remove CRYPTO_TEST from defconfigs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

(replaying my response to v1, which I wrote before I noticed there was a v2)

On Tue, 22 Apr 2025 at 17:23, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> CONFIG_CRYPTO_TEST enables a benchmarking module that is only really
> useful for developers working on the crypto subsystem.  It is in a bunch
> of defconfigs.  But as with most of the other crypto options that tend
> to be randomly set in defconfigs, it is unlikely that much thought was
> put into these, especially when placed in "production" defconfigs.
> Clear it out of the defconfigs for now.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for your patch!

All of these are modular, so I don't think it's a big issue, even on
"production" defconfigs. It just means the test is available when
someone feels the urge to run it.
Hence I try to make all tests available as modules in m68k defconfigs.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
