Return-Path: <SRS0=qsSA=CV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596DAC433E2
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Sep 2020 10:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12074208FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Sep 2020 10:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldfJmLVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgILKFt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Sep 2020 06:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgILKFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Sep 2020 06:05:47 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1703C061573
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2020 03:05:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l9so6905572wme.3
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2020 03:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=90YY4GCj9MCnBhlZ4jV2qidPe5U41jo2zEaDvX7aM4Q=;
        b=ldfJmLVFOGl4H3Z8v/CWbsGSr1VumYHgra/HDUsYfeWMXnuf7uYtH0f8Lq047aB+NI
         7HM7plddd3nNxPqCML41L+EMFONmrcwBZ5q9eG6gfloMnThSgprmRUAWWqxBR8zAPowK
         lKF8DuZZe6mYh2UrsjUvLGOeGvKk7gqkTEUJ7/0nn6+BVO9Uu+/Xf2jyWRBh1mK6l6WK
         HWgwT5/nFWwbOr+/hQi/3K5dHIH7V4bzpDOFuEFoFySScVWSpF+uo56xpNe2LDhv8wZ0
         HaBXASFKfJs0zqI0JY/Z8ttPggJxLjOhPd67e5rtiS0LYPVXMF0czG/k5xkRajOHxDJA
         vyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=90YY4GCj9MCnBhlZ4jV2qidPe5U41jo2zEaDvX7aM4Q=;
        b=LVsxn//ZyBNaIqWlRshSyz2aJww8iwZoG/9qfLGgDukuvGh69xXVS745S71nPYVJZI
         rNHosvlGRKjWXx7BZroFmn7Z8acV2NzlJpRsVw26DhyHg5B8DCs0bJ/4QTZIBd6n7O9w
         wSQqC8NYbzpHXbt5ypX3/2j2kbVpF6rXswZgOMCQa1yl+oVwbFFbX2dwURZSBTpbwX9z
         g/tsWFV7VdF5ZF3MknktA7uHZc8YcADkrBVTTQPC/9p5uLJ6WOruGHMi3PI8gSjLRn0m
         OEOaopBRNC0NQgqvy4M/YH1QQ1EBa7vKtP5CRRy9QXoDTdPTMNhFS8VjqsnzPQf3/DGG
         IWJQ==
X-Gm-Message-State: AOAM531ckGWIrbZ6vTBiRQvpuwMk9ZK/xvTHLAuBwX4wHrF+5G5KoN/u
        p1NihFKbmjgpCWCfgwqx404=
X-Google-Smtp-Source: ABdhPJyDSYSL38ztFT/ifkvFTAaj69PVwgFWPuQ3uh4U3wXSLEJZqcgtFocTHkqjd3xwrhX28BgaTw==
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr6126485wml.59.1599905143839;
        Sat, 12 Sep 2020 03:05:43 -0700 (PDT)
Received: from [192.168.8.102] (37-48-59-155.nat.epc.tmcz.cz. [37.48.59.155])
        by smtp.gmail.com with ESMTPSA id b187sm9154522wmb.8.2020.09.12.03.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 03:05:42 -0700 (PDT)
Subject: Re: [PATCH] crypto: mark unused ciphers as obsolete
To:     Ard Biesheuvel <ardb@kernel.org>,
        "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>, dm-devel@redhat.com
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
References: <20200911141103.14832-1-ardb@kernel.org>
 <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <ddbf295b-1e02-6553-0d78-5543923ba100@gmail.com>
Date:   Sat, 12 Sep 2020 12:05:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/09/2020 18:30, Ard Biesheuvel wrote:
> (cc Milan and dm-devel)
> 
> On Fri, 11 Sep 2020 at 19:24, Van Leeuwen, Pascal
> <pvanleeuwen@rambus.com> wrote:
>>
>>> -----Original Message-----
>>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Ard Biesheuvel
>>> Sent: Friday, September 11, 2020 4:11 PM
>>> To: linux-crypto@vger.kernel.org
>>> Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel <ardb@kernel.org>
>>> Subject: [PATCH] crypto: mark unused ciphers as obsolete
>>>
>>> <<< External Email >>>
>>> We have a few interesting pieces in our cipher museum, which are never
>>> used internally, and were only ever provided as generic C implementations.
>>>
>>> Unfortunately, we cannot simply remove this code, as we cannot be sure
>>> that it is not being used via the AF_ALG socket API, however unlikely.
>>> So let's mark the Anubis, Khazad, SEED and TEA algorithms as obsolete,
>>>
>> Wouldn't the IKE deamon be able to utilize these algorithms through the XFRM API?
>> I'm by no means an expert on the subject, but it looks like the cipher template is
>> provided there directly via XFRM, so it does not need to live in the kernel source.
>> And I know for a fact that SEED is being used for IPsec (and TLS) in Korea.
>>
> 
> I have been staring at net/xfrm/xfrm_algo.c, and as far as I can tell,
> algorithms have to be mentioned there in order to be usable. None of
> the ciphers that this patch touches are listed there or anywhere else
> in the kernel.
> 
>> The point being, there are more users to consider beyond "internal" (meaning hard
>> coded in the kernel source in this context?) and AF_ALG.
>>
> 
> That is a good point, actually, since dm-crypt could be affected here
> as well, hence the CCs.
> 
> Milan (or others): are you aware of any of these ciphers being used
> for dm-crypt?

Cryptsetup/dm-crypt can use them (talking about Seed, Khazad, Anubis, TEA), but I think
there is no real use of these.
(IOW these are used only if someone deliberately uses them - manually specifying on format.)

For dm-crypt. there should be no big harm if these are marked obsolete.

Milan
