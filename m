Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E6C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Nov 2022 14:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKIOMl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 09:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKIOMj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 09:12:39 -0500
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C66A47B
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 06:12:38 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.129])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 052B11C0083;
        Wed,  9 Nov 2022 14:12:37 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A447C50007A;
        Wed,  9 Nov 2022 14:12:36 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.40.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id BC79C13C2B0;
        Wed,  9 Nov 2022 06:12:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com BC79C13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1668003156;
        bh=fTOMhfucBpNfnPFWb9/TY08euH6Xo0fFf7OGQlGSj4c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JwWO4ZuPnLIFaQZ7Kipx85TBkjb8Q90XyCIKozCUoKVqfz9l90WrKBN73HUDDyILI
         MT28tN91wur5YJT5s/ehjAXdkEkjUxhO3SV+Tth/U843VHevlW7PYCsge5jhc8V15P
         JNkY7kwjvkS/qVkWzgeaHHUhVL/L70sPG3rk52mk=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20201210024342.GA26428@gondor.apana.org.au>
 <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au>
 <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au>
 <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au>
 <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au>
 <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <7dd866a1-e05b-347f-0058-d5a622bbf39e@candelatech.com>
Date:   Wed, 9 Nov 2022 06:12:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1668003157-rTOnciQPLg0O
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/9/22 2:05 AM, Ard Biesheuvel wrote:
> On Wed, 9 Nov 2022 at 04:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
>>>
>>> While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
>>> and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
>>> supported upstream now?  Or is it specific to whatever xctr is?  If so,
>>> any chance the patch is wanted upstream now?
>>
>> AFAICS the xctr patch has nothing to do with what you were trying
>> to achieve with wireless.  My objection still stands with regards
>> to wireless, we should patch wireless to use the async crypto
>> interface and not hack around it in the Crypto API.
>>
> 
> Indeed. Those are just add/add conflicts because both patches
> introduce new code into the same set of files. The resolution is
> generally to keep both sides.
> 
> As for Herbert's objection: I will note here that in the meantime,
> arm64 now has gotten rid of the scalar fallbacks entirely in AEAD and
> skipcher implementations, because those are only callable in task or
> softirq context, and the arm64 SIMD wrappers now disable softirq
> processing. This means that the condition that results in the fallback
> being needed can no longer occur, making the SIMD helper dead code on
> arm64.
> 
> I suppose we might do the same thing on x86, but since the kernel mode
> SIMD handling is highly arch specific, you'd really need to raise this
> with the x86 maintainers.

Wifi stack is unlikely to ever change in this regard, so I hope that it does not
become too much more trouble to keep this patch alive.

I made an attempt at the merge, but the error path clean up looks tangled to me,
I'll post a patch for review once I get my tree cleaned up a bit from the rebase.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
