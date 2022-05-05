Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A0CC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 May 2022 09:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353749AbiEEJg5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 May 2022 05:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiEEJg4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 May 2022 05:36:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2BE2ADF
        for <linux-crypto@vger.kernel.org>; Thu,  5 May 2022 02:33:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 204so423849pfx.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 May 2022 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LAABk+Hqn/ed3olCk7cLLnxGOLs8GPCl8qPvqmsVMMM=;
        b=ErbXNtFsbGBEns+3J2+rqVHArDPQgCAH5aInArNTr5Ytkh/2HnvkfZXsi+I8K9/fKL
         FOod075XSxK4u/V8rbUwYiTnw6NXlPrvknjrKk02/PKJgkljGMJxHnB+e1xcGiYhZC4J
         CVcjLuK/RXUvnMfbnldwLtRd3sIqwBcG5uKkEbX8yd+vyFbQZRSah9nEtuLOhACyZ3ya
         XaDrcJdsyj6SllWgRfR3/AOf2W1IRrw9wkJdWRgoV9vASSILU2/qzvlVf0Zxqb1gMZYI
         oIKjAQgqB18wWrdMBJP2VgJ1s0eE++rcSs3OtLqAt5iMcVjZMs3QZ4wqnKyLSuxZIqFR
         WDmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LAABk+Hqn/ed3olCk7cLLnxGOLs8GPCl8qPvqmsVMMM=;
        b=GMV0xLBRPh9vjQeCtOGM3SDID0iVJTPsSEiuzWp9rU3EJwQD5W/OcGf/J2Ex8yCgLC
         zksBmOe09yFl2XIS30dAJJc3uHWmt57Tt+Gdu24PWTNcwxFo/EKwSMpDtPKK9BjBk+OX
         MTofjkEYvv9HVaN8+lKp8bfTO4ir9eNAjNYcGDMR96evDxqGL0JQiGfI/LoOXw4a/peG
         p71Lp3nT1TTTATQfilvjTp3pYqFa4e/rgrHFijgk/OhzK/bdZxewY23Rpg05WQFsgcYT
         rAA1XrvRBPntgBfX+etpv+IXe6FFWJM3XKnWiYF/DkZFD48UGiH7HUN0dCAVryRI11fw
         su4w==
X-Gm-Message-State: AOAM530VrdsbJBIVjadpWG5Ul8uD3DbAPWu6NdDYbur7sD8Hvmve8P/M
        1az96lV8ppwYaDf29vD6PZemhA==
X-Google-Smtp-Source: ABdhPJwaIsuvBtKuAQv+SmYbKWs22EAjLiyHSuubS0HBGDuWiWajxYniwE9CGElZZX7/xwqc39QOow==
X-Received: by 2002:a65:5b81:0:b0:3aa:1671:c6a7 with SMTP id i1-20020a655b81000000b003aa1671c6a7mr21224552pgr.169.1651743197230;
        Thu, 05 May 2022 02:33:17 -0700 (PDT)
Received: from [10.255.89.252] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id mu6-20020a17090b388600b001d960eaed66sm1054035pjb.42.2022.05.05.02.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 02:33:16 -0700 (PDT)
Message-ID: <ea42cb6e-cd1d-e0be-ab9f-382b75c070e8@bytedance.com>
Date:   Thu, 5 May 2022 17:29:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Re: PING: [PATCH v4 0/5] virtio-crypto: Improve performance
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20220424104140.44841-1-pizhenwei@bytedance.com>
 <cc9eb4aa-2e40-490f-f5a0-beee3a57313b@bytedance.com>
 <7f7ab8ae46174ed6b0888b5fbeb5849b@huawei.com>
 <20220505005607-mutt-send-email-mst@kernel.org>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20220505005607-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 5/5/22 12:57, Michael S. Tsirkin wrote:
> On Thu, May 05, 2022 at 03:14:40AM +0000, Gonglei (Arei) wrote:
>>
>>
>>> -----Original Message-----
>>> From: zhenwei pi [mailto:pizhenwei@bytedance.com]
>>> Sent: Thursday, May 5, 2022 10:35 AM
>>> To: Gonglei (Arei) <arei.gonglei@huawei.com>; mst@redhat.com;
>>> jasowang@redhat.com
>>> Cc: herbert@gondor.apana.org.au; linux-kernel@vger.kernel.org;
>>> virtualization@lists.linux-foundation.org; linux-crypto@vger.kernel.org;
>>> helei.sig11@bytedance.com; davem@davemloft.net
>>> Subject: PING: [PATCH v4 0/5] virtio-crypto: Improve performance
>>>
>>> Hi, Lei
>>>
>>> Jason replied in another patch:
>>> Still hundreds of lines of changes, I'd leave this change to other maintainers to
>>> decide.
>>>
>>> Quite frankly, the virtio crypto driver changed only a few in the past, and the
>>> performance of control queue is not good enough. I am in doubt about that this
>>> driver is not used widely. So I'd like to rework a lot, it would be best to complete
>>> this work in 5.18 window.
>>>
>>> This gets different point with Jason. I would appreciate it if you could give me
>>> any hint.
>>>
>>
>> This is already in my todo list.
>>
>> Regards,
>> -Gonglei
> 
> It's been out a month though, not really acceptable latency for review.
> So I would apply this for next,  but you need to address Dan Captenter's
> comment, and look for simular patterns elesewhere in your patch.
> 

I fixed this in the v5 series. Thanks!

-- 
zhenwei pi
