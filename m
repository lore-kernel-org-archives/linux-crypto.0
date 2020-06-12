Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F88C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 02:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF40E206DC
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 02:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cantona-net.20150623.gappssmtp.com header.i=@cantona-net.20150623.gappssmtp.com header.b="HmJkGLHP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFLCDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgFLCDP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 22:03:15 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69105C03E96F
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2020 19:03:15 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id e2so3724893qvw.7
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2020 19:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cantona-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xgcq+HGcr+2E0r2fW1Aksh/0luTigEmDuGP+izUX+VY=;
        b=HmJkGLHP42JUOmNtHkbJ+J0+A7oEgR/tT9d4PEfgn2WB9kHSMwqKuPUXC+T3SU+P6y
         xC2m7H/uB2xsPRnLgPmB+mvwZDRuKCtcfT6B/+kJ4ZlFzOeQXI0x/RSleZTKYhmqdyLw
         TclXEV5nXApZIjLSmxG14A37nE6xBaMRIzqr4X2uEZUmrQYUEXc8kSbFiD0nSShYsWTe
         X3Zk5dUguhoEmMkWluX3klNE9gI9eV+Mdvm4bn777R79pgu1ATVBcCxLxZ4TrQVwvO7c
         lgGCLxhlb34h3cIS/Vr5hchbWsBCl+EQI+bBHyZRg4P2bBCtkq2vTnvRXsirqZ99PnXU
         Ncjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xgcq+HGcr+2E0r2fW1Aksh/0luTigEmDuGP+izUX+VY=;
        b=Cv8TSR3q2np4qWCd1GkYJMG21gtMDvSLIrM6rU3GATmj7bPJuAMfIUj6OPSZ0b1cwD
         IRBKDnAcVezuIVTreJMjCLo4/lCaou4qpgJ0rUGZZrwG7wcWOrCCxJkrDOLlYHM6p30R
         YWoN3w9MgHZvf/rI+96+EWr5ztIPNDNjL0VcZZle22XVWDo+gFbprt5HRVI1bMyJxnEv
         oVcN85pZZWQq7FGImldXFhUTUfkTghVgX8XJ9XzHJR5/qwzaGvShBKelbBOGeSeF/990
         yy3tyG7oDCFYYE+0a/tpNeg2UKIbIgYgGLV2oiCtdHRRsAJC+MIPb8Q7eI15yR/9fC0T
         VEYA==
X-Gm-Message-State: AOAM530/8327UGbnwI07TjHIP/eHMkLWgwNMv5xN9OcO35XAkQ5dAqg2
        5aewTszro90QpViuZJis/5BfgVLcMB4RXbsQy6LJbQ==
X-Google-Smtp-Source: ABdhPJx4a+HqrR4sihJ1rHsQYSKxpOqkvQBZ2YnE2nDHXikA4/bX33trbn92WZ7+Sml3eGzP9adfCLCKUnE6CmOFjBQ=
X-Received: by 2002:a05:6214:aaf:: with SMTP id ew15mr10590137qvb.110.1591927394407;
 Thu, 11 Jun 2020 19:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <cantona@cantona.net> <20200611115048.21677-1-cantona@cantona.net> <20200611135727.GA1060798@kroah.com>
In-Reply-To: <20200611135727.GA1060798@kroah.com>
From:   Kang Yin Su <cantona@cantona.net>
Date:   Fri, 12 Jun 2020 10:03:03 +0800
Message-ID: <CABJLtPHqn1ocvdS6n0x-TQWVY8SabrVJtH6sqvqbw4UX6SCH3Q@mail.gmail.com>
Subject: Re: [PATCH V2] crypto: talitos - fix ECB and CBC algs ivsize
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-crypto@vger.kernel.org, christophe.leroy@c-s.fr,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cool, thanks!

yin

On Thu, 11 Jun 2020 at 21:57, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 11, 2020 at 07:50:47PM +0800, Su Kang Yin wrote:
> > commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> > wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
> >
> > This restore the CBC algs original ivsize of removes ECB's ones.
> >
> > Fixes: e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> > Signed-off-by: Su Kang Yin <cantona@cantona.net>
> > ---
> > Patch for 4.9 upstream.
>
> Also seems to be an issue for the 4.14 and 4.19 backport, so I'll queue
> it up there too, thanks!
>
> greg k-h
