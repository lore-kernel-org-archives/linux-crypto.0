Return-Path: <SRS0=CUlN=CA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CCEC433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Aug 2020 22:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31FA32078A
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Aug 2020 22:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FImfX2wl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHVWgA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Aug 2020 18:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbgHVWf6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Aug 2020 18:35:58 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EA5C061573
        for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2020 15:35:57 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id ba10so4941859edb.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2020 15:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fuwztpLGAT3zDZoXwPYNRPBFs6sq5n3E7A5GojxpOEo=;
        b=FImfX2wl0SYhX+gus2BTk6RcbMDLbRDAXV6pBYtC/9UAad5HiocCn2CZNgcRKdn0oV
         h4AQwnfGIqVqvL57KnlDQsRLYAZQR1zSbfW7xEPK1N2pu8VEXNsqnTrpxIl+f3fR4I8R
         brIrZPg08zPSebuiD6rQu2DEOfd0WHO+pWs8smAN894Ul2p4FSixMErL9Nan4vIJONwW
         E9ypxBxCzWW+ujeseMLYQD+bKHd6+u21MF0Lhn8bmDWCBRjOVJOGn0M+3kBYFG1gi0Jv
         p3CzoOaOEmIlJjY8xxvPw/83fxFw24YRJCGEcvWHi854pxzY8rzV5tHv6CINRrhKDb/A
         xf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fuwztpLGAT3zDZoXwPYNRPBFs6sq5n3E7A5GojxpOEo=;
        b=iJCW05hKokh0PpEi3oY3ZDGUJn8Fxzz3GtQMKXFlWMZ0jJHJgR+htk4ZznNYuQmOR7
         6qeaug5rED/oOXEySLi6b9g2NWgvF0hy4nBuZgTX+PorVC8aIo4rZuAm1ThDRDW7iusm
         M6Opi/VBuWW/OBbMfDg1aH+1X12P/JgzI/VT5AcFeNRzxODC/rSpIJC38d0oNma44PdD
         WKelxT0KrnImXLEUZCkXQRdQrExR9Ivf++scIfiECiwtnZc/5PJ/5CEX+WvWQgg1TTVI
         d2+FrfJlaPUPncCbreAs6KJ9SKESsqk5hYu2ukHPVoBCpsTpYhKJozBWsQJqSp1RmiFd
         B8yA==
X-Gm-Message-State: AOAM532YkoVdbnBhmi3oCjfoc8VCG0HNJjLaoydNvM8lhyC70QRsDtZl
        sy0uPgBkU/scZe8cQm/gGcE++/1+9Ud1xA==
X-Google-Smtp-Source: ABdhPJzQwbLP0U6X8kDZu892Cdv6bXkCTaCvffXPQPCrGFfMCFbMtGP9a8Mn29INZEMOsn4EJSKkWw==
X-Received: by 2002:a05:6402:1a57:: with SMTP id bf23mr9190139edb.185.1598135756122;
        Sat, 22 Aug 2020 15:35:56 -0700 (PDT)
Received: from debian64.daheim (p4fd09171.dip0.t-ipconnect.de. [79.208.145.113])
        by smtp.gmail.com with ESMTPSA id u6sm4156142ejf.98.2020.08.22.15.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 15:35:55 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k9c76-000GDN-MN; Sun, 23 Aug 2020 00:35:54 +0200
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Greear <greearb@candelatech.com>
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
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <e6149c06-9827-abaa-2e3b-308ea93414d5@gmail.com>
Date:   Sun, 23 Aug 2020 00:35:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818222719.GA27622@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-08-19 00:27, Herbert Xu wrote:
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

Ohh, is this still about a heavily-updated and rewritten version
of my old initial patch from 2014 for 3.16-wl?
<https://lore.kernel.org/linux-wireless/1518134.xFh23iA8q1@blech/>

Because back in 2016, I've asked this on linux-wireless:

| It would be a great if mac80211 would do to the encryption and
| decryption asynchronously. As this would work for other ciphers
| and also allows crypto offload to dedicated crypto hardware.

And the answer back then (same as now) was:
<https://lore.kernel.org/linux-wireless/1477168300.4123.8.camel@sipsolutions.net/>

 >The only problem with that is that we'd essentially need a software
 >queue for *all* frames, and release them from there in RX order after
 >decrypt. That's surely doable, but so far nobody has thought it
 >important enough since mostly HW crypto is used ...

Ben, keep up the good work!

Cheers,
Christian
