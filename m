Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2E5C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 14:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05431207F9
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 14:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgFJO2j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jun 2020 10:28:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39400 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgFJO2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jun 2020 10:28:39 -0400
Received: from mail-ua1-f71.google.com ([209.85.222.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mauricio.oliveira@canonical.com>)
        id 1jj1iX-0004I0-AE
        for linux-crypto@vger.kernel.org; Wed, 10 Jun 2020 14:28:37 +0000
Received: by mail-ua1-f71.google.com with SMTP id p11so886992uaq.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2020 07:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fT25jmVwQCrq+LBbxgKBRUwHPoZ/yWZHqiHsumtsuQI=;
        b=sOAUFcWgrraRjYw2a8EtPg3yQgnlkpYRdmFvlRn9yQ55glYlVV8NKc4S3i1WPLchGu
         kX9B5nmAF9OlauDbISJT2QPCSnGAp0En+y7SJ913BKuakZtVqLX8am0dQuqhkPsYTsqy
         VPU+xkexq1yHbf52lFtCI4OyaTMY9IWkrCnGOGuQ9fZNEMoplWI6Q5LiXiqo6nwlYqOr
         bz+x5LGuFVr4A/K9fZOBn0JfFINiHgndFUSLq8Jyqh0GWJPJfOxRP2yHctJf4Zo1lE2I
         jBlw6hAX3v3y69ZwHY3xZXspnRXckausFCnJqyI0Kkyw4MaehLW9yzoYAllFj+33Me67
         C8FA==
X-Gm-Message-State: AOAM530UU5heKRxU6efo1DgKad5Ac0/dn6rmYBlcY+hZDfWWLZ249ZoM
        YSBVx6Iw1dROWTDq534H5QcYwEvWjXbUXa7a5T7bLTA178/0g8cFZiMWUYwo0v/0p5XvPjovKFu
        65oUDY9/6CzAQP25FRYvzOIDGYYsJsl47hxWxUbIGjxQMCgoZIRlKOjuseA==
X-Received: by 2002:a1f:a906:: with SMTP id s6mr2463001vke.26.1591799316306;
        Wed, 10 Jun 2020 07:28:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxohiyMMHa91MNwTbw6giqFmXWm1JSamW7nyby9ger99SxaMQCSsS7CUgyiCzeeoZxEAZHST9DR4EK0LRhe8gM=
X-Received: by 2002:a1f:a906:: with SMTP id s6mr2462981vke.26.1591799316028;
 Wed, 10 Jun 2020 07:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200605161657.535043-1-mfo@canonical.com> <20200608064843.GA22167@gondor.apana.org.au>
 <CAO9xwp0KimEV-inWB8176Z+MyzXqO3tgNtbtYF9JnBtg07-PiA@mail.gmail.com> <20200610002123.GA6230@gondor.apana.org.au>
In-Reply-To: <20200610002123.GA6230@gondor.apana.org.au>
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
Date:   Wed, 10 Jun 2020 11:28:24 -0300
Message-ID: <CAO9xwp2VryJi46+3UPhbQz3npCaZBziOTWEp+Kiqd90rMhkJXQ@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: af_alg - fix use-after-free in af_alg_accept()
 due to bh_lock_sock()
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 9, 2020 at 9:21 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jun 09, 2020 at 12:17:32PM -0300, Mauricio Faria de Oliveira wrote:
> >
> > Per your knowledge/experience with the crypto subsystem, the changed code
> > paths are not hot enough to suffer from such implications?
>
> I don't think replacing a spin-lock with a pair of atomic ops is
> going to be too much of an issue.  We can always look at this again
> if someone comes up with real numbers of course.

Right; I meant the other places as well, where atomic ops were added
(in addition to the existing spinlocks.)

But indeed, real numbers would be great and tell whether or not
there's performance differences.

We're working on that -- Brian (bug reporter) has access to detailed
metrics/stats from the workload, and kindly agreed to set up two
identical instances to compare the numbers.  I'll keep you posted.

Thank you,
Mauricio



>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Mauricio Faria de Oliveira
