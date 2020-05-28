Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FAEC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 06:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37C8207BC
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 06:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i9zZJ+TN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgE1GrM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 02:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE1GrL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 02:47:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60908C08C5C3
        for <linux-crypto@vger.kernel.org>; Wed, 27 May 2020 23:47:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id i17so2620513pli.13
        for <linux-crypto@vger.kernel.org>; Wed, 27 May 2020 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bofUGbEFbdnCpZWFs8DHvdOjPGm9ZoW5dSffBdf+/48=;
        b=i9zZJ+TNeNvRcNidmG6piUlVvLM12Ql3gwyE+1zs9+dJy5yzwRheejuryIIdaoZ4Oy
         PpqV4KZbIEBAopt3QeSB7kIlzfJ/gbWqRtjQdJUqsTEvr+QSDb1MpiutTS4mt27VJCUT
         wGolKhdBUMCO/4xP7K+wFV4wv+9gh0GtSNTZB22oVGKXEuXTwgUf3S6zOwCFXqSedPwS
         YFXT5ssn5iSuHWecgXg/mm3uDYHzC4v6XDBneViordfQVzOqzgDXeZa++mqrl38Mj+tu
         hrnxug4U/nOg29Qjc/NWFC05jy+tQ7In0/wAskn4wZvpS2yEdT1qW9PePMneSuSNMFTS
         bNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bofUGbEFbdnCpZWFs8DHvdOjPGm9ZoW5dSffBdf+/48=;
        b=BGgTplvXW4ckEYIhR3NYltYCeiqiBWui8Gj+zJlu7LzOHpvDU/JLzPJytvY1TqrOyH
         LUcrzXG5lDeqinVCh8ibAEi85rB4+bmgy2crjhu5mnYBXsF1QkUF0IzoG/XaV6L5nZdo
         RqbpQCFYOxxoIgD8sNLU3jGeM+PO+fEs1jg6dB/Pi+ZyDfc4dtwzlgpzaXzb0tQWc5Mb
         LtNaMGKIatM+Cv/O/mewxWJ49sRvt7w5qdWKwQQvTAi7GiWIHdjpqwYueWWY5i7Lk5+G
         NaMOLeGRty+VoxYnOnQxZCMaxh3ibbWuCdVLDm1xGZtepyPn4S5OgIHGMQ8B1eH+5XjZ
         k5ww==
X-Gm-Message-State: AOAM531I392ZU4FUQiAnorJ2rO33odDADLdGq1XUbkWzG5AbWJ6PHU/1
        M0Y72AvwcZ3gPfvyp+JmKoGH3w==
X-Google-Smtp-Source: ABdhPJxLtsDA5liLh4kIqfAgfwRAV1r9YEZbncwuClIEToyTcjpXKMtzdNc0SaVnvBbQN+Q0kn7IoQ==
X-Received: by 2002:a17:90a:de8b:: with SMTP id n11mr2312350pjv.87.1590648429749;
        Wed, 27 May 2020 23:47:09 -0700 (PDT)
Received: from [10.140.6.42] ([45.135.186.12])
        by smtp.gmail.com with ESMTPSA id 188sm3707241pfu.165.2020.05.27.23.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 23:47:09 -0700 (PDT)
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
References: <20200527181842.GA256680@bjorn-Precision-5520>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <83bd3d72-3a0c-d9b6-54ad-5bc0dbc5be7d@linaro.org>
Date:   Thu, 28 May 2020 14:46:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200527181842.GA256680@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Bjorn

On 2020/5/28 上午2:18, Bjorn Helgaas wrote:
> On Tue, May 26, 2020 at 07:49:07PM +0800, Zhangfei Gao wrote:
>> Some platform devices appear as PCI but are actually on the AMBA bus,
>> and they need fixup in drivers/pci/quirks.c handling iommu_fwnode.
>> Here introducing PCI_FIXUP_IOMMU, which is called after iommu_fwnode
>> is allocated, instead of reusing PCI_FIXUP_FINAL since it will slow
>> down iommu probing as all devices in fixup final list will be
>> reprocessed, suggested by Joerg, [1]
> Is this slowdown significant?  We already iterate over every device
> when applying PCI_FIXUP_FINAL quirks, so if we used the existing
> PCI_FIXUP_FINAL, we wouldn't be adding a new loop.  We would only be
> adding two more iterations to the loop in pci_do_fixups() that tries
> to match quirks against the current device.  I doubt that would be a
> measurable slowdown.
I do not notice the difference when compared fixup_iommu and fixup_final 
via get_jiffies_64,
since in our platform no other pci fixup is registered.

Here the plan is adding pci_fixup_device in iommu_fwspec_init,
so if using fixup_final the iteration will be done again here.

>
>> For example:
>> Hisilicon platform device need fixup in
>> drivers/pci/quirks.c handling fwspec->can_stall, which is introduced in [2]
>>
>> +static void quirk_huawei_pcie_sva(struct pci_dev *pdev)
>> +{
>> +    struct iommu_fwspec *fwspec;
>> +
>> +    pdev->eetlp_prefix_path = 1;
>> +    fwspec = dev_iommu_fwspec_get(&pdev->dev);
>> +    if (fwspec)
>> +        fwspec->can_stall = 1;
>> +}
>> +
>> +DECLARE_PCI_FIXUP_IOMMU(PCI_VENDOR_ID_HUAWEI, 0xa250, quirk_huawei_pcie_sva);
>> +DECLARE_PCI_iFIXUP_IOMMU(PCI_VENDOR_ID_HUAWEI, 0xa251, quirk_huawei_pcie_sva);
>>
>> [1] https://www.spinics.net/lists/iommu/msg44591.html
>> [2] https://www.spinics.net/lists/linux-pci/msg94559.html
> If you reference these in the commit logs, please use lore.kernel.org
> links instead of spinics.
Got it, thanks Bjorn.



