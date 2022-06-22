Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC8DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 16:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376418AbiFVQCP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376425AbiFVQCD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jun 2022 12:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7550393EF
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 09:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655913694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKaYCw8Ch4uyTRBCSszYHcyFXJcUvZ5fY3k0dp6Kfho=;
        b=VyJAoYbFdU/P+YO69thzb/ibsygujnHc44CTVxhrUUAdMlubb3jdJnCKss67iVs7cpybvz
        9pCFCdeMRgoOLgU1Eys5txq9ImGqRESSSZnuMFbhviIW8zxTX0Ldq9Tdu5QqkqlnBPz+Ql
        FJZW0Vuu6Nmy5bSO8u3zNMriYKOSjoQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-nyOTX9ymM6CW-GDTYXbcZg-1; Wed, 22 Jun 2022 12:01:29 -0400
X-MC-Unique: nyOTX9ymM6CW-GDTYXbcZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F6523C138A4;
        Wed, 22 Jun 2022 16:01:27 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E9271121315;
        Wed, 22 Jun 2022 16:01:22 +0000 (UTC)
Message-ID: <6fdc7beefaa7265e8397e6d6b1951c6f688d3747.camel@redhat.com>
Subject: Re: [PATCH 3/4] x86/cpuid: move filter_cpuid_features to
 cpuid-deps.c
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jiri Olsa <jolsa@kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jane Malalane <jane.malalane@citrix.com>,
        Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 22 Jun 2022 19:01:21 +0300
In-Reply-To: <6f83722d-d402-ca68-7d3e-77dca14a794b@intel.com>
References: <20220622144820.751402-1-mlevitsk@redhat.com>
         <20220622144820.751402-4-mlevitsk@redhat.com>
         <6f83722d-d402-ca68-7d3e-77dca14a794b@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2022-06-22 at 08:07 -0700, Dave Hansen wrote:
> On 6/22/22 07:48, Maxim Levitsky wrote:
> > No functional change intended.
> 
> It would be really nice to at least write a "why" sentence.  You wrote
> the "what" (move code), but I have no idea why you are moving it.

This is a good point, I will add a justification in V2.

> 
> >  arch/x86/kernel/cpu/common.c      | 46 -----------------------------
> >  arch/x86/kernel/cpu/cpuid-deps.c  | 48 +++++++++++++++++++++++++++++++
> 
> That looks a wee bit odd for a code move.  Where did the 2 lines go?
> 
> > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > index ea34cc31b0474f..3eb5fe0d654e63 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -147,6 +147,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
> >  
> >  extern void setup_clear_cpu_cap(unsigned int bit);
> >  extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
> > +extern void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn);
> >  
> >  #define setup_force_cpu_cap(bit) do { \
> >  	set_cpu_cap(&boot_cpu_data, bit);	\
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index 4730b0a58f24a5..4cc79971d2d847 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -620,52 +620,6 @@ __noendbr void cet_disable(void)
> >  		wrmsrl(MSR_IA32_S_CET, 0);
> >  }
> >  
> > -/*
> ...
> > -}
> >  
> >  /*
> >   * Naming convention should be: <Name> [(<Codename>)]
> 
> One, by leaving extra whitespace.
> 
> > diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> > index d6777d07ba3302..bcb091d02a754b 100644
> > --- a/arch/x86/kernel/cpu/cpuid-deps.c
> > +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> > @@ -131,3 +131,51 @@ void setup_clear_cpu_cap(unsigned int feature)
> >  {
> >  	clear_cpu_cap(&boot_cpu_data, feature);
> >  }
> > +
> > +
> > +/*
> 
> Two, by adding extra whitespace.
> 

I will fix this, I didn't notice that I added new lines.
Next time I move code around, I'll check that the number count matches.

Thanks!
Best regards,
	Maxim Levitsky

