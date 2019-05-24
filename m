Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444D1C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0445B217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T4l6g1i+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389782AbfEXJ0G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:26:06 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:34905 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389758AbfEXJ0G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:26:06 -0400
Received: by mail-io1-f47.google.com with SMTP id p2so7257822iol.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 02:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5uzxv6jScEZI69BEin99uQol9SSmWGmZYkTmXGN+tk=;
        b=T4l6g1i+FaEHnFix9NYAoDm+dJq/pt1TCp1GA1lOVr9HAsDfxIwQYaR/fAt7TDjb4j
         3Pn0AdAD3rwJjveq9qyB/EAM8Bw8yhtSVZY0lIrOrez0fic8CB0Y0qbwXa/bDhcSod7h
         8zWtL+bELQiDcteUDtT2XYgh3oH42JF94PCAHtmfGBWbhGJWveqhFS86ZnOUbM9GLIbZ
         QmJxzvdtFvxrICa5OPPBttkkat6WRz7bqNYFop//e48CWbz0mecBC2PUh3hiMbKYb68w
         hdIesWYtJTKM089FqM+HgGINA/uVA2gO8032X0g4UwBXVVqEwXJw9JSE+5dFGAIfmt+Z
         tQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5uzxv6jScEZI69BEin99uQol9SSmWGmZYkTmXGN+tk=;
        b=AeZN645hp0xQgTtLWkUg67WV+J559FEA8lxJ98fhcRZpXk3fNpiw9gJmyE3T+7fcvd
         gVFXJLrKQ9EDr5cAQO1YjYeSRRw94MNDhL59iuk7ngFuTCRhSIgwoWkZT5uCpPgR83N7
         g5Tp8XMgKkyE92B9oGvQK36T25Hl12L6fSwGP97xSOPwFfBwPXgX90wOWmWk0Xk5fs48
         uybguJ3jldpSw/3D8qrRu2K29vZ2edsz/AFXdSL0yMuXD9IIr31Bkq9lhi+9aSovwuON
         Z+nn+i+Gt8/Gv+OW4MLxU7IenA5IcwCe9cnL3e+OCpLEnRzy8gLdbr+zcHzGFFum2A77
         rpwQ==
X-Gm-Message-State: APjAAAXwmDSe73gpZk2tY2ZGgYZlYXmJTNwLAHNEO9ux4iTGSTj0UJ8r
        ryOPR+WRIfqHLoyg3Bd2QrWyYdQHJafrH/FuD2tiLg==
X-Google-Smtp-Source: APXvYqzf3FiF9aDKlbW+RhjrJ2pRzMD+DvjNODCI2rVV+OXtHfdhySJ31hztN1mZw1pEl9wprIbcIE6jfOPLEGrW0g0=
X-Received: by 2002:a5d:968e:: with SMTP id m14mr25232883ion.49.1558689965527;
 Fri, 24 May 2019 02:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com> <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr> <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 24 May 2019 11:25:52 +0200
Message-ID: <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 24 May 2019 at 11:21, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > > As I already mentioned in another thread somewhere, this morning in the
> > > shower I realised that this may be useful if you have no expectation of
> > > the length itself. But it's still a pretty specific use case which was
> > > never considered for our hardware. And our HW doesn't seem to be alone in
> > > this.
> > > Does shaXXXsum or md5sum use the kernel crypto API though?
> >
> > The ones from libkcapi do (http://www.chronox.de/libkcapi.html)
> >
> > Christophe
> >
> I was not aware of that, so thanks for pointing that out.
> Do they use the async calls (_aio) though? Because otherwise they shouldn't
> end up being hardware accelerated anyway ...
>

All userland clients of the in-kernel crypto use it specifically to
access h/w accelerators, given that software crypto doesn't require
the higher privilege level (no point in issuing those AES CPU
instructions from the kernel if you can issue them in your program
directly)

Basically, what is used is a socket interface that can block on
read()/write(). So the userspace program doesn't need to be aware of
the asynchronous nature, it is just frozen while the calls are being
handled by the hardware.
