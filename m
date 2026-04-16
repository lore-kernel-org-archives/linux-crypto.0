Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF43A63E7
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776338554; cv=none; b=m8vYuZ8iVdACHj5CDn4UD3p/f2bwFXVivMBs2um82aKYCBC8rQuM0X7UsHL6VukoHhvQmilw0/fohVuEdsllhV/gMX7GNF0iYehI/6s4MyGMtBC5t2xUWE9dxcIK6ytPqKXCX1qPdj5aGCR7MkD7WYudE6iTvGafiAB744p7/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776338554; c=relaxed/simple;
	bh=5RcGmn3E6IkK/4PLTUVN24XJ2jAiV11BodM4t9S5uGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E/DeNVoZT2R4jeVUWwe6DBv3AKb7zaWUaNQK6TH52h4UqeYKdA4mHmNlzQZkzs9enwYqNHUi5YQradXDUM2HnsaYd09tR9ufdRlpQhFYLxAwHG44LSpG+Qj0rSGU29bbAhqJcBgQobum6QVdrreMiaMPu4N3Ex2NVlcZ/Nt4luA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-56f75445470so2068704e0c.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338548; x=1776943348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6jqlHRyBmHp78NPQbVn/INUSPCxYZ/sUXVIyq1nXfE=;
        b=OSozXJoUqnUqYLfOJxlJUJmdSN5qMxeh9sKJqJex9C4qN63YrdgfufD2saKrWVtoCX
         aSri41vrXdIC/UCFVZD786bjIkmnV/cRfRuLY2Pbz//aMRECFCO7TKoLCJkgNOMmRMZg
         T+p4MkAYFOHAtovH/0B5ppXfaJXC5vchzBGO3nL7iVWPBz7zV+sxtdIiqJX0klyW+Q7Q
         0eQdFPLRsisVzhoYln4CBvMDFwlEc+q2hWm0Uu64q6jmupKfBgdS9ZoNYgu2XC5bkxzf
         qUGkrxrs45t5OaMMFLVXMEAoBm/06BIf/mzL/chubWrbYQZTmG4Q6OFYDgVDVNPd+HT7
         Iyng==
X-Forwarded-Encrypted: i=1; AFNElJ+7OF4AF5AtD0TIwlJ4mUClxmKL/SL/xy2KnXwrs14RCy6HaYGnHj1cFAc4E3W9LJ2TGbBbkLusnp7kWO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YynfsGoe0GyiC8QrSBpAp3MwuJRKBy5rOCw3lQdSi0P7l1N4kw0
	JWpa2jxHdCLmsbnxR5fjCBucXQS7Ntf/cB0mdNX19YLYsWSuWx/zYnFN+/Rfrjb5
X-Gm-Gg: AeBDieuarkIyJFqIrJ+jO6MvgMuhA6+jt2R3JuPs0csYcF6LelXg+7J6erleopG8pH5
	6G/RvjkqUW6Bg2RoeGtq7Rby3zfl6X3Swyqd8SiVnkIRIo6qzd3WGcxM74RRTL5F+9dqT8D4DUw
	zZcJU4ZJOtIHEHxVWyMTlQl0HTYLtJLjC/P2NtW2T8nWymiA0WPpYvgSH2P76MKte1ZI4uOd5Qm
	pddn05aqfdyH3tKpk1GxeSArAALq+9+v/MOqyZI5RngR5fUibKK0SV5zT4BZS2isadSrijh6c9Y
	OjbabRhK0YmUbanMPiWt+79KMBxfLBUCtp/bvAxHgk77L2OJpmGrH4mlEz+JNUabov++rfu3xaC
	+DFsLYHGDwF2bm1FUjJTb5sI85afQtkLUgW2OdyxJdUz+rFGVf9Ddg3nHNkd6nAnrpxVNHnVlXK
	zHhieKQ0enJBkiQmAOIMPPjAjLBV4RIzIoldtianW5y/uiiAB4XcZGXC3NDxOckPHNSzzuOCU=
X-Received: by 2002:a05:6122:62e9:b0:56d:aa1f:e48a with SMTP id 71dfb90a1353d-56f3bd0b045mr12543921e0c.12.1776338547807;
        Thu, 16 Apr 2026 04:22:27 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56f89dd3bc5sm2886213e0c.3.2026.04.16.04.22.27
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:22:27 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-606045ef716so4243818137.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:22:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/AHurYOms74vwx4RzrOx+MgJv+e5xqFam4fxUPqOrYql7H+8xpldTNqY+/aRCsgW3SRxvjeOgICX5zUXY=@vger.kernel.org
X-Received: by 2002:a05:6102:6044:b0:5ff:c64d:2283 with SMTP id
 ada2fe7eead31-60a0157295cmr11348128137.30.1776338547396; Thu, 16 Apr 2026
 04:22:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.397219631@kernel.org>
In-Reply-To: <20260410120319.397219631@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:16 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVoo_6i9=2oQj-=yjW7nK8eL4og08bdYvk_EGj=_cQvQA@mail.gmail.com>
X-Gm-Features: AQROBzCJ6rVnwwfhi99PI36wWXAFQ5DEgo1zw3RhVwYNSXoxkTYAcgIxt5Z0K1g
Message-ID: <CAMuHMdVoo_6i9=2oQj-=yjW7nK8eL4og08bdYvk_EGj=_cQvQA@mail.gmail.com>
Subject: Re: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-m68k@lists.linux-m68k.org, 
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, 
	iommu@lists.linux.dev, Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
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

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.
>
> Remove asm/timex.h as it has no functionality anymore.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
