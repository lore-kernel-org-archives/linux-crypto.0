Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0861EC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 23:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3D3761AA5
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 23:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKRXz1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 18:55:27 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:42911 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbhKRXz0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 18:55:26 -0500
Received: by mail-oi1-f176.google.com with SMTP id n66so17942637oia.9;
        Thu, 18 Nov 2021 15:52:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mdlZbMN9TOaMLBnrcnl83d3wKAwscGmZJDPaDKwPea0=;
        b=OtZknKWNR/c3LrGxNmLARy8+wmja84t3eOyiD0X7Qac35UQG6dluicYvjEr9LEIc0u
         NR5GZB+rB8Zn+/wrynrStcf080i0rJOOcVXB1UUV1WcvJsa7sXdkUUUNI9kU/mBqdRi+
         Tzyd3dCQraNyGAe1ur0bATH1RfEwjw8xo9btnZTkJQWYw0a5CeR2l03RyVgNnLb3y4Kp
         hBlMmEgSEltuzkmkbdFEu8QXzvBjKUhOsOzmltiK3RBQinU+Mevn8acZq9tPsoMSHnYk
         ROutTOWCVqvxjX//1e5TnpcaHaredUcG0ya2dMxox+e5IqahG0F5uczOgO1/FIe5XR3m
         D9/A==
X-Gm-Message-State: AOAM533RfIZJ1mZWWNlysdIDAjwDon3NRSvp0eavyDq9uq8ckcqmyEAS
        y5T1pSscM+Er80gIWJRXHy4wfI2ksg==
X-Google-Smtp-Source: ABdhPJzMwGaxhd/IUYj4isXqiHLxIuWpR77lKuVhs+KlheqZ0MneavY6HFVTEKdkMIaLbomXOkG8qg==
X-Received: by 2002:a54:4701:: with SMTP id k1mr903999oik.37.1637279545284;
        Thu, 18 Nov 2021 15:52:25 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id n6sm165204otj.78.2021.11.18.15.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 15:52:24 -0800 (PST)
Received: (nullmailer pid 2018987 invoked by uid 1000);
        Thu, 18 Nov 2021 23:52:23 -0000
Date:   Thu, 18 Nov 2021 17:52:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     agross@kernel.org, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, Thara Gopinath <thara.gopinath@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        herbert@gondor.apana.org.au, stephan@gerhold.net,
        linux-kernel@vger.kernel.org, bhupesh.linux@gmail.com
Subject: Re: [PATCH v5 04/22] dt-bindings: qcom-bam: Add 'interconnects' &
 'interconnect-names' to optional properties
Message-ID: <YZbnNzd9a2lPA+N8@robh.at.kernel.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-5-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110105922.217895-5-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 10 Nov 2021 16:29:04 +0530, Bhupesh Sharma wrote:
> Add new optional properties - 'interconnects' and
> 'interconnect-names' to the device-tree binding documentation for
> qcom-bam DMA IP.
> 
> These properties describe the interconnect path between bam and main
> memory and the interconnect type respectively.
> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
