Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB35C433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 13:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9557520C01
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 13:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hqoY8rdy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbfHFNTj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 09:19:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52865 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfHFNTj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 09:19:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so78161947wms.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 06:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YOmDP5pcS9DP+kILEPX6UYyio2UB1ntP/9I75g0ifwU=;
        b=hqoY8rdyta096nGprC4Fp5kIOvA+OpDXMtT8CFsQP8qF8pfm3fG0D1q1nFJbvGd2z9
         zZiFMTLaKzwd8PcuMKOQubNyDdAhHKxFQ5AgT0Tc9mtcW/2U9USUs6mraUdYnSlRWCCO
         0Co6nAICxQlZUfZ877upnqVryp+d5zEbotiAlJyLyxg0QdNM4R0iQZqKDuzNi72HCru8
         /bpdCyrluNfN+BCJr6VlAjIsySy/8ok6u1OeU8nOqCel3WZP5q1OFD9htBuAzoFied2B
         YBwzApUGHhjbZwettmdZlufbCVk1pRcNoWQgfZTkQGmz9z3KVFiRV6OQXN2lOgFcD4B3
         +4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YOmDP5pcS9DP+kILEPX6UYyio2UB1ntP/9I75g0ifwU=;
        b=SooM517H9JfzMrriT3bOxXqX8+EvbX7Os/wiHbpAwq2qJY6n156YmNQtDChDKQ7Mor
         ccIj5Sws0HNudqElowm90WCtmFKJcgWqxcUC6LwWhc/dFj02Xl9yakg3KLfoBvSG27Vu
         8jTkAVo09nZ6B6x8YDAXJR5bkTsyq0Q+6sF6woTpubCOCfIdRI2zpl10L/TwWKW3Whj6
         C98ji5S3wYY/2oBVyQ161eETBZzWSEFvszcTvhEYKw/Zgj0ThMgMRzRMrubCZVuNWLT0
         2Y5o8VE8WNl72Hc2XASnIi0gOBTe5ZA1i7Wz5pxfBegAjOGPUHEJs1IcLTj8gb4b4td9
         xVyw==
X-Gm-Message-State: APjAAAVGTQfQh4yrbz074zbUqJfeioWv+JyEp3Qz2IHLQeNP79TWpMI0
        px0fJuS4Out1kujHtwGibYY=
X-Google-Smtp-Source: APXvYqw6GndavLc1jXE4mw+YFt5Qemf4yvKM3zxDtz6Cg7Crq9Y7Bl3909My/muyCCo7xmJUq3DOcQ==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr5049545wmb.129.1565097576186;
        Tue, 06 Aug 2019 06:19:36 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b8sm119228737wmh.46.2019.08.06.06.19.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 06:19:35 -0700 (PDT)
Subject: Re: [RFC PATCH 2/2] md/dm-crypt - switch to AES library for EBOIV
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
 <20190806080234.27998-3-ard.biesheuvel@linaro.org>
 <22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
 <CAKv+Gu_LQwtM47njiksCJL2tMx_Zv8Paoegfkah--T6Mh55u3A@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <922068a1-6123-b4b6-fe2e-d453c28c45dd@gmail.com>
Date:   Tue, 6 Aug 2019 15:19:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu_LQwtM47njiksCJL2tMx_Zv8Paoegfkah--T6Mh55u3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/08/2019 14:17, Ard Biesheuvel wrote:
> On Tue, 6 Aug 2019 at 13:43, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> On 06/08/2019 10:02, Ard Biesheuvel wrote:
>>> The EBOIV IV mode reuses the same AES encryption key that is used for
>>> encrypting the data, and uses it to perform a single block encryption
>>> of the byte offset to produce the IV.
>>>
>>> Since table-based AES is known to be susceptible to known-plaintext
>>> attacks on the key, and given that the same key is used to encrypt
>>> the byte offset (which is known to an attacker), we should be
>>> careful not to permit arbitrary instantiations where the allocated
>>> AES cipher is provided by aes-generic or other table-based drivers
>>> that are known to be time variant and thus susceptible to this kind
>>> of attack.
>>>
>>> Instead, let's switch to the new AES library, which has a D-cache
>>> footprint that is only 1/32th of the generic AES driver, and which
>>> contains some mitigations to reduce the timing variance even further.
>>
>> NACK.
>>
>> We discussed here that we will not limit combinations inside dm-crypt.
>> For generic crypto API, this policy should be different, but I really
>> do not want these IVs to be visible outside of dm-crypt.
>>
>> Allowing arbitrary combinations of a cipher, mode, and IV is how dm-crypt
>> works since the beginning, and I really do not see the reason to change it.
>>
>> This IV mode is intended to be used for accessing old BitLocker images,
>> so I do not care about performance much.
>>
> 
> Apologies for being blunt, but you are basically driving home the
> point I made before about why the cipher API should become internal to
> the crypto subsystem.
> 
> Even though EBOIV is explicitly only intended for accessing old
> BitLocker images, you prioritize non-functional properties like API
> symmetry and tradition over sound cryptographic engineering practice,
> even after I pointed out to you that
> a) the way EBOIV uses the same symmetric key for two different
> purposes is a bad idea in general, and
> b) table based AES in particular is a hazard for this mode, since the
> way the IV is generated is susceptible to exactly the attack that
> table based AES is most criticized for.
> 
> So if you insist on supporting EBOIV in combination with arbitrary
> skciphers or AEADs (or AES on systems where crypto_alloc_cipher()
> produces a table based AES driver), how do you intend to mitigate
> these issues?
 I am not going to mitigate these. We will never format new devices
using these exotic configurations. And if user enforces it, there can be
a reason - or it is just stupid, like using cipher_null.
(Which is entirely insecure but very useful for testing.)

The IV concept in dm-crypt is straightforward and allows many insecure
and obscure combinations (aes-ecb-null, for example - and this is used
for millions of chipset encrypted drivers, people used it to access through
dmcrypt without the USB bridge.) The same applies for obscure cryptloop
image combinations. (I would better spent time to remove cryptoloop,
it is much worse that what we are discussing here :)

So I see no reason to spend hours and hours attacks for devices
that use crypto that is obsolete anyway (all new drives use XTS).

I would like to provide way to access data on existing, maybe obsolete and insecure,
encrypted images from foreign OSes.

But all that said is meant in the isolated context of dm-crypt driver,
if you want to provide generic API, it perhaps makes sense to enforce such a policy.

I understand you want to propose more secure ways of implementing crypto,
but then - if you decide to remove existing API I used, we can switch to something better.
(Is there something better except AES-only lib you used?)

I just disagree with adding various checks for cipher/mode/iv combinations inside dm-crypt.
It was meant to be configurable from userspace.

Milan
