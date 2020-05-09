Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F110C38A2A
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 01:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 142BF20820
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 01:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j23Gv3Wc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgEIBne (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 21:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgEIBnd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 21:43:33 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1289C061A0C;
        Fri,  8 May 2020 18:43:33 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id g14so3009420otg.10;
        Fri, 08 May 2020 18:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qj2NsxxrxGvcjEmd9rf19lFO4hTM6QQZYMW5MhboOoc=;
        b=j23Gv3WcZSw7Qh3HqAqBbX1Mjk+cbqhd9vHrrnXwvLJ+/WbnkeES+9R3aTfdo7Xod0
         veU/ADpIIVaM3mEWusgjTYeUedB1SAiW7/OTmuN+Kf66JKJglBnJ7NMOY/IwffbCSf+J
         yA8TMfaM7qK291QvNYtzeQ63u3+8+skbCZQCJysxiZdUK/qVvXMeGQJOS2TPt0lKCtQQ
         R8V6JWYl48H29SrxpqW9cnmh52gWvviuVKZRanP58AkO9P6/3mkHE7c9AoWuMGF2Ofe2
         1N0UaPocX4LawQ/PhW6WbgOrQa+rByGoFOIRwk2xHgCfCKCqs763HRE6pmlATn4Ttl24
         AnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qj2NsxxrxGvcjEmd9rf19lFO4hTM6QQZYMW5MhboOoc=;
        b=YbE/brrbiTtbYIJPw3IvGNaYwM8xB+gGuEofqlHNqgS9HayXPq7OmLmVkOLGlsuN9U
         /q9yzST/fY9IHgNx2dsqtvcxQ3f1BChRUv7e3/yIgRPoLa6Wu1NIH22NTwIZj/FG9dSF
         y5vRj3Fwl6nPjNaotXI2OvobHh4xhxp5OQuT+vKFa7Un3ylFtTxxeHy2KTrAeKyMLxux
         7yrRlkXLLQKENFhl/2lFa/0Zp9B3G5zWJY/btqMOE0XrWT1OnAErJe8UdO3PRNkXtMqz
         qagvsYLPySVWn6DJONYYJw9T/4Receiv4twgw4JVwvG4p7eHTnvkxL6zmEGBFmt+THiP
         p/sg==
X-Gm-Message-State: AGi0PubSSfR3XbkhP1sExA/hjZD1xE9kdsjbTLTSAtEO5IV8c6HUZKoa
        POBZWgjVwhFDmjakCQMi7pM=
X-Google-Smtp-Source: APiQypLdyi3Jv6TN6mCs4307DPP++qwr5Ww4nk3D7QYpmTgWtl6SDsKHTSCmkKfLPXG3SELlAs5kIQ==
X-Received: by 2002:a9d:6c09:: with SMTP id f9mr4566004otq.94.1588988612824;
        Fri, 08 May 2020 18:43:32 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id t15sm940863oov.32.2020.05.08.18.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 18:43:32 -0700 (PDT)
Date:   Fri, 8 May 2020 18:43:30 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Sterba <dsterba@suse.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Eric Biggers <ebiggers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] crypto: blake2b - Fix clang optimization for ARMv7-M
Message-ID: <20200509014330.GA2153306@ubuntu-s3-xlarge-x86>
References: <20200505135402.29356-1-arnd@arndb.de>
 <20200506051200.GA831492@ubuntu-s3-xlarge-x86>
 <CAK8P3a2LAgEG7epWFtUZrcgk9OwpVJd+ji9Ru_rq4L-Qk_dYbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2LAgEG7epWFtUZrcgk9OwpVJd+ji9Ru_rq4L-Qk_dYbg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 08, 2020 at 11:31:07PM +0200, Arnd Bergmann wrote:
> On Wed, May 6, 2020 at 7:12 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> > > -
> > > +#ifdef CONFIG_CC_IS_CLANG
> >
> > Given your comment in the bug:
> >
> > "The code is written to assume no loops are unrolled"
> >
> > Does it make sense to make this unconditional and take compiler
> > heuristics out of it?
> >
> > > +#pragma nounroll /* https://bugs.llvm.org/show_bug.cgi?id=45803 */
> > > +#endif
> > >       for (i = 0; i < 8; ++i)
> > >               S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
> 
> No, that would not work, as gcc does not support this pragma.
> 
>         Arnd

Ah fair enough.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
