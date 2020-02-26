Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0302C4BA06
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 01:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B128820732
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 01:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o80oA2ww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgBZBLi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 20:11:38 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46948 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729346AbgBZBLi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 20:11:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id k29so502112pfp.13
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2020 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=p+ckrLz3LRCoSFrfiU30gmbNyc8j6wjK1s1RA2TWajk=;
        b=o80oA2wwqENPftna7/zKRVKoL3DudW8CJuoNGJhKQurPflg4m7wY+s5rdqW1b+zdpW
         LoZWVXYuj2kyYWbb2fGxrBwXJpDzoAR7jwOjWCAh/sMSzynLVtPA7Jitj9iy3uJZeokJ
         BVZn+tnxjRxDXBaXScRBqhEb0zR8BnO6rSER1IyfwRTrfcHXbJ8p3T+zM9czSbbr4SMo
         0F5uag648+xMEEUTw6hyV+t66j69cLVziSXZ+qdsWweHC2VOPCrXrEGbUo6GZYMxVzvY
         aUIj/DiaWh8dZVW91xEsFwPIn1D4mAJUmGxxLjyYMHaRlpQYDeUO5fPrKkyqgjV55xXz
         l9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=p+ckrLz3LRCoSFrfiU30gmbNyc8j6wjK1s1RA2TWajk=;
        b=O/VFoTymOcrer3jKGFMMFeLi1Gb6ueePU6pK7fDt8ST4vMyXJRzZa7fYrCJhIiQjm4
         X9gag2WmXe1BDQkS2S42qiDiTBF9y0ttT8RpIMrpgmLHsgfzrLmOEe1jhDSt5uKZdKC8
         Bt9NWYV6++yEWI7xRF7b69eg49vq4C99Df0ZkOTZ99sv4ES7NYwDApWRoZyf0MRsBNz3
         1qawFuydG374BViI4NDAYEnk3+/OjjgI52bP27IIe9QDjyQABqUD1954v38pHcFsWDf/
         JPq9DiBQKy65AiQyY2CaeQ0bepNbGx+iCIcLDvAnazfMOrB0C40QOatHIDFrA3fDH0Qp
         aE3g==
X-Gm-Message-State: APjAAAWGd1vGjXInhtS6tfbl2R3BVUAhNsUUSQfeD5tgu9Fr4tPxAFi1
        g0+z38Y3eMx2OH0BqtJxpkbeyg==
X-Google-Smtp-Source: APXvYqwBrVhiEx4l0romklhpTH+y+CgXMko1VU+ZOxfZOJLkAj7ZLDO3KH4v0RJodC8aSrvfaOpG6g==
X-Received: by 2002:a62:19d1:: with SMTP id 200mr1501438pfz.26.1582679497101;
        Tue, 25 Feb 2020 17:11:37 -0800 (PST)
Received: from ?IPv6:240e:362:4c3:8800:a057:bb7f:18d7:2e? ([240e:362:4c3:8800:a057:bb7f:18d7:2e])
        by smtp.gmail.com with ESMTPSA id z10sm204892pgz.88.2020.02.25.17.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 17:11:36 -0800 (PST)
Subject: Re: [PATCH] MAINTAINERS: add maintainers for uacce
To:     Dave Jiang <dave.jiang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org
References: <1582611475-32691-1-git-send-email-zhangfei.gao@linaro.org>
 <b424d911-7293-0048-3270-0f7c1502c928@intel.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <0ed68faa-63f1-2bcb-6044-11629a610b9b@linaro.org>
Date:   Wed, 26 Feb 2020 09:11:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b424d911-7293-0048-3270-0f7c1502c928@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/2/26 上午12:02, Dave Jiang wrote:
>
>
> On 2/24/20 11:17 PM, Zhangfei Gao wrote:
>> Add Zhangfei Gao and Zhou Wang as maintainers for uacce
>>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> ---
>>   MAINTAINERS | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 38fe2f3..22e647f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17039,6 +17039,16 @@ W:    http://linuxtv.org
>>   S:    Maintained
>>   F:    drivers/media/pci/tw686x/
>>   +UACCE ACCELERATOR FRAMEWORK
>> +M:    Zhangfei Gao <zhangfei.gao@linaro.org>
>> +M:    Zhou Wang <wangzhou1@hisilicon.com>
>> +S:    Maintained
>> +F:    Documentation/ABI/testing/sysfs-driver-uacce
>> +F:    Documentation/misc-devices/uacce.rst
>> +F:    drivers/misc/uacce/
>> +F:    include/linux/uacce.h
>> +F:    include/uapi/misc/uacce/
>
> Mailing list for patch submission?
> +L: linux-accelerators@lists.ozlabs.org ?

Thanks Dave

How about adding both
linux-accelerators@lists.ozlabs.org
linux-kernel@vger.kernel.org
Since the patches will go to misc tree.

Thanks
