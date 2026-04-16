Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA47838A721
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776339007; cv=none; b=ftXz5Nk0UZ+44KCrvktJ+hHYfhhFMjRFjpZzqZtCrrQ5ci6dfKqNxPEFbR31W5/PGI4gNHI9T4jVb2l8UWxD0q1c8IUG5vOtKAdLXFicFgpCWWt6MEJbiX1aCZQ/ftY19+RuT6egYr6IdaY288QRdnq0iK1sxis3MYQmvEfLIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776339007; c=relaxed/simple;
	bh=onL90hyVAUlPY0ASaWQwK2lX8QEYr5m106IAfPoIE0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IEhQwrdP1d/3A7DIiXN11bpT2XW8kXHHWa+jeaF/T0UAtJm5yR3kzPUacae/zm2P4DrKwBRjPKsQmoVcVYwe6J76t1XrVc1UC5NGcrROedxXCMx/M08pxkaYI+1ZEZ+e9OFY1dyGCk2EirpaseYhWt+bmJIptZdDpqFPLnx5mgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d67a483d3eso851276585a.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776339005; x=1776943805;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0N28AiHhMQm9a3ncbvMl4jwXcNZbOrN6OiiJm2DjJOE=;
        b=ktkZUJp5v7rXKyI0HNJekQ0SYrxaRz1Yh13H9KqwffrQxVQprzALrlewXyqOUN1Z3O
         2anHRbXIctSLITAJzBdruMr1J2RNu6OHMjT6nrVYQJkIX4qmNnJXrhTVQ2+ZOMV5rn3i
         Dkq+LFjb/vTgno84VqzjKaNUl/vFu57RKEgkHyc/BP0suiVB65/XN3yc/q6ttUzVQWM9
         xEgtnfC9kTju/+svVasaoGSkpIFUmZs++GROlcQXbF6AmRjzHhScdLJqYY1GWKoSkc4e
         UNaaAIk9er+23LexXGfbuDZshRTQ4vdapukcAc3yl19oo8RA7yzMMDfcNuYQxQKvL2Iq
         p03A==
X-Forwarded-Encrypted: i=1; AFNElJ/aOASK2JrAkL7DW/C65mPONBus9pV2c4buDj0DgpCF53SIq6bLmgvgOqnKjS6YlxzOm0NDnV923LAocF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEaRI8hHEhyXN2e7R1hdWzvevBjIM2z1A6d9omJ/9qlDoJzGlE
	j7xx5FNcTSqR8LkxjkODy7LKm0dtQJPA7kHhQtNOexYGuH75isbuTR1XJkYJiTf0
X-Gm-Gg: AeBDietEBW4BPdWZyg/d26htsJd8ydZgwQdUpcPcaXOHYwq2QZAXdj1ZTFQwqHA3HDf
	Q8LdUcd77hbxrwNXrB8SfgMunWU2yfdfE7wjB0fpDN0i5fEfLHQK9roFAgUS8xpDsoLLycaFIMT
	lnD5qdC261mWWsC0YIYq6rSQZOhbbjP6ftEEQsIDfJWxIxx06u8QGDI4+j8I+CFNv8vGD9+Y6zz
	2oEuVC7EQuSxWE0ZLMoFHpbwUXhVuMZx78yq9W4kzCm/bqbzrXlzxPw8qGCVRpAjcZwpRXscfwX
	iBChoNZUdekd145vP4c16RsA+ZrqGblfIlQ53xdejd9bPlHwrCixylEXCriAxHhKw8qUP3zRaTj
	fVdKViDfLlzufgJOahklyH7H+ZqQiPxSYuYj+h9fGTxSwYehw4LcnTQW4Y0Upaw1s6Lge5v/D3Y
	m1Oqt3ClG9LkWeX01D/qdtezwYfG3c8RTtZEZglM6CSxUCJ0//3Bdwgi6+5JqmwAVc5/tCe/9zz
	9g=
X-Received: by 2002:a05:620a:4014:b0:8cf:d3f2:9f4f with SMTP id af79cd13be357-8ddcfca99f8mr3784170985a.55.1776339005425;
        Thu, 16 Apr 2026 04:30:05 -0700 (PDT)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com. [209.85.160.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4f2dffa0asm339457385a.38.2026.04.16.04.30.05
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:30:05 -0700 (PDT)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-506251815a3so65657261cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:30:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/+cJGlNnZPuNr3INvBsJL9tLYw+r6p1T/d1m6XBgm/66nCcSbfl+8A4tmj1v2yurQFyzFnp9MduyvAuS0=@vger.kernel.org
X-Received: by 2002:a05:6102:3fa2:b0:608:1b6e:f4dc with SMTP id
 ada2fe7eead31-609ff0c50e9mr11028119137.11.1776338540828; Thu, 16 Apr 2026
 04:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.045532623@kernel.org>
In-Reply-To: <20260410120318.045532623@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXtR7T62Wf+yDM=J0+96C64qRws=ffX_xXbfzfbS0Xz8g@mail.gmail.com>
X-Gm-Features: AQROBzCyA8BqoTVnHFn7fWQMKVWyMF2wrQlYn44P8f0X0RsdCOwGnnxui8decDA
Message-ID: <CAMuHMdXtR7T62Wf+yDM=J0+96C64qRws=ffX_xXbfzfbS0Xz8g@mail.gmail.com>
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Apr 2026 at 14:19, Thomas Gleixner <tglx@kernel.org> wrote:
> Most architectures define cycles_t as unsigned long execpt:
>
>  - x86 requires it to be 64-bit independent of the 32-bit/64-bit build.
>
>  - parisc and mips define it as unsigned int
>
>    parisc has no real reason to do so as there are only a few usage sites
>    which either expand it to a 64-bit value or utilize only the lower
>    32bits.
>
>    mips has no real requirement either.
>
> Move the typedef to types.h and provide a config switch to enforce the
> 64-bit type for x86.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

>  arch/m68k/include/asm/timex.h      |    2 --

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
