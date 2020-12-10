Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC6FC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 03:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9C62332A
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 03:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgLJDBx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 22:01:53 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:37208 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgLJDBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 22:01:53 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 8414713C2B0;
        Wed,  9 Dec 2020 19:01:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8414713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1607569272;
        bh=W8GxDXTMxRLEiD0SqBXS9XG80ehCSR90Y34022flBDA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=d07wuo8yYrCkhxpxEw08R9teUUbwZ4hUF1ejoEAtFQDA908D3i1lS7Mok3PHzYrb/
         D78YKMk7XJLY2w+WGmjq2ebjZigDNbA/6QLPspqBt8qNo7Ks3vbXOCt+hyBzM9RCga
         6RG+BHi+bS5FjY8DmeRrrmF3Th3NoxSvbYQCpBFc=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
Date:   Wed, 9 Dec 2020 19:01:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201210024342.GA26428@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/9/20 6:43 PM, Herbert Xu wrote:
> On Thu, Dec 10, 2020 at 01:18:12AM +0100, Ard Biesheuvel wrote:
>>
>> One thing I realized just now is that in the current situation, all
>> the synchronous skciphers already degrade like this.
>>
>> I.e., in Ben's case, without the special ccm implementation, ccm(aes)
>> will resolve to ccm(ctr(aesni),cbcmac(aesni)), which is instantiated
>> as a sync skcipher using the ctr and ccm/cbcmac templates built on top
>> of the AES-NI cipher (not skcipher).  This cipher will also fall back
>> to suboptimal scalar code if the SIMD is in use in process context.
> 
> Sure, your patch is not making it any worse.  But I don't think
> the extra code is worth it considering that you're still going to
> be running into that slow fallback path all the time.

How can we test this assumption?  I see 3x performance gain, so it is not hitting
the fallback path much in my case.  What traffic pattern and protocol do you think
will cause the slow fallback path to happen often enough to make this patch not
helpful?

> Much better to fix the wireless code to actually go async.

This will not happen any time soon, so better to make incremental
improvement in the crypt code.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
