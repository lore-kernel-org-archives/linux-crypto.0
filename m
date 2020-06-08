Return-Path: <SRS0=nn+h=7V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0424C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 02:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CD32078C
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 02:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="izDTLbNF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgFHCyd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Jun 2020 22:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgFHCya (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Jun 2020 22:54:30 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FFEC08C5C3
        for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2020 19:54:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ne5so2672852pjb.5
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2020 19:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=TNiiby0GhibJHmG02ytGWtb3GrXv/h2IE3SFE6qK8wY=;
        b=izDTLbNFapAPFawYa8bP5L1UpCxlkSTCCzx2ye/9STM1DqXymdysNnGkX12FV0/OIo
         tKcjXEIEuxSNO572pWS545T9DoQqGqTM8DmMcj/pjObZb/s4KuucXPV8lxnGJsPOEWOP
         creFxg4Q8lnO5UPN6FiY9AkscKdJteM1nKY+Qmci5RctGzZp1Lm8RhpxAeqkzQiUCQxI
         Gn/htYffz0hnLWeWv7zjKwwzU0TiNbE2IVaAoUldJmQdAcEGN9qicP3+rskQKiUOfzQ9
         T1+IF9bYkLx6QP/gZ6BWN651hoOpft0Cc6Lq2cjMJoEoVussc3m5Gv9e47HSM5NkG+Yl
         PSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TNiiby0GhibJHmG02ytGWtb3GrXv/h2IE3SFE6qK8wY=;
        b=ZoQlRBcjiiRY0gk86AASDBMIwDEQTNTL7ldmT49HjxoW/hKuX6jfbd8I/HKS8PSPq0
         ZAl17Hn9k1RuAvLzgjG0UCTSviqZYhoIsJqPX8ESGE7KtZp83kLAzzHRlBJmfCY8DZUR
         E1XEFvpgbdnSA0IHUW6zAVOp8DwuMQLtGp6foOOLkRVLXKg1rpFnT47Jhs94Bmne8KCl
         c9DaFQltAVY5WZCyKxH/3QrR0Z6kaScxb2d4TNUqNAKlaHOM0hEoeGd0NsfXakIDVA2M
         2BeczfWBDeczgkTSjj0Q4rbOoXX/Oq+lPsr3bxJxP2sQFer00MwxVeVrC3+S/EpRZX+Y
         ktSg==
X-Gm-Message-State: AOAM5302dgUmmo9p2Y5S5QdcP3ndY+McMtL/DVrgOVZmFW+YrELv5b43
        uAl31gj7YGIjYO6tBPQ7TmSGrA==
X-Google-Smtp-Source: ABdhPJxkqD1zFPHkx/wch8a4hS4Dcd7qZB1Ug7k+ig+u/wKNnkcnbqH/JdvGWQP6MIHxl1bz+Ni7fQ==
X-Received: by 2002:a17:90a:f3c4:: with SMTP id ha4mr15260604pjb.18.1591584870012;
        Sun, 07 Jun 2020 19:54:30 -0700 (PDT)
Received: from [10.80.2.98] ([45.135.186.73])
        by smtp.gmail.com with ESMTPSA id t9sm9533489pjs.16.2020.06.07.19.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 19:54:29 -0700 (PDT)
Subject: Re: [PATCH 0/2] Introduce PCI_FIXUP_IOMMU
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        jean-philippe <jean-philippe@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <20200605231909.GA1155454@bjorn-Precision-5520>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <be91b0f0-c685-789d-6868-1c8ebd62b770@linaro.org>
Date:   Mon, 8 Jun 2020 10:54:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200605231909.GA1155454@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Bjorn

On 2020/6/6 上午7:19, Bjorn Helgaas wrote:
> On Thu, Jun 04, 2020 at 09:33:07PM +0800, Zhangfei Gao wrote:
>> On 2020/6/2 上午1:41, Bjorn Helgaas wrote:
>>> On Thu, May 28, 2020 at 09:33:44AM +0200, Joerg Roedel wrote:
>>>> On Wed, May 27, 2020 at 01:18:42PM -0500, Bjorn Helgaas wrote:
>>>>> Is this slowdown significant?  We already iterate over every device
>>>>> when applying PCI_FIXUP_FINAL quirks, so if we used the existing
>>>>> PCI_FIXUP_FINAL, we wouldn't be adding a new loop.  We would only be
>>>>> adding two more iterations to the loop in pci_do_fixups() that tries
>>>>> to match quirks against the current device.  I doubt that would be a
>>>>> measurable slowdown.
>>>> I don't know how significant it is, but I remember people complaining
>>>> about adding new PCI quirks because it takes too long for them to run
>>>> them all. That was in the discussion about the quirk disabling ATS on
>>>> AMD Stoney systems.
>>>>
>>>> So it probably depends on how many PCI devices are in the system whether
>>>> it causes any measureable slowdown.
>>> I found this [1] from Paul Menzel, which was a slowdown caused by
>>> quirk_usb_early_handoff().  I think the real problem is individual
>>> quirks that take a long time.
>>>
>>> The PCI_FIXUP_IOMMU things we're talking about should be fast, and of
>>> course, they're only run for matching devices anyway.  So I'd rather
>>> keep them as PCI_FIXUP_FINAL than add a whole new phase.
>>>
>> Thanks Bjorn for taking time for this.
>> If so, it would be much simpler.
>>
>> +++ b/drivers/iommu/iommu.c
>> @@ -2418,6 +2418,10 @@ int iommu_fwspec_init(struct device *dev, struct
>> fwnode_handle *iommu_fwnode,
>>          fwspec->iommu_fwnode = iommu_fwnode;
>>          fwspec->ops = ops;
>>          dev_iommu_fwspec_set(dev, fwspec);
>> +
>> +       if (dev_is_pci(dev))
>> +               pci_fixup_device(pci_fixup_final, to_pci_dev(dev));
>> +
>>
>> Then pci_fixup_final will be called twice, the first in pci_bus_add_device.
>> Here in iommu_fwspec_init is the second time, specifically for iommu_fwspec.
>> Will send this when 5.8-rc1 is open.
> Wait, this whole fixup approach seems wrong to me.  No matter how you
> do the fixup, it's still a fixup, which means it requires ongoing
> maintenance.  Surely we don't want to have to add the Vendor/Device ID
> for every new AMBA device that comes along, do we?
>
>
Here the fake pci device has standard PCI cfg space, but physical 
implementation is base on AMBA
They can provide pasid feature.
However,
1, does not support tlp since they are not real pci devices.
2. does not support pri, instead support stall (provided by smmu)
And stall is not a pci feature, so it is not described in struct 
pci_dev, but in struct iommu_fwspec.
So we use this fixup to tell pci system that the devices can support 
stall, and hereby support pasid.

Thanks
