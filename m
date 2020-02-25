Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DBEC35DF5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 08:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A59820CC7
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 08:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DCYfGreF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgBYIhU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 03:37:20 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35196 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgBYIhU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 03:37:20 -0500
Received: by mail-pg1-f195.google.com with SMTP id 7so4446724pgr.2
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2020 00:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lesurzoUvSvfZ2EeEsmnXSXZFaFQRXcHJcV4OzRZYOs=;
        b=DCYfGreFPdhhVUKXFmeqvJ7SEwhie4HjOFGZRNvYH5SHGiV2hNKnZM5LLgrSEwuNK7
         ETetaQ1oMfVmaw3i9vzZIH/dJHU/aNeO2l1wNQw3Jk0AI7ENyeR5T7UPFpZ78lCsi/mv
         kgwfnufCzk/jHU/WRhl1aJXX8MoSfanEuNzEWfq6le+2X32btUn47Uln8Dc0XD0ZbgEJ
         RBVbcCdYViUIjt0SAfo8x3VSPfsgeOQzZ3YlESmTJ0yAIE2HbOtkc5SEViXCsGYjH40X
         Zniy5FQ2dnfIFvKYiV9vPy5iyjHXhmpX6OMC/q3DWm0AjGtMNhDEpxP9Nu4SWi6NCbn2
         1IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lesurzoUvSvfZ2EeEsmnXSXZFaFQRXcHJcV4OzRZYOs=;
        b=PyyzBUzvmz4upm3xaUyuatq5e9m/PyYUhG8PWCQQ2gcdegDorDQmGH2B5GjO9MNxk+
         MF+tEKXt1bEZ7fvvBqUnyRj+mG4KHVLaM+vygdNEztX4jNLXj7kP/4U5zUFc1QwIpvja
         wDHH5O5mAziz7M2cqhVTNNJnr9tVU1MMl594IMCsAGh5O9cnvHZ4neqlVf+NUuckeldq
         IEchevdHzSAx+BjtN2f3Om7d6zvAgu3UqrVR3G12+in+TH1eHQQ8TMljoNqMl+rr5rIB
         wAQb39WrANRRh84UpeHJEIDtFaDIq2UMdGllEsp+MH0zhxzPk/A+3WTfOBGru5uFbNz4
         KnhA==
X-Gm-Message-State: APjAAAXZfKAU/stt0P3LhQeiIbQAsLkWlLXziKEmOaq/te/eTrKLI9kk
        f4zOJaqsiQOkNeoCKTEkvwg9sg==
X-Google-Smtp-Source: APXvYqxEIXMkJNt5ttW3aixCV0507Pt6cLR5KGoDAfoWs6jkQMH5M+MdAxhMB11LIwT8PXIuxrhNDA==
X-Received: by 2002:a63:f70e:: with SMTP id x14mr55230760pgh.71.1582619839849;
        Tue, 25 Feb 2020 00:37:19 -0800 (PST)
Received: from ?IPv6:240e:362:421:7f00:524:e1bd:8061:a346? ([240e:362:421:7f00:524:e1bd:8061:a346])
        by smtp.gmail.com with ESMTPSA id c26sm16217660pfj.8.2020.02.25.00.36.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 00:37:19 -0800 (PST)
Subject: Re: [PATCH v12 2/4] uacce: add uacce driver
To:     "Raj, Ashok" <ashok.raj@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>, Ashok Raj <ashok.raj@intel.com>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
 <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
 <20200224182201.GA22668@araj-mobl1.jf.intel.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <81c5a532-468c-3316-83d2-b4fa027dbe0e@linaro.org>
Date:   Tue, 25 Feb 2020 16:36:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200224182201.GA22668@araj-mobl1.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Raj

On 2020/2/25 上午2:22, Raj, Ashok wrote:
> Hi Kenneth,
>
> sorry for waking up late on this patchset.
>
> +
> +static int uacce_fops_open(struct inode *inode, struct file *filep)
> +{
> +	struct uacce_mm *uacce_mm = NULL;
> +	struct uacce_device *uacce;
> +	struct uacce_queue *q;
> +	int ret = 0;
> +
> +	uacce = xa_load(&uacce_xa, iminor(inode));
> +	if (!uacce)
> +		return -ENODEV;
> +
> +	q = kzalloc(sizeof(struct uacce_queue), GFP_KERNEL);
> +	if (!q)
> +		return -ENOMEM;
> +
> +	mutex_lock(&uacce->mm_lock);
> +	uacce_mm = uacce_mm_get(uacce, q, current->mm);
> I think having this at open time is a bit unnatural. Since when a process
> does fork, we do not inherit the PASID. Although it inherits the fd
> but cannot use the mmaped address in the child.
>
> If you move this to the mmap time, its more natural. The child could
> do a mmap() get a new PASID + mmio space to work with the hardware.
>
Thanks for the suggestion.
We will consider fork in the next step, may need some time.

Thanks
