Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA796C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DEA720645
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="InVIjS4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389776AbfEXJph (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:45:37 -0400
Received: from mail-it1-f170.google.com ([209.85.166.170]:54869 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389582AbfEXJpg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:45:36 -0400
Received: by mail-it1-f170.google.com with SMTP id h20so14722937itk.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 02:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mm7u6ZMplwJx3ZNg0k2j2OUTMi4snU1dJyY1vDxWWsA=;
        b=InVIjS4gIzLlaEssKpThQZA9ClkW6K7hAzv+B52Bgr1MJo5CD/2ThaGgdDcdjWWjVt
         IXG0vAxXB0n6PJ4gTaDnUH9L+t+hhccKI8WILBpIVTu3ioWeoCVmuqgVLd81cs2CXPjd
         loT1mu+HIGoqrC3tETY1xCu3IyRE4NaVca0CmKt1/E7DT1cyc2TbzF2Fh/BpmXW6jgg4
         BX41NivGsrK/6eskMAO+5JxhDWLjj9LQ7zKXxmALFRxXUJNbJsOlCqDEW0KrYyOScVHL
         Ck2P3VEZxaXyapekOWFoJeeR4lhFkgXwWT48JJwSVvNLgGEYm0TcncF4HyKmbD3wAvNd
         oXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mm7u6ZMplwJx3ZNg0k2j2OUTMi4snU1dJyY1vDxWWsA=;
        b=jMDcxkyw/5eaG2y6F9/HBmqCALxOjRm6kQErA631YfELMpYfzCs+R42p2yTDJA1LyD
         jIp7HDT5IygrfoPI6oo+btHav6hfgqm9nNb/svGkJlbNUj7ddhC7bKc1VcGbn7DBz0o5
         qXSARxcWet5Nd3hwSCOPR1OvhAoTyDk78U5RVcGOso+jDcCWbOWJ/JEKzXex13hMvlp0
         3dHcWf8TLR4oD9jPEuslYgmL30LIC4Uvnb+thKGnAB2r8PRy/87Uv0FGB6IDsAJxLHOr
         fefxXfl+9G6EbTSK48EJi5f86465k4ZK4uGctUBNG3QPd7mLiKTufnDXudYTHpbJ8H1a
         LlpQ==
X-Gm-Message-State: APjAAAUnQUMOj8NdazOevdsiJBucge3XC3jXMrGFqppwopE65AUb+sdU
        eFiI4vRBaBLLZcpGr+pklQMVPj1wOIpRJYBKDCJuj5SIWrpnCg==
X-Google-Smtp-Source: APXvYqzvEkTBcF66ezXzfZgB8DoaeyT7Dsc2VnzrPl5qIhKHCde4kIOaPrNIR0hOccPCKjbK2gZdsr2RMsiQyUIMX4o=
X-Received: by 2002:a24:910b:: with SMTP id i11mr18345668ite.76.1558691135997;
 Fri, 24 May 2019 02:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com> <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr> <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com> <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 24 May 2019 11:45:21 +0200
Message-ID: <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 24 May 2019 at 11:34, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > All userland clients of the in-kernel crypto use it specifically to
> > access h/w accelerators, given that software crypto doesn't require
> > the higher privilege level (no point in issuing those AES CPU
> > instructions from the kernel if you can issue them in your program
> > directly)
> >
> > Basically, what is used is a socket interface that can block on
> > read()/write(). So the userspace program doesn't need to be aware of
> > the asynchronous nature, it is just frozen while the calls are being
> > handled by the hardware.
> >
> With all due respect, but if the userland application is indeed
> *frozen* while the calls are being handled, then that seems like its
> pretty useless - for symmetric crypto, anyway - as performance would be
> dominated by latency, not throughput.
> Hardware acceleration would almost always lose that compared to a local
> software implementation.
> I certainly wouldn't want such an operation to end up at my driver!
>

Again, you are making assumptions here that don't always hold. Note that
- a frozen process frees up the CPU to do other things while the
crypto is in progress;
- h/w crypto is typically more power efficient than CPU crypto;
- several userland programs and in-kernel users may be active at the
same time, so the fact that a single user sleeps doesn't mean the
hardware is used inefficiently

> Which brings up a question: is there some way for a driver to indicate
> something like "don't use me unless you can seriously pipeline your
> requests"?
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> www.insidesecure.com
>
