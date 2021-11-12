Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361A1C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F67B60C4A
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhKLKfA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 05:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhKLKe7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 05:34:59 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A708C06127A
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 02:32:08 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 207so17644439ljf.10
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 02:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oIInsHoJtPspQu2JlNxneTffyvc0sq43xk24340ZzN8=;
        b=zFFoS6w0vBeC3X9Bq4WTDSuGKzhXq3DnF8UpAAfEnQwQafE/yIdNVgIVLNO5xGpdmq
         670H/g+uSAelYyN9JZURAYGghQrY9yPZ7Q829BDE1BdCBklLVDLYBtKnrf9CbJ71Hhoo
         MHxhdfhtXl+dMQpzCW6yzrwzHZNUEeQ1PtZXlzjhTs7eVtUVaNbgUXZHGNtFS3q/z+f4
         Ao4IBzKHsYsLG0b/3Ljtf3Enp4lJd4JBzwd1Q6gj4aOykyDtGPQtRl58xL1pVfDbRKxp
         k9x7nzA//y8afIIrKMH76Zsh5TZf3gdl4YT0GLRjwgATcQIr6q8U1D8x7Rv7v5oXTKXf
         mEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oIInsHoJtPspQu2JlNxneTffyvc0sq43xk24340ZzN8=;
        b=b1ALcqL66NI56t2bsQYOP6UmTPisXrRBb1uyIm2RA33ROwYSx+cv1qxOMsK22f/1GL
         L+14F8nKwvZVTSo+1aeQjvEjTzB+sLkH/7QyT9tAWXnfpjMAZhCitN5QpGhShD2lroFy
         k2I4A2nKzNWbYmXYB1BSTbp6/gs0hNbcI8JXC6jWtJK1p1KrOGrXhZrTe03A9MlB443X
         bzAJM12CHAFVhOzcSntwN35abMGqosL1yabDqUnKgqcI12cBhbhbRPoBDhzlOotnHJ2Z
         nq7h72X4lgIav6UcQj9tVbyNMY7zDkWmrj6cbm7srvcyXTyKSgR6aCREyc4MnMUeBuHm
         kLcQ==
X-Gm-Message-State: AOAM532nepIN2dNf/z1ItSgmZ45VxEs4dVCi0GBI6s7lJkRRYSvm1tBL
        4J4MYpcoSW1NZQOxk+X22X2LvQ==
X-Google-Smtp-Source: ABdhPJycDOSgO1LjddtCMBo1bAMldNS+GVeAguKQrsogA8R83WNB5vfhntvLQI8G1XO7RHvUlgEc9A==
X-Received: by 2002:a2e:81d2:: with SMTP id s18mr14425824ljg.223.1636713126826;
        Fri, 12 Nov 2021 02:32:06 -0800 (PST)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id k14sm584741lfu.210.2021.11.12.02.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 02:32:06 -0800 (PST)
Subject: Re: [PATCH v5 13/22] dma: qcom: bam_dma: Add support to initialize
 interconnect path
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-14-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <5fe9bb9f-ded6-1aa4-347f-ef5cd0b21358@linaro.org>
Date:   Fri, 12 Nov 2021 12:32:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211110105922.217895-14-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 11/10/21 12:59 PM, Bhupesh Sharma wrote:
> From: Thara Gopinath <thara.gopinath@linaro.org>
> 
> BAM dma engine associated with certain hardware blocks could require
> relevant interconnect pieces be initialized prior to the dma engine
> initialization. For e.g. crypto bam dma engine on sm8250. Such requirement
> is passed on to the bam dma driver from dt via the "interconnects"
> property.  Add support in bam_dma driver to check whether the interconnect
> path is accessible/enabled prior to attempting driver intializations.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> [Make header file inclusion alphabetical and use 'devm_of_icc_get()']
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>

please let me ask you to swap your and Thara's sob tags above, there is
a rule applicable to all cases dealing with someone's else changes:

 From Documentation/process/submitting-patches.rst:

   Any further SoBs (Signed-off-by:'s) following the author's SoB are from
   people handling and transporting the patch, but were not involved in its
   development. SoB chains should reflect the **real** route a patch took
   as it was propagated to the maintainers and ultimately to Linus, with
   the first SoB entry signalling primary authorship of a single author.

--
Best wishes,
Vladimir
