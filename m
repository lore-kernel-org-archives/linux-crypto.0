Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D48C04EB8
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Dec 2018 08:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D312920850
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Dec 2018 08:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="lM4BoZJ3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D312920850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbeLDIik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Dec 2018 03:38:40 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:37898 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbeLDIik (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 03:38:40 -0500
Received: by mail-vk1-f193.google.com with SMTP id w72so3595225vkd.5
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 00:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnvYEhSL31NE2LZ9t0/Dvcct6en1iyjOs84XyLkWDYc=;
        b=lM4BoZJ3LdIbkVdqC95FQXd8V2lr6GOYRo5TVIJsG/dh4m+MKvNQuLDdpJtLnqlb4o
         LjBl+WAJUgDq4IjSzn2uwG7MKKgRYUjRBo5RdmWxzQDqCmWCvTGkI92PKey0VjBi2Sii
         Ev+gLLRT6adpJKyFblquOq6fGvpgO2eNoVKw86CCINY+5IyCy66XVOspFGmgs0zWUdy7
         M30kr1YOxqm8N6Io4Xr4UZMCPlRxjZ2YMZXutBaP3bA0fLLQlEd8WCQBiOzku91+we4q
         SEezga3+5rdN2z2flYlI5MAdSFCPFMKxHvlFBSOmKdhC4XpLs9ux9iDHxYxESPHjnoHj
         YFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnvYEhSL31NE2LZ9t0/Dvcct6en1iyjOs84XyLkWDYc=;
        b=WvXWVD/RO17/9qHyr4Ds2dmByIC0abSNp3nkwckSYcCgLGbSU7/m30VqLcam3YRMX/
         zGZfCkBNnLodtDr7cTmLI/WPMKapVJhFFuEL9EKPJD3GeOPMlA66PDGmRdLIUJO+OuNx
         08Sb6P42srcbCDWe4CK5Sm4gRq9ba4gtO8M6WS8pbLm8J+tYV78oGv137zB3/eCLw5CS
         lvrtQ/VjBivzQvthuHPAimf+KjnMFBiOES1gFUcokVfbvf5GAjWdYTDGYOlmkjpYETiE
         PbOyGQGJT0UblDxNF5qjPzA2vK0EubmEdy7hb6E7FvJjwPGFXeaZtNT+LHiPUzRgOgqO
         +4qw==
X-Gm-Message-State: AA+aEWadwoFIxLC+hgGNfJRPZe5wFRzSa1s5r6RrGy+gKIvSzfPMS1sL
        6Nquhz8NYJ8if/Zoo5c/CgXFb8wmuc0n4WbvuiV5dg==
X-Google-Smtp-Source: AFSGD/VaQiOmLuqIORljjwqHVtxjn7t+vCfUWYaf90PuTypdeCghoVeLUTdGgMWG6aI63jWoiBjR6shTV274id2ZgN0=
X-Received: by 2002:a1f:a147:: with SMTP id k68mr8269149vke.1.1543912718076;
 Tue, 04 Dec 2018 00:38:38 -0800 (PST)
MIME-Version: 1.0
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
 <1542102039-22256-3-git-send-email-gilad@benyossef.com> <20181129064218.53qc33vus5anla76@gondor.apana.org.au>
In-Reply-To: <20181129064218.53qc33vus5anla76@gondor.apana.org.au>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 4 Dec 2018 10:38:26 +0200
Message-ID:
 <CAOtvUMepGR89J-5SQXnReRiHanrOhp52cEKKm58Ej2uoHFAcyA@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: crypto: ccree: add dt bindings for ccree 703
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        yaeceh01 <yael.chemla@foss.arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181204083826.qMOAunrdBwu3o9iuFas0_AkuuGywJ6n5nyGSNNOpaJI@z>

On Thu, Nov 29, 2018 at 8:42 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Nov 13, 2018 at 09:40:36AM +0000, Gilad Ben-Yossef wrote:
> > Add device tree bindings associating Arm TrustZone CryptoCell 703 with the
> > ccree driver.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > ---
> >  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 1 +
> >  1 file changed, 1 insertion(+)
>
> Which tree is this patch meant to go through?

I'm not sure the question was addressed to me but if it did - either
going through the device tree or the crypto tree is fine by me.

Thanks,
Gilad
