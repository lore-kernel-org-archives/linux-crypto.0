Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EFCECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 13:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9769320867
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 13:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvsMreOj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfJGNV1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:21:27 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38758 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbfJGNVZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 09:21:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id j31so19070040qta.5;
        Mon, 07 Oct 2019 06:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S8wlw07g8wWEy+g1Qnw0IAVWlpAPz3AD6YBd3AOwHGg=;
        b=MvsMreOjWowkMYxirbTI/Whcd25VmB1K1uF9cL5wYMi3Wevatl6/A+mDAGe1u7ZSCX
         t+5eBC+fQ7aJYJvZ++u8jWMkTTAkw1tiEUzphMI+hpskX7n1K4EzDHEwZ4qhzOkFHy1Q
         fz5yHAfu4Lae8EVQaCytiIK0wlVfL9UCejMTTXp3657Ch40iSfB/81TtAbEIXlmEqn0L
         Ap2VWjiE6dcqNBjH/BVpJ7+CbmIcw7NMQuB2KqoACq1OH9oAYDi3IFsGfcf6fvpT58O8
         wprb71hRLwPFtcd+WspK2eHb3wgfvEzkjUXonqJX6/C/AG12xW1U9UjZtkpS64y75khb
         VuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=S8wlw07g8wWEy+g1Qnw0IAVWlpAPz3AD6YBd3AOwHGg=;
        b=mJ3UHvCmrBLaez25d5wTf+w63FuRJLcJdCIqFssunm7AUof0xd053JmNDDyfC2kygl
         sv4yZDnLjugWjmOh8jb1ysvOpwcbw/j5bCaNsxE4n16EiK/U5BiTuAGtZW6CDcpoYpKH
         RFbPL7n9hK2LnGHW3QhWC4qt0bNT3Qhl91DFMxxJmZ+AQbGvhJmeeIOoi2QhAWysLi/Y
         FbnasYkiYiyah70xGzDr7cDPyVOYFdmsN2GXps8s4x1v/Hyt4NMOx1hZfc/UTOlRpSe9
         yAD7rBg2oqnJxQ2I8reQ3+UuCO9dSSDyXIN1T8r2p+aUx+DXQv9/e0JSfRakXc3IbZJR
         FxJA==
X-Gm-Message-State: APjAAAXRUvTxF/D1PqWuI7g0GWmk03kmNcgsCmjThTS00+irFEayRZb1
        Xy/Z+Aayu22FU90lis8ySDQ=
X-Google-Smtp-Source: APXvYqxnqeEPThONvJ7tZRDJLlZxNbmzMIKgaeimkWutUPDnjp4sG67pr8n4AnPXN/H595js2GBhPA==
X-Received: by 2002:ad4:4712:: with SMTP id k18mr26455788qvz.97.1570454484390;
        Mon, 07 Oct 2019 06:21:24 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id o52sm10073249qtf.56.2019.10.07.06.21.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 06:21:24 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Mon, 7 Oct 2019 09:21:22 -0400
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007132122.GC269842@rani.riverdale.lan>
References: <20191007085501.23202-1-hdegoede@redhat.com>
 <65461301.CAtk0GNLiE@tauon.chronox.de>
 <284b70dd-5575-fee4-109f-aa99fb73a434@redhat.com>
 <12200313.ic8YZTgDOU@tauon.chronox.de>
 <1da4c70f-c303-5469-6978-77a03f4cf792@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1da4c70f-c303-5469-6978-77a03f4cf792@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 03:00:51PM +0200, Hans de Goede wrote:
> Hi Stephan,
> 
> On 07-10-2019 11:34, Stephan Mueller wrote:
> > Am Montag, 7. Oktober 2019, 11:06:04 CEST schrieb Hans de Goede:
> > 
> > Hi Hans,
> > 
> >> Hi Stephan,
> >>
> >> On 07-10-2019 10:59, Stephan Mueller wrote:
> >>> Am Montag, 7. Oktober 2019, 10:55:01 CEST schrieb Hans de Goede:
> >>>
> >>> Hi Hans,
> >>>
> >>>> The purgatory code now uses the shared lib/crypto/sha256.c sha256
> >>>> implementation. This needs memzero_explicit, implement this.
> >>>>
> >>>> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> >>>> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get
> >>>> input, memzero_explicit") Signed-off-by: Hans de Goede
> >>>> <hdegoede@redhat.com>
> >>>> ---
> >>>>
> >>>>    arch/x86/boot/compressed/string.c | 5 +++++
> >>>>    1 file changed, 5 insertions(+)
> >>>>
> >>>> diff --git a/arch/x86/boot/compressed/string.c
> >>>> b/arch/x86/boot/compressed/string.c index 81fc1eaa3229..511332e279fe
> >>>> 100644
> >>>> --- a/arch/x86/boot/compressed/string.c
> >>>> +++ b/arch/x86/boot/compressed/string.c
> >>>> @@ -50,6 +50,11 @@ void *memset(void *s, int c, size_t n)
> >>>>
> >>>>    	return s;
> >>>>    
> >>>>    }
> >>>>
> >>>> +void memzero_explicit(void *s, size_t count)
> >>>> +{
> >>>> +	memset(s, 0, count);
> >>>
> >>> May I ask how it is guaranteed that this memset is not optimized out by
> >>> the
> >>> compiler, e.g. for stack variables?
> >>
> >> The function and the caller live in different compile units, so unless
> >> LTO is used this cannot happen.
> > 
> > Agreed in this case.
> > 
> > I would just be worried that this memzero_explicit implementation is assumed
> > to be protected against optimization when used elsewhere since other
> > implementations of memzero_explicit are provided with the goal to be protected
> > against optimizations.
> >>
> >> Also note that the previous purgatory private (vs shared) sha256
> >> implementation had:
> >>
> >>           /* Zeroize sensitive information. */
> >>           memset(sctx, 0, sizeof(*sctx));
> >>
> >> In the place where the new shared 256 code uses memzero_explicit() and the
> >> new shared sha256 code is the only user of the
> >> arch/x86/boot/compressed/string.c memzero_explicit() implementation.
> >>
> >> With that all said I'm open to suggestions for improving this.
> > 
> > What speaks against the common memzero_explicit implementation?
> 
> Nothing, but the purgatory is a standalone binary which runs between
> 2 kernels when doing kexec so it cannot use the function from lib/string.c
> since it is not linked against the lib/string.o object.
> 
> > If you cannot
> > use it, what about adding a barrier in the memzero_explicit implementation? Or
> > what about adding some compiler magic as attached to this email?
> 
> Since the purgatory code is running in a somewhat limited environment,
> with not all standard headers / macros available I was afraid that the
> barrier_data() from the lib/string.c implementation would not work, so
> I left it out. In hindsight I should have really given it a try first as
> it seems to compile fine and there are no missing symbols in
> arch/x86/purgatory/purgatory.ro when using it.
> 
> So I will send out a new version with the barrier_data() added making
> the arch/x86/boot/compressed/string.c implementation identical to the
> lib/string.c one.
> 
> Regards,
> 
> Hans
> 

I think we also need a fix for at least s390 right? That also has sha256
verification and would presumably have the same issue with undefined
memzero_explicit? powerpc does not seem to do sha256 verification
afaict.
