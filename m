Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52021C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 03:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbiEMDyV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 May 2022 23:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376865AbiEMDyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 May 2022 23:54:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF5E663C1
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2022 20:54:17 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 137so6379988pgb.5
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2022 20:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Sdy4JWVMgzouLiUuz2tCTiM3qS000Ug614pPLg974GQ=;
        b=vqmu5UC4sY7X1lyXBtg1p5wMTx2LVa+3jvsaYuBa7srCB3GpZmRcvIFiQp2vfTU7Pv
         eSvBoLoNz/ttuBceOcbDJC3+hDuAwLxsCp84eOjzJHNlfPdk8s9z4Eym7jLPQEVplVzD
         ldq1aPWqSRKQjTCK5w610yr6sbWTa9OV1zGehsH9rGw7raf15KRqvPAbvreobdWWtmWz
         A6251J8zMKkeyYW/XLUXPgFW3QYz9ZXSixbZChOvA8jL040euOQVEf7DRqiHKKNlvGf/
         GbrxwHbx//ztt7/1T8MiZ2NIGZI9GV6Ryv4afc0ypp+fzj/32u8mZndEvSzZb+POdiWz
         Vodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sdy4JWVMgzouLiUuz2tCTiM3qS000Ug614pPLg974GQ=;
        b=Hf//nhV3xO0QfTOYX5HjCz5Tq+ZoawPDmVJ372q6n4CLsuxrgxmz/9/Xjep5PuzrrE
         3q9144GWGqYFAuwbwKq0WIqTHUVUmj1qQX5npIrbeowtrfSL0kGssSKBfwQiwB3FQXOm
         B36/Mkk1i/dyJAP5P5q5HHNWPQgpCFWf6ykohngBWurVUmsLd0PB9DOkOhUkgXIrKytP
         h7GTX29BkWhQN4uQZndxKM6T/DIMeuXEiEz+R1LjgX9dBWiZMUYsjDGis+7+tvHD63Nj
         g1ZC3u+OGVsmKU4MDeA5pv58ZhpOeiLkCPUf7px59aBpkWkT37StM7Xp5t171tXsGOap
         Z8aA==
X-Gm-Message-State: AOAM533jKckX/LnDsOzZ30J3r4/eeWgeRO9yszIhY9KGyK/PY7ZXEhR/
        fzxbmgyKaEzKDm+K2bzRBgT4IA==
X-Google-Smtp-Source: ABdhPJyMwqzVGhhlXUsB2d/mXiL8fGEDAMUZIgY+YPHRDqo7t6DyFSdT21UUHdeLYUoWnpc5riIUeQ==
X-Received: by 2002:a65:6e82:0:b0:381:71c9:9856 with SMTP id bm2-20020a656e82000000b0038171c99856mr2357297pgb.316.1652414056895;
        Thu, 12 May 2022 20:54:16 -0700 (PDT)
Received: from [10.255.89.252] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id y124-20020a62ce82000000b0050dc76281f9sm566919pfg.211.2022.05.12.20.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 20:54:16 -0700 (PDT)
Message-ID: <67aedc07-96d7-4078-611e-a01b3a93904f@bytedance.com>
Date:   Fri, 13 May 2022 11:50:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Re: [PATCH v5 1/9] virtio-crypto: header update
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-2-pizhenwei@bytedance.com>
 <YnzZhjwbD6PaKx+2@redhat.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <YnzZhjwbD6PaKx+2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Daniel

Something I do in my local branch(for the v6 series):
- [PATCH v5 1/9] virtio-crypto: header update
- [PATCH v5 3/9] crypto: Introduce akcipher crypto class
   Add 'Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>'

- [PATCH v5 4/9] crypto: add ASN.1 DER decoder
- [PATCH v5 7/9] test/crypto: Add test suite for crypto akcipher
   Fixed the issues you pointed out.

Do you have suggestions about the other patches? Or I'll send the v6 series?

On 5/12/22 17:55, Daniel P. Berrangé wrote:
> On Thu, Apr 28, 2022 at 09:59:35PM +0800, zhenwei pi wrote:
>> Update header from linux, support akcipher service.
>>
>> Reviewed-by: Gonglei <arei.gonglei@huawei.com>
>> Signed-off-by: lei he <helei.sig11@bytedance.com>
>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>> ---
>>   .../standard-headers/linux/virtio_crypto.h    | 82 ++++++++++++++++++-
>>   1 file changed, 81 insertions(+), 1 deletion(-)
> 
> I see these changes were now merged in linux.git with
> 
>    commit 24e19590628b58578748eeaec8140bf9c9dc00d9
>    Author:     zhenwei pi <pizhenwei@bytedance.com>
>    AuthorDate: Wed Mar 2 11:39:15 2022 +0800
>    Commit:     Michael S. Tsirkin <mst@redhat.com>
>    CommitDate: Mon Mar 28 16:52:58 2022 -0400
> 
>      virtio-crypto: introduce akcipher service
>      
>      Introduce asymmetric service definition, asymmetric operations and
>      several well known algorithms.
>      
>      Co-developed-by: lei he <helei.sig11@bytedance.com>
>      Signed-off-by: lei he <helei.sig11@bytedance.com>
>      Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>      Link: https://lore.kernel.org/r/20220302033917.1295334-3-pizhenwei@bytedance.com
>      Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>      Reviewed-by: Gonglei <arei.gonglei@huawei.com>
> 
> 
> And the changes proposed here match that, so
> 
>    Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
> 
> 
> With regards,
> Daniel

-- 
zhenwei pi
