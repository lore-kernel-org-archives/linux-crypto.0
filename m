Return-Path: <SRS0=py82=2N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364E2C2D0D0
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Dec 2019 13:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BEA820715
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Dec 2019 13:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y6kMDUZy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLWNnB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Dec 2019 08:43:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46030 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfLWNnB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Dec 2019 08:43:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so9198881pfg.12
        for <linux-crypto@vger.kernel.org>; Mon, 23 Dec 2019 05:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=wVTAxAkLybU/XzL/opvLLffdVLtU7bgXnpcg4bd91o4=;
        b=Y6kMDUZyIpXUhY/6S6BGldJrLa3Be3lQw1aP1BG6W+6jpQs0H94u4738rszDgOEhev
         yj1YEU5Dhi+0a5z+R8dlTKCFEuU7NWGPTiCqZMIE80senDFfhVqi6pcyZbipej4nkQ1d
         V6tESjmrSWYreiBea6tmcV267sBT5fNb09WlZ1BUoaTGrqGyrgi8V+t4P7pGb2ZnYemn
         JQiamP8GzVdx2hTRs/mV/QNsjP6r2E86kVtm2jS0pSsqEyoL0hwlTM8OUhoWzQLioUq1
         qo3tKYhZjjwuv5Wwu/PXS8Oo+fqbuCWVUjnmzjEaSEIUUYY3m7TB7K6FLeQseWDqYeP9
         DSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wVTAxAkLybU/XzL/opvLLffdVLtU7bgXnpcg4bd91o4=;
        b=dJBRgFmPzNKVoph8/SdwLXXZWOo9AldQVOhVoUXBHSqDCbtqfWIrtKJoe4TU4gHbfy
         0IGsvOP1qoKoieqbnozNsRClt+LClX6euRbuIJqDiHBt0KQJppSdOJnMzpnlayZLP0Tb
         f34q6bxhcGT8Maw3KeiTfuRHVfxaMNv8d3TDR8gtGnV8UtlzopOYwFCBDLUt6CEpcI73
         f853ynG4MpigB7Xq3sodloaAcsiqtpik3xsTAjMkkpfPYVyJr1EYfP2bf6jdcbDSrkPh
         DY5qEWZ+05rx1OGQUZys9AHZBv8g7VbjveuSSgmBmsecJRlCYTb9YkqzlOy+cDJkjDcu
         q4LA==
X-Gm-Message-State: APjAAAUo7pgru4L5YvM46jhMPV7qh7wzPeQlGxGoPqWvrYPtz5Fjxut7
        9B3qjz4u5oaoNgRUFOeqXyG/fg==
X-Google-Smtp-Source: APXvYqwmupBlYBUO32XRngGKnjqX9G8UnI7c7rx2T5XTS3rPO/gmjyWX42Do7N5EQcg90Wl/OdkwDQ==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr30692540pgd.135.1577108580760;
        Mon, 23 Dec 2019 05:43:00 -0800 (PST)
Received: from [192.168.11.202] (li1566-229.members.linode.com. [139.162.86.229])
        by smtp.gmail.com with ESMTPSA id z4sm21121512pjn.29.2019.12.23.05.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Dec 2019 05:43:00 -0800 (PST)
Subject: Re: [PATCH v10 0/4] Add uacce module for Accelerator
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
References: <1576465697-27946-1-git-send-email-zhangfei.gao@linaro.org>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <0e7f16b7-938b-402a-e3e3-2a0bed6fb708@linaro.org>
Date:   Mon, 23 Dec 2019 21:41:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1576465697-27946-1-git-send-email-zhangfei.gao@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Greg

On 2019/12/16 上午11:08, Zhangfei Gao wrote:
> Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
> provide Shared Virtual Addressing (SVA) between accelerators and processes.
> So accelerator can access any data structure of the main cpu.
> This differs from the data sharing between cpu and io device, which share
> data content rather than address.
> Because of unified address, hardware and user space of process can share
> the same virtual address in the communication.
>
> Uacce is intended to be used with Jean Philippe Brucker's SVA
> patchset[1], which enables IO side page fault and PASID support.
> We have keep verifying with Jean's sva patchset [2]
> We also keep verifying with Eric's SMMUv3 Nested Stage patches [3]
>
> This series and related zip & qm driver
> https://github.com/Linaro/linux-kernel-warpdrive/tree/v5.5-rc1-uacce-v10
>
> The library and user application:
> https://github.com/Linaro/warpdrive/tree/wdprd-upstream-v10
>
> References:
> [1] http://jpbrucker.net/sva/
> [2] http://jpbrucker.net/git/linux/log/?h=sva/zip-devel
> [3] https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
>
> Change History:
> v10:
> Modify the include header to fix kbuild test erorr in other arch.
>
>
> Kenneth Lee (2):
>    uacce: Add documents for uacce
>    uacce: add uacce driver
>
> Zhangfei Gao (2):
>    crypto: hisilicon - Remove module_param uacce_mode
>    crypto: hisilicon - register zip engine to uacce
>
>

Would you mind take a look at the patch set?

The patches are also used for verifying the sva feature.
https://lore.kernel.org/linux-iommu/20191219163033.2608177-1-jean-philippe@linaro.org/

Thanks
