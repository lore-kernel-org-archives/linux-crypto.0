Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0247DC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 12:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2DDA208B3
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 12:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J+ir68ua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgEZMHd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 08:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgEZMHc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 08:07:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511DFC03E96D
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2020 05:07:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t8so1263089pju.3
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2020 05:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fpsA7Nq2nxropNth7zUzBAVP9PJ+/EXl3l54pU3n9ZM=;
        b=J+ir68uaqgnC0bpUtYh7gEhKg91ecOFPaqozofq5uKsLc7Q5y3iFeqMqCZAJviMx+s
         5ig+pjzGqwz+mFaduqg65bildjvb3DkPZio13iXEBv0mAnfqdngUZrwP8cIh8JeTUCVJ
         gmFnjjcFBD8aNXil24SDu+Jkirv39gmumTTyj55+HgtSDlf8tVbBjh7E552efJG/Wjo8
         EJDaQDAdQwq7KwVsaMRKey6Y7TjZsMZCOt/LAThI6/92Dp0fkT6otf1CI6seawSCUyPt
         WoWoRsARBzdoihaCWqPAXG3jCyZxwI+pM2gsZxtGTudpYt/c710Xf3GM28FbeauVBfE6
         ryPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fpsA7Nq2nxropNth7zUzBAVP9PJ+/EXl3l54pU3n9ZM=;
        b=K0exZwdUMYeGFb7kmm9e9AojZhVlAWW1Ffhcx8u/r8sMF5E27RgqsvIlQcpmUdUmPj
         qxqX/lyx6ie8L3C2ljzCOclLdcIx+wWQZr4KxWb49V2hGNxPa+wiN6BP+K+qYy/9AO4W
         ZYxrpZdRrb/FFbTz46xjwNF0tLb5nFFf0Xb0gKEhDDmscWsohMUc22atHMJmAGNDqbV3
         l29uOSnJyMzQmEcsrX7qI4psRqvwNTGkLMOPG3T9WVcKfNY+WTk0NaZo9snTs9SSQdos
         03kuyRfkPlrOhkiVwtuoolarFAe5Bcsl4ttUFPT/MowQ9e8fj+/vvRRHcq55prLJsBI9
         OFnA==
X-Gm-Message-State: AOAM531pmHR04Nju7mxc6yo6XVDyLXPoe+j+I50+mOtVEzYYuKtBIXT9
        in7NSJSayFodNZbFDuI9CYXo0g==
X-Google-Smtp-Source: ABdhPJwJC/VIL8ph3znchjMxyQibr056u3YncVEhb6v6BwGdiIO+FoFmlj/9d7sAY/kJdEg5hx2xFg==
X-Received: by 2002:a17:902:6b02:: with SMTP id o2mr822931plk.25.1590494851770;
        Tue, 26 May 2020 05:07:31 -0700 (PDT)
Received: from [10.74.2.18] ([45.135.186.9])
        by smtp.gmail.com with ESMTPSA id x132sm15300133pfd.214.2020.05.26.05.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 05:07:30 -0700 (PDT)
Subject: Re: [PATCH 0/2] Let pci_fixup_final access iommu_fwnode
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
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
        linux-arm-kernel@lists.infradead.org
References: <1589256511-12446-1-git-send-email-zhangfei.gao@linaro.org>
 <20200525134318.GB5221@8bytes.org>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <7c6e9389-c34a-4d30-bc8d-572c41572d15@linaro.org>
Date:   Tue, 26 May 2020 20:07:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525134318.GB5221@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/5/25 下午9:43, Joerg Roedel wrote:
> On Tue, May 12, 2020 at 12:08:29PM +0800, Zhangfei Gao wrote:
>> Some platform devices appear as PCI but are
>> actually on the AMBA bus, and they need fixup in
>> drivers/pci/quirks.c handling iommu_fwnode.
>> So calling pci_fixup_final after iommu_fwnode is allocated.
>>
>> For example:
>> Hisilicon platform device need fixup in
>> drivers/pci/quirks.c
>>
>> +static void quirk_huawei_pcie_sva(struct pci_dev *pdev)
>> +{
>> +	struct iommu_fwspec *fwspec;
>> +
>> +	pdev->eetlp_prefix_path = 1;
>> +	fwspec = dev_iommu_fwspec_get(&pdev->dev);
>> +	if (fwspec)
>> +		fwspec->can_stall = 1;
>> +}
>> +
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_HUAWEI, 0xa250, quirk_huawei_pcie_sva);
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_HUAWEI, 0xa251, quirk_huawei_pcie_sva);
> I don't think it is a great idea to hook this into PCI_FIXUP_FINAL. The
> fixup list needs to be processed for every device, which will slow down
> probing.
>
> So either we introduce something like PCI_FIXUP_IOMMU, if this is
> entirely PCI specific. If it needs to be generic we need some fixup
> infrastructure in the IOMMU code itself.

Thanks Joerg for the good suggestion.
I am trying to introduce PCI_FIXUP_IOMMU in
https://lkml.org/lkml/2020/5/26/366

Thanks
