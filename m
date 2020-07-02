Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A69EC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF1620899
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593676303;
	bh=PtPJ1faADv4ZyISHM4fuICE4VJVsmABNMkIdMwo6VkU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=E5NsqwMcX+pCIXK9ktGGivi+Qxo1pzT2MS4VwB+J4Z2y81VZXOrIUY4SQEjJDmzFm
	 PDIH7PqktSgNU1itaCAuOo6HM/n/3hkZtD4GOk+joN5UxGnIp0oWTNYMAumyzAjoTT
	 Xsa0hn9Eo4QdrQtucuNSwKqfp9flYsnTLokEIKQc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgGBHvm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgGBHvm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 03:51:42 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1EF20899
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2020 07:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593676301;
        bh=PtPJ1faADv4ZyISHM4fuICE4VJVsmABNMkIdMwo6VkU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BMzzsqAaNviB+KvECt36mZgW3EPzjMTmlTocT99aXw1cIOw12nZ1m1ObAjifhtwS0
         hMc76STIrtHJgzoTgvuIPfvH8GiypzKAPIT9Gp+H1OcDDMia9D8tlZvZRFeGiSmKSi
         7QVRU8xjGq7YJPamTMl6kcxpulQthaDtp+CicbZw=
Received: by mail-ot1-f54.google.com with SMTP id w17so15607380otl.4
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2020 00:51:41 -0700 (PDT)
X-Gm-Message-State: AOAM533SPY4c++Cl96Main/e+KPTBLx3WmQMnXJwc17ZKDCNr3ip13tw
        h1hXkg1Bxm/Fdv2I3eYYVqaknNxI5skQvok7T6c=
X-Google-Smtp-Source: ABdhPJx9oH1bF3ZUtDDgvgTOzBN58PK1R8j4+4At+nC7u4pfNFD62jh0lF+RcRSbfeu+P33e/FMpxS4GuFL/zqzZwBY=
X-Received: by 2002:a9d:5a12:: with SMTP id v18mr24949239oth.90.1593676300918;
 Thu, 02 Jul 2020 00:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au> <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
 <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
 <CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com> <20200702074533.GC4253@gondor.apana.org.au>
In-Reply-To: <20200702074533.GC4253@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 2 Jul 2020 09:51:29 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHT9Puv2tC4_J2kVMjSF5es_9k+URVwsvao6TReS_5aJA@mail.gmail.com>
Message-ID: <CAMj1kXHT9Puv2tC4_J2kVMjSF5es_9k+URVwsvao6TReS_5aJA@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Jul 2020 at 09:45, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 02, 2020 at 09:40:42AM +0200, Ard Biesheuvel wrote:
> >
> > I suppose you are looking into this for chaining algif_skipcher
> > requests, right? So in that case, the ARC4 state should really be
> > treated as an IV, which is owned by the caller, and not stored in
> > either the TFM or the skcipher request object.
>
> Yes I have considered this approach previously but it's just too
> messy.  What I'm trying to do now is to allow the state to be stored
> in the request object.  When combined with the proposed REQ_MORE
> flag, this should be sufficient.  It evens works on XTS.
>

But that requires the caller to reuse the same skcipher request object
when doing chaining, right?

Currently, we have no such requirement, and it would mean that the
request object's context struct should be aligned between different
implementations, e.g., when a driver ends up invoking a fallback for
the last N bytes of a chained request.

I'll wait for the code to be posted (please put me on cc), but my
suspicion is that carrying opaque state like that is going to bite us
down the road.
