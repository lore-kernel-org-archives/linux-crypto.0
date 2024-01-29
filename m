Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F78B56444
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jan 2024 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706522296; cv=none; b=fFPWQfd5Xnq8NNH4aBPPR0AhQozID72I4CHJioSGeGXr6n+nXSWBBpHuzapBZs2HEs6mqaJf9XUfAo6SaC0LyHG9wiG09gZpJnFK2Nt4Gm5I1tyHx42P3gIsj2JJQFkF+ULXVMfGIO2oSUc6QnxHmFcb0ZR4jrHvm1/l8WUy2Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706522296; c=relaxed/simple;
	bh=0nRlWJibNBWrP/2+ulbYIt6Yw5St4sDPPbMGqESeuNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aERLLInfLypFKOacq3qz3vkbFW8sWPI5dwcLcoY+jVdy8uFA330QQT2QmFX4WHHTs5DJKmS4WWCbGtYGZ6FsdUFJKofqQS9iVPgJaIj3dzGJv/SrLppZghS4QuuMzB9HLAppu4wB0EPk8HmIgYocv0iJJjA5r7kTlfDSdCsDNUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RNlgWAFy; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RNlgWAFy"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso1792317a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jan 2024 01:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1706522293; x=1707127093; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/yj2cF4QFPTINMOJ5Odb3ijjKjStQFfbkPQ+E8TM9k=;
        b=RNlgWAFymMFKB1KEo7jH+RHIQNT28ekJbYNTSENDaalXis+6y1iBW0fOQGnGryBZXF
         M37I1DmiNkwo2xfZEUvv5UjtDudZxeTfY64M0FfKOsN8CR+HQs2iRVdDU1wliwQ5G42I
         mscyRe8fUxTacV0U0bRBYktI7S6ERHfZtlpZtzAEQ9YcK4k7/bRnolmOt871rpLoBBD+
         hbPnBEsbbDsPe21lwfmufus032ca4lvxuEFyQ/c+4lXGmGQXTAq1l5CiuWctE2CtxKva
         v6sz2k2ORTC7QkDb2POt2tn0J4GpfrecWoBjBPFEnyCs7SbanydC8Kh1Ao8/PJPe4uPV
         RTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706522293; x=1707127093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/yj2cF4QFPTINMOJ5Odb3ijjKjStQFfbkPQ+E8TM9k=;
        b=sWxC5lSeXfon+Bl37+NNAqrc+ZvN/73BUyn6mAl6sgX3J5PncTosZ5CClHLpQtwjNL
         2aL+roCyftqhCH7U+tBgJxEDWSeJReI8p8zePwXwtYW0eT3EkilhrTAQoAs40y7NLMd2
         AxS91OFXAcqoyY0x5RHj8oE5Yt0bomxObFmcefuxEmeJcvyYcWs3LywGPeT2xZPTqa7r
         b5EgD6TE8z9spW2kRcXmHsnSt6ezMUyKSh0mi+3haskedNaafcW2gDwh5Wut+wgBT7Bm
         PnyA829ixGiMHLKLBpD5Oj6zEa/xqSijQLv4bUQFb7O6kfa4OGxUNfmmOwBCN6Dcy/Yi
         D/cg==
X-Gm-Message-State: AOJu0YzBKmNkh+a75Keq6BkW6mI3stbqMVEBhJD+Ehsn2988jbx5mlyF
	VH0u6PcKwq+AT7o3PN+eqhlCEhkEf1FDvBe9vqZy9xUa28LHdXIv2Udc0MoWr3ebVqcUy3Rvuhy
	Q
X-Google-Smtp-Source: AGHT+IGLLoxO4r2cecG2riTmnlc0oiwaiM2/Qa304+OOrXxvULSm26H9zFdDAUUlmZA6ogAFjHFqxA==
X-Received: by 2002:a05:6a20:9591:b0:19c:b4ef:3fa5 with SMTP id iu17-20020a056a20959100b0019cb4ef3fa5mr241147pzb.29.1706522293506;
        Mon, 29 Jan 2024 01:58:13 -0800 (PST)
