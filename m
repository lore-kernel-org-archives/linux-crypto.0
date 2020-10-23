Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BB2C4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 03:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8003821531
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 03:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1SH0X9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460281AbgJWDMk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460280AbgJWDMk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 23:12:40 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E47FC0613CE;
        Thu, 22 Oct 2020 20:12:40 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id t20so44035qvv.8;
        Thu, 22 Oct 2020 20:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hIFoFXqG3C+aVpuglbj3vcsQiNpdlid8a/GnTrIUHmQ=;
        b=l1SH0X9M0892p8pp7CfYTOhNO58lYSnHjPGY5n9S9NTQU7NSGb9Sh9ZgNZLUUKkc71
         2DImOx4UWvIEWsyH/u7yfmPnQtEHQuRQFBxdQs9dw7qyqM88XRzhzrmMOIt1F7XRva25
         XTDp1jfI+u4QnGqK5YXuVzjDyRpDtRUiwncWoN0hQhOCF6zLTxfazclZ4M4/SihsRz5h
         vU5bI+vfCE0D8rvs6Afmax5B9I6xBDuFw+lh+28UTUp0HkTVXCOcBi6K1FWp+TTLIvj+
         B/XMz++GbwHyAsrrhAi3QOzMyuBd7S+vulQuwv4odO/Zj+lv0DXXCqjBnxZC/4ACan9i
         6wzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hIFoFXqG3C+aVpuglbj3vcsQiNpdlid8a/GnTrIUHmQ=;
        b=avQNmFKLOuuNLL8KapeHig2WQxGQvdVBlHEdKzV1S6pwecZpOf3Xdy/s+RcIFWaRny
         7p0eNpvusw5hoKW1bDQaq3yDBcKxW2Kr481z9JlXH905mfhNTDdCzMjcGHh7zMXuwEvc
         RroEBpHD49WGnJo8yKH8QdZ3XaZQetX91l5ACkd2zZTYVfVo4or8/YKTmOUq7bT8xHFq
         ck0+0jbJGQRZFApik/iuuDWHe63RvvSJZlRJHE9S3bqymjhSoZg+XxQ0k2MpClMOe9tq
         VvhTdN/NWQwL3dsHNN9c43hmPZdQFnwcKTkZFT72et8IcpRzpnbakasNzP1V3bNT0khv
         Fdqw==
X-Gm-Message-State: AOAM5322wiEFnXejOYtutRlHHhl8XrT3sTT2l0fNMCFq4Hk6TNKZdYTJ
        B3/edVH8/cTWYblsLu1hyow=
X-Google-Smtp-Source: ABdhPJw0SSH1xM+L8IAd50r2m49N1qq4EkX7ZTsb2RmW/zYctY42/x7DtLB2TALDnLEfNDMZnuq4Fg==
X-Received: by 2002:a0c:e250:: with SMTP id x16mr153891qvl.1.1603422759305;
        Thu, 22 Oct 2020 20:12:39 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id r17sm163828qtc.22.2020.10.22.20.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 20:12:38 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 22 Oct 2020 23:12:36 -0400
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Message-ID: <20201023031236.GA135789@rani.riverdale.lan>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-5-nivedita@alum.mit.edu>
 <20201022050219.GG857@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201022050219.GG857@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 21, 2020 at 10:02:19PM -0700, Eric Biggers wrote:
> On Tue, Oct 20, 2020 at 04:39:55PM -0400, Arvind Sankar wrote:
> > This reduces code size substantially (on x86_64 with gcc-10 the size of
> > sha256_update() goes from 7593 bytes to 1952 bytes including the new
> > SHA256_K array), and on x86 is slightly faster than the full unroll
> > (tesed on Broadwell Xeon).
> 
> tesed => tested
> 
> > 
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > ---
> >  lib/crypto/sha256.c | 166 ++++++++------------------------------------
> >  1 file changed, 30 insertions(+), 136 deletions(-)
> > 
> > diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> > index c6bfeacc5b81..5efd390706c6 100644
> > --- a/lib/crypto/sha256.c
> > +++ b/lib/crypto/sha256.c
> > @@ -18,6 +18,17 @@
> >  #include <crypto/sha.h>
> >  #include <asm/unaligned.h>
> >  
> > +static const u32 SHA256_K[] = {
> > +	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
> > +	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
> > +	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
> > +	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
> > +	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
> > +	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
> > +	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
> > +	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
> > +};
> 
> Limit this to 80 columns?

I was aiming for 8 columns per line to match all the other groupings by
eight. It does slightly exceed 100 columns but can this be an exception,
or should I maybe make it 4 columns per line?

> 
> Otherwise this looks good.
> 
> - Eric
