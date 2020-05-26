Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3602C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 15:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFCB2070A
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 15:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D+4nQ0vW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgEZPKl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 11:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbgEZPKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 11:10:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B3FC03E96E
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2020 08:10:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so1546770pjh.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2020 08:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=zuN1PH7d2dfCgGQO7mbhwyoBsWzuZEv+CGEfJv0Zw+c=;
        b=D+4nQ0vWQOUObnvWLE2c2rqZVSpP4vHdMdjPbiYho4sYugLqtt6WRlJ+HEBBjO+1lQ
         2eR7eboY09he7DRe3bVtn422CDYVxb587PRQ/F+XM06FycTChxmMLph4uSQfy6rrhj88
         Uj/F+naAfokobOjg7tIBJp6aRXQKGJrWwM0M5NQhdl2IHrzkJZx4YN7V8c4YmU5AiA4m
         2klNrqpTzCwkPVLI9ZrzKuMoCf/oP8Y0Egww1cMRgelz+NygXiJoljRrWYfv9E+KnDQ2
         1VULYXUIQtH0XM1HRyfnK3yn7EbRcnN61uIfb9jjlWUJ7wTomFrOFYUYdUmZtFvN1GcP
         jAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zuN1PH7d2dfCgGQO7mbhwyoBsWzuZEv+CGEfJv0Zw+c=;
        b=eyHnPVcI3P6SpdZ2Eb0e8foLPi4emQM5IUrFMQyMDDmWDm4cao7ydHhvlegdivji3m
         2DWg/PXgAOVn0kly8x11Q1RyJfD1tW04PIn9RptLNJYm/Bo6hn7iY6BfdFN38WeQPyW7
         tCvN2qAq+shcMHo71Um4y/lTU7aCGxQnBe083dAbwTSVKjUrC+k4Wxq1e+G97ukc5B19
         M0o6+8XKSTfM5Cq5oD9BP+FLnXGWsA4EXN+jzw73MgM7UDZN7MytDbonz+D6bn9JC7xW
         Sig+K0t3s5yyM3MaeiK6UgUVIWbQ6XTJurtQ1t7zOk0taj7Kxe/b2Z8EUgeRwhP80a5h
         U7RQ==
X-Gm-Message-State: AOAM532eCqcCtLbXf2xYHS7b0fWq0Am9wXk10W6G2qa9fpaFKsmvKvxn
        HcF0npg5e+phFp5p0kyN87hYJw==
X-Google-Smtp-Source: ABdhPJwe+1sgmh2OwBptymAExtulFHEpnY96Q4RDulxomLppHnhiwFUYKKMDqrVR8wVFmvAPxb4eUQ==
X-Received: by 2002:a17:90a:1a17:: with SMTP id 23mr27507707pjk.198.1590505839978;
        Tue, 26 May 2020 08:10:39 -0700 (PDT)
Received: from [10.140.0.202] ([45.135.186.12])
        by smtp.gmail.com with ESMTPSA id i197sm3623225pfe.30.2020.05.26.08.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:10:39 -0700 (PDT)
Subject: Re: [PATCH 1/2] PCI: Introduce PCI_FIXUP_IOMMU
To:     Christoph Hellwig <hch@infradead.org>
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
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1590493749-13823-1-git-send-email-zhangfei.gao@linaro.org>
 <1590493749-13823-2-git-send-email-zhangfei.gao@linaro.org>
 <20200526144644.GA20784@infradead.org>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <39144dc0-3b04-3127-978b-bd8487dd06e0@linaro.org>
Date:   Tue, 26 May 2020 23:09:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526144644.GA20784@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Christoph

On 2020/5/26 下午10:46, Christoph Hellwig wrote:
> On Tue, May 26, 2020 at 07:49:08PM +0800, Zhangfei Gao wrote:
>> Some platform devices appear as PCI but are actually on the AMBA bus,
>> and they need fixup in drivers/pci/quirks.c handling iommu_fwnode.
>> Here introducing PCI_FIXUP_IOMMU, which is called after iommu_fwnode
>> is allocated, instead of reusing PCI_FIXUP_FINAL since it will slow
>> down iommu probing as all devices in fixup final list will be
>> reprocessed.
> Who is going to use this?  I don't see a single user in the series.
We will add iommu fixup in drivers/pci/quirks.c, handling

fwspec->can_stall, which is introduced in

https://www.spinics.net/lists/linux-pci/msg94559.html

Unfortunately, the patch does not catch v5.8, so we have to wait.
And we want to check whether this is a right method to solve this issue.

Thanks