Received: from [10.255.192.107] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id ju11-20020a170903428b00b001d8ead3d805sm1027576plb.58.2024.01.29.01.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 01:58:12 -0800 (PST)
Message-ID: <d900f0fd-a586-404d-8568-0d2511908067@bytedance.com>
Date: Mon, 29 Jan 2024 17:58:05 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Re: [PATCH 5.10 000/286] 5.10.209-rc1 review
To: "Michael S. Tsirkin" <mst@redhat.com>, Guenter Roeck <linux@roeck-us.net>
Cc: Nathan Chancellor <nathan@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, llvm@lists.linux.dev, keescook@chromium.org,
 arei.gonglei@huawei.com, jasowang@redhat.com,
 virtualization@lists.linux.dev, linux-crypto@vger.kernel.org
References: <20240122235732.009174833@linuxfoundation.org>
 <6b563537-b62f-428e-96d1-2a228da99077@roeck-us.net>
 <2024012636-clubbed-radial-1997@gregkh>
 <2f342268-8517-4c06-8785-96a588d20c63@roeck-us.net>
 <20240126203436.GA913905@dev-arch.thelio-3990X>
 <0a194a79-e3a3-45e7-be98-83abd3e1cb7e@roeck-us.net>
 <20240126223554.GA1320833@dev-arch.thelio-3990X>
 <bef7737e-4b8e-4a89-b538-cd8e75874fd2@roeck-us.net>
 <20240129034304-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20240129034304-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/24 16:46, Michael S. Tsirkin wrote:
