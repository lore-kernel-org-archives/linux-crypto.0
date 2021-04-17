Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E03C433B4
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9524611EF
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhDQMrx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 08:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236395AbhDQMru (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 08:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQtldtf06vCuCMFfu9MNiH7bfVCIHZm3b7M33WAhmmY=;
        b=TTsCqPp0ctX/R1bdONBmwnwpLlV4yYdlGLpTHKG4xzYU12wEDo+k/Mfr+uezXQ6wEaqBcm
        PiHwJ/26GL0G/kEnwygHK7wZ7zEVIFTHCh/jcqcRmA4KzAYqmsxS/sZb4nbrncItAaCZ/m
        5UU4yLzD2cgHvCtDaDc9ajAoODh0HD8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-BLXgBXLTPqWP8CFnenTjJw-1; Sat, 17 Apr 2021 08:47:20 -0400
X-MC-Unique: BLXgBXLTPqWP8CFnenTjJw-1
Received: by mail-ed1-f71.google.com with SMTP id y10-20020a50f1ca0000b0290382d654f75eso8592025edl.1
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 05:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uQtldtf06vCuCMFfu9MNiH7bfVCIHZm3b7M33WAhmmY=;
        b=i2L69d0h6IjUjkq8EFL3RrhwvsZ/FkS7Pga+zd+th2kph2HcIbLIpfemS3nh75eBnU
         ivPF65SkVT+QzAXHSNkSHHwko6S3phahDaLdWfVQMclJ16TfTWS3dYlhJNYVWI9vAy3T
         nblSpLcLqLqKeorD0Wpx1r5SOoEhIEKlCFWdhtOhHgOMzsl4aDZ6dEpXo1fQ0/1SAGI0
         DBiby10VlHjX1HWFMJMfWsSSx8EjmQbyM7FNkVLcNbvEW+iC2DGDgdJaFxLT48Ron/ZS
         1XddoAe7yA5ddgB+ZWlaxsKoZVVSEyr5WQ7zdn42G8Igo4jJJpqUdq/cecnWnxJl7JQt
         KKNw==
X-Gm-Message-State: AOAM530K2SSH0V0Tk9HZMCzLfTsoxIrEHuAT512YSC7J/CrYaEppJIio
        35LmRuDGe4ZWEbz3vsNYA4qHe7yOI5ll6m1gpro4zuAbBpTZQTBAbnV2zZxlTgb3x5xvLZlwEqH
        oGZH2/ph1hQGXG9Iwv2m2dObn
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr15723025edd.258.1618663638885;
        Sat, 17 Apr 2021 05:47:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXta7hhelgA+r2YxcZQcgzga5nb49Ilr6PXHoMp2MOVXvEcQCEpv0JEj0sDeDgNSu2LdGdow==
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr15723004edd.258.1618663638740;
        Sat, 17 Apr 2021 05:47:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bh14sm6293284ejb.104.2021.04.17.05.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:47:18 -0700 (PDT)
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1932d295-5e16-ebb6-b25a-5957f5d7d3ea@redhat.com>
Date:   Sat, 17 Apr 2021 14:47:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/04/21 00:49, Sean Christopherson wrote:
> This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
> command buffers by copying _all_ incoming data pointers to an internal
> buffer before sending the command to the PSP.  The SEV driver and KVM are
> then converted to use the stack for all command buffers.
> 
> Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
> near enough about the PSP to give it the right input.
> 
> v2:
>    - Rebase to kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
>      sharing SEV context").
>    - Unconditionally copy @data to the internal buffer. [Christophe, Brijesh]
>    - Allocate a full page for the buffer. [Brijesh]
>    - Drop one set of the "!"s. [Christophe]
>    - Use virt_addr_valid() instead of is_vmalloc_addr() for the temporary
>      patch (definitely feel free to drop the patch if it's not worth
>      backporting). [Christophe]
>    - s/intput/input/. [Tom]
>    - Add a patch to free "sev" if init fails.  This is not strictly
>      necessary (I think; I suck horribly when it comes to the driver
>      framework).   But it felt wrong to not free cmd_buf on failure, and
>      even more wrong to free cmd_buf but not sev.
> 
> v1:
>    - https://lkml.kernel.org/r/20210402233702.3291792-1-seanjc@google.com
> 
> Sean Christopherson (8):
>    crypto: ccp: Free SEV device if SEV init fails
>    crypto: ccp: Detect and reject "invalid" addresses destined for PSP
>    crypto: ccp: Reject SEV commands with mismatching command buffer
>    crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
>    crypto: ccp: Use the stack for small SEV command buffers
>    crypto: ccp: Use the stack and common buffer for status commands
>    crypto: ccp: Use the stack and common buffer for INIT command
>    KVM: SVM: Allocate SEV command structures on local stack
> 
>   arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
>   drivers/crypto/ccp/sev-dev.c | 197 +++++++++++++-------------
>   drivers/crypto/ccp/sev-dev.h |   4 +-
>   3 files changed, 196 insertions(+), 267 deletions(-)
> 

Queued, thanks.

Paolo

