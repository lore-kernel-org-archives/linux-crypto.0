Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63309C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 15:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F0523C81
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 15:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391396AbgLJOla (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:41:30 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:54826 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391383AbgLJOlU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 09:41:20 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1EA1713C2B0;
        Thu, 10 Dec 2020 06:40:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1EA1713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1607611236;
        bh=BQf+7BLSD1IsdZHZHY1hN/owhK98UPm6lYRWn98BGLg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SyILDUkVi4X8AL/8yDcnCkcOrlS7NiKl4Cb4p3KcpGfgaHOVizpPPoml9f+psqAHM
         QaozbrP4vrjIGnJuxOc41gwJZIAskz6fVKur/SW9hgmcKbPL0yL82+4QPXxd2uEv5P
         KJ5oDPkhweam9bdAa0qV2su1YQxVyQYCgMLDBx2Q=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
References: <20201201194556.5220-1-ardb@kernel.org>
 <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au>
 <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au>
 <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
 <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
 <20201210024342.GA26428@gondor.apana.org.au>
 <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <737f75a8-0709-c0ac-c98c-ccbe1b3e5ece@candelatech.com>
Date:   Thu, 10 Dec 2020 06:40:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/9/20 11:30 PM, Ard Biesheuvel wrote:
> On Thu, 10 Dec 2020 at 04:01, Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 12/9/20 6:43 PM, Herbert Xu wrote:
>>> On Thu, Dec 10, 2020 at 01:18:12AM +0100, Ard Biesheuvel wrote:
>>>>
>>>> One thing I realized just now is that in the current situation, all
>>>> the synchronous skciphers already degrade like this.
>>>>
>>>> I.e., in Ben's case, without the special ccm implementation, ccm(aes)
>>>> will resolve to ccm(ctr(aesni),cbcmac(aesni)), which is instantiated
>>>> as a sync skcipher using the ctr and ccm/cbcmac templates built on top
>>>> of the AES-NI cipher (not skcipher).  This cipher will also fall back
>>>> to suboptimal scalar code if the SIMD is in use in process context.
>>>
>>> Sure, your patch is not making it any worse.  But I don't think
>>> the extra code is worth it considering that you're still going to
>>> be running into that slow fallback path all the time.
>>
>> How can we test this assumption?  I see 3x performance gain, so it is not hitting
>> the fallback path much in my case.  What traffic pattern and protocol do you think
>> will cause the slow fallback path to happen often enough to make this patch not
>> helpful?
>>
> 
> Is there a way to verify Herbert's assertion that TX and RX tend to be
> handled by the same core? I am not a networking guy, but that seems
> dubious to me.
> 
> You could add a pr_warn_ratelimited() inside the fallback path and see
> if it ever gets called at all under various loads.

Even if it does sometimes use the same core, if performance is better and
CPU usage is lower, why would it even matter?

Anyway, looks like Herbert is dead set against this code in hopes that he
can force other subsystems to re-write their code.  If you come up with
some other variant that Herbert will accept, let me know and I'll test it.

Otherwise, I will just add your patch to my kernel and carry on.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
