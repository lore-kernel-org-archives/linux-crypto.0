Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2976EECAAD3
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Sep 2022 12:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIOMAA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Sep 2022 08:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIOL7q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2022 07:59:46 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C493D101D3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2022 04:59:43 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id bn9so21892368ljb.6
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2022 04:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=DNXgwpqPIIuqzQRBdCOMAHQNDRiIqcoEBtZfHuZEnuI=;
        b=Caj3VE0KYQ63gm0H/qtyEmckga6j2I/I7D55jcaHYjmqyDSv+ubOmSFBm4UwYiZwEj
         l+G7XHskToz21DpzHhpcowet1X5s99fybCUYrYGqmvYSQajPjWNsyM35vgnQylf8WslF
         TFptD8xDF9wbNgffePeb4NucCk0csVT+6TDTQM3HtyyoEnnhQb9sJF7QLHbxcEOM0Cn1
         Fxkr0iTDnGwtUnMREfoHSpNK0oXFYs8VGSbk6QtZGsXJLEvutY39a/HpQNwKYUxRW1Wg
         XzSxXM7/JI2VMbo61Ty688oRW5cx7Culg2iZuJtB52ntm7hRVMS6NL3XQo2OLAP6Pc1Y
         LwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=DNXgwpqPIIuqzQRBdCOMAHQNDRiIqcoEBtZfHuZEnuI=;
        b=2b4IWevxkeAm7MWhmn67JuqsBZ3bYkig9VBAOBjWd79enyvsnYpPgkVWcf0Am6ECgd
         T3loXfNiRCHnVYyvkOgrU+xvIMNHBAksag0wUTLvmeH/g9yMOWr39Ph98ScSy4WOD931
         hjg3S/PtjoDdBOShgoMnAgECkKbP4riU0djv9RwBaIB7qZog0TRmDEpKpjvwW7NEnF4Y
         U0FsqMXhW5GO33yxQ3LVHkO3fDhGfByzNlyTCBJBYXwq9caCeNmRtCM0vLagLtADLVFq
         h5GddwHpn7xC5ZAoQysuuRedOmR0B/YkPiIEnO0i20HiEoMI7H2vzUD16xD/hXNZlTWG
         A1fA==
X-Gm-Message-State: ACgBeo10eLTPz/ALJAc3IWKKXl38DbbNAWyUdr0+XUoR1+dPn6l1vTWx
        cd6anwkdu7Dy4gsyiwdqwe2XZn8aafQSmQ==
X-Google-Smtp-Source: AA6agR5IL9rhpZcQF9IYtFoiIZn0QLiK5ag2E6B4j9k5RGj66dITMVwJ1rApg5wOCUOIxxz9lCE/jA==
X-Received: by 2002:ac2:4c50:0:b0:49a:3768:da81 with SMTP id o16-20020ac24c50000000b0049a3768da81mr6504701lfk.247.1663242374833;
        Thu, 15 Sep 2022 04:46:14 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id 7-20020a2e0907000000b00261e7e7b698sm3096292ljj.123.2022.09.15.04.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 04:46:14 -0700 (PDT)
Message-ID: <2d24ed07-5501-5ee9-e2a9-34ef15216e28@linaro.org>
Date:   Thu, 15 Sep 2022 14:46:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 0/2] crypto: intel-fcs: Add crypto service driver for
 Intel SoCFPGA
Content-Language: en-GB
To:     wen.ping.teh@intel.com
Cc:     bjorn.andersson@linaro.org, catalin.marinas@arm.com,
        davem@davemloft.net, dinguyen@kernel.org,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawnguo@kernel.org, will@kernel.org
References: <20220914144137.605279-1-wen.ping.teh@intel.com>
 <20220915032506.641639-1-wen.ping.teh@intel.com>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220915032506.641639-1-wen.ping.teh@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15/09/2022 06:25, wen.ping.teh@intel.com wrote:
> From: wen.ping.teh@intel.com
> 
>> This patch introduces a crypto service driver for Intel SoCFPGA
>> family. The FPGA Crypto Service (FCS) includes a large set of security
>> features that are provided by the Secure Device Manager(SDM) in FPGA.
>> The driver provide IOCTL interface for user to call the crypto services
>> and send them to SDM's mailbox.
>>
>> Teh Wen Ping (2):
>>   crypto: intel-fcs: crypto service driver for Intel SoCFPGA family
>>   arm64: defconfig: add CRYPTO_DEV_INTEL_FCS
> Hi,
> 
> I just found out that there was a previous attempt to upstream this driver
> 2 years ago. It was NACK because it did not implement crypto API. Please
> drop this review.
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg44701.html
> 
> I will move this driver to drivers/misc.

I think the proper solution would be to implement the existing API first 
rather than adding a set of custom proprietary IOCTLs that nobody else 
is going to use.

-- 
With best wishes
Dmitry

