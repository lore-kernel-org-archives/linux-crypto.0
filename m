Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE41C83005
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 16:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242157AbjFIQU2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 12:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbjFIQUX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 12:20:23 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A64D3A9E
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 09:20:14 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f6283d0d84so2497867e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2023 09:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686327612; x=1688919612;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usUa91lFTwm78ZcJqDITECIX6IQZqVVPZb/qreiSqx0=;
        b=ot7OR9FGvlcYcZD5e+cFOOoEF/WG2TryjkzKF7Y7nyRNcMhYN0MPV79TOo+C+dmXVR
         lvY31ZIut1OfKvPeIw1e4q0ma1wj7mAjXEFWSFt7BORxCehJmy+esFpQFKx8xRPe5RPa
         s4oATGJiDMXjJbGLGJxsRdaGE8LN2xwnUjHvb003d2AHf4bECiPk6MM3tIZC1gDgtqIo
         S8rUIbK2/DPKp88G24eIsWO5PYwE1Plm80C+bNKFkMHjM0r4iYDPMwaUxCptdVMLIqDT
         NdWzm185jBe4dLSFadFllbTJ1U8CNLjkqheJd96W2zGVd0ou9BREA0NHohLbIw/KL3G4
         vHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686327612; x=1688919612;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=usUa91lFTwm78ZcJqDITECIX6IQZqVVPZb/qreiSqx0=;
        b=flBDWEFv7ZE9/2MTdQ/1uxqu+0RapZsIcxfIpFPmj3MWc1mcd58PbVfyMaxOV/bzh5
         HNjK6MNQ+5xlyb91/Wj9KDu5Q9j76p+470LVBnkkU8mdXm0lCdS6gkmkKKJPpfq7G68M
         crXrUwdSrNihJGE16CP8oLllOkmAddWyJBjrf5Pdy2QiggFRoGoakNxApWLueOHaC/+/
         3vKW9Xzys18qufBk7uH16RD8n3jx8jMFZfHJ91R7vNwSkGmc2nSDkokVsbx602wMZRF2
         JE9YHTsynWB/O6+c6o9JOBgHkutPvWlANwxeZ2puOonTxNNtjJJT00069q1LyGpm4mOD
         L58Q==
X-Gm-Message-State: AC+VfDzVBvq6SYFdpsDLrdO6oo/v2HNEnv4L4PLRXNcsofOd5mLP8YJV
        EwxHAAdFi0llTCQCs6tT+qqUjQ==
X-Google-Smtp-Source: ACHHUZ5JUKhb5xLWhhwfP9hIde5UuYkLpVxnT1k61JKzExG1On60bR+Hs2VUE0a/47NYIgSj/pTTUg==
X-Received: by 2002:a19:5009:0:b0:4f3:b588:48d0 with SMTP id e9-20020a195009000000b004f3b58848d0mr1249482lfb.14.1686327612574;
        Fri, 09 Jun 2023 09:20:12 -0700 (PDT)
Received: from [192.168.1.101] (abyj190.neoplus.adsl.tpnet.pl. [83.9.29.190])
        by smtp.gmail.com with ESMTPSA id a1-20020a056512020100b004f138c4de81sm594947lfo.149.2023.06.09.09.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 09:20:12 -0700 (PDT)
Message-ID: <90b04e1b-8f3b-982e-bab2-36c09cc1d53d@linaro.org>
Date:   Fri, 9 Jun 2023 18:20:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net,
        will@kernel.org, boqun.feng@gmail.com, mark.rutland@arm.com,
        catalin.marinas@arm.com, dennis@kernel.org, tj@kernel.org,
        cl@linux.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, joro@8bytes.org, suravee.suthikulpanit@amd.com,
        robin.murphy@arm.com, dwmw2@infradead.org,
        baolu.lu@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
        roman.gushchin@linux.dev, 42.hyeyoo@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        iommu@lists.linux.dev, linux-arch@vger.kernel.org,
        linux-crypto@vger.kernel.org, sfr@canb.auug.org.au,
        mpe@ellerman.id.au, James.Bottomley@hansenpartnership.com,
        deller@gmx.de, linux-parisc@vger.kernel.org, llvm@lists.linux.dev
