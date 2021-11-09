Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4095CC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 17:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28B31611BF
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 17:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241037AbhKIRdq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 12:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240950AbhKIRdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 12:33:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37862C061766
        for <linux-crypto@vger.kernel.org>; Tue,  9 Nov 2021 09:31:00 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id r5so22225220pls.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Nov 2021 09:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPI4ZCQRURPZIsOC64jQpnT/5OeIjuClEs1QAMLHFZg=;
        b=T23jWnsziCyIkJpGQztI0joS0PK005SodS9NRFKNgdNn81xfJyLSr7pDKBOlNe0PGj
         zyXUrG7rZpU51xOkn5y6AdEPhjII221F9j/cF9zdUsvv3AFnYyVQxwoPIbzWrI86QxfA
         +rXSapOAoQx+2qYYIrYRJgAtsCt/mi1N3Vau3R43AXfbOMsJbcI8pKjnJxUswiv20YIc
         w03lPgJ4rCCmV5CN1QqsoRL6k2FBEr4Y8fuaC3rFEtsXV9YLSv6qH57uu4dxOT31Fw2a
         wnsYVeu8tZ5kUCwY1Rr2z3ZF+sILf8syKaZLb0L+YQLo9fnodNrqb/E1GSBBYHRj9GLR
         HMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPI4ZCQRURPZIsOC64jQpnT/5OeIjuClEs1QAMLHFZg=;
        b=VJvkAozxBnkkXYCVCVvXZ8xzt63wpGKWMPlI1OYyDGt2rboJD8K8gnH3Qtj1wZ8VnA
         LEnGFOJdlVQoBnbXW0VoSbT5WcLIrnJ2PF96yygP1/5m3zw8HICg+81sXPlZKVO51kMd
         KXyq8dW/933CSedH84FIEaDi91lb7QZOv0Ertv3+xAEOacIROA3rye3ML7oAVPqkO9jL
         RXw/3jRTUI0bwpF9NfBhT6UhfBMv7C6SRT5LQ/hwCvn1YqQPBc+EHoa8n9HFUm/hiWHA
         0AbdC7FoVY1lLSDUfK1Y31Aoh9a+zqo7RTdmJc05tpSIfFhV3ibVyPFwOKzXJvAr8nzI
         v+rA==
X-Gm-Message-State: AOAM531Fj7PDeTMJjcPFeoCukDcwgZnRTL9OkCrnL5b5DXvp7aCJfPCT
        DgGWk5HOiQqoaOI0dLbwrdKcZQ==
X-Google-Smtp-Source: ABdhPJwqMoASNle9Qc0G7/vEs87ZCYi+J1spGyo8LVcqUR3JMIYunoT4kOj378d2RQ3ZlKU0sPhPHQ==
X-Received: by 2002:a17:902:d50d:b0:141:ea03:5193 with SMTP id b13-20020a170902d50d00b00141ea035193mr8451486plg.89.1636479059556;
        Tue, 09 Nov 2021 09:30:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z71sm20371603pfc.19.2021.11.09.09.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 09:30:58 -0800 (PST)
Date:   Tue, 9 Nov 2021 17:30:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Thomas.Lendacky@amd.com, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/4] crypto: ccp - Move SEV_INIT retry for corrupted
 data
Message-ID: <YYqwT1fGxBQQmFvY@google.com>
References: <20211102142331.3753798-1-pgonda@google.com>
 <20211102142331.3753798-3-pgonda@google.com>
 <YYqicq5YnNuwTS+B@google.com>
 <CAMkAt6q37BmPcA2Le98NOFQoz9nAwiDQqrALLD-Ogf5RytSS4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6q37BmPcA2Le98NOFQoz9nAwiDQqrALLD-Ogf5RytSS4g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 09, 2021, Peter Gonda wrote:
> On Tue, Nov 9, 2021 at 9:31 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Nov 02, 2021, Peter Gonda wrote:
> > > This change moves the data corrupted retry of SEV_INIT into the
> >
> > Use imperative mood.
> 
> Will do for next revision
> 
> >
> > > __sev_platform_init_locked() function. This is for upcoming INIT_EX
> > > support as well as helping direct callers of
> > > __sev_platform_init_locked() which currently do not support the
> > > retry.
> > >
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > Reviewed-by: Marc Orr <marcorr@google.com>
> > > Acked-by: David Rientjes <rientjes@google.com>
> > > Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > > Cc: Marc Orr <marcorr@google.com>
> > > Cc: Joerg Roedel <jroedel@suse.de>
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: David Rientjes <rientjes@google.com>
> > > Cc: John Allen <john.allen@amd.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: linux-crypto@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++------------
> > >  1 file changed, 12 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > > index ec89a82ba267..e4bc833949a0 100644
> > > --- a/drivers/crypto/ccp/sev-dev.c
> > > +++ b/drivers/crypto/ccp/sev-dev.c
> > > @@ -267,6 +267,18 @@ static int __sev_platform_init_locked(int *error)
> > >       }
> > >
> > >       rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> > > +     if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
> >
> > There are no guarantees that @error is non-NULL as this is reachable via an
> > exported function, sev_platform_init().  Which ties in with my complaints in the
> > previous patch that the API is a bit of a mess.
> 
> That seems like a bug from the caller right? Is it typical that we
> sanity-check the caller in these instances?

sev-dev.c needs to make up its mind.  __sev_do_cmd_locked() very clearly allows
a NULL @error, ergo all of the wrappers for sev_do_cmd() support a NULL @error.

> For example the same comment could be made here:
> https://elixir.bootlin.com/linux/latest/source/drivers/crypto/ccp/sev-dev.c#L336
> 
> ```
> static int sev_get_platform_state(int *state, int *error)
> {
> struct sev_user_data_status data;
> int rc;
> 
> rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, error);
> if (rc)
> return rc;
> 
> *state = data.state;  <--- State could be null.

No, because this is an internal helper and all call sites can be easily audited.

> return rc;
> }
> ```
> 
> Example outside of this driver:
> https://elixir.bootlin.com/linux/v5.15.1/source/arch/x86/kvm/x86.c#L468
> 
> ```
> int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> {
> enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
> enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);  <---
> msr_info could be null here
> u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
> (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
> 
> if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
> return 1;
> if (!msr_info->host_initiated) {
> if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
> return 1;
> if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
> return 1;
> }
> 
> kvm_lapic_set_base(vcpu, msr_info->data);
> kvm_recalculate_apic_map(vcpu->kvm);
> return 0;
> }
> EXPORT_SYMBOL_GPL(kvm_set_apic_base);
> ```

The difference is that KVM has consistent expecations for a set of functions,
whereas sev-dev.c does not.   Yes, KVM will explode if @msr_info is NULL, and
there are undoubtedly a bajillion flows in the kernel that would do the same,
but unlike the functions declared in include/linux/psp-sev.h() the requirements
on the caller are fairly obvious.  E.g. why should this be illegal from a caller's
perspective?

	sev_platform_init(NULL);
	sev_platform_status(&status, NULL);
