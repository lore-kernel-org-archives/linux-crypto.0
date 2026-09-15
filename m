Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44394184524
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477090; cv=none; b=Ig7lnK17g7dkG+/hN02iJ4LVzw2VrtA7+5I7yNhUclXxK+xGDPFcLv465x0//vVySvTMmvOXkGovwC9h/+vBTHrtsXdJjLeN4/SGSXyZshwKi0m1INYousGBRvQlDy5Y12WzGs2jFiufMBSgnWLUHe5LjXOuGFvYOOOAajGZeto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477090; c=relaxed/simple;
	bh=BRxd8wSlB7E2SQMnKygjHENZYzxvB1TF13r/v+CPDeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lv2l6U57d75d5bbpP1Bws9ZuAAPzL2d4lKnLkN1YEqaVVX0tSNSgvEba2V3+aTjNWWyIRLLY1GNdkRAsMvVw/QJTAwVakKmk3u4+qXLIAKcoZ3jZbUDTpenK6M0fGOBkZKigh4hzy6Ee9TaMYqC3AfY09vPwd/hRJ1rErFCdOTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5c83fbd23a5so733399e0c.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 05:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789477087; x=1790081887;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IgE9SQeMzyYPYC75O9wUrB+kCn+Vwoe0FuhgCIRqcx4=;
        b=A/zFDw23S/Q8KS/BeQuf7Om8cSaJuRKl3DWd2eFvHMiEsm0pVU1I7e/kg8y9wyR3y/
         AlAp8AWJ9HkNkWowORiOrJMWaBtJ9WtqW0cNx6Ksa5I4x9OelY+RJNVe1pmNEUvr9YwP
         +0a4tyr+6skV520i1IJr3RBbkNVkOrOl0thvPLy4kSdy6sqGTeJyQ1LVLhFqOpm3yLAH
         wZCGljOXI7lg3ozWMaS/7CU4iVH7m+jaR/IfDwOJr5MN5S5GXiZkjIuvNIEFr4SScj9k
         /xTMcskoSEkH6GjM2ZLedcCSICe1BOrrJo5eKq15lA11nK8VSrG7HTvu1CuIua3QZ0qK
         U81A==
X-Forwarded-Encrypted: i=1; AKwUvBw+kBovST4dAPGGsfi9iSc3iVDkcPmhg66d+Hnu0o+7LFTQTxUSx3NZRt1pQ/lMBiIfb9CN62XvxTWD4wk=@vger.kernel.org
X-Gm-Message-State: AFuF++miCXGw+fSnYdcFeOuuDIRXyizgfv++I6+Z5fuVt/PuaXFYvAbo
	WS4Fi172igVBdur/4Ee78auBINErp3QAXZajGLUUCoCaPSSkn0Jr1dDjOhuMzJXz
X-Gm-Gg: AYBFou3pbqaWlbussEwNxohu51tEw+f3dklWbJNuUtj2M5ydiwJONj86nG83s5rP9ws
	WF9pAsF77sILAvFJK9KGObJbC0rEB+DfxvuJ/Z+jIvKOkOROVT0NxMHB0YHoBTI8XpE6zYgbRGi
	wSTzMXr5iUUjiOFzmZ+HfWux3Wtpu/9YCetkJ5/gDqq+JPTAckbe0YDHX+iboAFveOlJabuDW30
	XH6yt3xdbNZg0mGHNkkeddyDk/nFXt5gldZtxKNdRVsfieV8BvksutIWYIxTA8Vc+LcJAzGtVlk
	XtAECCCsqdgE6rNHh8m8DfpZ/WDsWSvNvnkJyKBaN8e8iE9ATGtGZOsVyrYH0XpfTL9XVyI2CqW
	KzdrQrb8MaZD080ELB0SCFySW3lNDuRupyQZzYASRifwkCmPXcfunOA+brlgTvUs6rIyGqZApNx
	0FxqYRRF6eOSiNX7DG7aBtsgN8hExkr6s9CMymRLOXp0WvG6E8DGsQt+FUvwtq4ynvS02bJ9uwO
	jGmTkDufv/Hgm3huWIPUrzWqBMu5mTUBK2Q
