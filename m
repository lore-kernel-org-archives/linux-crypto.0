Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFEEC4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 03:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E812177B
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 03:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BH3L95hh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460371AbgJWDSD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460370AbgJWDSC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 23:18:02 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EBBC0613CE;
        Thu, 22 Oct 2020 20:18:01 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id v200so4234941qka.0;
        Thu, 22 Oct 2020 20:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AppCYP1ZaGbbS48l2CE8WdDxVMAQivKpkaa3oombwS0=;
        b=BH3L95hhzNvc9Ji/gcQu9ffvQi60vd3EW7tm/Z4hMuh0ZTB69TcVq6LlFOrFPbk7FV
         ObXZYe5i7eFvp1yJ3ILp8ZfxtJ3clpUy5mYGkB7jdWEw/sA8SxtiVAuQds9ZHVWzsRVC
         UasKdGluK9RxihaweoBslOmQ1beK6WL31vXfTafnhDp8Clemsyv33fN6gGUEttMQayc1
         oixWZJeW7/+8e5OMIsh/O5Np9gQb5C0Y2hS84w+MagwPh3ys9F0LMxV1E2YLOVQwERw6
         x75AN7s+nh7XEvY+WseNqX8Y8PqesroOf2RVjsDuqIJbep7k0/SzjMGDcl+IuxsyoG0z
         rczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AppCYP1ZaGbbS48l2CE8WdDxVMAQivKpkaa3oombwS0=;
        b=LMbRNwzSykcs4cpMpcDUyE0LNnwxIuchowyQemEwxEdDinSDLprizqTNv43WZxZ7/H
         pJL/VEXaWRNuLGlz5kHFFrNoEUT40Og4HALkomNGY7gYuDUCiLy94/Y3GQO7E2umCV9q
         H4PNBmpEtz/+AWmRIWO905DmY57I3mQYo9XrVUaQ9tXsJ5yW/8RlkE2/3OeWQzmvfdvy
         Kpi3Kd+MjWA+AVI7xgZLvP9RlKB0ebMQQ2DD5ilJwA0eyDaCqj/nWSyByeouxDjvo14p
         4wF8W+6vbSyCaNij5zpiOe6ZAzyGKeTVngx0tBMncU+VjUZkatk5K/Fj+0JIWny/15FY
         pIuA==
X-Gm-Message-State: AOAM533LyX6zvOKg1ek0Pdf9PhwDPRLqyVp279WNbmHxaF9cASHSh+r/
        GaV/SqHHsXzjgmEmv82L+0pYUAk9F2lHmg==
X-Google-Smtp-Source: ABdhPJwWe9CyuJ6yJAa/z3yGUVHgeNiM+caSDVb6Px9rlegznKKUg24iEDMgF8efu3d7FjH7VR5XIQ==
X-Received: by 2002:a05:620a:714:: with SMTP id 20mr351510qkc.238.1603423080150;
        Thu, 22 Oct 2020 20:18:00 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t13sm153620qtw.23.2020.10.22.20.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 20:17:59 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 22 Oct 2020 23:17:57 -0400
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] crypto: lib/sha256 - Don't clear temporary
 variables
Message-ID: <20201023031757.GB135789@rani.riverdale.lan>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-3-nivedita@alum.mit.edu>
 <20201022045850.GE857@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201022045850.GE857@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 21, 2020 at 09:58:50PM -0700, Eric Biggers wrote:
> On Tue, Oct 20, 2020 at 04:39:53PM -0400, Arvind Sankar wrote:
> > The assignments to clear a through h and t1/t2 are optimized out by the
> > compiler because they are unused after the assignments.
> > 
> > These variables shouldn't be very sensitive: t1/t2 can be calculated
> > from a through h, so they don't reveal any additional information.
> > Knowing a through h is equivalent to knowing one 64-byte block's SHA256
> > hash (with non-standard initial value) which, assuming SHA256 is secure,
> > doesn't reveal any information about the input.
> > 
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> 
> I don't entirely buy the second paragraph.  It could be the case that the input
> is less than or equal to one SHA-256 block (64 bytes), in which case leaking
> 'a' through 'h' would reveal the final SHA-256 hash if the input length is
> known.  And note that callers might consider either the input, the resulting
> hash, or both to be sensitive information -- it depends.

The "non-standard initial value" was just parenthetical -- my thinking
was that revealing the hash, whether the real SHA hash or an
intermediate one starting at some other initial value, shouldn't reveal
the input; not that you get any additional security from being an
intermediate block. But if the hash itself could be sensitive, yeah then
a-h are sensitive anyway.

> 
> > ---
> >  lib/crypto/sha256.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> > index d43bc39ab05e..099cd11f83c1 100644
> > --- a/lib/crypto/sha256.c
> > +++ b/lib/crypto/sha256.c
> > @@ -202,7 +202,6 @@ static void sha256_transform(u32 *state, const u8 *input)
> >  	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
> >  
> >  	/* clear any sensitive info... */
> > -	a = b = c = d = e = f = g = h = t1 = t2 = 0;
> >  	memzero_explicit(W, 64 * sizeof(u32));
> >  }
> 
> Your change itself is fine, though.  As you mentioned, these assignments get
> optimized out, so they weren't accomplishing anything.
> 
> The fact is, there just isn't any way to guarantee in C code that all sensitive
> variables get cleared.
> 
> So we shouldn't (and generally don't) bother trying to clear individual u32's,
> ints, etc. like this, but rather only structs and arrays, as clearing those is
> more likely to work as intended.
> 
> - Eric

Ok, I'll just drop the second paragraph from the commit message then.
