Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D60C4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 08:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0336260FA0
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 08:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhHQIzK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 04:55:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234692AbhHQIzK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 04:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629190476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7dT68S5InJZhNBx9TRr7Eqppd3kXow67HBH2rTIYNw=;
        b=VFwZz4ABAO1IiJ4ZCFy/N3T9rl7aMA082XpLoC1J0bAnwsKpwDBAxZmYQ/dpMpDVaPw0qt
        Hp4s6FLev3+/1DGj8x3EPIIRIo/bW2WTVOF/N6NVx52Hye/+LZigDIBGqkmEacMkHGWkw2
        7bVd0P8IqMaSfh4oy3WHzlSWAZWiTLg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-0XwUYSVoPqqk73RCbRTEHQ-1; Tue, 17 Aug 2021 04:54:35 -0400
X-MC-Unique: 0XwUYSVoPqqk73RCbRTEHQ-1
Received: by mail-ed1-f70.google.com with SMTP id y22-20020a0564023596b02903bd9452ad5cso10237894edc.20
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 01:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q7dT68S5InJZhNBx9TRr7Eqppd3kXow67HBH2rTIYNw=;
        b=NH9pXkjRxkP6tSPWLs8v3kKKTmaePcrq7o3MjVZIhZp2ajVAUnkeLKumwgChWrm5Q2
         ytTfjLOvr49QVOV0AKM1Pd6RgTLkSlb3sZRZ+gKiARxT32g/kBBYI2ziB0ZOEdWCWkQB
         cHFOPj71cT2YjioQxIJA0KhytPOcCM3p/upmk+n0gbdMOS/zoLaOTZ6Yhy6yo7K4UP6V
         6y7wyJZRy/Qt30o4ygkNQDZ0XYkjmzQcyJ5QnD2tFp+sZvGNpHF/LRCQXLnciMx8R0lw
         5WwLCRTje7J7LdxhdjiFpwcFS1rgwrJZc+KN1277eCkLqEtpLM2fgKHxj6CCShJgiLHR
         f+nQ==
X-Gm-Message-State: AOAM531TiSo83pYh2Qpii8emNYCgm1GmSNSLQhmjI7Wh4Yk5xeZiavBD
        dWKW9EOFJZJM/UlKXNFIzFZDTaSRuan8ZPkI1LiEqfAmuEtVuLmkPACw+jRIxl4FJW0q9OeEhxp
        n+c21Z5qGKKSgMA7/nO927X5r
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr2755597ejc.409.1629190473899;
        Tue, 17 Aug 2021 01:54:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyaZzx8M+BoKRkmTA5CfaBnIow9YCTFU9Nx/CQxSA2xF72pC5gtASADBR6/oFNOwPsBO4xVA==
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr2755582ejc.409.1629190473745;
        Tue, 17 Aug 2021 01:54:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gh23sm484905ejb.27.2021.08.17.01.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 01:54:33 -0700 (PDT)
Subject: Re: [PATCH 0/3] clean up interface between KVM and psp
To:     Mingwei Zhang <mizhang@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
References: <20210816202441.4098523-1-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c66484d2-3524-d061-1e65-70dab0703cc3@redhat.com>
Date:   Tue, 17 Aug 2021 10:54:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816202441.4098523-1-mizhang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/08/21 22:24, Mingwei Zhang wrote:
> This patch set is trying to help make the interface between KVM and psp
> cleaner and simpler. In particular, the patches do the following
> improvements:
>   - avoid the requirement of psp data structures for some psp APIs.
>   - hide error handling within psp API, eg., using sev_decommission.
>   - hide the serialization requirement between DF_FLUSH and DEACTIVATE.
> 
> Mingwei Zhang (3):
>    KVM: SVM: move sev_decommission to psp driver
>    KVM: SVM: move sev_bind_asid to psp
>    KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp

No objections apart from the build failure on patch 1.  However, it's up 
to Tom whether they prefer this logic in KVM or the PSP driver.

Paolo

