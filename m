Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AC1ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3AE021655
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570458156;
	bh=Ox88whuC8uKV1i7HEP/KbtiYnB2gqIgW5HeiEPdXCtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Ofh0iYi/NGoFDQpdcBcFqME2fiQKq3FJ1EDtaCg3ohH3XWfUjE1hLr8rLFms9Q42O
	 wthM3cPgjSQOpgysmfuxqpjVwIla3FYE6yQYif5YKYXCng7kSKRrA4CZ92NrmiQCKp
	 6pcBsyrFydCgufHc1pA7wAkcb9VOBeANYhQ4/ZOw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfJGOWf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:22:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43310 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOWf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 10:22:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so14747309wrq.10;
        Mon, 07 Oct 2019 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i1iPOPDObUtdkhKgZivRBgqCEbtyqjoATFmtKPXDvrY=;
        b=nQCgj9ezS8bgXT68Ws3T6ySHVujFbONhMj58nzGhkVdDy8geNmzawspB2tJ8FbqJov
         0A3fiaZlET5vRM+HNzKvJBInDIygqZ8MkBX4gpTFJPIimpzxPhUzBaWCmgpLSH+/0GTC
         +YVUibZFJgCyv10iP5EvuDceyJftRPLgdP6CTASGO4W8aTEnMFInSs/1dcT75HiIkg31
         AhW6yxZkMH6F0FaGVJCyNtq7NN4KYDFGAdnrVfyn1hBABVJU26Ppq6xQpK8yAHubfpi9
         AtgzMWOviPkQFAQ/Flyi7n8p/FmWuN1VONOzrSbrYsXlFyscVQ2MvC/ho6TxYq3x3VkW
         F4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=i1iPOPDObUtdkhKgZivRBgqCEbtyqjoATFmtKPXDvrY=;
        b=JJKQR78HQc+ph2ex51UB2GCNZ2Moow/QiXEww+99cyw4Cb9dqNI91TOf+VKShnIRU3
         3/jjtD2TunsJmr4Bcr53SRsax60f4zsJbm5oC2fLQZ2fpMmnUT39TTLt7HOxnJWJOXSR
         iEwtgJY4lK2EZ1G1VUwp7byzJFInleqCQbAVI5DKOkRNfFGz4I4ir7pUGxHk8K17Or7M
         YhV0x4vJY3jmiT2uNDg9ewJH2PlxRgNr77as1GTMS4aDXfu003HgN3TyvKBr0Dn90SeL
         7l0POXSppT2U6/0V58Ba0rlZaxq/hcOrsj+cM/FwGmHAYoI0kG+rtgQ++koaVvQvbGV5
         HLnQ==
X-Gm-Message-State: APjAAAUgESCRrEqoZLKQxFMtjhMmW6QfLfcWrGahfPpT0HVbzrCxpbsK
        +NjenSog89trAVqf8z/hejQ=
X-Google-Smtp-Source: APXvYqyjEr3GWRQHz8CZrrnHfdqu9WODfMvbCifoqn9HMd1MdWfuVzqODZ1nM3Jt3yA2mqgQrqegZQ==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr22733932wru.284.1570458153175;
        Mon, 07 Oct 2019 07:22:33 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id a18sm24455478wrs.27.2019.10.07.07.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 07:22:32 -0700 (PDT)
Date:   Mon, 7 Oct 2019 16:22:30 +0200
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
Message-ID: <20191007142230.GA117630@gmail.com>
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


* Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> On 07-10-2019 16:00, Ingo Molnar wrote:
> > 
> > * Hans de Goede <hdegoede@redhat.com> wrote:
> > 
> > > The purgatory code now uses the shared lib/crypto/sha256.c sha256
> > > implementation. This needs memzero_explicit, implement this.
> > > 
> > > Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> > > Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
> > > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > > ---
> > > Changes in v2:
> > > - Add barrier_data() call after the memset, making the function really
> > >    explicit. Using barrier_data() works fine in the purgatory (build)
> > >    environment.
> > > ---
> > >   arch/x86/boot/compressed/string.c | 6 ++++++
> > >   1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
> > > index 81fc1eaa3229..654a7164a702 100644
> > > --- a/arch/x86/boot/compressed/string.c
> > > +++ b/arch/x86/boot/compressed/string.c
> > > @@ -50,6 +50,12 @@ void *memset(void *s, int c, size_t n)
> > >   	return s;
> > >   }
> > > +void memzero_explicit(void *s, size_t count)
> > > +{
> > > +	memset(s, 0, count);
> > > +	barrier_data(s);
> > > +}
> > 
> > So the barrier_data() is only there to keep LTO from optimizing out the
> > seemingly unused function?
> 
> I believe that Stephan Mueller (who suggested adding the barrier)
> was also worried about people using this as an example for other
> "explicit" functions which actually might get inlined.
> 
> This is not so much about protecting against LTO as it is against
> protecting against inlining, which in this case boils down to the
> same thing. Also this change makes the arch/x86/boot/compressed/string.c
> and lib/string.c versions identical which seems like a good thing to me
> (except for the code duplication part of it).
> 
> But I agree a comment would be good, how about:
> 
> void memzero_explicit(void *s, size_t count)
> {
> 	memset(s, 0, count);
> 	/* Avoid the memset getting optimized away if we ever get inlined */
> 	barrier_data(s);
> }

Well, the standard construct for preventing inlining would be 'noinline', 
right? Any reason that wouldn't work?

Thanks,

	Ingo
