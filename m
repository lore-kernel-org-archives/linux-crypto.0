Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D78C433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 17:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916426120E
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 17:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbhDGRFX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 13:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354514AbhDGRFW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 13:05:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074D7C061762
        for <linux-crypto@vger.kernel.org>; Wed,  7 Apr 2021 10:05:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so1644494pjh.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Apr 2021 10:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P3H/p87DD2uK+rnl2OC8aI1MMRvWj6Mn4ar7xqh2J64=;
        b=FVIG2VfvYNZJlJWCBzXHJ9mCEm5lUC2C6jBpQvNzNuHo9Lt+32ir9WJlEuPRngsfO0
         pZ3uJyrQMlBblR2KYELiRyeuewzlurI19jTOj6NcW9u0elA5nTXneSDPwFyN+hwnF6Wy
         mh58YMlhbNqbdYfDzu+FdbnMp8LB7gok6QBFxswx6Wg1ikqL1V0BmUkO8zVdIyPHSZsM
         EcLWZf3k5mbZRIfVV2NURXEH78uNCpQCaSGkImFMX06pIX/vqz8mBDZevrTo60mOnc/g
         LuyTMXETh6gXR9hw+E+CnSOEu/iFGTcBzHzA2Z9xdi4jHDbDgzbWq9cArMWBv+IupTyS
         wH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P3H/p87DD2uK+rnl2OC8aI1MMRvWj6Mn4ar7xqh2J64=;
        b=Q/Mkquc4MaL01v2WzbacxwmHHTFplTjLlAU/spI/bFIqthOnBj1Oiu9XgIrsCgokt3
         hjskLXdHIvOTdh3uElbPRkDohPZhc5rNmGfUGNeibIEnlaHTqXTj5aD74hZdKIhqRbi7
         SePli4DFqqYNUBNblHV7kD1NtDbmxwH2Jrx1BkIxOuu2Ym6sg0kmtt9F24lUkt58PAU3
         Gq2TeztKksaZBS48ag2mqq4C803AlSydkdDiysYuiWQaXUVWPMVNZ2TMRWREK2e0mVHc
         asB7pzJdp7HsK1hDgs1Q0TJL0vj3B/j9VjbCDR2g4qt90hkD/GGtMhRGmrKiSuodGMCu
         kwOw==
X-Gm-Message-State: AOAM533Q+MteTp22rbW4bsBW8XvLufhQf+CMw4bqwIYomtzRQlplVs1Q
        m2EfqLkGDyVPGWpmtq9/0iJAiA==
X-Google-Smtp-Source: ABdhPJyH0h4KWRemqXlRFCFYBKywn2zfSXqXN93gXAfvQLeZz90fd4Kf+/C/ya5xYUn7nbiMaSO10g==
X-Received: by 2002:a17:90b:1992:: with SMTP id mv18mr4144192pjb.83.1617815111355;
        Wed, 07 Apr 2021 10:05:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b10sm22344008pgm.76.2021.04.07.10.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 10:05:10 -0700 (PDT)
Date:   Wed, 7 Apr 2021 17:05:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@suse.de>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] KVM: SVM: Allocate SEV command structures on
 local stack
Message-ID: <YG3mQ+U6ZnoWIZ9a@google.com>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-9-seanjc@google.com>
 <9df3b755-d71a-bfdf-8bee-f2cd2883ea2f@csgroup.eu>
 <20210407102440.GA25732@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407102440.GA25732@zn.tnic>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 07, 2021, Borislav Petkov wrote:
> First of all, I'd strongly suggest you trim your emails when you reply -
> that would be much appreciated.
> 
> On Wed, Apr 07, 2021 at 07:24:54AM +0200, Christophe Leroy wrote:
> > > @@ -258,7 +240,7 @@ static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
> > >   static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >   {
> > >   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > -	struct sev_data_launch_start *start;
> > > +	struct sev_data_launch_start start;
> > 
> > struct sev_data_launch_start start = {0, 0, 0, 0, 0, 0, 0};
> 
> I don't know how this is any better than using memset...
> 
> Also, you can do
> 
> 	... start = { };
> 
> which is certainly the only other alternative to memset, AFAIK.
> 
> But whatever you do, you need to look at the resulting asm the compiler
> generates. So let's do that:

I'm ok with Boris' version, I'm not a fan of having to count zeros.  I used
memset() to defer initialization until after the various sanity checks, and
out of habit.
