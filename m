Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF98EC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 08:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiBJIU6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 03:20:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiBJIU5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 03:20:57 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E465ADA9
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 00:20:58 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id l19so3127047pfu.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 00:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Krb0rzTOGW2eoN3LEJWPKbRX68tZZeijjPHmNpJEiuw=;
        b=X4RptU//lXEDz6B2GaWL43her2cGYbE8ScvsaqQ3JDFxx7ikqIOgZzJmDbrBWJYIH5
         qFWOEB6GALcHvoB9kXYuJR5deJQVuDVhdvONH8VdK58lVe8RJJ2CzniSMQ1IT643zYW3
         PN6gZCJ+G6BNsA4cbPKAjvuqSwBnwSOnQBKnoHWK9neRlFGmQHS9sscwrzLpDjmqa+P5
         FUlmw9/4CLC4p9yw8X3lg4aFSRFRPZ4EbOESz6GaPBadEFPM+5bEuIrlN0ioqc3YgVm4
         1Klc4wADjbs44eiQkPkkcIcqBJ7+CDOGUnPiLqXW+ynjBDI23rBhQQPAaQd3wWK2OTkO
         QWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Krb0rzTOGW2eoN3LEJWPKbRX68tZZeijjPHmNpJEiuw=;
        b=j5Djr643wkgoQa0EvGc3kmKhEZd83yrVk8YF9W51wvhKG+eKHni5EIKGCxSDrP3v7n
         8BniMaEYfu2ugoXOfKaE7KUujPdeAQkuI/7ikTqk2UahtIiBl7jr0tk/7VYQniW4LcE+
         wC1G4DKMT+LUOE9PV451xDstH5tdcTLhIUDQPGjd5bHAg1UjPvAGhfEyn69K4onufCIH
         DPCl5p89DSBsauVVKDteCfu5L74YSlSkcduRXLeLP2/t5PtGWLB5UwVpN0hn7LSMC+47
         +l7tLTsFOB23vjrLB5LrYcQnV7qD/iPd1fhH+lGDG29gZy/aXH/RfuHIS1e+nCSHvpfH
         k03w==
X-Gm-Message-State: AOAM533oVaHrRdaqB6iGjhGN+rzxd5LN0fhPmaG8KA07Fmjin3JExFm6
        oLg5b3t0rLNfiMTtdeM/XrUqGQ==
X-Google-Smtp-Source: ABdhPJyK+1a3UQV6u+LP1EI1H/P04vpG2Owo6ZPLmkdSsqC12revmFlKMy2HiNOC46200H7wPK8xIg==
X-Received: by 2002:a63:81c8:: with SMTP id t191mr5242468pgd.321.1644481258472;
        Thu, 10 Feb 2022 00:20:58 -0800 (PST)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id p4sm21374590pfw.133.2022.02.10.00.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 00:20:57 -0800 (PST)
Subject: Re: RE: [PATCH 2/3] virtio-crypto: introduce akcipher service
To:     "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>,
        "mst@redhat.com" <mst@redhat.com>
References: <20220121022438.1042547-1-pizhenwei@bytedance.com>
 <20220121022438.1042547-3-pizhenwei@bytedance.com>
 <15e960491a684b649e5d0179a32848a2@huawei.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <540f29e4-12ef-3786-bd54-9a94ba6ee7ab@bytedance.com>
Date:   Thu, 10 Feb 2022 16:18:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <15e960491a684b649e5d0179a32848a2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>>   /* The accelerator hardware is ready */  #define
>> VIRTIO_CRYPTO_S_HW_READY  (1 << 0) @@ -442,6 +520,7 @@ struct
>> virtio_crypto_config {
>>   	__le32 reserve;
>>   	/* Maximum size of each crypto request's content */
>>   	__le64 max_size;
>> +	__le32 akcipher_algo;
>>   };
>>
> You can use the reserve attribute. Keeping 64-bit aligned.
> 
>>   struct virtio_crypto_inhdr {
>> --
>> 2.25.1
> 

Can I use the "__le32 reserve;" field directly?

struct virtio_crypto_config {
         /* See VIRTIO_CRYPTO_OP_* above */
         __le32  status;

         /*
          * Maximum number of data queue
          */
         __le32  max_dataqueues;

         /*
          * Specifies the services mask which the device support,
          * see VIRTIO_CRYPTO_SERVICE_* above
          */
         __le32 crypto_services;

         /* Detailed algorithms mask */
         __le32 cipher_algo_l;
         __le32 cipher_algo_h;
         __le32 hash_algo;
         __le32 mac_algo_l;
         __le32 mac_algo_h;
         __le32 aead_algo;
         /* Maximum length of cipher key */
         __le32 max_cipher_key_len;
         /* Maximum length of authenticated key */
         __le32 max_auth_key_len;
         __le32 reserve;            -->    __le32 akcipher_algo;
         /* Maximum size of each crypto request's content */
         __le64 max_size;
};

-- 
zhenwei pi
