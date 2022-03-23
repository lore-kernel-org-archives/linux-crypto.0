Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C273C43219
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 16:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiCWQF1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiCWQFZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 12:05:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C0D140A1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 09:03:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u17so1817737pfk.11
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 09:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=URu1Cld800RCpFArjD3mILx4RS3EOY2glrIHlB2KP8Q=;
        b=VFfXM5YxFWV1n769LQtS6lAB0qgqL8kW45iyrLTKOyu5t09OX//Lc2kgTexCPwxO1m
         DNO1uQtVYMW07nVqiP70fusf6ZNhI64ed4YsTbhAeBGIIV7aNp98yBQ0ltlSZ74Lpjud
         2+hFvqsrpb9Y25jcKBsrfjnKPQwYspqQcVyM5zL5bHijVyY6qFs15Woa5NzsE24q0oCr
         Rkbx+JVO5LwjOfYRfg+5cdghuSGXQ6PQi/d6Lm3Y4UXa6BvLDd0fH3lXvIgi1rwa18rD
         kg5+i306FFdIa9psNvPEBu91D9OSZjRvRynBGzdx5mEQDjvukE8G1MbzsqRPxMXN6ymf
         gJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=URu1Cld800RCpFArjD3mILx4RS3EOY2glrIHlB2KP8Q=;
        b=zN2LRsUBv9H+YhduB7whGgsLQKCnSVmw0iNeyk6ksJXj4Tsh/PvtDTaf+7LWVTJHnL
         hWQ1MKKs0eHmJlmNoql59uqZIXQ78qoM+LtCDU27Cxc8ZlSQMsTZoWKUeJyzbIGBLH8e
         moxtGgCbDxTUE0W91oJSB5i1G//c0ZiE+ewT3hzlKqsNIy8h0hEWOG7eiM1FifcKfdEK
         vE3lPTeFWPcndC/ceMMf0ChDgxwpFYvA7iK9rgZtGoDY8RawY9VJLSqlBGw9xJB/8i9M
         iQAEQBqnKZmoxgRV+GPZfcGbMql4j4/htZE30WSUfbQowUY7APwJXnoyZaPsLJKYES1P
         4u2Q==
X-Gm-Message-State: AOAM530mv6XlszYIgieqBfHuaUmIv3xRkhwqD+4KDQZUqSe/pcVAL8g/
        jyLhxCOrEe50hGr87KoUaJl34w==
X-Google-Smtp-Source: ABdhPJwxGfSENN/9Lwi9Dj6rnEjBTulAhjGbko1yBhAsuIBmI8EdYx67EM0pJ0KJ8RIRRT7o4EbRQw==
X-Received: by 2002:a05:6a00:3309:b0:4fa:950b:d011 with SMTP id cq9-20020a056a00330900b004fa950bd011mr291249pfb.24.1648051433738;
        Wed, 23 Mar 2022 09:03:53 -0700 (PDT)
Received: from [10.255.146.117] ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id oa16-20020a17090b1bd000b001c72b632222sm7101041pjb.32.2022.03.23.09.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 09:03:41 -0700 (PDT)
Message-ID: <59113ffd-60c3-8036-d5c8-ca19908f0e65@bytedance.com>
Date:   Wed, 23 Mar 2022 23:59:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Re: [PATCH v3 1/6] virtio-crypto: header update
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com,
        herbert@gondor.apana.org.au, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, lei he <helei.sig11@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323024912.249789-2-pizhenwei@bytedance.com>
 <Yjs+7TYdumci1Q9h@redhat.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <Yjs+7TYdumci1Q9h@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/23/22 23:38, Daniel P. Berrangé wrote:
> On Wed, Mar 23, 2022 at 10:49:07AM +0800, zhenwei pi wrote:
>> Update header from linux, support akcipher service.
> 
> I'm assuming this is updated for *non-merged* Linux headers, since
> I don't see these changes present in current linux.git
> 
>>
Hi,

The related context link:
https://lkml.org/lkml/2022/3/1/1425

- The virtio crypto spec is the first part. It will be deferred to 1.3.
The latest version: 
https://www.oasis-open.org/committees/ballot.php?id=3681 (need put 
"__le32 akcipher_algo;" instead of "__le32 reserve;" and repost)

- According to the spec, then we can define the linux headers. (depend 
on the spec)

- Update the header file for QEMU. (depend on the linux headers)

All the parts are in development.

-- 
zhenwei pi
