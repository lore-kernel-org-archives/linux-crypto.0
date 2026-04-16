Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B254C3A7F5D
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776339004; cv=none; b=FgZGDSYuZFOOA3JIDXS1XABvrlmZuWzt+zYEUEyaGzPOKX9gQwjV23bz+1ji/wcvAbRYfR/QoQPYXQE35n/vMZJFkPobdU+8ws4OQjg9h0XWkBEt/ng5+jKRMH7ExqhSOmL3aXDrT+WOk2DHxw9gfjdbPttkA+UAd2Tir3j8lLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776339004; c=relaxed/simple;
	bh=FSgVIzpnraycKQsxAztrNgNSM9On/XU1ftEj+pCL/gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bebFiN876NVU8bRPTJS2twwKFRfy7yWmKhfNtLS1ieI00A7ulKHM4OKLkRmWMVdq5IsdNiWbS9HnsBq1y4KSlX6/1VQFCfvy5cM/IyStICkhUzNkswiWkLZXsGtH5M5ei8ZpEV4hpfjDBRnt932+wPdJAtARexfSvl71wd/r+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4670464029eso4446555b6e.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776339000; x=1776943800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AptjVPQ97g683jPGYCmYUacoTRTAG/3/TQY5t1TSdkk=;
        b=eEQ76WqFcfUK849r009aaDSlMhO+384MpMjlHtgNJFx8qq+A84rg4wYXtQ0vOTqI7G
         DgxYcceG4R4nexgw8nxDxAmsbE2j3PpZ8u+bpe/80ZGAixI5r2OaRsY2D4jCLCb9SQp5
         gdpnWQnw9BS2wt6L64rz1taUI28xhgVkavDMGq3mqsU1Zrvi0waEvnzb45Im6WhHc3r9
         7MOrJTls5AO8bwDa0PW9mR+ysYg8x/8M7tcIaMJNlW63+riuK0RGlZfUZ3d1nua2UpDd
         kCcQmVLln/cRV0MTZuefKd6QAZfIG2CIFjrkMECWwXHh15V2BY2y/JVuY8DHA5UM3sHt
         SSuw==
X-Forwarded-Encrypted: i=1; AFNElJ+F28dOFPoOH3uFHA48XDAyAA++HTmMvL3xThps4KaDwQ0EJt/mJDMWdQf3ASJvfaPIg55/qb86sGfhMhE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8W59lSUJeNa4ZUH8hBXKERgj8WVgpsT8PKEMcIW8T22FOyAh3
	afFxDl1tk+W9PB0joSAmRJX5/JSXZ3n6YBpBjuZDPprzFBYCPd582/ZCs/4iuDdH
X-Gm-Gg: AeBDieveyOOurgiTm8Fm2FwVabEPwG4ZKVtEAwka3drtrl7TH/OKN0CypBpIc+hm9EC
	2p8f3jZ2JMryjNl3ZZlZEdkJ7rJ4Ry9rqrLa7bFkhl4X6NPVmqnu8AwhEHQTWdWsLPQK3Nrf/ro
	Rc+CP7Tziv5iRUyrWikYO+1v7EicBmTCa9MW5JoolfeNWqiptaMkqq3VxPHHMn0+uGtHGMpUzJW
	ojM085+4oliZHlVN7Qegj9sqpc/svw2/pa3olPkw1c3YdTkd9slygEGB4GxMuXzDAWJzrln72Na
	uc32ICRCEXSEilIvysfhSsQEi+vWoBLk3tvYyvIK4g5zKME1H6txtZir3EyOZGAlwm4wX1VoyBJ
	PHGgHQ1mKSpcDIOXSGQ0Fxl6d80+qosf+7TYiRAZLVNYx3cnyyEoiFl3M82u9ZP4AwgipceHhCR
	xVANmk1KNWPsAyFFcqy6DN8NJV3kY9buxJCWYp+mi3HbelHpAXPyXoTyW04pB6yU56sUBnz/8=
X-Received: by 2002:a05:6808:6f88:b0:467:2926:1231 with SMTP id 5614622812f47-4789ef13d68mr14274993b6e.33.1776339000449;
        Thu, 16 Apr 2026 04:30:00 -0700 (PDT)
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4797a38afd5sm2502543b6e.8.2026.04.16.04.30.00
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:30:00 -0700 (PDT)
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-68207984e66so4360208eaf.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:30:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+DSb/gWshuAbleHzZpZhtng0OMv3dTtG5wagCBq3FWIl0JDDjbEi6j4CRZ6Pw216ao4oXTNfFwM5z+jjM=@vger.kernel.org
X-Received: by 2002:a05:6122:788:b0:56f:1ed6:1d29 with SMTP id
 71dfb90a1353d-56f3bca6059mr11244615e0c.9.1776338533353; Thu, 16 Apr 2026
 04:22:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120317.910770161@kernel.org>
In-Reply-To: <20260410120317.910770161@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:02 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX1aShz8esbYzJ7T-0Na6++_Yi315aCiUx0Cnsgod5uUg@mail.gmail.com>
X-Gm-Features: AQROBzBwwjc8yd10cT00Tu5Dl2qrCYQStWr3Lcobhh8coMrpPeCH9vhBSNokYJk
Message-ID: <CAMuHMdX1aShz8esbYzJ7T-0Na6++_Yi315aCiUx0Cnsgod5uUg@mail.gmail.com>
Subject: Re: [patch 05/38] treewide: Remove CLOCK_TICK_RATE
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
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Apr 2026 at 14:18, Thomas Gleixner <tglx@kernel.org> wrote:
> This has been scheduled for removal more than a decade ago and the comments
> related to it have been dutifully ignored. The last dependencies are gone.
>
> Remove it along with various now empty asm/timex.h files.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

>  arch/m68k/include/asm/timex.h       |   15 ---------------

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
