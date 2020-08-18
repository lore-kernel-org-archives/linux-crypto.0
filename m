Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0BCC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 22:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E52D20709
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 22:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="q32sjsme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgHRWbN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:31:13 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:57410 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHRWbM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 18:31:12 -0400
Received: from [192.168.254.6] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id F186913C2B0;
        Tue, 18 Aug 2020 15:31:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com F186913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1597789871;
        bh=ESOU0iGO+yz002BDQed4NjjU37hTef+HXGWOhBgBiTI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=q32sjsmeVMBq3RFtpNRKB0WXH5el7AY6HNIhH6yvV2NJY6SY3VzgDuEBKk0wTBF20
         T3mFaysgor/freySOmqbhh8jS0uwF+NxcM48jNwk3cADELPuhGvs5+xMBuzOOAM4Kn
         5QIUxScT6Rw/XpGC1meEi7SP+AZolS7U0B6xEo44=
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20200802090616.1328-1-ardb@kernel.org>
 <20200818082410.GA24497@gondor.apana.org.au>
 <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
 <20200818135128.GA25652@gondor.apana.org.au>
 <2aad9569-877e-4398-88ef-e40d9bbf7656@candelatech.com>
 <20200818140532.GA25807@gondor.apana.org.au>
 <be188471-b75f-d2e2-d657-265a1cd9831b@candelatech.com>
 <20200818221550.GA27421@gondor.apana.org.au>
 <20200818222719.GA27622@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com>
Date:   Tue, 18 Aug 2020 15:31:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818222719.GA27622@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/18/20 3:27 PM, Herbert Xu wrote:
> On Wed, Aug 19, 2020 at 08:15:50AM +1000, Herbert Xu wrote:
>> On Tue, Aug 18, 2020 at 07:17:35AM -0700, Ben Greear wrote:
>>>
>>> Is there any easy way to use your work to make shash fast for aesni?  I
>>> basically just want it to perform as well as it used to with my patch.
>>
>> Yes.  We could add a sync version of aesni that simply falls back
>> to aes-generic when simd is unavailable.
> 
> But I think before anyone attempts this we should explore making
> mac80211 async like IPsec.  Is there any fundamental reason why
> that is not possible? Have the wireless people expressed any
> objections to making this async before?

I don't think it has been discussed recently, but mac80211 is already
a complicated beast, so if this added any significant complexity
it might not be worth it.

Truth is though, I know very little about what changes would be
needed to make it do async decrypt, so maybe it would be a simple
matter?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
