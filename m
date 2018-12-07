Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F32FC07E85
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Dec 2018 20:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D6162081C
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Dec 2018 20:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q+G7N6R9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D6162081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbeLGU02 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Dec 2018 15:26:28 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:37172 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeLGU02 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 15:26:28 -0500
Received: by mail-it1-f195.google.com with SMTP id b5so9033982iti.2
        for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2018 12:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLYwNXnzoVvepzSuxQ5p4veFSZuSN5QPAisGoFQq+eo=;
        b=Q+G7N6R9cNmw2rFHSHCBK/LyjNfFNjK6oJlQ9JyHKZBsMx0HxymipERlO49GeMH+20
         KhxyCMfcVstVMdHpB0rtXG0FadSe+4UM6hpo8dZy0naiJ49nd9djvcPExigmA9q6YjPE
         X9GOzFNFMdixUDbASur84eKVfqpCpgVQbFM6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KLYwNXnzoVvepzSuxQ5p4veFSZuSN5QPAisGoFQq+eo=;
        b=EqktGjecSaiSS28npZ12WumJdn2GgLSIKJMlfK5Gt+Xl7FxucbzLyl25mZH1a9ex4U
         qs3YUDjvrDQfCP4HZeJ/ywnojJKc8C6EJYmXiL1bxfZTT+R5E8iQ7QbhH/4nvKHv4kSE
         lwXNHnWsoPXTEi0LgXMEUeG02ws/2JXK3lV8h+IdBZFnHnE2Jl//TiTnK4HNJjXavrYG
         /1BGMoURbNPQmVjcCNAP3QG0UWBhKZNSZp9uxlTBM1zZayRiiMFNs2HkLnb4GWDuD3/g
         PaRSK1R0H1ykdJM68SvaTNYRAgIJRsIAOjo3mdnknJpfApk6D9hR9qlBug0EEc3SxeyN
         zZiQ==
X-Gm-Message-State: AA+aEWa6ibCX/W/YeP7eXmdNpBBmIOIUQXhh2mYwcDGdPkAO2qJ8GSs0
        dMGBP6P+8pXMzj1GJwPq4Q2erwJS6WsNkgLH+m5qFm4w
X-Google-Smtp-Source: AFSGD/WzF2x0t8jZwsZm4obvUhsaa6Fi7Yqlyol6bPbkz5Lun5YOwVmvPE6dYEWnDi+4QFfBf7aB2CPX1N+FCwV1vMI=
X-Received: by 2002:a05:660c:4b:: with SMTP id p11mr3437505itk.71.1544214387289;
 Fri, 07 Dec 2018 12:26:27 -0800 (PST)
MIME-Version: 1.0
References: <20181207173309.82A0E6D165@po14163vm.idsi0.si.c-s.fr>
In-Reply-To: <20181207173309.82A0E6D165@po14163vm.idsi0.si.c-s.fr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 7 Dec 2018 21:26:15 +0100
Message-ID:
 <CAKv+Gu9gz0h2CFNPe9bgrSBzRe7iTVOMxiEEb6OXb75Acv7HUQ@mail.gmail.com>
Subject: Re: [PATCH] crypto/testmgr: fix skcipher test with CONFIG_VMAP_STACK
To:     christophe.leroy@c-s.fr
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181207202615.UOc3sCy9fbx_6hPrckEGLXPA5SKzYag9CK4SqzClKMo@z>