> On Fri, Jan 26, 2024 at 03:55:02PM -0800, Guenter Roeck wrote:
>> On 1/26/24 14:35, Nathan Chancellor wrote:
>>> (slimming up the CC list, I don't think this is too relevant to the
>>> wider stable community)
>>>
>>> On Fri, Jan 26, 2024 at 01:01:15PM -0800, Guenter Roeck wrote:
>>>> On 1/26/24 12:34, Nathan Chancellor wrote:
>>>>> On Fri, Jan 26, 2024 at 10:17:23AM -0800, Guenter Roeck wrote:
>>>>>> On 1/26/24 09:51, Greg Kroah-Hartman wrote:
>>>>>>> On Fri, Jan 26, 2024 at 08:46:42AM -0800, Guenter Roeck wrote:
>>>>>>>> On 1/22/24 15:55, Greg Kroah-Hartman wrote:
>>>>>>>>> This is the start of the stable review cycle for the 5.10.209 release.
>>>>>>>>> There are 286 patches in this series, all will be posted as a response
>>>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>>>> let me know.
>>>>>>>>>
>>>>>>>>> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
>>>>>>>>> Anything received after that time might be too late.
>>>>>>>>>
>>>>>>>> [ ... ]
>>>>>>>>
>>>>>>>>> zhenwei pi <pizhenwei@bytedance.com>
>>>>>>>>>          virtio-crypto: implement RSA algorithm
>>>>>>>>>
>>>>>>>>
>>>>>>>> Curious: Why was this (and its subsequent fixes) backported to v5.10.y ?
>>>>>>>> It is quite beyond a bug fix. Also, unless I am really missing something,
>>>>>>>> the series (or at least this patch) was not applied to v5.15.y, so we now
>>>>>>>> have functionality in v5.10.y which is not in v5.15.y.
>>>>>>>
>>>>>>> See the commit text, it was a dependency of a later fix and documented
>>>>>>> as such.
>>>>>>>
>>>>>>> Having it in 5.10 and not 5.15 is a bit odd, I agree, so patches are
>>>>>>> gladly accepted :)
>>>>>>>
>>>>>>
>>>>>> We reverted the entire series from the merge because it results in a build
>>>>>> failure for us.
>>>>>>
>>>>>> In file included from /home/groeck/src/linux-chromeos/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c:10:
>>>>>> In file included from /home/groeck/src/linux-chromeos/include/linux/mpi.h:21:
>>>>>> In file included from /home/groeck/src/linux-chromeos/include/linux/scatterlist.h:5:
>>>>>> In file included from /home/groeck/src/linux-chromeos/include/linux/string.h:293:
>>>>>> /home/groeck/src/linux-chromeos/include/linux/fortify-string.h:512:4: error: call to __read_overflow2_field declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
>>>>>>                            __read_overflow2_field(q_size_field, size);
>>>>>
>>>>> For what it's worth, this is likely self inflicted for chromeos-5.10,
>>>>> which carries a revert of commit eaafc590053b ("fortify: Explicitly
>>>>> disable Clang support") as commit c19861d34c003 ("CHROMIUM: Revert
>>>>> "fortify: Explicitly disable Clang support""). I don't see the series
>>>>> that added proper support for clang to fortify in 5.18 that ended with
>>>>> commit 281d0c962752 ("fortify: Add Clang support") in that ChromeOS
>>>>> branch, so this seems somewhat expected.
>>>>>
>>>>
>>>> That explains that ;-). I don't mind if the patches stay in v5.10.y,
>>>> we have them reverted anyway.
>>>>
>>>> The revert was a pure process issue, as you may see when looking into
>>>> commit c19861d34c003, so, yes, I agree that it is self-inflicted damage.
>>>> Still, that doesn't explain why the problem exists in 5.18+.
>>>>
>>>>>> I also see that upstream (starting with 6.1) when trying to build it with clang,
>>>>>> so I guess it is one of those bug-for-bug compatibility things. I really have
>>>>>> no idea what causes it, or why we don't see the problem when building
>>>>>> chromeos-6.1 or chromeos-6.6, but (so far) only with chromeos-5.10 after
>>>>>> merging 5.10.209 into it. Making things worse, the problem isn't _always_
>>>>>> seen. Sometimes I can compile the file in 6.1.y without error, sometimes not.
>>>>>> I have no idea what triggers the problem.
>>>>>
>>>>> Have a .config that reproduces it on upstream? I have not personally
>>>>> seen this warning in my build matrix nor has our continuous-integration
>>>>> matrix (I don't see it in the warning output at the bottom but that
>>>>> could have missed something for some reason) in 6.1:
>>>>>
>>>>
>>>> The following command sequence reproduces the problem for me with all stable
>>>> branches starting with 5.18.y (plus mainline).
>>>>
>>>> rm -rf /tmp/crypto-build
>>>> mkdir /tmp/crypto-build
>>>> make -j CC=clang-15 mrproper >/dev/null 2>&1
>>>> make -j O=/tmp/crypto-build CC=clang-15 allmodconfig >/dev/null 2>&1
>>>> make -j O=/tmp/crypto-build W=1 CC=clang-15 drivers/crypto/virtio/virtio_crypto_akcipher_algs.o
>>>>
>>>> I tried clang versions 14, 15, and 16. This is with my home system running
>>>> Ubuntu 22.04, no ChromeOS or Google specifics/internals involved. For clang-15,
>>>> the version is
>>>>
>>>> Ubuntu clang version 15.0.7
>>>> Target: x86_64-pc-linux-gnu
>>>> Thread model: posix
>>>> InstalledDir: /usr/bin
>>>
>>> Okay interesting, this warning is hidden behind W=1, which our CI does
>>> not test with. Looks like it has been that way since the introduction of
>>> these checks in f68f2ff91512 ("fortify: Detect struct member overflows
>>> in memcpy() at compile-time").
>>>
>>
>> Interestingly the warning is seen in chromeos-5.10, without this patch,
>> and without W=1. I guess that must have to do with the revert which is
>> finally biting us.
>>
>>> I think this is a legitimate warning though. It is complaining about the
>>> second memcpy() in virtio_crypto_alg_akcipher_init_session():
>>>
>>>     memcpy(&ctrl->u, para, sizeof(ctrl->u));
>>>
>>> where ctrl is:
>>>
>>>     struct virtio_crypto_op_ctrl_req {
>>>             struct virtio_crypto_ctrl_header header;         /*     0    16 */
>>>             union {
>>>                     struct virtio_crypto_sym_create_session_req sym_create_session; /*    16    56 */
>>>                     struct virtio_crypto_hash_create_session_req hash_create_session; /*    16    56 */
>>>                     struct virtio_crypto_mac_create_session_req mac_create_session; /*    16    56 */
>>>                     struct virtio_crypto_aead_create_session_req aead_create_session; /*    16    56 */
>>>                     struct virtio_crypto_akcipher_create_session_req akcipher_create_session; /*    16    56 */
>>>                     struct virtio_crypto_destroy_session_req destroy_session; /*    16    56 */
>>>                     __u8               padding[56];          /*    16    56 */
>>>             } u;                                             /*    16    56 */
>>>             union {
>>>                     struct virtio_crypto_sym_create_session_req sym_create_session; /*     0    56 */
>>>                     struct virtio_crypto_hash_create_session_req hash_create_session; /*     0    56 */
>>>                     struct virtio_crypto_mac_create_session_req mac_create_session; /*     0    56 */
>>>                     struct virtio_crypto_aead_create_session_req aead_create_session; /*     0    56 */
>>>                     struct virtio_crypto_akcipher_create_session_req akcipher_create_session; /*     0    56 */
>>>                     struct virtio_crypto_destroy_session_req destroy_session; /*     0    56 */
>>>                     __u8                       padding[56];          /*     0    56 */
>>>             };
>>>
>>>
>>>             /* size: 72, cachelines: 2, members: 2 */
>>>             /* last cacheline: 8 bytes */
>>>     };
>>>
>>> (so size and p_size_field should be 56) and the type of the para
>>> parameter in virtio_crypto_alg_akcipher_init_session() is 'void *' but
>>> the para passed by reference to
>>> virtio_crypto_alg_akcipher_init_session() in virtio_crypto_rsa_set_key()
>>> has a type of 'struct virtio_crypto_akcipher_session_para':
>>>
>>>     struct virtio_crypto_akcipher_session_para {
>>>             __le32                     algo;                 /*     0     4 */
>>>             __le32                     keytype;              /*     4     4 */
>>>             __le32                     keylen;               /*     8     4 */
>>>             union {
>>>                     struct virtio_crypto_rsa_session_para rsa; /*    12     8 */
>>>                     struct virtio_crypto_ecdsa_session_para ecdsa; /*    12     8 */
>>>             } u;                                             /*    12     8 */
>>>             union {
>>>                     struct virtio_crypto_rsa_session_para rsa;       /*     0     8 */
>>>                     struct virtio_crypto_ecdsa_session_para ecdsa;   /*     0     8 */
>>>             };
>>>
>>>
>>>             /* size: 20, cachelines: 1, members: 4 */
>>>             /* last cacheline: 20 bytes */
>>>     };
>>>
>>> (so q_size_field would be 20 if clang were able to do inlining to see
>>> through the 'void *'...?), which would result in the
>>>
>>>     __compiletime_lessthan(q_size_field, size)
>>>
>>> check succeeding and triggering the warning because 20 < 56, so it does
>>> seem like there is an overread of the source buffer here? Adding the
>>
>> Looks like it; I think either the passed 'para' should be of type
>> virtio_crypto_akcipher_create_session_req() or it should only copy
>> sizeof(struct virtio_crypto_akcipher_session_para) bytes.
>>
>> Anyway, how did you find that ? Is there a magic trick to find the
>> actual code causing the warning ? I am asking because we had seen
>> similar warnings before, and it would help to know how to find the
>> problematic code.
>>
>> Thanks,
>> Guenter
> 
> 
> 
> Cc: zhenwei pi <pizhenwei@bytedance.com>
> 
> Zhenwei I think you wrote most of the code here.
> Can you take a look please?
> Stack overflows are plus plus ungood.
> 
> 
> 
> 
>>> maintainers of the driver and subsystem in question.
>>>
>>> Cheers,
>>> Nathan
> 

I can also reproduce this warning by commands on ubuntu-2204:
make -j CC=clang-14 mrproper >/dev/null 2>&1
make -j O=/tmp/crypto-build CC=clang-14 allmodconfig >/dev/null 2>&1
make -j O=/tmp/crypto-build W=1 CC=clang-14 
drivers/crypto/virtio/virtio_crypto_akcipher_algs.o

so sorry on this issue, I think Guenter's suggestion is right(also test 
by these commands), I'll send a fix later.

-- 
zhenwei pi
