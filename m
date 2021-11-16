Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDE2C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 03:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3652061BFE
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 03:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhKPEC2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbhKPEC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 23:02:26 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5D3C1F317B;
        Mon, 15 Nov 2021 16:47:39 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so1081688wme.4;
        Mon, 15 Nov 2021 16:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7Zpl/DXdhG00ea4QY24UUqjABtDhWhOn+Yu7tlYVgg=;
        b=DDAcr2gsJ09hWMFGvzP3SCIik8Ot9gHLzhRzFB/JBY6bue7cOQ0KfNt1jpGHwbrmZJ
         0Aqqt59vOfNv6TOQ2dQLXJhKdFbZmcBf8SrO63LJZlVuTQoNItLu+WhJP+F2ja2pL4LK
         WDQhBXxr00BpgEge7yBuPUGwCeTQDtj1l4FpKKzFEsq4jF0OnLVnjU4EjgFqJw0RbNvC
         v+9sh+s5V8oImiPF/qR70MR9Rn4AfGqofzaU5ksou7C/x7PFE+DrvFbGsaxTs4cj+O/n
         DI6u+smh7iwCyXsiQEFadW6naLON9qMAGlmpJHbEj4jjlrzC8MGtHjD2MPn0Bn9MU1J5
         8IWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7Zpl/DXdhG00ea4QY24UUqjABtDhWhOn+Yu7tlYVgg=;
        b=G3B3uclaBUmQoKXGpT0KuFinO/wftEf7/wB5teJLu2xt/aRyG/Qghsx4TBmvZ11iYs
         SUi8g0qPRCEV9ood2nhRlT016mG2kxLebC7OdbTnZsIP9voHjycUshzhne9W8wAn4KQZ
         iLJ6sQvKO/ckJxfSacjhEN3JZGRzLmU3NeaBKuaQ2Zr9GtM6IpL+f83qRnhZpcUgvL7r
         +Hru/JNBBJaTxHFekVlbeCZcLv65nnmfSViS73hf/UYnpdVF/9fIa9V6nN+hsBu4m/Uh
         XFhKE7Oyi9VWLLK08YPQ/zH2y71xCmKwvI310dOovEQPQeGvR3BhyqNRWtB1nZKvS0xj
         Dv5w==
X-Gm-Message-State: AOAM530mqzD02Ni6Kk7JAht7hYjC0a5d+6XaDPm48vNmP8qV/sn744WP
        MOuJOf+T+4TzHhGkuBFlPyVZq8ExWxu3ccGj96A=
X-Google-Smtp-Source: ABdhPJxVNCaPU/aUukWSdSMMsjLAdKYDfnvDUeXfun4RqT4loLAMWitSH1BZt3ZVWHm01xMLz6Eyz5RfWhiutR0W4TE=
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr63786688wmm.5.1637023658559;
 Mon, 15 Nov 2021 16:47:38 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmnOeHwuu4N=WiGrMB+NNgGer9oCLoG0JAORN03gv1y+HQ@mail.gmail.com>
 <YTG9fAQTha7ZP/kh@kroah.com>
In-Reply-To: <YTG9fAQTha7ZP/kh@kroah.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 08:47:26 +0800
Message-ID: <CACXcFmkwRi9+guXc0v_t=pP6nMidKprD1EJdGTmEsU4puyit-A@mail.gmail.com>
Subject: Re: memset() in crypto code
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 3, 2021 at 2:15 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Sep 03, 2021 at 09:13:43AM +0800, Sandy Harris wrote:
> > Doing this the crypto directory:
> > grep memset *.c | wc -l
> > I get 137 results.
> >
> > The compiler may optimise memset() away, subverting the intent of
> > these operations. We have memzero_explicit() to avoid that problem.
> >
> > Should most or all those memset() calls be replaced?
>
> The ones that are determined to actually need this, sure, but a simple
> grep like that does not actually show that.  You need to read the code
> itself to determine the need or not, please do so.

Done. Patches to follow. I ended up making about a dozen changes
in eight files. Of course, while I did read the code, I do not know it
deeply so I may have misjudged some.