On Fri, 7 Dec 2018 at 18:33, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>
> [    2.364486] WARNING: CPU: 0 PID: 60 at ./arch/powerpc/include/asm/io.h:837 dma_nommu_map_page+0x44/0xd4
> [    2.373579] CPU: 0 PID: 60 Comm: cryptomgr_test Tainted: G        W         4.20.0-rc5-00560-g6bfb52e23a00-dirty #531
> [    2.384740] NIP:  c000c540 LR: c000c584 CTR: 00000000
> [    2.389743] REGS: c95abab0 TRAP: 0700   Tainted: G        W          (4.20.0-rc5-00560-g6bfb52e23a00-dirty)
> [    2.400042] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24042204  XER: 00000000
> [    2.406669]
> [    2.406669] GPR00: c02f2244 c95abb60 c6262990 c95abd80 0000256a 00000001 00000001 00000001
> [    2.406669] GPR08: 00000000 00002000 00000010 00000010 24042202 00000000 00000100 c95abd88
> [    2.406669] GPR16: 00000000 c05569d4 00000001 00000010 c95abc88 c0615664 00000004 00000000
> [    2.406669] GPR24: 00000010 c95abc88 c95abc88 00000000 c61ae210 c7ff6d40 c61ae210 00003d68
> [    2.441559] NIP [c000c540] dma_nommu_map_page+0x44/0xd4
> [    2.446720] LR [c000c584] dma_nommu_map_page+0x88/0xd4
> [    2.451762] Call Trace:
> [    2.454195] [c95abb60] [82000808] 0x82000808 (unreliable)
> [    2.459572] [c95abb80] [c02f2244] talitos_edesc_alloc+0xbc/0x3c8
> [    2.465493] [c95abbb0] [c02f2600] ablkcipher_edesc_alloc+0x4c/0x5c
> [    2.471606] [c95abbd0] [c02f4ed0] ablkcipher_encrypt+0x20/0x64
> [    2.477389] [c95abbe0] [c02023b0] __test_skcipher+0x4bc/0xa08
> [    2.483049] [c95abe00] [c0204b60] test_skcipher+0x2c/0xcc
> [    2.488385] [c95abe20] [c0204c48] alg_test_skcipher+0x48/0xbc
> [    2.494064] [c95abe40] [c0205cec] alg_test+0x164/0x2e8
> [    2.499142] [c95abf00] [c0200dec] cryptomgr_test+0x48/0x50
> [    2.504558] [c95abf10] [c0039ff4] kthread+0xe4/0x110
> [    2.509471] [c95abf40] [c000e1d0] ret_from_kernel_thread+0x14/0x1c
> [    2.515532] Instruction dump:
> [    2.518468] 7c7e1b78 7c9d2378 7cbf2b78 41820054 3d20c076 8089c200 3d20c076 7c84e850
> [    2.526127] 8129c204 7c842e70 7f844840 419c0008 <0fe00000> 2f9e0000 54847022 7c84fa14
> [    2.533960] ---[ end trace bf78d94af73fe3b8 ]---
> [    2.539123] talitos ff020000.crypto: master data transfer error
> [    2.544775] talitos ff020000.crypto: TEA error: ISR 0x20000000_00000040
> [    2.551625] alg: skcipher: encryption failed on test 1 for ecb-aes-talitos: ret=22
>
> IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stack
> cannot be DMA mapped anymore.
>
> This patch allocates it with kmalloc()
>

This looks like a driver bug to me. Other accelerators in
drivers/crypto all take a copy of the IV before mapping it for DMA, so
it would be better if talitos did the same.

> Fixes: da7f033ddc9f ("crypto: cryptomgr - Add test infrastructure")
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>  crypto/testmgr.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index b1f79c6bf409..eea498f9030d 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1112,12 +1112,16 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
>         struct crypto_wait wait;
>         const char *input, *result;
>         void *data;
> -       char iv[MAX_IVLEN];
> +       char *iv;
>         char *xbuf[XBUFSIZE];
>         char *xoutbuf[XBUFSIZE];
>         int ret = -ENOMEM;
>         unsigned int ivsize = crypto_skcipher_ivsize(tfm);
>
> +       iv = kmalloc(MAX_IVLEN, GFP_KERNEL | GFP_DMA);
> +       if (!iv)
> +               goto out_noiv;
> +
>         if (testmgr_alloc_buf(xbuf))
>                 goto out_nobuf;
>
> @@ -1339,6 +1343,8 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
>  out_nooutbuf:
>         testmgr_free_buf(xbuf);
>  out_nobuf:
> +       kfree(iv);
> +out_noiv:
>         return ret;
>  }
>
> --
> 2.13.3
>
