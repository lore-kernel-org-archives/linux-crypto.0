Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FCDC282DB
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 10:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAD220861
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 10:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548067615;
	bh=xqpY8AMg/HXFeMSt+0tUMAS0bbracdhBU8y41l9I78c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uMwK9AfUAe3o5zuzAfid8RaI8xxnjL7UkLhrnmc2N2aMhcOaEVzQYa/4XbtLs1/o4
	 NAfQzGrGnUJVzU/pXHQJkKWN0lXlqJ1pl9TkO6NgkJXcHFtuwV4w85Ig+Y/SVwJMKQ
	 hUQD4AXtxNLtdEVXIWaHHeDvJsu+2X30T+Zv7+jc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfAUKqy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727622AbfAUKqy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 05:46:54 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628A420663;
        Mon, 21 Jan 2019 10:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548067613;
        bh=xqpY8AMg/HXFeMSt+0tUMAS0bbracdhBU8y41l9I78c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VGF3eeJxNxTpY9MpljMERB4r4zvGF0LkCaC+bDs2GPOtAz0tynrGs5QckrRIALfgy
         3Ca6yFtBuxSYVhkjzBMAgzNgq1uiRImEu71BPHEYWBx+27UHEGY4aZ+2EG57KIqXqk
         yWa+SqHW1puGQjKr3R7Csb7k9JuZantde9blxl7U=
Date:   Mon, 21 Jan 2019 11:46:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mpm@selenic.com, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Subject: Re: [PATCH v4 4/4] hwrng: add OP-TEE based rng driver
Message-ID: <20190121104651.GA27442@kroah.com>
References: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
 <1548062959-31860-5-git-send-email-sumit.garg@linaro.org>
 <20190121103026.GB15590@kroah.com>
 <CAKv+Gu9xT87twvnfvnxZqZ-Yj-Xmw5+2wkw6yCRhF7iuz+y-TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9xT87twvnfvnxZqZ-Yj-Xmw5+2wkw6yCRhF7iuz+y-TA@mail.gmail.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 21, 2019 at 11:43:14AM +0100, Ard Biesheuvel wrote:
> On Mon, 21 Jan 2019 at 11:30, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jan 21, 2019 at 02:59:19PM +0530, Sumit Garg wrote:
> > > --- /dev/null
> > > +++ b/drivers/char/hw_random/optee-rng.c
> > > @@ -0,0 +1,272 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> >
> > Nice, but:
> >
> > <snip>
> >
> > > +MODULE_LICENSE("GPL");
> >
> > This string means "GPL2+", you need "GPLv2" here instead.
> >
> 
> I think you need a space there: "GPL v2" or it doesn't get picked up
> correctly (or at least, it didn't use to)

Sorry, yes, see I even got it wrong :)

The correct strings are in include/linux/module.h

