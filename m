Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2DDC43387
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 09:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F12020874
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 09:54:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="EIcnHl8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfAKJyT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jan 2019 04:54:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39927 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfAKJyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 04:54:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so14458919wra.6
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 01:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nkf9/5iA3E6KP4iOorpGJNEgxsrAnhqFpwiLvHdb7lg=;
        b=EIcnHl8JnL0fqQn6uGpdUkzn36mc3hQ2zifOp4JPzxmLwiO179GzbCLnpmHFcuHQ93
         Om/0KyMNA3UA4rccGU96pgfJwY3lP8g4BK4p53L2e5+5zmNtLR1Rn34ZCdxEjcRW085h
         Di0rxMiUcUAbPXz5yYHlNdQWZSC7TWATRptao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nkf9/5iA3E6KP4iOorpGJNEgxsrAnhqFpwiLvHdb7lg=;
        b=WCNqeQ9Sn8XidlKgUN4/WN4vSCDgGTgcLEvMiDuP2F0xs53QcEqle0aK1pS2fJzt/A
         tn/t1TyIduGJfMwPfP1ceWU8B6IlwJP4CPh5vHASvhyre38z1mpNTpMTDYJxvlFwzwT+
         jAEWH62y9c9Z60ES/TazuBflWC4ncAPWhrdetfr9Ce9RuBtepta0Z2JMyulok/AxMWCC
         Dqx82GRWjXkeFt1INiQIIvbwaQq+Tjp9sD4N5XXi+WqcyQeqHb9WvB7P8uFLAtQ2I5ug
         pDzsG4A8JAOso5lRV0pNokkOB2mTttVdPntxw29DiBMqtt4jWnmfYyRRYFYtfDzFROYB
         IG6w==
X-Gm-Message-State: AJcUukeEa/6cN8jAVVVHLcsvQuYLUdP+oiMwhbIgr1+CJhGPtrHRrTTx
        mSdeODDcAi7AId4TVj3qN2LAyw==
X-Google-Smtp-Source: ALg8bN56GVH2/sjleOq169ZKaNQdMURQeexzxkatzs56pWJTpsTbQdDVeUtfDiZH6iITIsZSaqx5vw==
X-Received: by 2002:adf:b307:: with SMTP id j7mr13532668wrd.46.1547200457315;
        Fri, 11 Jan 2019 01:54:17 -0800 (PST)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id f137sm18810289wmg.29.2019.01.11.01.54.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jan 2019 01:54:16 -0800 (PST)
Date:   Fri, 11 Jan 2019 09:54:14 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Jens Wiklander <jens.wiklander@linaro.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Subject: Re: [PATCH v2 3/4] tee: add supp_nowait flag in tee_context struct
Message-ID: <20190111095414.nbnzbocdn32zypdc@holly.lan>
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-4-git-send-email-sumit.garg@linaro.org>
 <20190110142355.bcgw62w2qk2mlzj6@holly.lan>
 <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190111095414.eqlucdLruubzNswVFA-EoLi__JggjRuFQKpGeP_DyCs@z>

On Fri, Jan 11, 2019 at 01:00:49PM +0530, Sumit Garg wrote:
> On Thu, 10 Jan 2019 at 19:53, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
> > > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > > index 9ddb89e..5d6c317 100644
> > > --- a/drivers/tee/tee_core.c
> > > +++ b/drivers/tee/tee_core.c
> > > @@ -105,6 +105,7 @@ static int tee_open(struct inode *inode, struct file *filp)
> > >       if (IS_ERR(ctx))
> > >               return PTR_ERR(ctx);
> > >
> > > +     ctx->supp_nowait = false;
> > >       filp->private_data = ctx;
> > >       return 0;
> > >  }
> > > @@ -981,6 +982,7 @@ tee_client_open_context(struct tee_context *start,
> > >       } while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
> > >
> > >       put_device(put_dev);
> > > +     ctx->supp_nowait = true;
> >
> > Why automatically set supp_nowait inside open_context() ?
> >
> 
> I think this is the default behaviour (non-blocking request) that any
> in kernel client would expect. Also this flag could be configured
> again before call to open_session() if any in kernel client requires
> different behaviour.

Makes sense. I think this is a deep enough behaviour to warrant proper
commenting though.


Daniel.