X-Received: by 2002:a05:6122:d17:b0:5c7:c898:9817 with SMTP id 71dfb90a1353d-5c98a4ff3b4mr1624013e0c.7.1789477087081;
        Tue, 15 Sep 2026 05:58:07 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c847122e2dsm15616412e0c.14.2026.09.15.05.58.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 05:58:06 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-97cc700fcf5so590729241.0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 05:58:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByU+6dRNjWyJU+fMnY4GVmCzqkhY0gMDhnJSoRwZLoB3HV4ywOxOpdI63UZ8zB2h0jMMaVc9ayTBEjlOlk=@vger.kernel.org
X-Received: by 2002:a67:fd97:0:b0:744:d517:b0b0 with SMTP id
 ada2fe7eead31-79d2757b2e3mr1341211137.10.1789477086677; Tue, 15 Sep 2026
 05:58:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1787978627.git.kmehltretter@gmail.com> <e9659617ce2f1466f227d562f47b961f340ab3c7.1787978627.git.kmehltretter@gmail.com>
In-Reply-To: <e9659617ce2f1466f227d562f47b961f340ab3c7.1787978627.git.kmehltretter@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Sep 2026 14:57:55 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com>
X-Gm-Features: AcwNN1We6JvHroelTMDgiuev4qCnhIIlzUn7-aK8UKQI_PPoPrsqy0x60B6d-t0
Message-ID: <CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] lib/842: add KUnit tests for the decompressor
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Haren Myneni <haren@us.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Dan Streetman <ddstreet@ieee.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Higgins <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Karl,

On Sun, 30 Aug 2026 at 05:05, Karl Mehltretter <kmehltretter@gmail.com> wrote:
> Add table-driven tests for the 842 decompressor's output and history
> validation.
>
> Three malformed streams cover an indexed copy larger than the remaining
> output, short data larger than the remaining output, and a repeat after
> fewer than eight output bytes. Every case checks the return value, output
> length and fixed guard bands on both sides of the output. Successful cases
> also check complete contents from a poison-filled destination. The repeat
> vector's CRC includes the leading guard byte, so the unfixed decoder
> successfully validates the CRC after reading before the buffer.
>
> Three valid streams cover the same boundaries at equality: an I8 index
> consuming the final eight bytes, five short-data bytes consuming the final
> five, and a repeat with exactly one block of history.
>
> On an unmodified baseline the malformed cases fail and the boundary cases
> pass; with the preceding fixes all six pass.
>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Thanks for your patch, which is now commit cca072cb1423191c
("lib/842: add KUnit tests for the decompressor") in crypto/master

> ---
> Review notes:
>
>   - CONFIG_842_DECOMPRESS_KUNIT_TEST=m selects 842_DECOMPRESS=m.
>   - A fixed x86_64 CONFIG_PROVE_LOCKING=y run passes all six cases without
>     a lockdep report.

> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2225,6 +2225,21 @@ menuconfig RUNTIME_TESTING_MENU
>
>  if RUNTIME_TESTING_MENU
>
> +config 842_DECOMPRESS_KUNIT_TEST
> +       tristate "KUnit tests for the 842 decompressor" if !KUNIT_ALL_TESTS
> +       depends on KUNIT
> +       select 842_DECOMPRESS

Enabling a (modular) test should not silently enable additional kernel
functionality, as that may increase the attack vector for a product.

> +       default KUNIT_ALL_TESTS
> +       help
> +         Enable stream-validation and boundary tests for the software 842
> +         decompressor. The tests exercise indexed copies, short data and
> +         repeat operations at valid and invalid output or history boundaries.
> +
> +         For more information on KUnit and unit tests in general, refer to
> +         Documentation/dev-tools/kunit/.
> +
> +         If unsure, say N.
> +
>  config TEST_DHRY
>         tristate "Dhrystone benchmark test"
>         help

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
