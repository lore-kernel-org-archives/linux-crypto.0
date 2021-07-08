Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B388C11F66
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jul 2021 08:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001D661CE6
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jul 2021 08:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhGHI4S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Jul 2021 04:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231248AbhGHI4R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Jul 2021 04:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625734415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gIPcM/AEt6CFgVLe5U5Gt1G0R6Bu5ZtRDH8h8xxqSLM=;
        b=RIaFFA4LZX3QJ8NIavAhOqer5nD+ieYm50ubrm1rR3GutMi4SbyBLf+FWQoH6IU3iyodcf
        HSsaC5DeO9brs9qEfxhEWn//138vhBsxFeckodDZerr1vEUvIPo3F+6SbxYMxLhTM+1Ujb
        /YfMye7saH9yD0Pd3vhyDXmZQj2FvYY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-GaOvcsxtM1WTcpdPeKT4Vg-1; Thu, 08 Jul 2021 04:53:34 -0400
X-MC-Unique: GaOvcsxtM1WTcpdPeKT4Vg-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so2942048edw.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jul 2021 01:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gIPcM/AEt6CFgVLe5U5Gt1G0R6Bu5ZtRDH8h8xxqSLM=;
        b=bAf//NgPd07mB42miol30yCw8IPuLY+LrhSTq/RttluMOIEDSDFaj/hmm+NpzssdCg
         ubNXMCRzNGeFqg17l40BRflm5fQIPAbJ8Hi3ze9YnUv+odEGgtlJ/7DPktIqjQn1g7Pw
         n0MLxpx+9I9t8Wfexd8Rz5WI84aDOKMr3dKqfoBhnis1JaeGCHFZVOfCbY57Yprt8JdI
         RL04TCf02qyW3dx6ZoFSX2PDujn0InGDTeXF5RJQqvi/EJxgLwdWWSykTEVE6VSmPuX8
         dcvbNDWCFp/yIMqoPLesZwlwXcAq8HeoQo9v+kKN/DQf6B5rbZmm/gcFunHNpnXCrrpk
         4Wgg==
X-Gm-Message-State: AOAM532VuhygbQQKqVYvfEQtflaq1kx1Q47YHaN0Xhbo+rQi4EsMCJIT
        MjlNeJysO/M3op0tRWhfAXqFOI1UXS1P7xPPkf4dujlibfTser9vqtQ4BCyXzZzyvlS9dQ7plw+
        x8nwtVF2HTyKJ1fbcHbkXyWjw
X-Received: by 2002:a05:6402:1014:: with SMTP id c20mr36763730edu.380.1625734413610;
        Thu, 08 Jul 2021 01:53:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxx/+0c8nIU7pwYBojXCHzTNcV8ZCk6Cqibqq/t9wTBQKxs+CGQcGK3UP/Yf8+cmhDD/LkdhQ==
X-Received: by 2002:a05:6402:1014:: with SMTP id c20mr36763691edu.380.1625734413381;
        Thu, 08 Jul 2021 01:53:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u17sm853904edt.67.2021.07.08.01.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 01:53:32 -0700 (PDT)
Subject: Re: [PATCH Part1 RFC v4 04/36] x86/mm: Add sev_feature_enabled()
 helper
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
References: <20210707181506.30489-1-brijesh.singh@amd.com>
 <20210707181506.30489-5-brijesh.singh@amd.com> <YOa8TlaZM42+sz+E@work-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6c68c70-ac6e-07f2-c24e-f1c892080eab@redhat.com>
Date:   Thu, 8 Jul 2021 10:53:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOa8TlaZM42+sz+E@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/07/21 10:50, Dr. David Alan Gilbert wrote:
>> +enum sev_feature_type {
>> +	SEV,
>> +	SEV_ES,
>> +	SEV_SNP
>> +};
> Is this ....
> 
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index a7c413432b33..37589da0282e 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -481,8 +481,10 @@
>>   #define MSR_AMD64_SEV			0xc0010131
>>   #define MSR_AMD64_SEV_ENABLED_BIT	0
>>   #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
>> +#define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
> Just the same as this ?
> 

No, it's just a coincidence.

Paolo

