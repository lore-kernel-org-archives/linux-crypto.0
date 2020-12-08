Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AF0C4167B
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 16:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0375923B31
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 16:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgLHQQE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Dec 2020 11:16:04 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45948 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgLHQQE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Dec 2020 11:16:04 -0500
Received: by mail-oi1-f196.google.com with SMTP id f132so5461253oib.12;
        Tue, 08 Dec 2020 08:15:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/A5RkYY4853LJ83SNcwGrd9pzrqICpgZ4WV/ppEDVw0=;
        b=oFUpt/yymq/cDRWk54sA89/BLjCbfyDZpdTiQV8K5LqSW3PkqLqQT9mgxvamOG9r+V
         86zf/bDo+jpn/s4l/I93VSomc/FC+uTDNJ9ollZxwrS3Asei4n8R8T1YKwDYfPJOcK35
         uGu+Bau/3VtLNegpbwWSrDsDNot57UkS37m6KIoV2yAbpdi70lgM0kPk8ekgl9RPHMFT
         UUJwk0mgVUQHypJes6t/XkgWMOGo1LAlSjg3xassTefXdVdebR7ZtoaEA/KxIZskoiHM
         OeLemdv2uFhPFQPnYt9DKdaagGG+LwkYH8ybCSdszstVAUn4tGIjaBkd5//kf96xeOUu
         sS5A==
X-Gm-Message-State: AOAM533/hRuYwYX5FV55lTq1va0gK0xDhJpDpbmWt7/EAEVlBkqTE13A
        9Sv1ivXiGX1EGYt3ktuxGA==
X-Google-Smtp-Source: ABdhPJyBhn7yunGObn+5VAHECgHK18a7z4JWaQwAkAVty8iu2yN6sKxNqznL6eWk+z748LSe/WbHow==
X-Received: by 2002:aca:4d8b:: with SMTP id a133mr3333273oib.79.1607444123100;
        Tue, 08 Dec 2020 08:15:23 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m109sm3465698otc.30.2020.12.08.08.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 08:15:21 -0800 (PST)
Received: (nullmailer pid 2630366 invoked by uid 1000);
        Tue, 08 Dec 2020 16:15:19 -0000
Date:   Tue, 8 Dec 2020 10:15:19 -0600
From:   Rob Herring <robh@kernel.org>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: Add Keem Bay OCS AES bindings
Message-ID: <20201208161519.GA2630335@robh.at.kernel.org>
References: <20201126115148.68039-1-daniele.alessandrelli@linux.intel.com>
 <20201126115148.68039-2-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126115148.68039-2-daniele.alessandrelli@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Nov 2020 11:51:47 +0000, Daniele Alessandrelli wrote:
> From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> 
> Add device-tree bindings for Intel Keem Bay Offload and Crypto Subsystem
> (OCS) AES crypto driver.
> 
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> Acked-by: Mark Gross <mgross@linux.intel.com>
> ---
>  .../crypto/intel,keembay-ocs-aes.yaml         | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
