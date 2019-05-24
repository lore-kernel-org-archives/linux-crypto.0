Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D95C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310502175B
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZ7DdLz5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbfEXGOq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 02:14:46 -0400
Received: from mail-it1-f174.google.com ([209.85.166.174]:53968 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387936AbfEXGOq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 02:14:46 -0400
Received: by mail-it1-f174.google.com with SMTP id m141so13930209ita.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 May 2019 23:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=cw+m3tz0Flfcb4YXmlIzhiDbVioDjBpsx5nAxYfAWIs=;
        b=VZ7DdLz5olx8sOu387XGCwU+XLEgpXN69RegyZHdzuebtgqlniwdBTvyyUP0h1umLz
         mObiPM4Sv8Z4HVArUDIgq5MV5Nahz6HubTIbgHEpf5KwsStQOExGz1+qyrRjff+Mf0v8
         onOCet5Md075LH9pVyNhmEgQI8DUmKeqadxmD7f3oKZ7W0VlnivP2VypE5j3jjp3KXVR
         y2Dj25SY3oXe3jJTa7LSLnbapfHaQ6+eJ9FQyOlUnBjHodUY3p4lHNbhQy00x4L4hncb
         7ziAsgqvDp4dwJiier+/skQzDPf8vcoYqiUUhgBB2jAqhG2QF5PE4nKU8bNTxy3pw/s9
         w98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=cw+m3tz0Flfcb4YXmlIzhiDbVioDjBpsx5nAxYfAWIs=;
        b=RRDUCRtLRrHyfG0wuC503J57j39qWUV8WO6UokhUZq+hNs+oPSjzUMbQatfB9HRj5d
         5QHns5IbmVpHYXMQyusqPhsF724gyTe71oi/ff9SpRdRKJW4TPGzz7U1wjVeQuKFyZHs
         H1OJ96VmHZpRuj/FaR1YG6cuiX8dWfVzYRl0GInW/C28w7v7kf7IIgdoEGbFk6dj6d2/
         kI/xMG7PfXQjfnuQ0Ze1S8M8HeieonXMVfuYBae9yGJMBABmmc+z1/BoefEVrsjlBeDQ
         1Rwxk1WEKIgLDUxM/cFwtNpJILZKQwss3mUBGBARd51acEpUvB8MDC+CFjb+SZiMjvom
         1LZQ==
X-Gm-Message-State: APjAAAXPy7MCuOctOMBJIE1LNeVJ+2YtYz6s3T8W/ZXX/BC4b6MHhNoq
        0lEIu2M+joTN0t6DTgzfFnQT83xMCc6W215ai+ohiEp0
X-Google-Smtp-Source: APXvYqwAJwWMvarHsGpqYdTRhIDu2SV8M4vuQ++3WaGx7vSKu8voe/RB6DAy1yTT4JUF1O4Pw7JD+wWy2vBPedBXmFg=
X-Received: by 2002:a24:440c:: with SMTP id o12mr17076958ita.145.1558678485288;
 Thu, 23 May 2019 23:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
In-Reply-To: <20190523200557.GA248378@gmail.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Fri, 24 May 2019 02:14:11 -0400
Message-ID: <CAH8yC8mFC82bUBTMObLAGZMff6teThW=XgQSv-SMYObir2ov=g@mail.gmail.com>
Subject: Re: another testmgr question
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 23, 2019 at 4:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, May 23, 2019 at 01:07:25PM +0000, Pascal Van Leeuwen wrote:
> >
> > I'm running into some trouble with some random vectors that do *zero*
> > length operations. Now you can go all formal about how the API does
> > not explictly disallow this, but how much sense does it really make
> > to essentially encrypt, hash or authenticate absolutely *nothing*?
> >
> > It makes so little sense that we never bothered to support it in any
> > of our hardware developed over the past two decades ... and no
> > customer has ever complained about this, to the best of my knowledge.
> >
> > Can't you just remove those zero length tests?
>
> For hashes this is absolutely a valid case.  Try this:
>
> $ touch file
> $ sha256sum file
> e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  file
>
> That shows the SHA-256 digest of the empty message.
>
> For AEADs it's a valid case too.  You still get an authenticated ciphertext even
> if the plaintext and/or AAD are empty, telling you that the (plaintext, AAD)
> pair is authentically from someone with the key.
>
> It's really only skciphers (length preserving encryption) where it's
> questionable, since for those an empty input can only map to an empty output.
>
> Regardless of what we do, I think it's really important that the behavior is
> *consistent*, so users see the same behavior no matter what implementation of
> the algorithm is used.
>
> Allowing empty messages works out naturally for most skcipher implementations,
> and it also conceptually simplifies the length restrictions of the API (e.g. for
> most block cipher modes: just need nbytes % blocksize == 0, as opposed to that
> *and* nbytes != 0).  So that seems to be how we ended up with it.
>
> If we do change this, IMO we need to make it the behavior for all
> implementations, not make it implementation-defined.
>
> Note that it's not necessary that your *hardware* supports empty messages, since
> you can simply do this in the driver instead:
>
>         if (req->cryptlen == 0)
>                 return 0;

+1. It seems like a firmware update in the hardware or a software
update to the driver are the ways to proceed.

Why isn't the driver able to work around the hardware bugs?

I don't think it is wise to remove tests from the Test Manager.

Jeff
