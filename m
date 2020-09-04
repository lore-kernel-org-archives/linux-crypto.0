Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3441AC43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6C6206B7
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIDIzc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:55:32 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45276 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgIDIzb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 04:55:31 -0400
Received: by mail-lj1-f195.google.com with SMTP id c2so6980316ljj.12;
        Fri, 04 Sep 2020 01:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nu8oE74z5YBqiFxodPe/uvx/vJbyX2uHL0xvWWab5to=;
        b=WX2C0bogxKF21ZGgpTKj5IiAbFMGfVOOSudtGTt9NR+J1Gw1vuJKsYfCmlXxdQcFGJ
         PI4r+PwwzZsCUSvupspmBPazkULA+ngHWpvaRV+3+6PmNIdcMYPnB3gQlQYfac4BRDpi
         Mpgs092vKbFixwuiGQN09UAvQmQ7gIJzS7pfEXCCU6wcVaXVfBnDsR5cR86POoc01FrG
         XLwlORV+N5y+p2TNHZS+D6E9r3lwg7R6eyiiOMEmLbc2WDt7hemVftFBlHE1x51bZwrD
         kpo9RlaikiCV2kaai0KwvXxrmveYK3sn84zLcMAasaCvnNZ0vBfNM1zBPLaxGKIECWvc
         56Qg==
X-Gm-Message-State: AOAM533jRkZlX28toJGYUq+5+ZNInZZmbZxbPtpWHCrhOZWXjnDW72ue
        orOOgIAqgp2pQ2EN1sJlI6BEYxqz1x8=
X-Google-Smtp-Source: ABdhPJweM51R4S6z0DWK6Y1+pL4HJMqhC3w/2hUrgyhp95P9gYPCxrKW9CZWpIYqytyoHaz9OYDkLg==
X-Received: by 2002:a2e:9794:: with SMTP id y20mr3192952lji.269.1599209727867;
        Fri, 04 Sep 2020 01:55:27 -0700 (PDT)
Received: from [10.68.32.147] (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.gmail.com with ESMTPSA id m13sm1175032lfl.30.2020.09.04.01.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 01:55:27 -0700 (PDT)
Reply-To: efremov@linux.com
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200827064402.7130-1-efremov@linux.com>
 <20200827064402.7130-2-efremov@linux.com>
 <CY4PR0401MB3652FFD58D9ED14F4805FC99C32F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Denis Efremov <efremov@linux.com>
Autocrypt: addr=efremov@linux.com; keydata=
 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
Subject: Re: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
Message-ID: <8ac5cb88-7df5-1060-2fac-510541fca48b@linux.com>
Date:   Fri, 4 Sep 2020 11:55:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CY4PR0401MB3652FFD58D9ED14F4805FC99C32F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 9/2/20 4:10 PM, Van Leeuwen, Pascal wrote:
>> -----Original Message-----
>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Denis Efremov
>> Sent: Thursday, August 27, 2020 8:44 AM
>> To: linux-crypto@vger.kernel.org
>> Cc: Denis Efremov <efremov@linux.com>; Corentin Labbe <clabbe.montjoie@gmail.com>; Herbert Xu
>> <herbert@gondor.apana.org.au>; linux-kernel@vger.kernel.org
>> Subject: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
>>
>> <<< External Email >>>
>> Use kfree_sensitive() instead of open-coding it.
>>
>> Signed-off-by: Denis Efremov <efremov@linux.com>
>> ---
>>  drivers/crypto/inside-secure/safexcel_hash.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
>> index 16a467969d8e..5ffdc1cd5847 100644
>> --- a/drivers/crypto/inside-secure/safexcel_hash.c
>> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
>> @@ -1082,8 +1082,7 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
>>  }
>>
>>  /* Avoid leaking */
>> -memzero_explicit(keydup, keylen);
>> -kfree(keydup);
>> +kfree_sensitive(keydup);
>>
> I'm not sure here ... I verified it does not break the driver (not a big surprise), but ...
> 
> memzero_explicit guarantees that it will not get optimized away and the keydata _always_
> gets overwritten. Does kfree_sensitive also come with such a guarantee? I could not find a
> hard statement on that in its documentation. Although the "sensitive" part surely suggests
> it.

kfree_sensitive() uses memzero_explicit() internally.

> Additionally, this remark is made in the documentation for kfree_sensitive: "this function
> zeroes the whole allocated buffer which can be a good deal bigger than the requested buffer
> size passed to kmalloc().  So be careful when using this function in performance sensitive
> code"
> 
> While the memzero_explicit does not zeroize anything beyond keylen.
> Which is all you really need here, so why would you want to zeroize potentially a lot more?
> In any case the two are not fully equivalent.

There are a number of predefined allocation sizes (power of 2) for faster alloc,
i.e. https://elixir.bootlin.com/linux/latest/source/include/linux/slab.h#L349
and it looks like that keys we free in this patches are in bounds of these sizes.
As far as I understand, if a key is not a power of 2 len, the buffer will be zeroed to the closest
power of 2 size. For small sizes like these, performance difference should be unnoticeable because
of cache lines and how arch-optimized memzero() works. Key freeing doesn't look like a frequent event.

Thanks,
Denis
