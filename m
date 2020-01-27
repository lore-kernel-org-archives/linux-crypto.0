Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E775C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E602071E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgA0Mwj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 07:52:39 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44883 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbgA0Mwj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 07:52:39 -0500
Received: by mail-ot1-f66.google.com with SMTP id h9so8192406otj.11;
        Mon, 27 Jan 2020 04:52:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ufAzCYn+7brb4qlonfImCP+/XzT48l8NOoy0xcVDR1g=;
        b=J9/829rjYywtd+ewYBmbrf2Ea+rP1ckcZSK2TzRyzr3TEzHfgHEOmvEMEYWcxF2RQa
         GvOESyhByt0jVovqiNxDFHXkkdEhrHd1dIwoLyRKczXkLdPRDtzT0yU60a5u6yZuVQXs
         FfV70Xw7m0UVNM3JTVSlSjnbxxCcwjA1zfMZ55ePL9dsdGwnH6SrbQM2vz7/wHgQmmLw
         dbbJPseGPMSpSRz95HBEIe3DcjWljCBQs07FmpZw+rBqAuhdlr4W1DnvrfruzUb4YpJv
         eAAKnLfYQw99shvig17oSAfrm6v1BPxWsi6zXiKPrWTePWr4k2npZtaF/CA0kyzmdzze
         VuUw==
X-Gm-Message-State: APjAAAX1kG/52EMklMbCGh09FBqH1aJIC2M6oMk8KyBHS8Qj9yxHkNUr
        F4RjC9YTkiWIF3H4otjavvnQxL1FXRiVQjK6zSX9tgZn
X-Google-Smtp-Source: APXvYqwh3UkQ6QOPWt0zTBO1I2SHJ4uPj6qzrZ3fktxcBQVGNrR3Gvv6msZkKjal5GE9DDKsM/60Zc3SKTa/3W4xQUY=
X-Received: by 2002:a9d:146:: with SMTP id 64mr7640640otu.39.1580129558642;
 Mon, 27 Jan 2020 04:52:38 -0800 (PST)
MIME-Version: 1.0
References: <20200127122939.6952-1-gilad@benyossef.com>
In-Reply-To: <20200127122939.6952-1-gilad@benyossef.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Jan 2020 13:52:27 +0100
Message-ID: <CAMuHMdVrQh-1cEncfWoAjhd6SjJRHZPg9Qt7yVyw5Qrdo+-nrQ@mail.gmail.com>
Subject: Re: [RFC] crypto: ccree - protect against short scatterlists
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Gilad,

On Mon, Jan 27, 2020 at 1:29 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Deal gracefully with the event of being handed a scatterlist
> which is shorter than expected.
>
> This mitigates a crash in some cases of Crypto API calls due with
> scatterlists with a NULL first buffer, despite the aead.h
> forbidding doing so.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks for your patch!

Unable to handle kernel paging request at virtual address fffeffffc0000000
Mem abort info:
  ESR = 0x96000144
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000144
  CM = 1, WnR = 1
[fffeffffc0000000] address between user and kernel address ranges
Internal error: Oops: 96000144 [#1] PREEMPT SMP
CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.5.0-rc6-arm64-renesas-00813-g0ada3a94aab4dd18-dirty #520
Hardware name: Renesas Salvator-X 2nd version board based on r8a77951 (DT)
pstate: 40000005 (nZcv daif -PAN -UAO)
pc : __dma_inv_area+0x40/0x58
lr : arch_sync_dma_for_cpu+0x18/0x20
sp : ffff800008003cb0
x29: ffff800008003cb0 x28: ffff0006f89f0000
x27: ffff800008e44fa8 x26: 0000000000800000
x25: ffff0006f89f0000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000
x21: 0000000000000000 x20: ffff0006fa648010
x19: 0000000000000000 x18: 0000000000000014
x17: 000000005111eab2 x16: 000000006cc48a27
x15: 41075e541c170702 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000001
x11: 0000000000000002 x10: 0000000000000000
x9 : 0000000000000000 x8 : 0000000040000000
x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff80000825590c x4 : 0000000000000000
x3 : 000000000000003f x2 : 0000000000000040
x1 : fffeffffc0000000 x0 : fffeffffc0000000
Call trace:
 __dma_inv_area+0x40/0x58
 dma_direct_sync_single_for_cpu+0x84/0x88
 dma_direct_unmap_page+0x84/0x88
 dma_direct_unmap_sg+0x54/0x80
 cc_unmap_aead_request+0x160/0x408
 cc_aead_complete+0x2c/0xf8
 comp_handler+0x174/0x398
 tasklet_action_common.isra.16+0xa8/0x190
 tasklet_action+0x24/0x30
 efi_header_end+0x110/0x560
 irq_exit+0x13c/0x148
 __handle_domain_irq+0x60/0xb0
 gic_handle_irq+0x58/0xa8
 el1_irq+0xbc/0x180
 arch_cpu_idle+0x34/0x230
 default_idle_call+0x1c/0x38
 do_idle+0x1e0/0x2c0
 cpu_startup_entry+0x24/0x28
 rest_init+0x1a0/0x270
 arch_call_rest_init+0xc/0x14
 start_kernel+0x488/0x4b4
Code: 8a230000 54000060 d50b7e20 14000002 (d5087620)
---[ end trace 843cb2d928c7bf8b ]---
Kernel panic - not syncing: Fatal exception in interrupt
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x10002,21006004
Memory Limit: none
---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
