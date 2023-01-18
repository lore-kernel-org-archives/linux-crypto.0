Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0B1C46467
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Jan 2023 21:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjARVd7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjARVd6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2023 16:33:58 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8673261D47
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 13:33:57 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g23so360766plq.12
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 13:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PV2LLjcXwxGB4uAP0cXtlo+9pb6/lAlmJvlfTFPpKO0=;
        b=jClde1svtNxzd4S5YpqLYxhB5hDETtoHp4f98weH3OKDzKvrFMdPXPDW7GNYj7KzP6
         IAOODq4osxaWdKQIztfYn6p2PEETi9Y1foDc5Ho2m99IAPDykVHkiV9eYhri8cSRdTEv
         DTK03VrwpCnS5yMQMMdo1V+JcDVvnecZFy89o5zutgd2dl7qtn61gSYxGYCee3FLvM3S
         fjQUJoP0iuKFTPBXimR1s1PnYwovsVdbLYRXH7Ajxn3nqSIkvOEVj1vb5nTCH3f9l6kn
         v8htsXGKXcijvhSlD1M+mnlUEbO/WCI2btqI+QRP4Li157TCJGwuDw38TzYaJwNng0F5
         6Wog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PV2LLjcXwxGB4uAP0cXtlo+9pb6/lAlmJvlfTFPpKO0=;
        b=1/qSv0wPcTIO4qhd7rIOTevrpOHIzUWHVQQZD5SYa5+DGigIWKMbbFR2MvJ0Hnlu2P
         YJb4dSWVdI0NS9bNr6uVTzzQ1+b9X97br4B7xRwfHKwJYHP27yUiBHkYB2jaz8QJT1d8
         jIYMRT/ClzTvDQ20fLFuyC5ZP+xJp1xPCmMfqG92241kW6Sm1tw20UrXU9+46lyp8uwp
         izMko2JKLXTpzL8C7b1auWJDj+nARlZR4mam7eQT68KZytTzf/bIoIXZLT5E7BPni7o+
         PrJs2AOdJD6Qrm6XR/9aZpPisHuiMNEgMKtz3cUFfJF7ppwqgPAEr50ziXgUPYYLw0H0
         agLg==
X-Gm-Message-State: AFqh2kpJA1lu1jIutd5/AR+bJuaIP0h5QGq5SM8C5POp8akex3+Uu+Sj
        gnGRnCmf7Mvder/lYUfts96g7A==
X-Google-Smtp-Source: AMrXdXtmY68VQO8PeJqA2jW7tlmH+eNNquVAK7kXYpjOhcdoxIkG+SuufwVgmp4Q8YuAFk9vvmEUBQ==
X-Received: by 2002:a17:90a:fd12:b0:226:5758:a57f with SMTP id cv18-20020a17090afd1200b002265758a57fmr3340532pjb.2.1674077636822;
        Wed, 18 Jan 2023 13:33:56 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 8-20020a631448000000b004b25a51d6f4sm16484941pgu.36.2023.01.18.13.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:33:56 -0800 (PST)
Date:   Wed, 18 Jan 2023 21:33:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "harald@profian.com" <harald@profian.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "nikunj@amd.com" <nikunj@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <Y8hlwId/NlniGTe3@google.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <4e75a1a0b67e7b3ccaf6b140b08a5f2080aedbdb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e75a1a0b67e7b3ccaf6b140b08a5f2080aedbdb.camel@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 18, 2023, Huang, Kai wrote:
> On Wed, 2022-12-14 at 13:39 -0600, Michael Roth wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 91352d692845..7f3e4d91c0c6 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4694,6 +4694,14 @@ static int svm_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >  
> > +static int svm_private_mem_enabled(struct kvm *kvm)
> > +{
> > +	if (sev_guest(kvm))
> > +		return kvm->arch.upm_mode ? 1 : 0;
> > +
> > +	return IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING) ? 1 : 0;
> > +}
> > +
> 
> Is this new callback really needed?

Probably not.  For anything in this series that gets within spitting distance of
CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, my recommendation is to make a mental note
but otherwise ignore things like this for now.  I suspect it will be much, much
more efficient to sort all of this out when I smush UPM+SNP+TDX together in a few
weeks.