References: <20230531132323.587480729@infradead.org>
 <f320f021-88c4-c5c9-0781-c82d0b88f67d@linaro.org>
 <20230609161340.GA4019185@dev-arch.thelio-3990X>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: Re: [PATCH v2 5/12] percpu: Add {raw,this}_cpu_try_cmpxchg()
In-Reply-To: <20230609161340.GA4019185@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9.06.2023 18:13, Nathan Chancellor wrote:
> Hi Konrad,
> 
> On Fri, Jun 09, 2023 at 06:10:38PM +0200, Konrad Dybcio wrote:
>>
>>
>> On 31.05.2023 15:08, Peter Zijlstra wrote:
>>> Add the try_cmpxchg() form to the per-cpu ops.
>>>
>>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> ---
>> +CC Nathan, llvm list
>>
>> Hi all, this patch seems to break booting on Qualcomm ARM64 platforms
>> when compiled with clang (GCC works fine) for some reason..:
>>
>> next-20230605 - works
>> next-20230606 - doesn't
>>
>> grev -m 1 dc4e51fd9846 on next-20230606 - works again
>> b4 shazam <this_msgid> -P 1-4 - still works
>> b4 shazam <this_msgid> -P 5 - breaks
>>
>> Confirmed on at least Qualcomm QCM2290, SM8250.
>>
>> Checking the serial console, it hits a BUG_ON:
>>
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] kernel BUG at mm/vmalloc.c:1638!
>> [    0.000000] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
>> [    0.000000] Modules linked in:
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted [snip]
>> [    0.000000] Hardware name: Qualcomm Technologies, Inc. Robotics RB1 (DT)
>> [    0.000000] pstate: 000000c5 (nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> [    0.000000] pc : alloc_vmap_area+0xafc/0xb08
>> [    0.000000] lr : alloc_vmap_area+0x9e4/0xb08
>> [    0.000000] sp : ffffa50137f53c20
>> [    0.000000] x29: ffffa50137f53c60 x28: ffffa50137f30c18 x27: 0000000000000000
>> [    0.000000] x26: 0000000000007fff x25: ffff800080000000 x24: 000000000000cfff
>> [    0.000000] x23: ffffffffffff8000 x22: ffffa50137fef970 x21: fffffbfff0000000
>> [    0.000000] x20: ffff022982003208 x19: ffff0229820031f8 x18: ffffa50137f64f70
>> [    0.000000] x17: ffffa50137fef980 x16: ffffa501375e6d08 x15: 0000000000000001
>> [    0.000000] x14: ffffa5013831e1a0 x13: ffffa50137f30c18 x12: 0000000000402dc2
>> [    0.000000] x11: 0000000000000000 x10: ffff022982003018 x9 : ffffa5013831e188
>> [    0.000000] x8 : ffffcb55ff003228 x7 : 0000000000000000 x6 : 0000000000000048
>> [    0.000000] x5 : 0000000000000000 x4 : ffffa50137f53bd0 x3 : ffffa50136490000
>> [    0.000000] x2 : 0000000000000001 x1 : ffffa5013831e190 x0 : ffff022982003208
>> [    0.000000] Call trace:
>> [    0.000000]  alloc_vmap_area+0xafc/0xb08
>> [    0.000000]  __get_vm_area_node+0x108/0x1e8
>> [    0.000000]  __vmalloc_node_range+0x1fc/0x728
>> [    0.000000]  __vmalloc_node+0x5c/0x70
>> [    0.000000]  init_IRQ+0x90/0x11c
>> [    0.000000]  start_kernel+0x1ac/0x3bc
>> [    0.000000]  __primary_switched+0xc4/0xcc
>> [    0.000000] Code: f000e300 91062000 943bd9ba 17ffff8f (d4210000)
>> [    0.000000] ---[ end trace 0000000000000000 ]---
>> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
>>
>> Compiled with clang 15.0.7 from Arch repos, with
>> make ARCH=arm64 LLVM=1
> 
> Thanks a lot for testing with LLVM, submitting this report, and doing a
> bisect.
No, thank *you* for making it even possible ;)

I sent a patch to fix this a couple of days ago and Peter pushed
> it to -tip today, so it should be in the next -next release:
> 
> https://git.kernel.org/tip/093d9b240a1fa261ff8aeb7c7cc484dedacfda53
Amazing, I can boot the most recent next-20230609 with it again!

Konrad
> 
> Cheers,
> Nathan
