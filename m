Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCDE39F17E
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776335078; cv=none; b=sR8LPCS2sk+ph+k306mEXLA4JpeyV+GnQjBeqklY4U+UNPWYLcOOQFolqkLPWvB4sAvWcmhfD3ScaRTwSyhwhLTD9GYHUhil+lFKdRfaIGU5vzESp8YkNjd4Z8e7rwt/Ec3guuW8yT90Uy+8Z5X1EJkL5ddeZ24DRUDy8Li1POQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776335078; c=relaxed/simple;
	bh=Il5EilNKbQmVM1qv4XgxLAe02Z9+zxydkwUqJc2BPRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dsFWczDugO5/Nb6cnH5imdSa/TNMf9sJK34UsYkZk8om/frOosNiEK+LhpEfx9hU93fcCt5r+HqTjZTLY8E1e+AYiu8zODfHaTjOb2rSsUrqdPtU+KjeJimSHLX7LgOP9JLSX07Z+mPhDIU/8dWu/hcrmOzgBti1pZI4oev+7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-94dd01deb53so1822228241.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 03:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335073; x=1776939873;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9HEDsaws+1AaPEcUyrGjtCss1Kv3jZQFAB8Oib7mmY=;
        b=AjgvBuE0WWt0IF4P/oSUjo+Xxniawn+hWyktEPPQF4C4szqIhumJJJ3dBNLjYtN48Y
         fgj66g2bHmZ3UILhS+GHhKGYvzNQu7ZK9Qz+IHDGrsdhmRMCnzshzdqp9OGQ0cm/+zCi
         SU5VsuBdZsDwafAAb8ZZhNeB7FN5Mz5EV8ccecO7FZYWXG3YwcKUlrCuLWktGwhrPQxi
         FtWM5V5PME8gjRt2D7/Y81sPD0N7jY4FfyGIQYX4kkCTa4kQNQXvaXq+kUPCjKAEqlYa
         qz0iuwxWoMwZbFbQNfRcftce0usjcN3Rtpj0els0mVKXYHgUuHp/WTzGWToudkF08KeW
         nn3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/21aPjpJtOv9hsABZFiR5MFH2MUAtP/g76KGjJh+MI20dJnC/ZUvbFELjdJeW+1Rv3fcl7JAq58HeIUpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiHQFOLf3uPXkDPhS6XPaiRwEraERcnw24MatsO3ZJpFC6lNrH
	BsMv6RlaK6uuuhdlAMpqDyFSTfwQNB5hlsvs6KDEt8Vb657PmiLL1V2OQb9LeWAK
X-Gm-Gg: AeBDies3SU76equoNDlyr4pQmesTcmCpuCIROr5iZ7k3QdPL/8i9jBTNQ8RG08ddCh1
	VjhbfEgwNJOOExinjZSPp7sVZ3b39Bk38+avWrc0pqCfMPOUR0TPvOhi+TrX33R+sEd5UqrDUjt
	sY7orrzlKspp1IT25+suXlF+XMgXjfMMg4rVEBJ2Oa+HfOPm2zUSfq0dlBLzzfr6AEebYk8iq9i
	KX6ktldIAQYV+1ne6ku9gYAO+71lbpNy7UijzEH8VsYVEMeUuXvYcN1glHiOfylNd2OFpCbd5H9
	dqrpbbdLoUpC01fvdxuYzYRLrfh3gsqppLHaGZynGCs0IkJnfiz5EZDdgSA7dGD/IAgmvMsXuBS
	BgYHRdEFqyef4doxATOoUfuTTeqM9knsylmyNzoYs7nlGrSL7s6p4SO1XAs18F0WVVxssZC63UN
	IsUtLvruw2jJTINusF3JPLb3EzgagTaH5j/CNN/SFja+9LHdV3u9dzN8WU1IYraJbsbutpntA=
X-Received: by 2002:a05:6102:290a:b0:613:3fff:feb8 with SMTP id ada2fe7eead31-6134000025emr2686745137.29.1776335073318;
        Thu, 16 Apr 2026 03:24:33 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-612ccb251e1sm2198299137.3.2026.04.16.03.24.31
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 03:24:31 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-94dd01deb53so1822218241.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 03:24:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8DjkUEqzOvgJ8ax5aKcu5Q0bkrNClym5E617aV7cb8kKEly8q+u6l7dGM08J/IF/5DMV43elthDJpYZts=@vger.kernel.org
X-Received: by 2002:a05:6102:c48:b0:608:cd24:354c with SMTP id
 ada2fe7eead31-609fe9b0d22mr11966750137.3.1776335071251; Thu, 16 Apr 2026
 03:24:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.794680738@kernel.org>
In-Reply-To: <20260410120318.794680738@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 12:24:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVerN6Pz07CQH+hcvT=-ZD-r9VNrSrGzTQZBEsuecK_ig@mail.gmail.com>
X-Gm-Features: AQROBzDRGGELVSySTko37h6zEj8YoV3p6pwZDCVQUlUW6sZbw_W5mbJzFIh35nQ
Message-ID: <CAMuHMdVerN6Pz07CQH+hcvT=-ZD-r9VNrSrGzTQZBEsuecK_ig@mail.gmail.com>
Subject: Re: [patch 18/38] lib/tests: Replace get_cycles() with ktime_get()
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Thomas,

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
> get_cycles() is the historical access to a fine grained time source, but it
> is a suboptimal choice for two reasons:
>
>    - get_cycles() is not guaranteed to be supported and functional on all
>      systems/platforms. If not supported or not functional it returns 0,
>      which makes benchmarking moot.
>
>    - get_cycles() returns the raw counter value of whatever the
>      architecture platform provides. The original x86 Time Stamp Counter
>      (TSC) was despite its name tied to the actual CPU core frequency.
>      That's not longer the case. So the counter value is only meaningful
>      when the CPU operates at the same frequency as the TSC or the value is
>      adjusted to the actual CPU frequency. Other architectures and
>      platforms provide similar disjunct counters via get_cycles(), so the
>      result is operations per BOGO-cycles, which is not really meaningful.
>
> Use ktime_get() instead which provides nanosecond timestamps with the
> granularity of the underlying hardware counter, which is not different to
> the variety of get_cycles() implementations.
>
> This provides at least understandable metrics, i.e. operations/nanoseconds,
> and is available on all platforms. As with get_cycles() the result might
> have to be put into relation with the CPU operating frequency, but that's
> not any different.
>
> This is part of a larger effort to remove get_cycles() usage from
> non-architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Thanks for your patch!

> --- a/lib/interval_tree_test.c
> +++ b/lib/interval_tree_test.c
> @@ -65,13 +65,13 @@ static void init(void)
>  static int basic_check(void)
>  {
>         int i, j;
> -       cycles_t time1, time2, time;
> +       ktime_t time1, time2, time;
>
>         printk(KERN_ALERT "interval tree insert/remove");
>
>         init();
>
> -       time1 = get_cycles();
> +       time1 = ktime_get();
>
>         for (i = 0; i < perf_loops; i++) {
>                 for (j = 0; j < nnodes; j++)
> @@ -80,11 +80,11 @@ static int basic_check(void)
>                         interval_tree_remove(nodes + j, &root);
>         }
>
> -       time2 = get_cycles();
> +       time2 = ktime_get();
>         time = time2 - time1;
>
>         time = div_u64(time, perf_loops);
> -       printk(" -> %llu cycles\n", (unsigned long long)time);
> +       printk(" -> %llu nsecs\n", (unsigned long long)time);

While cycles_t was unsigned long or long long, ktime_t is always s64,
so "%lld", and the cast can be dropped (everywhere).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
