Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984AEC5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 07:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 603E8217F4
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 07:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="tXq9+cEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfKFHde (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 02:33:34 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:39009 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728291AbfKFHdd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 02:33:33 -0500
Received: by mail-vk1-f195.google.com with SMTP id j84so5378519vkj.6
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2019 23:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbVrCNlPLaDTmcKHIN3LtBZK21JIiPNghUTOX5jQAi0=;
        b=tXq9+cEdTgcUL/rTgW92c4PNWlxnqdy9ufzkcqPbyt0BmkFpZwtDr2SKTAZ2B2adPA
         F+XDqVbx7RMa+5XEnQg/NkxPXT5p1qsf2Il96TWl2Xo9SSM9hUuVYMdG4OSux/yBuUE8
         /lt+ifyc1imI3ov8PQ2W9bkBv+/tM6c/VcGIy/P/kI10Cz+YzkEMxuP+yQO8wBG0+vvv
         4n+EMc34+wsK62rjmo/p32ZrKZm00eMyRRnbQWc2dTB1jGdGHtZvt3NtPvauqSi+hfbZ
         LBqtHWQ+Da8ZxU44fzKnYQQKozNVLB2Tu1/P25qp5db4qn1FRQ9kkdL7iUFiBnTCljtW
         Vuzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbVrCNlPLaDTmcKHIN3LtBZK21JIiPNghUTOX5jQAi0=;
        b=KUb+aH0p6fGL0ZCPP6fOp8l1uTteZe/CHOFNSNBI5wxfYpX+Jl0ZicE+PsCePDQ2fm
         N3VvzzpVV+JJGejpKwTSA/9AvXUPxYN7x58M7f/py03PY2G3ejo64ZXor5pSCcrisJTy
         5k1i+jgFIfS8csCIstHN/2UtBUXIUXY5odFFckDYbnfloBZjaLNzb9mBLM/73SveKwpk
         q46EsyRDRjE9tsZ1XcN7oiOouOAc6HFtM3C4fbAkl3cwxdMdOSzpc4tTnD9dmNXSxxqo
         ChEHgOCusVBbUVlLWi2KWBvodBd7pgZTJitn0J12penjiP5isC0eNGFA2BAOk6eNpGQr
         t1mA==
X-Gm-Message-State: APjAAAW+N6tSB/xKbHKxTU0uIkr+T8WliJ1qB2+xL9cuVYNNvxsMVwcs
        0sjTv7du2B/1BCV6XXQ5jVgicpeIaUCfyZJSsLJWCQ==
X-Google-Smtp-Source: APXvYqw32qEeWfeBSD+BM8iRa57I4atoH5ZwU4QbRCyWX48m3mTUA1rFPOiMiu2Vt5iwu172Y/DEdSEJXJ81xV0PdLY=
X-Received: by 2002:ac5:c756:: with SMTP id b22mr628305vkn.2.1573025611342;
 Tue, 05 Nov 2019 23:33:31 -0800 (PST)
MIME-Version: 1.0
References: <20191017122549.4634-1-t-kristo@ti.com> <20191017122549.4634-10-t-kristo@ti.com>
 <CAOtvUMeBXjDBhSVgMOW=hshEx_AkNPg-Zk2c2jCDzY8vyXWW5g@mail.gmail.com> <076f0bc6-ad04-9543-db02-d7c7060db036@ti.com>
In-Reply-To: <076f0bc6-ad04-9543-db02-d7c7060db036@ti.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 6 Nov 2019 09:33:20 +0200
Message-ID: <CAOtvUMc7pbtPAPUbEmz_MTHmB9LboQVdgG-t9tHCr=biEbFuUQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] crypto: add timeout to crypto_wait_req
To:     Tero Kristo <t-kristo@ti.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-omap@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 6, 2019 at 9:25 AM Tero Kristo <t-kristo@ti.com> wrote:
>
> On 06/11/2019 08:39, Gilad Ben-Yossef wrote:
> > Hi,
> >
> >
> > On Thu, Oct 17, 2019 at 3:26 PM Tero Kristo <t-kristo@ti.com> wrote:
> >>
> >> Currently crypto_wait_req waits indefinitely for an async crypto request
> >> to complete. This is bad as it can cause for example the crypto test
> >> manager to hang without any notification as to why it has happened.
> >> Instead of waiting indefinitely, add a 1 second timeout to the call,
> >> and provide a warning print if a timeout happens.
> >
> > While the incentive is clear and positive, this suggested solution
> > creates problems of its own.
> > In many (most?) cases where we are waiting here, we are waiting for a
> > DMA operation to finish from hardware.
> > Exiting while this pending DMA operation is not finished, even with a
> > proper error return value, is dangerous because
> > unless the calling code takes great care to not release the memory the
> > DMA is being done from/to, this can have disastrous effects.
> >
> > As Eric has already mentioned, one second might seem like a long time,
> > but we don't really know if it is enough.
> >
> > How about adding a second API (ig. crypto_wait_req_timeout) which
> > supports a calee specified timeout where
> > the calle knows how to correctly deal with timeout and port the
> > relevant call sites to use this?
>
> Yeah, that would work for me. I guess we could just swap the testmgr to
> use this timeout API, as it is quite clear it should timeout rather than
> wait indefinitely, and afaics, the data buffers it uses are limited
> size. It doesn't really matter for it whether the timeout is 1 second or
> 10 seconds, as long as it eventually times out.


As long as you avoid releasing the memory used on timeout, that should
work well, I think.

Gilad
