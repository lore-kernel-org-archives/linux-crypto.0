Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50319C43331
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 04:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1420920719
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 04:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lz2nQ4xl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgCZEkG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 00:40:06 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:60969 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgCZEkG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 00:40:06 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id fecb4eae
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Mar 2020 04:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=5e6V75IBofV3OvJr5MajhQsNkyM=; b=lz2nQ4
        xlhK2jYYJ33qE5Ad7gGutQUXj8psC8l+7y/S7eyp7VD3WFPSln7f8O5ijQUVbgG1
        r/ACmEePRGuhcTdsdQdhPWmD8W5aN844JAlREkYfSIh38abeWMMqtD+x/sJymrwd
        q/HKknFcd1tA/bW7nbRwYc+icmuwtCJHR/mX8E7VpKoIIE/iIX4Uy11TowivfVQu
        2JeH8G3aynhA4lyUy6nixWhdNQ/5crJMdTc5r5mbSuMEsJ/XsZnzt7g6UW4WozSV
        A1E9eM6xAG84yo5BDUulnd0ts9YWu6/yK/yQwV66IoPbgJMBXaEn2rXrSNfGgGIT
        eXTwulEQvwdI52aQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0b23a58c (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Mar 2020 04:32:43 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id t11so4177484ils.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 21:40:04 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1QCBHVEQK5nh0xVyu2c2pcFFy+ZIVIcgHGfJVDFbO91JVPfOIV
        6vLFrzUwbTm7gQosSok7+wJfEZ8/H9xkkpwKe/8=
X-Google-Smtp-Source: ADFU+vtki0oI1pRIuBTSrfVzA9NQLUcU/7Yu1962QVf6SLZHinVrxpDpg/BNjFL94AUlt9MNkHUbn+POhWkCwKzuxKk=
X-Received: by 2002:a92:cc8c:: with SMTP id x12mr7149006ilo.224.1585197603395;
 Wed, 25 Mar 2020 21:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200319180114.6437-1-Jason@zx2c4.com> <CAHmME9p5KnsUpRCve3_6ugobG9c-fnqQgNOE8F28CX4SvsTX1w@mail.gmail.com>
 <20200326043857.GA6690@gondor.apana.org.au>
In-Reply-To: <20200326043857.GA6690@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 25 Mar 2020 22:39:52 -0600
X-Gmail-Original-Message-ID: <CAHmME9rkW+noUsPH4AXNjQV+TqS4Cyfcjy4qRSUdPKr50zozow@mail.gmail.com>
Message-ID: <CAHmME9rkW+noUsPH4AXNjQV+TqS4Cyfcjy4qRSUdPKr50zozow@mail.gmail.com>
Subject: Re: [PATCH crypto] crypto: arm[64]/poly1305 - add artifact to
 .gitignore files
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 25, 2020 at 10:39 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Mar 25, 2020 at 10:32:41PM -0600, Jason A. Donenfeld wrote:
> > I think this might have slipped through the cracks?
>
> It's on the list:
>
>         https://patchwork.kernel.org/project/linux-crypto/list/

Oooo! Had no idea you used Patchwork. Thanks! Will bookmark that and
check there periodically instead.

Jason
