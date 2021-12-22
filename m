Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CDCC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 14:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbhLVOq7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 09:46:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343591AbhLVOq5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 09:46:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640184416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9gcyPWh8veARTOFyykIJ1v+FqxdAa2cAjT6Y8PmLnx8=;
        b=YtHt9B5gOKCNCpGpvvv7KsMxRwbKHCWyfoyn/TLdNqiHxoW69r69Dz5XYEeH8zkQxBFg7S
        A33doodbHsrI6QK1iGrla1O2t7TmiKGfENCjmUXtjbARY5qMCwpv01gIqLVqtJca8NVltm
        W89yF6vQd5Monh/6xDVi6krjqQ5hPC0=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-vNVIw_FrMZKDd72IEO_1dg-1; Wed, 22 Dec 2021 09:46:54 -0500
X-MC-Unique: vNVIw_FrMZKDd72IEO_1dg-1
Received: by mail-oo1-f70.google.com with SMTP id k8-20020a4a4308000000b002c6b67d6b05so1251122ooj.15
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 06:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9gcyPWh8veARTOFyykIJ1v+FqxdAa2cAjT6Y8PmLnx8=;
        b=gl0e/hSnfVKoGw8CgipADyb5QJbIFO11k2Flo5XlKPTGA4tLYaxr37kj1C+YmklZTQ
         YB5Kn6fzXurqBEiad1G9bAR13VHFpDm/1wB+5QF5PY9YthlVI7bRTAE1eGFkFDO/SRGu
         92gpsqdUO/MBfsgOfbyYSH4zLxkc4ap7miws4iau7nRvPS0j2tJdtUiVHlFlFQLtggA5
         CluVo9eiTuuaWT2F0yrKqmbE24Yj3MighXuJLa3yH2o8Uzq7K81JoIeAEjHb5Qujk43v
         4rqjXTv5g5tvLF2mRcuJycmiKGFojJsOSXbxpPhlm+KwjcLn7rzAIUkeYtqcR1z+S2z0
         kA+g==
X-Gm-Message-State: AOAM533FXzq/QvfmNWTBmTLgLy/b0zT1RmoRLbwQ+YFw9iLvHVyUxs6I
        eO/xUNZpQHID8xYuwLtoDBQ63hlxyGuJYLY4SA4CvGQgp3wLDCghdPXPuy+7x+mr9V9brMn+gnN
        QbidBThFRkhBWxHedKiLHg9nP
X-Received: by 2002:a9d:64d4:: with SMTP id n20mr2169950otl.328.1640184413992;
        Wed, 22 Dec 2021 06:46:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWGq5v3Wbtrh4PeU7H62cWTdK5USh26sBwa/v72QaoEC128SxOE0jV+vaOf9/lS2lEuLJKNg==
X-Received: by 2002:a9d:64d4:: with SMTP id n20mr2169944otl.328.1640184413798;
        Wed, 22 Dec 2021 06:46:53 -0800 (PST)
Received: from localhost.localdomain (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id e20sm388241oiw.32.2021.12.22.06.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 06:46:53 -0800 (PST)
Subject: Re: [PATCH] crypto: cleanup warning in qm_get_qos_value()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, ndesaulniers@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20211221205953.3128923-1-trix@redhat.com>
 <YcJHoqXXVFZatIla@archlinux-ax161>
From:   Tom Rix <trix@redhat.com>
Message-ID: <73952545-2236-6065-3016-543e8d503c06@redhat.com>
Date:   Wed, 22 Dec 2021 06:46:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YcJHoqXXVFZatIla@archlinux-ax161>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 12/21/21 1:31 PM, Nathan Chancellor wrote:
> On Tue, Dec 21, 2021 at 12:59:53PM -0800, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> Building with clang static analysis returns this warning:
>>
>> qm.c:4382:11: warning: The left operand of '==' is a garbage value
>>          if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
>>              ~~~~ ^
>>
>> The call to qm_qos_value_init() can return an error without setting
>> *val.  So check ret before checking *val.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
>
> Should this have a fixes tag?

I was debating that, the existing if-check will catch this, just not as 
efficiently.

I'll add the line.

Tom

>
> Fixes: 72b010dc33b9 ("crypto: hisilicon/qm - supports writing QoS int the host")
>
>> ---
>>   drivers/crypto/hisilicon/qm.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
>> index b1fe9c7b8cc89..c906f2e59277b 100644
>> --- a/drivers/crypto/hisilicon/qm.c
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -4379,7 +4379,7 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
>>   		return -EINVAL;
>>   
>>   	ret = qm_qos_value_init(val_buf, val);
>> -	if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
>> +	if (ret || *val == 0 || *val > QM_QOS_MAX_VAL) {
>>   		pci_err(qm->pdev, "input qos value is error, please set 1~1000!\n");
>>   		return -EINVAL;
>>   	}
>> -- 
>> 2.26.3
>>

