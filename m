Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7550919E97B
	for <linux-crypto@vger.kernel.org>; Fri, 27 Feb 2026 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772181184; cv=none; b=mwu/PpbVvCinepOT4NeB/c4WG+VL/3U2WrLCLQ0qvaza79Y3ijwIikAdxcIhMCjOXiAcqw6X1WFblE1Tb/f7q0a6JiKF9ROD/Vqp02cpYl0ke4jV1ECOwjiD/gLGjcWaHGbfoKbdz35lfwFs5Gjk7ak0H/AOMjuvT4j/PMhm0C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772181184; c=relaxed/simple;
	bh=3RupPG3bVf8o1iXp3/mZ55D1C9CIdFksOYT0HhrFzOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VyrXt3xWYr6gtgAaiaK1+YmvMusyhKgFz0TxypRcIih6tkQXAO62P4+SRQv8T/EIvKYfor9uWKbZs1aYKTOP3N6hfYADdvxniOr6NjUFrreVLlflGQUz6TvcKKo81xiAh2zgPGNibL/krta1tt/4aVw7EcbDoNsFBJFxWmCncdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-94acf9ce1b7so1355526241.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Feb 2026 00:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772181182; x=1772785982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dEzLMMeMCHGMsmtD9q5xZQbfso5OBJS8UWwuF8jf68=;
        b=rTmp/sViFx7D0WnXjImyzFiSCHeDww9aiSgD+DnbMdZxIesQgBDxeDNQPb1a4z5uDw
         A2iMYz42rxlW+iCSo7+vmxjZWdsVeOrvU4OegqlyR//xEF5Gme60cunn/OBlofMOMyQ4
         kkUlnNibhlqlrgDKZGi0fcPVkjdip9THmFYeuJGwV68jqnI/dICWVwOGLNbuufdiUlcx
         CS4i/rR1iTaOpGBAVnIUC7TRPA8rr8c6/eP74eTp+IPfW6lZOGypkIx8HbAFJ+/EGPYS
         URU1V9UOBJv9KvAaVuR3ohRktbrEYevse6LBBS59Oj9jXd2OmCXDQU/t74WZI+3XXtnr
         kSIQ==
X-Gm-Message-State: AOJu0YzF42QYn8mnnOglrJWx9cXc/vqFaTMyRg5MitbPAOnTl3/JJijW
	HLbF8NR0rIZKzHx5lVpcsU5SssHr6c4qNVPHV34I2wL4ScBmdRd+IYSN/UPb3oEOdBk=
X-Gm-Gg: ATEYQzx3Jc8vtLa3jKzUsDIA0H0OKwbBZwZaydFA0zdhtK1UdewHkxBUryxd9so44+2
	uQuzyR5iydFcXXfW1gxI256dxR2SsRKR5QaYZxdIK7kk7ZcsVNb9EQ8AQs30KVhIlIV1jld9d9/
	7msx7Ed7IiC2KEVQUU6IJTIBdBi75WmD7Bx03A0jtg09Dsvv3ZXJ06lnbVjaQ5ol/5hS4oWPFYI
	avbavfEGBDSsRT+LAzaCTVbaQmNhIGl0TB+hjh6AzYZRIcSCLgDGzmsb323LwNGLcn/9+deK9ni
	0I4KHmJZa7aAEct6TiAuEvJtdGBxqDVdzdcyi4qL+dFyw7H5ZToqoGUekegm1at/yoRbz4Mc09R
	2fD9zyFIY5Z68+Y9r3J4iu3PJ1k+5Kq/Bl69XikOTQWB/TJ3r8WWKt6HwRyJE/+aZSDnRMrVbg0
	CzBqSNCKGoIjPEq+bTE8N3eUhacCwZym2gKq8c3OG54lm7G1qwdquISCDSfa/jw/eYIxBwwvZJE
	h8=
X-Received: by 2002:a05:6102:a46:b0:5db:cf38:f506 with SMTP id ada2fe7eead31-5ff324e889cmr1364025137.23.1772181182393;
        Fri, 27 Feb 2026 00:33:02 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94df63d6f03sm3946198241.3.2026.02.27.00.33.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 00:33:02 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-56a9402b52fso1546992e0c.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Feb 2026 00:33:01 -0800 (PST)
X-Received: by 2002:a05:6102:c47:b0:5f5:487c:83d2 with SMTP id
 ada2fe7eead31-5ff325d53c9mr1297367137.38.1772181181577; Fri, 27 Feb 2026
 00:33:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226191749.39397-1-ebiggers@kernel.org>
In-Reply-To: <20260226191749.39397-1-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 27 Feb 2026 09:32:50 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXH94DvcDKN1zTzTBOrcn_zAfZZZJCyGbxjfs8DBya5_Q@mail.gmail.com>
X-Gm-Features: AaiRm52H2NMgOqKerYwyHCRsXF_5j9O_JAbJk1Fw4Sl8AnR8WmXboXf1vEA3uZA
Message-ID: <CAMuHMdXH94DvcDKN1zTzTBOrcn_zAfZZZJCyGbxjfs8DBya5_Q@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: tests: Depend on library options rather than
 selecting them
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Rae Moar <raemoar63@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

Thanks for your patch!

On Thu, 26 Feb 2026 at 20:20, Eric Biggers <ebiggers@kernel.org> wrote:
> The convention for KUnit tests is to have the test kconfig options
> visible only when the code they depend on is already enabled.  This way
> only the tests that are relevant to the particular kernel build can be
> enabled, either manually or via KUNIT_ALL_TESTS.
>
> Update lib/crypto/tests/Kconfig to follow that convention, i.e. depend
> on the corresponding library options rather than selecting them.  This
> fixes an issue where enabling KUNIT_ALL_TESTS enabled non-test code.
>
> This does mean that it becomes more difficult to enable *all* the crypto
> library tests (which is what I do as a maintainer of the code), since
> doing so will now require enabling other options that select the
> libraries.  Regardless, we should follow the standard KUnit convention.
>
> Note: currently most of the crypto library options are selected by
> visible options in crypto/Kconfig, which can be used to enable them
> without too much trouble.  If in the future we end up with more cases
> like CRYPTO_LIB_CURVE25519 which is selected only by WIREGUARD (thus
> making CRYPTO_LIB_CURVE25519_KUNIT_TEST effectively depend on WIREGUARD
> after this commit), we could consider adding a new kconfig option that
> enables all the library code specifically for testing.

You can make those library symbols visible if KUNIT_ALL_TESTS, like
I suggested (after I sent my earlier reports to you) in [1], and like
Vladimir already did in [2].

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Closes: https://lore.kernel.org/r/CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com

[1] "Re: [PATCH v3 net-next 05/10] phy: add phy_get_rx_polarity()
    and phy_get_tx_polarity()"
    https://lore.kernel.org/CAMuHMdUBaoYKNj52gn8DQeZFZ42Cvm6xT6fvo0-_twNv1k3Jhg@mail.gmail.com/
[2] "[PATCH phy-fixes] phy: make PHY_COMMON_PROPS Kconfig symbol
    conditionally user-selectable"
    https://lore.kernel.org/20260226153315.3530378-1-vladimir.oltean@nxp.com/

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
