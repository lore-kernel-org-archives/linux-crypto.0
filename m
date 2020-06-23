Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D078C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 07:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59AE92073E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 07:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dvb9jWrW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgFWHsu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 03:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731588AbgFWHst (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 03:48:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC29C061796
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2020 00:48:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b5so9479830pgm.8
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2020 00:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=iXMHLbguntKcuTgr1nAq0fpxZctLmOVLPocRZ01HV1s=;
        b=Dvb9jWrWxYf0cUS7+mre8Ce7N6LCPCbgM4TfzIgO9x/j/Sz44QbFtHYcBvV6YcHykC
         /UOjUDAlRBaipXGhgPtfj5VOhd0MjmoLTxYmHS14ROKFa4k7B6adT6mjHgV2lQZYAb2L
         9lBtnjHKiulqZ7h6mF5QFFytTHA5SEJIAChcsfvKC0+xwvXLEhh4oJ/sXC4FDnOEad0q
         wFvAaXsf3se/vnfb3bW1sYXvPN+QVKdtP6yU8qG9ZHjQx6589ayIzIweyVGj7eNLSCdB
         qISGLxSJaNs+JUUvbM8FXzy2OTirEzU1whLCBwbJsuBLePOiMyrCufoYlY4bb/bJX8TB
         Kruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iXMHLbguntKcuTgr1nAq0fpxZctLmOVLPocRZ01HV1s=;
        b=bGVswk8V9vhIE2g62iRYeeLzhJBZgrs2ouacEH+gkfm/3fT3ZJpNppuKMYYeYZ6o3m
         naM0UXF1nRKiqpQhR/9NONCUj8lKuk9TGQto8T1ZczeI9quUzBcw9v3UZQl0MfqWwcl8
         vets8nCfk8F5sJ9lpl0x2/jPRr3atNURTzGL7ApoLfgo7WheVMCWPitz/DlvANUzFuJn
         r0HMkGvnXHIARGg3PcXRphV7LSijBM3Uyw5W5g1uYPvICQ7YcOvwYkYwD35v9N3YkS9v
         BypQE1PcsnvcrNe+OvQ9ezFxWOyVfvPnzOyH+zhYkgrMmc50FlTa30yRKAoSEDsMjWv7
         VdBQ==
X-Gm-Message-State: AOAM530mg27VAZLYmZcdK2mOZzaxsMOSnL9oQ9Peo+gqySlXenb3D+NX
        PhX5c8HqQYwq6f1UBr1UJQS5Ww==
X-Google-Smtp-Source: ABdhPJxwJ+AW8uQAXY8Win57SIEKcys5G+XsLikqbv6KNfk0Z4v0oLWW7NunPD5K78dMacn0DXTtuQ==
X-Received: by 2002:a62:f201:: with SMTP id m1mr25533751pfh.198.1592898529334;
        Tue, 23 Jun 2020 00:48:49 -0700 (PDT)
Received: from [10.37.1.30] ([45.135.186.125])
        by smtp.gmail.com with ESMTPSA id u6sm16409369pfc.83.2020.06.23.00.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 00:48:48 -0700 (PDT)
Subject: Re: [PATCH 0/2] Introduce PCI_FIXUP_IOMMU
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
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
References: <20200601174104.GA734973@bjorn-Precision-5520>
 <779f4044-cf6a-b0d3-916f-0274450c07d3@linaro.org>
 <20200622115536.GH3701@8bytes.org>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <d007cbea-85c0-6c75-fc4a-e2872ff59ea4@linaro.org>
Date:   Tue, 23 Jun 2020 15:48:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622115536.GH3701@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Joerg

On 2020/6/22 下午7:55, Joerg Roedel wrote:
> On Thu, Jun 04, 2020 at 09:33:07PM +0800, Zhangfei Gao wrote:
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
> That's not going to fly, I don't think we should run the fixups twice,
> and they should not be run from IOMMU code. Is the only reason for this
> second pass that iommu_fwspec is not yet allocated when it runs the
> first time? I ask because it might be easier to just allocate the struct
> earlier then.
Thanks for looking this.

Yes, it is the only reason calling fixup secondly after iommu_fwspec is 
allocated.

The first time fixup final is very early in pci_bus_add_device.
If allocating iommu_fwspec earlier, it maybe in pci_alloc_dev.
And assigning ops still in iommu_fwspec_init.
Have tested it works.
Not sure is it acceptable?

Alternatively, adding can_stall to struct pci_dev is simple but ugly too,
since pci does not know stall now.


Thanks



