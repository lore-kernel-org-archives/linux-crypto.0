Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D78C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D39520675
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KlTKFNO1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfFTNx5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 09:53:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38525 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfFTNx5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 09:53:57 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so1777772ioa.5
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2019 06:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0vIXNw6IkK7+noGSyo5S+Vhxo01kIr5An5KCT/yZtQ=;
        b=KlTKFNO13ZwaLx0eExtpcBtMCOu5xdOL29sS9i/Lyz6IO//LHdBSWp6aDwUbq+n9F1
         CABMLheQqbvmE5ZRnv+i+gi4/MHqWbiX45/2e6DMzj3X0aSKoyPMgo5TlAo4BpexecDN
         ymOq+dE9aGEwWraSCjCtIZgHBcqKFrGsoynePjm74o6khNuewS+AAEv8Kk/qKgGzWR51
         o9QpnZnKQy4bNCR4JxzrIbLNRvN24VAfDYzsTMCotz2YV3q/Jh9STqEyYd+AT8YfQ8yt
         Pn7sHwsODlaIpM04IViHyrtMB1aannx5L184Oh9qrVz82MlLAVYhG+ZCQjJC8PHxdv4g
         8lQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0vIXNw6IkK7+noGSyo5S+Vhxo01kIr5An5KCT/yZtQ=;
        b=P2h7SAn7qgafNm+BXFvaZNIKy0XO42LQ3y/KmzCKkBsplHhdTeYxiurI2ULgREtRJO
         i0Sks1gtFuVa95WcQKvEuDlTjlJsBeUfcvt2Pxr2is6eArQPUumTiZpygVIfpecAiEKE
         RhKD5KXpX6gmKGiWJ0RgeG1hc0dbf88C4bJDsGGHulzhpp57dwgpTUXbhBZazDLaF/cY
         MOUogAshkFwMwzQQOgKYoRLp9M45+BeZqAUtgBPqeQ+wSsjGDEaIpxKmkYDPtTAODTOi
         Aax406TU4ApX8P+g8IW76y3O5pVjQqKkEVJS2+ISsKfBVSqFmmkVbTGDnnNcmNbsgHEy
         meEA==
X-Gm-Message-State: APjAAAWhTP7HeBgFXU0EzLKbcn5bKFEVXGuSA8PbqHFFiDGRiVPvf9BA
        zQwsZA/d9+N/QSBwloiEnKup4PrRJiRY3l/jJeEl3Av9XBQ=
X-Google-Smtp-Source: APXvYqwtfZzrYQMbQkOK6e3dZ11mzuRUTZK3eybV3NTUaN9QmoMQSIWPRiU3as2yid/Ysmd6prgeaCjN26BdpXRnHzA=
X-Received: by 2002:a02:3308:: with SMTP id c8mr35402333jae.103.1561038836657;
 Thu, 20 Jun 2019 06:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au> <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au> <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
 <20190620134045.fncibzc7eyufd5sj@gondor.apana.org.au>
In-Reply-To: <20190620134045.fncibzc7eyufd5sj@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 15:53:45 +0200
Message-ID: <CAKv+Gu8OFbDJGoYw_DHresF5HJDSamtw1YtZ13gpOVJCYV+22Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Jun 2019 at 15:40, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 20, 2019 at 03:02:04PM +0200, Ard Biesheuvel wrote:
> >
> > It also depend on how realistic it is that we will need to support
> > arbitrary sector sizes in the future. I mean, if we decide today that
> > essiv() uses an implicit sector size of 4k, we can always add
> > essiv64k() later, rather than adding lots of complexity now that we
> > are never going to use. Note that ESSIV is already more or less
> > deprecated, so there is really no point in inventing these weird and
> > wonderful things if we want people to move to XTS and plain IV
> > generation instead.
>
> Well whatever we do for ESSIV should also extend to other IV
> generators in dm-crypt so that potentially we can have a single
> interface for dm-crypt multi-sector processing in future (IOW
> you don't have special code for ESSIV vs. other algos).
>
> That is why we should get the ESSIV interface right as it could
> serve as an example for future implementations.
>
> What do the dm-crypt people think? Are you ever going to need
> processing in units other than 4K?
>

We'd need at least 512 and 4k for dm-crypt, but I don't think the
sector size is limited at all tbh
