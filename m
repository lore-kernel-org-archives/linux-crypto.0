Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D455C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 14:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiCWOmj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237353AbiCWOmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 10:42:38 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417B27E0A2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 07:41:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f3so423463pfe.2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 07:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9S4eZd/rXA3n6neAOpli6HJc1yfp+ivfWjQ96On7pkI=;
        b=QhZqkNggS08Iaw6ai+E2dKoy/D9zbMKsZp1q7bLscXQKKNTf2iXab7MnrMd1vBk6Er
         2MWstlzqkm6T21vy6t5M/3ndyjHsZso7L4CrkCYWu2ChTfnRgKwo2TgNg9RMXSEwp9MW
         GMfSOF1OQQWrio3KOet+GLNOTHxytfLoHtF+kYIrYQUtTUhN0AYpaR6IdBrjTJMNr6Xa
         /WpnT6wXbFhnN1OR2SQQcLPAGSXzDTvuuPs7jGWyBMTXLtrvgdhQoUgZl+dNRulOviAQ
         2iKSILaEbeGVSymi+LDckIyJJAyZtHlx8ZIVDLV3O/ut2zEsWbNgJXoV9+kUq9QMDIZ5
         mKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9S4eZd/rXA3n6neAOpli6HJc1yfp+ivfWjQ96On7pkI=;
        b=XkvlEE/VPMfrazm6O2UoE1+HaGzRewzY2R0EQDnos4DZ3VQUIhFpTN+2HGAbDLyLOw
         924iA3Q95sekGo4b1Q43xut8w7jtvJvdkDWhne+KTb+NFpfzserAAvhjPhveieND4Ojt
         TnMcpuVRGsnoRTGVeol90qhusDy+QQLflkssQrkgGfdoszp8qObY+r7v9tGVLxkmX9zL
         T/mfHZ0ElFT9t2ttj47J+aRlcxqLy1o+tezQrUikJJ1ptpZhQrxYJXIy8swQkAb3FdB/
         CqT9gSf6CYwJUg9cKn8iLddh+7W+IplkNHo1WC85g/9+08gVTYuEC50XnbbHWh5YoAk7
         8GtA==
X-Gm-Message-State: AOAM531RFiuTvXSN/h3dbSa/wXINQ0BT3RwZDK8O68Ml3CDbg2nIs3BI
        FvDFkoPYAr1GpTUSneG8mEkbDw==
X-Google-Smtp-Source: ABdhPJxs2YxbMDq4cFOUneNrKNpZMka1lWtg2y+oKbcBfOGQcS9WES0IMW0H8pPRUYmVwxqVrEN6wg==
X-Received: by 2002:a63:ae03:0:b0:386:2b5d:dd7d with SMTP id q3-20020a63ae03000000b003862b5ddd7dmr196912pgf.332.1648046467709;
        Wed, 23 Mar 2022 07:41:07 -0700 (PDT)
Received: from [10.255.146.117] ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id e11-20020a056a001a8b00b004fab740dbddsm166340pfv.105.2022.03.23.07.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 07:41:07 -0700 (PDT)
Message-ID: <f0b798fe-d341-775d-c722-1d05b99da0c3@bytedance.com>
Date:   Wed, 23 Mar 2022 22:37:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Re: [PATCH v3 0/6] Support akcipher for virtio-crypto
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323083558-mutt-send-email-mst@kernel.org>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20220323083558-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/23/22 20:36, Michael S. Tsirkin wrote:
> On Wed, Mar 23, 2022 at 10:49:06AM +0800, zhenwei pi wrote:
>> v2 -> v3:
>> - Introduce akcipher types to qapi
>> - Add test/benchmark suite for akcipher class
>> - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
>>    - crypto: Introduce akcipher crypto class
>>    - virtio-crypto: Introduce RSA algorithm
> 
> Thanks!
> I tagged this but qemu is in freeze. If possible pls ping or
> repost after the release to help make sure I don't lose it.
> 
Hi,

Daniel has started to review this patchset, according to Daniel's 
important suggestion, I'll rework this feature and post the next version 
later.

Thanks a lot!

-- 
zhenwei pi
