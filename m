Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBC8C7EE21
	for <linux-crypto@archiver.kernel.org>; Thu,  4 May 2023 08:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjEDIOe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 May 2023 04:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjEDINN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 May 2023 04:13:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCB749E7
        for <linux-crypto@vger.kernel.org>; Thu,  4 May 2023 01:10:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-305f0491e62so70094f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 May 2023 01:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683187846; x=1685779846;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AEAJhREXxkwkAjTPpZvPokj/zHXMm768UtibcSphYNk=;
        b=SqjBG+zFd6XMBtMilb+Gwi0u9nafhh3KXuO7ISOJsarAR/zv3ZYByiPrpVWhyGkKJZ
         hi95G8ZlaqOmjvUdp4f1BlxiVU9IOaatTlFylzbSLkfttqsrO04KDuqTgNLvYh8KDtXy
         bPmUlusPuEe2Qw8R4wE+ZaUtSzamBmkZk7kJ9FE/ER4mCOyDBqR1tNmoBgo/MayBtL2b
         gIQ2XDKgI0h6vSybtZiCjR7DIYy/BxxyhpBbepBq3iHyvF2eemvNxEB6CCzrcqZUWyLG
         CErKlb0ZcvsftbOrOOQq+mZ7g45h6gFdKhycA57YnpFjs2D7TQfuJg7eJw/I6u/fwMY3
         oM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683187846; x=1685779846;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEAJhREXxkwkAjTPpZvPokj/zHXMm768UtibcSphYNk=;
        b=HrchVzq7JrO9BXshI8eyccl0Igd/Bmu69gTUYw0cRhyai07HjhSvIKpr46m5I8W6ku
         HoVWtVnQKp4jBCZNNJ8kfKVjMDhg0QPU3qct1eWyFm9BhUfGhVEhLp/m5OGxYg4JlX9L
         IWO8rzuFIMICmimsnOpvsSN4H9UWWmkfHUhrTXkv+LT0X3aKajK3CY7d9/FH0WbwPtL8
         KF2nFSyYh7Zhu7fV2NORzKDjDhVe4hu/cgfCpwGKn1ENQWMvobM7yf1ACW/Mj9l1dODQ
         vREH4kWEag/P4hosinUpWuV2G7Ct010j9brDcZfCJca6uD5aZYxtbjKlwGtydZTVdbiI
         HUIg==
X-Gm-Message-State: AC+VfDwFcss0P53N7xAKhKZgae8Zjvsall9m+ez+Ie0kIt+2Z/ewTkRx
        JQXpF+QEq35wBfX+zeu9EI3NAQ==
X-Google-Smtp-Source: ACHHUZ5sn6tdEm0Ok1suzCgkzUiI4xCKFXzlcJ/N/zGU0MzqTZuwH6EMDL6/PxsXnxR2Harp3+n45w==
X-Received: by 2002:a5d:4904:0:b0:306:2d36:c6d4 with SMTP id x4-20020a5d4904000000b003062d36c6d4mr1929128wrq.31.1683187845788;
        Thu, 04 May 2023 01:10:45 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.230])
        by smtp.gmail.com with ESMTPSA id p17-20020a056000019100b002fda1b12a0bsm36135718wrx.2.2023.05.04.01.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 01:10:45 -0700 (PDT)
Message-ID: <41ddc20d-8675-d8bc-18c6-2a26f0d6b104@linaro.org>
Date:   Thu, 4 May 2023 09:10:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] hwrng: virtio - Fix race on data_avail and actual data
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, olivia@selenic.com,
        syzkaller-bugs@googlegroups.com, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
References: <00000000000050327205f9d993b2@google.com>
 <CACT4Y+awU85RHZjf3+_85AvJOHghoOhH3c9E-70p+a=FrRDYkg@mail.gmail.com>
 <ZFI9bHr1o2Cvdebp@gondor.apana.org.au>
 <ede92183-bef3-78a7-abae-335c6c5cca1e@linaro.org>
 <ZFMsvxW+pEZA2EZ7@gondor.apana.org.au>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <ZFMsvxW+pEZA2EZ7@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/4/23 04:55, Herbert Xu wrote:
> On Wed, May 03, 2023 at 12:19:30PM +0100, Tudor Ambarus wrote:
>>
>>> Reported-by: syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com
>>
>> Link: https://syzkaller.appspot.com/bug?extid=726dc8c62c3536431ceb
>>
>> Please add the dashboard link if applying as searching for the syzbot ID
>> rarely gives meaningful results.
> 
> The syzbot ID is already present in the in the Reported-by tag.
> There is no reason to clutter up the commit message with redundant
> information.
> 

As you prefer. Theodore Ts'o encourages to add a dashboard link, here's
his reasoning:
https://github.com/google/syzkaller/issues/3393#issuecomment-1347476434

Cheers,
ta
