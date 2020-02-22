Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B22EC35641
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70B3920656
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mPktKWlv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgBVBxY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:53:24 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37718 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgBVBxY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 20:53:24 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so1637712plz.4
        for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2020 17:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=t2WN9Y6i+1sMeMmerTg/sIx0hN9tYd17GbQLJc7KWJ4=;
        b=mPktKWlv91J8zSVtP4T+e9BPp7EcbGwMkei5J/fBl3dBCAU7bzR0Gh9Hrdv25yYi9+
         KU5dPtNWsjM864SJ4zW/iT/MwY+dXe6EBn0QPYv5gaUfd537Ik6FOLz1nio5+5SPCACT
         H2zaNJsEkotdbxpnuzIDFodkNIKHUn62v1WuYFB7Flw6y4uugwe6ciVDBaAg/3DQTr7D
         yOYIWYs2ParfrKfXw8THe7ekRhRjoaUOIX3j0RtXRMw4/Rq89Y6QFmzWMmwrbXk9G6ZW
         YkPaP40q2o4cISWp+2fU2CXkLpsLcTJ/q7B27GoHMbSVvdbUrMMlVXIb/VXBqn2foHKb
         ww8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=t2WN9Y6i+1sMeMmerTg/sIx0hN9tYd17GbQLJc7KWJ4=;
        b=D3lIwnhhCHS8DumhT/ntPtkiT6ExbKmqYpn5H/Kjc14BvD/0FdmJkJmbFDbbGMec43
         14wsmcy2Bd15rmQ5NRukyRMfcfCBpRlvscUqkjYSpkZRGWwh9xuGRt1trhFYWi+plYkd
         zcmD6GBGRdw98RiwWt0tr+2Ym3Hqi90o4hUJhwk25OVL6Xfkl9tTxdfgeRPbcsf0pr8Y
         T0UdLfE3w/LVQvCtSxBcCohOISimbqnsj4Euyg5p1iI4+mjC9Zi0qbBbnj8jOiBNcWua
         /evKn7HQ5IKsTZFoWWtJJvwmj8X6LAnw1/BQ0MKIcwQ4wmODsG8cCdHh8//bsw2yFNUf
         5zyw==
X-Gm-Message-State: APjAAAXxmDOLXUVoDb6Ggg2pWE6mSoMqiMeKYrG+/l3Htc4hnBAf/pVe
        rvti8ol7HDT1iFXtCLtQfV0gyw==
X-Google-Smtp-Source: APXvYqzHrVqrmX9+Lk9w9FP91YPzkYcV0jkjab6rvQK3U4g9KuosSje8dbq9YgFdMYQh5L1aPjY6jQ==
X-Received: by 2002:a17:90a:cf08:: with SMTP id h8mr6352327pju.81.1582336401930;
        Fri, 21 Feb 2020 17:53:21 -0800 (PST)
Received: from ?IPv6:240e:362:47d:ee00:e13e:da52:2837:6aff? ([240e:362:47d:ee00:e13e:da52:2837:6aff])
        by smtp.gmail.com with ESMTPSA id 78sm1436422pge.58.2020.02.21.17.52.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Feb 2020 17:53:21 -0800 (PST)
Subject: Re: [PATCH v13 0/4] Add uacce module for Accelerator
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, jonathan.cameron@huawei.com,
        dave.jiang@intel.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org
References: <1581407665-13504-1-git-send-email-zhangfei.gao@linaro.org>
 <20200222014148.GC19028@gondor.apana.org.au>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <9048453c-530a-9063-b266-faa8d434015b@linaro.org>
Date:   Sat, 22 Feb 2020 09:52:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200222014148.GC19028@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/2/22 上午9:41, Herbert Xu wrote:
> On Tue, Feb 11, 2020 at 03:54:21PM +0800, Zhangfei Gao wrote:
>> Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
>> provide Shared Virtual Addressing (SVA) between accelerators and processes.
>> So accelerator can access any data structure of the main cpu.
>> This differs from the data sharing between cpu and io device, which share
>> data content rather than address.
>> Because of unified address, hardware and user space of process can share
>> the same virtual address in the communication.
>>
>> Uacce is intended to be used with Jean Philippe Brucker's SVA
>> patchset[1], which enables IO side page fault and PASID support.
>> We have keep verifying with Jean's sva patchset [2]
>> We also keep verifying with Eric's SMMUv3 Nested Stage patches [3]
>>
>> This series and related zip & qm driver
>> https://github.com/Linaro/linux-kernel-warpdrive/tree/v5.6-rc1-uacce-v13
>>
>> The library and user application:
>> https://github.com/Linaro/warpdrive/tree/wdprd-upstream-v13
>>
>>
>> Kenneth Lee (2):
>>    uacce: Add documents for uacce
>>    uacce: add uacce driver
>>
>> Zhangfei Gao (2):
>>    crypto: hisilicon - Remove module_param uacce_mode
>>    crypto: hisilicon - register zip engine to uacce
>>
>>   Documentation/ABI/testing/sysfs-driver-uacce |  39 ++
>>   Documentation/misc-devices/uacce.rst         | 176 ++++++
>>   drivers/crypto/hisilicon/qm.c                | 239 ++++++-
>>   drivers/crypto/hisilicon/qm.h                |  11 +
>>   drivers/crypto/hisilicon/zip/zip_main.c      |  49 +-
>>   drivers/misc/Kconfig                         |   1 +
>>   drivers/misc/Makefile                        |   1 +
>>   drivers/misc/uacce/Kconfig                   |  13 +
>>   drivers/misc/uacce/Makefile                  |   2 +
>>   drivers/misc/uacce/uacce.c                   | 617 +++++++++++++++++++
>>   include/linux/uacce.h                        | 161 +++++
>>   include/uapi/misc/uacce/hisi_qm.h            |  23 +
>>   include/uapi/misc/uacce/uacce.h              |  38 ++
>>   13 files changed, 1337 insertions(+), 33 deletions(-)
>>   create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
>>   create mode 100644 Documentation/misc-devices/uacce.rst
>>   create mode 100644 drivers/misc/uacce/Kconfig
>>   create mode 100644 drivers/misc/uacce/Makefile
>>   create mode 100644 drivers/misc/uacce/uacce.c
>>   create mode 100644 include/linux/uacce.h
>>   create mode 100644 include/uapi/misc/uacce/hisi_qm.h
>>   create mode 100644 include/uapi/misc/uacce/uacce.h
> All applied.  Thanks.
That's Great,
Thanks Herbert for the great help.


