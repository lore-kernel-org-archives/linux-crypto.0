Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E627C41513
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Oct 2023 16:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbjJQQ3g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Oct 2023 12:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjJQQ3g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2023 12:29:36 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AF6100
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2023 09:29:34 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2c523ac38fbso31253931fa.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2023 09:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697560172; x=1698164972; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GwqQGMN0bypddmjCukp90urvyt3HMvtNQrPUO31Nj68=;
        b=tEDTo92LcVeFIYbGkXK/Ec7MwJ2Z+NPKM6SF0OFr1o9l4OCRWDFfvSXV0DspH07+K3
         kiJzrMHR3MPkAkf7/iflxjXdtF3Cb8M+4sl1UuVIyiH7M+fopRSO62r6PYjMJ/lHv78m
         oI6z81WGlpwPzWHqA01TkNpj2FMCrNVrlT/8sLmR25pcajlHCRM3nQU30GWJQJQBOI0u
         xOCoFoqHyfw5LSf0Zx4M2GvfEUD7/CT6b+Q7GJxpO4+oaw3NeDoXvO38H4hBpLCGlnFo
         JhlMnHbuXTXXJdX+HRmx9uUO7Lv3Qg4ajpeB+Z9qWRjeDHpE9ptgsEp4sriRo2w6LBfT
         s5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697560172; x=1698164972;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwqQGMN0bypddmjCukp90urvyt3HMvtNQrPUO31Nj68=;
        b=WlNIvXOcrRRDESZcHboyOROiu4HDyYDW7ljcuc34xEc859hEtEB7GpxO0u7eKcEYd1
         ERrZ4mF9DtDTcZhiXio8SU34MsjdA21Kyes/aXCILAnF3gSra9EyVO1qWaBh1KaDFeuZ
         IJSXQDVUtDu10v8R5UPdqcq3bLYGD9Nf6mcOPoRknIeU0XYmxU67G3++qAlwXsdX/Xez
         bTdFhBBPSxy4JZRN5X4qDVKsaI6VbryVePnqJGecBL2XSjmaZ4f7mFvhZVG9hl8LhmOB
         lyUfQMJnc7jrVSxG/ZX5xwBYQtyPS3smnBtDqETY8+ggrXCj4dWHtL6idJZdVdqarQBt
         ZBCg==
X-Gm-Message-State: AOJu0YzvAf38FO/+/eIkAbM0zLsPUtYB7TQFg1tNvWr8bXUGUkackrmA
        0v2TOri6yc5qdqAUuosag5IGLg==
X-Google-Smtp-Source: AGHT+IE6knn2uSQzDBY240t/lWRRIIzKQOj/ZXJZ5ZlJFnZ+aS5Zs+m/wIsdNKpb4NeemLWD+BdWdg==
X-Received: by 2002:a2e:9d42:0:b0:2c5:18ed:1802 with SMTP id y2-20020a2e9d42000000b002c518ed1802mr2054074ljj.34.1697560172301;
        Tue, 17 Oct 2023 09:29:32 -0700 (PDT)
Received: from [172.30.204.57] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id d15-20020a05600c34cf00b004063d8b43e7sm10257184wmq.48.2023.10.17.09.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 09:29:31 -0700 (PDT)
Message-ID: <2a8e20d9-2e00-4d89-ae99-87e5b49bb220@linaro.org>
Date:   Tue, 17 Oct 2023 18:29:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 0/4] Enable TRNG for SA8775P and SC7280
Content-Language: en-US
To:     Om Prakash Singh <quic_omprsing@quicinc.com>
Cc:     neil.armstrong@linaro.org, agross@kernel.org, andersson@kernel.org,
        conor+dt@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        marijn.suijten@somainline.org, robh+dt@kernel.org, vkoul@kernel.org
References: <20231015193901.2344590-1-quic_omprsing@quicinc.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20231015193901.2344590-1-quic_omprsing@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 10/15/23 21:38, Om Prakash Singh wrote:
> Add device-tree nodes to enable TRNG for SA8775P and SC7280
> 
> *** BLURB HERE ***
Generally you want to delete this :)

Konrad
