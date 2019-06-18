Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79BCC31E5D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B11F8206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l/c1zYnr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfFRJig (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:38:36 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36025 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729433AbfFRJig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:38:36 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so28288114ioh.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZYxk0zpnWBOIpwkEOgb96nHnDd2liidUIE8WsxVQMbI=;
        b=l/c1zYnrThVQCNjjptn2RTlsV/kxJkwZ2aqJXiXdGGHDf2aj8R12Lp6tr1JHjhTsG7
         2tPXRCzsnUPxkEOKQem6FptIukoiTOrR7/TOQB497QcDSCNq9WxMgVDti6kzy6ig9uyq
         PxaZrzZ47KRUrX4vmImFnTJYnwbhX/q6nY0pP11SXMgie7+MlTVJZwz4zIUXhcwUErEr
         RMQDrgXPwDd1aVPCBLYGdeGGtitrYhFHBR0T6Evsy2CCDWi/rptpvNtHmL2b+jvtElr8
         bu2Gbicp/yiQsfqsb0jauUc/IfOaKyRnP4b6+YWeIdALs7/vFkQkUPPoo1Cm2V2PCZxb
         gsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZYxk0zpnWBOIpwkEOgb96nHnDd2liidUIE8WsxVQMbI=;
        b=iFiQhSmimDJxRuNYwJ7y+1SbV3ng1lRlTfYKcjTs6RZ1CkhNwqPi0AIOg8hwkG8Aeq
         f/wJvMVxzyVbG6uJza9LWTDolLOMyafocRLSEzy7MFF6oEz8vqbdYsm2TjKeGxjWtwSE
         Di231zN5FX08EqbXNVH3wzI8rFyNWC25Xfv9W2YxBl6dOpBFeApFDCCyBJLkVFWdF0EZ
         dZSbVPuot1zsoIsEfIWEFduJd8Sjc5kfI6Lz4O7S5aUHGfBJz32h0DCtvWOCC/ZOFgqV
         kptXs/R5gOZfUMMs55j9D90VFS42mkqFOBs8UBWMAGKw7TErY/iHZTKzDFO5NI2CAxTh
         jBGQ==
X-Gm-Message-State: APjAAAWOwZfIQ7jchl2xpqd77tbSXOyGtIHwlZha5qIMXAB3eQbkYPYf
        y2lIxGOkD7G1vWlxGxMOqDytn8wWmI7OFBdiGh/477f08WQ=
X-Google-Smtp-Source: APXvYqy5iMKHIoyO5hV9y5XQejAf3ueCf8/vJgPqlTh1hmwPScZA8IKGQdp6DJto0GIRU4iuC1267QC4eNY+bQi73YE=
X-Received: by 2002:a02:1a86:: with SMTP id 128mr88760574jai.95.1560850715088;
 Tue, 18 Jun 2019 02:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org> <CANn89i+Hcp5nxteWHOq-Uv9VzneCemVEkyyZJD=UG9-wsrLAwQ@mail.gmail.com>
In-Reply-To: <CANn89i+Hcp5nxteWHOq-Uv9VzneCemVEkyyZJD=UG9-wsrLAwQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 11:38:23 +0200
Message-ID: <CAKv+Gu-QbrSSCKn09XFa9Cms7jbCgsYotPdFboFR=dCDZWvPYg@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: fastopen: follow-up tweaks for SipHash switch
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 18 Jun 2019 at 11:37, Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > A pair of tweaks for issues spotted by Eric Biggers. Patch #1 is
> > mostly cosmetic, since the error check it adds is unreachable in
> > practice, and the other changes are syntactic cleanups. Patch #2
> > adds endian swabbing of the SipHash output for big endian systems
> > so that the in-memory representation is the same as on little
> > endian systems.
> >
>
> Please always add net or net-next in your patches for netdev@
>
> ( Documentation/networking/netdev-FAQ.rst )
>

Apologies. These patches are intended for net-next
