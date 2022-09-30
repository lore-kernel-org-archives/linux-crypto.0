Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC43DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 06:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiI3Gcp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 02:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiI3Gcm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 02:32:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD741F7EF7
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 23:32:37 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s26so3369564pgv.7
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 23:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3/r9sEUFsrXGDfR2A939Zx+57F6Hk0ETCIfd1KtmpRg=;
        b=rmmTyeDlrcMvucl2X8jk6lyNFKDDEWmaR1R4JCIcG898/vY5v/QeVWWbr7ND97HZXm
         jjLvF6wZNjMY29QFrhV+SvySRh5+x87c6qfpna+BvQkNsSVfc+gMOpL896GSnQCdD+ek
         ARz9Ah2SCAXym3K6YdRXhYuMFrEfU0d7HWvRmgxLanc/WwRPzE8JZrTMyiaczojlMQMA
         t6jsQAtYH2Prs8btPOienzHK6sKYqrnzWmlj0K9klmUYm/TYAkUf9tYEFlH5ZGQdTiaJ
         NxTnaNZBMdy5cNDXoo3fYw5Pt6JDEOD6oyf9mAVaQX/yGNdxADrTvLNSZoABBhn0aVwj
         EjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3/r9sEUFsrXGDfR2A939Zx+57F6Hk0ETCIfd1KtmpRg=;
        b=dksoKPq8vz6JX+fOFA9zk0NNl3Hc3nU7tWP+JKApJeT4yiZI/Np4HBZU6XhISWJee9
         SpjqtaFMU9upIB0K6RsqI/QcvYzVvceNA1TUaGOCVsj78kCnRPvSAanc4eyO7rWka7OY
         q9vlIYQ+zwwcLstobWTaM8b5+7rGBi+vcjGHY9dP5/bTZCF3YZulg0gyfg5tph3fDD8p
         m3kqGiiXu9ytP/U/09KBlIH0yiISZ6s5CqBb+F8z+OwnnPEHIQnBxR+zo0sRfDxeqCoG
         HQhTYtWZpcMq7mguBq2DiWQ2yG1vUr3oncaM6NKNCczfLJKcw0RKVo0BKDFnG2qHQBor
         sleg==
X-Gm-Message-State: ACrzQf1rV06WL/E2rTMSoTAOh/OKJQ5OveiuDbucoJD+GCVGyB0nqeU7
        O7Ko1JF9uO1tTs92qwiifHUSWw==
X-Google-Smtp-Source: AMsMyM75BgOGM6enaUG+dcjqUPmj+21zjwkjTEJhxTbztGdX3rV1Ju/EWf7NfE5uXStduInthENftw==
X-Received: by 2002:a63:f014:0:b0:43c:2ad9:ae9 with SMTP id k20-20020a63f014000000b0043c2ad90ae9mr6385345pgh.8.1664519556735;
        Thu, 29 Sep 2022 23:32:36 -0700 (PDT)
Received: from [10.76.53.66] ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id o1-20020a17090ab88100b00203059fc75bsm865642pjr.5.2022.09.29.23.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 23:32:36 -0700 (PDT)
Message-ID: <e8a49353-8ade-79c3-474d-90b5079f38ca@bytedance.com>
Date:   Fri, 30 Sep 2022 14:31:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Re: [PATCH v2 RESEND] virtio-crypto: fix memory-leak
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     mst@redhat.com, arei.gonglei@huawei.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220919075158.3625-1-helei.sig11@bytedance.com>
 <YzaJPuXVrB97ixvI@gondor.apana.org.au>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <YzaJPuXVrB97ixvI@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/30/22 14:14, Herbert Xu wrote:
> On Mon, Sep 19, 2022 at 03:51:58PM +0800, Lei He wrote:
>> From: lei he <helei.sig11@bytedance.com>
>>
>> Fix memory-leak for virtio-crypto akcipher request, this problem is
>> introduced by 59ca6c93387d3(virtio-crypto: implement RSA algorithm).
>> The leak can be reproduced and tested with the following script
>> inside virtual machine:
>>
>> #!/bin/bash
>>
>> LOOP_TIMES=10000
>>
>> # required module: pkcs8_key_parser, virtio_crypto
>> modprobe pkcs8_key_parser # if CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
>> modprobe virtio_crypto # if CONFIG_CRYPTO_DEV_VIRTIO=m
>> rm -rf /tmp/data
>> dd if=/dev/random of=/tmp/data count=1 bs=230
>>
>> # generate private key and self-signed cert
>> openssl req -nodes -x509 -newkey rsa:2048 -keyout key.pem \
>> 		-outform der -out cert.der  \
>> 		-subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=always.com/emailAddress=yy@always.com"
>> # convert private key from pem to der
>> openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER -out key.der
>>
>> # add key
>> PRIV_KEY_ID=`cat key.der | keyctl padd asymmetric test_priv_key @s`
>> echo "priv key id = "$PRIV_KEY_ID
>> PUB_KEY_ID=`cat cert.der | keyctl padd asymmetric test_pub_key @s`
>> echo "pub key id = "$PUB_KEY_ID
>>
>> # query key
>> keyctl pkey_query $PRIV_KEY_ID 0
>> keyctl pkey_query $PUB_KEY_ID 0
>>
>> # here we only run pkey_encrypt becasuse it is the fastest interface
>> function bench_pub() {
>> 	keyctl pkey_encrypt $PUB_KEY_ID 0 /tmp/data enc=pkcs1 >/tmp/enc.pub
>> }
>>
>> # do bench_pub in loop to obtain the memory leak
>> for (( i = 0; i < ${LOOP_TIMES}; ++i )); do
>> 	bench_pub
>> done
>>
>> Signed-off-by: lei he <helei.sig11@bytedance.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> Reviewed-by: Gonglei <arei.gonglei@huawei.com>
>> ---
>>   drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 4 ++++
>>   1 file changed, 4 insertions(+)
> 
> Patch applied.  Thanks.

Hi,

I noticed that MST has already applied on vhost branch.
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=vhost&id=1bedcf22c081a6e9943f09937b2da8d3ef52d20d

Thanks.

-- 
zhenwei pi
