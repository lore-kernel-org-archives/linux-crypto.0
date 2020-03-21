Return-Path: <SRS0=8vbj=5G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BF4C4332B
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Mar 2020 12:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFD120780
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Mar 2020 12:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FxDkBn0L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgCUMbQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Mar 2020 08:31:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40695 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCUMbQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Mar 2020 08:31:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id f3so10682407wrw.7
        for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2020 05:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xbtZjQMNQb/y6oMWok2fmAogGJpkRY2dtwNS/rxXLDc=;
        b=FxDkBn0LxGmSnyk9fCZRGcAZoSiwCEUWg5a+nQtSOerjHcNFAPd8MxcVIsbNJjw0Ar
         BvAJLCCFpzmATGIhszxfVTlBLKSkQSBPdfgEiwc9Sn4DP2Sg7SRLTsMPq71QYTw9rpfv
         kuGWIXDXQWKTOceK7yTz5SR0pLl9yPwi8NfLt+5o4tf43LjDw9MD3a86F69izQBHB4Ti
         XeglQa7A5myDDg1rhjjnkcHV2Hly+B1YBERtDJcwNMFomBLBkwu3qKz0oDae+foQsGQX
         VpZgxpsvQ2O8fynd0z+yLH4usaFL6mywftTEbttOt9JQGJ6sIIHRuexFbsRZUkdQCx93
         6GKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xbtZjQMNQb/y6oMWok2fmAogGJpkRY2dtwNS/rxXLDc=;
        b=LfTyQcvPPGJ1rcNMlomjDKfVODbCVXxmDZ0AwsVKc8A35eO6CyGqLus+P6Y6NXkPuD
         1g2OpfiUzT3gXv2XX60LRDMHNq4gC7gvHWnMFmySj7ipXgTcobRp2jktQQ/+PRPUOfNZ
         MTwXEgYLng0FT3Gg7K5gveBF/ff8mtLZdE+Oj9fyNRPI80Fw9Fwfy0UoLqyNsyZ2r1GP
         g89BewkGqy2GlRkDAj9OrrpaL7iKWO+fkYxNat+a2weMifAHQQVDyysiIhTJQCvIKu77
         OfS6gNqPrLv+JMvGWOR1gnUJ2h36UNsIF1yRiPFJLLILlQJLpyeFqNcOo+vxgR6AWvDz
         zJPg==
X-Gm-Message-State: ANhLgQ1zbFEgP0P13cK7GKKm5QUZWpkajjSf1taz8cNlNQLvHfie/R6m
        wCDAhviJnCAcdTk9Q74RiVs3driev784nHce9nBdyA==
X-Google-Smtp-Source: ADFU+vv+k2p23kBpnyhIU03BQrf4V8Z6Thh0ZM8qQPeMtggKwiJSuJ2mPPLgUoUUT3CWXdoqiSZtF6fjViVsdvJ0FoM=
X-Received: by 2002:a5d:4fcf:: with SMTP id h15mr11133455wrw.262.1584793874444;
 Sat, 21 Mar 2020 05:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
 <20200320053149.GC1315@sol.localdomain> <DM5PR18MB231111CEBDCDF734FA8C670BA0F50@DM5PR18MB2311.namprd18.prod.outlook.com>
In-Reply-To: <DM5PR18MB231111CEBDCDF734FA8C670BA0F50@DM5PR18MB2311.namprd18.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 21 Mar 2020 08:31:02 -0400
Message-ID: <CAKv+Gu_G4=Dn+6chjk1dQFMXm1aGU8QQZMmy94L5LicmR3itKQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX Cryptographic
To:     Srujana Challa <schalla@marvell.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Mar 2020 at 06:47, Srujana Challa <schalla@marvell.com> wrote:
>
> > On Fri, Mar 13, 2020 at 05:17:04PM +0530, Srujana Challa wrote:
> > > The following series adds support for Marvell Cryptographic Accelerarion
> > > Unit (CPT) on OcteonTX CN83XX SoC.
> > >
> > > Changes since v1:
> > > * Replaced CRYPTO_BLKCIPHER with CRYPTO_SKCIPHER in Kconfig.
> > >
> > > Srujana Challa (4):
> > >   drivers: crypto: create common Kconfig and Makefile for Marvell
> > >   drivers: crypto: add support for OCTEON TX CPT engine
> > >   drivers: crypto: add the Virtual Function driver for CPT
> > >   crypto: marvell: enable OcteonTX cpt options for build
> >
> > There's no mention of testing.  Did you try
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
> >
> Yes, the crypto self-tests are passed.

*which* selftests are passed? Please confirm that they all passed with
that kconfig option set
