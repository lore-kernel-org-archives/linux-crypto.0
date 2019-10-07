Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6D1ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 135EF21721
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570459567;
	bh=+WxnLtW0CM5zuNcVmAFSLRA1c01TWuxDEph+gcccG/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lP68WHyjVivDjglFxBUiltIQyMPEjpjNKZaCCUbgGyDUK4H/TIcalfe0p6CQoU+NW
	 Dt1Z+4JS9hdu8WBoWuWTdIYos4TqhnCjROHJJrYMnnAxvplSgqkR74kCxdokX3ywgA
	 gsjp1x/PW5OTg4Zg5b5qJAG5Bd1aZcZO7MZr+MoY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfJGOqG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:46:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34296 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGOqF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 10:46:05 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so200863wmc.1;
        Mon, 07 Oct 2019 07:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7LKk/MQUH9PrRGrgWgJu6sQTRpVfMAcu12gSHONSwaQ=;
        b=odUBTvBVB0ZmzaHCSWCJ6I1SZNze2wQrGoiGGMdma0cAgPHGgqm7Ii29Oo/bAVdf0D
         HHoPB69lGGhTa7g5KGhZFZxZFuzxG68pW6BvZcoGrALrMcc5KkfIMcHOREPQoXU7kNPK
         3+MI+D3fNoV2LbKW+iNbQF1lxkuGoZqdgeL2rj0ovZdwKEGYBOey1Bzj/xomXYpxgJRf
         okvssGH6OEP5VKGx6VwK7V6FZVdOZNXbcmrujG7M0DYCGIZQGAYxtj4MoktfzMsMQLxW
         LaBB4rJdO9CXTkL6DvtVn+mv7PrkUA7fr22A5lzX4bPQxw8c+zQ+R0ga1FEu5VOMZYjI
         ZcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7LKk/MQUH9PrRGrgWgJu6sQTRpVfMAcu12gSHONSwaQ=;
        b=acDqWpKP6on/hdJ5YzoFqn9oVEJvJn3w00Xv32O23vSCLUthYSqHlsqLUGfakXWWMa
         YgysVSnfi4VBoB4yrmZQcnJZCVJBTM2xd5q+FK84w2tyXCnOdcYyigxccd9xcw8K0eFW
         2xkbQZ0n1miETOEPafY3PkGPfoy4AWDd5cxe1OMCHjFTXxBxF/JkVEQQU8dWjPbbM3fQ
         PF79x+1XGZVZqk8R8xC2alJLZij6j4UWba3o5fr6ByxLuSu8Us7FPyRYOY1c7BIwKW7M
         uAf+FJPq7xwWs3B+3ZohtuPEur74NIhTa4J8GnjLldNWSlKy0n6w+meSVe2NA95kwJzI
         X93Q==
X-Gm-Message-State: APjAAAUa17YgjvBKaWlPmP34spAUjxu/htto3Pkh9u5tYkuNmWtsYME7
        V2cl+qE56vkFmeHqp/w/6c0=
X-Google-Smtp-Source: APXvYqy7eGqUJ6sI/nYfuvX1IX5cPiP8K+0tP/2XpBgkpGpDcxVFJurHv0UYmt4vIYyGTmceu58+pg==
X-Received: by 2002:a1c:4c12:: with SMTP id z18mr20487068wmf.45.1570459563086;
        Mon, 07 Oct 2019 07:46:03 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id o9sm36091179wrh.46.2019.10.07.07.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 07:46:02 -0700 (PDT)
Date:   Mon, 7 Oct 2019 16:46:00 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007144600.GB59713@gmail.com>
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
 <20191007142230.GA117630@gmail.com>
 <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


* Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> On 07-10-2019 16:22, Ingo Molnar wrote:
> > 
> > * Hans de Goede <hdegoede@redhat.com> wrote:
> > 
> > > Hi,
> > > 
> > > On 07-10-2019 16:00, Ingo Molnar wrote:
> > > > 
> > > > * Hans de Goede <hdegoede@redhat.com> wrote:
> > > > 
> > > > > The purgatory code now uses the shared lib/crypto/sha256.c sha256
> > > > > implementation. This needs memzero_explicit, implement this.
> > > > > 
> > > > > Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> > > > > Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
> > > > > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > > > > ---
> > > > > Changes in v2:
> > > > > - Add barrier_data() call after the memset, making the function really
> > > > >     explicit. Using barrier_data() works fine in the purgatory (build)
> > > > >     environment.
> > > > > ---
> > > > >    arch/x86/boot/compressed/string.c | 6 ++++++
> > > > >    1 file changed, 6 insertions(+)
> > > > > 
> > > > > diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
> > > > > index 81fc1eaa3229..654a7164a702 100644
> > > > > --- a/arch/x86/boot/compressed/string.c
> > > > > +++ b/arch/x86/boot/compressed/string.c
> > > > > @@ -50,6 +50,12 @@ void *memset(void *s, int c, size_t n)
> > > > >    	return s;
> > > > >    }
> > > > > +void memzero_explicit(void *s, size_t count)
> > > > > +{
> > > > > +	memset(s, 0, count);
> > > > > +	barrier_data(s);
> > > > > +}
> > > > 
> > > > So the barrier_data() is only there to keep LTO from optimizing out the
> > > > seemingly unused function?
> > > 
> > > I believe that Stephan Mueller (who suggested adding the barrier)
> > > was also worried about people using this as an example for other
> > > "explicit" functions which actually might get inlined.
> > > 
> > > This is not so much about protecting against LTO as it is against
> > > protecting against inlining, which in this case boils down to the
> > > same thing. Also this change makes the arch/x86/boot/compressed/string.c
> > > and lib/string.c versions identical which seems like a good thing to me
> > > (except for the code duplication part of it).
> > > 
> > > But I agree a comment would be good, how about:
> > > 
> > > void memzero_explicit(void *s, size_t count)
> > > {
> > > 	memset(s, 0, count);
> > > 	/* Avoid the memset getting optimized away if we ever get inlined */
> > > 	barrier_data(s);
> > > }
> > 
> > Well, the standard construct for preventing inlining would be 'noinline',
> > right? Any reason that wouldn't work?
> 
> Good question. I guess the worry is that modern compilers are getting
> more aggressive with optimizing and then even if not inlined if the
> function gets compiled in the same scope, then the compiler might
> still notice it is only every writing to the memory passed in; and
> then optimize it away of the write happens to memory which lifetime
> ends immediately afterwards. I mean removing the call is not inlining,
> so compiler developers might decide that that is still fine to do.
> 
> IMHO with trickycode like this is is best to just use the proven
> version from lib/string.c
> 
> I guess I made the comment to specific though, so how about:
> 
> void memzero_explicit(void *s, size_t count)
> {
> 	memset(s, 0, count);
> 	/* Tell the compiler to never remove / optimize away the memset */
> 	barrier_data(s);
> }

Ok, I guess this will work.

Thanks,

	Ingo
