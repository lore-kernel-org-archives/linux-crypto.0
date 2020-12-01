Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930A3C64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 19:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F0CE2151B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 19:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392442AbgLATkG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 14:40:06 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43823 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389343AbgLATj7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 14:39:59 -0500
Received: by mail-io1-f66.google.com with SMTP id n14so2838078iom.10;
        Tue, 01 Dec 2020 11:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jq7u5/UfncNIXt0qMkxHCilNHf/0tvbW1U30cwWUoHA=;
        b=QlG3WRkkQWH0ipPUOeJRQFsc2ZwARJNVZFZ30XY4Wuyt0cUOubjqRsYz5us0490k66
         nYoWlxi4iX0srTtw1j4rolkiL+tVyzgL7wSNMBRrQIvoRxeN5j11YIy6s1Z7bGED+cOl
         nozWJnP8w7y5E9uxd5tMyEWC/XPd8KQzXeyoNNiG/dlbR5aockHUZTKiEwhFBtTmTMyw
         VApT9BnBkvhJ2gmPZlkWQVMGrijBMWC9Ng9FfrUloWHgBIBQSMd4g8tleEZWtUxyjhLP
         Cbic1TRW2+oS2is77/bRT8mV7ZJ+/323JoS3yfxoq0ChgPUdpK/9/3+t7GQsfV84j5gP
         mb5Q==
X-Gm-Message-State: AOAM532k7M19xQa8MgQb+ICwAmGYR/52HB9aIQ8tTJotvnGXDGKs8LBH
        JA5h95Rqb6O/85qHQQYKag==
X-Google-Smtp-Source: ABdhPJxfrgZAxduHRKzNo2RBuk+51qGlK4QYC5A5RaXdhzhkKQOJbkkHDFsBY8Q3kqPdqmY8ZFhU1w==
X-Received: by 2002:a02:650e:: with SMTP id u14mr1783751jab.143.1606851558412;
        Tue, 01 Dec 2020 11:39:18 -0800 (PST)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id n16sm275022ilj.19.2020.12.01.11.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 11:39:17 -0800 (PST)
Received: (nullmailer pid 931037 invoked by uid 1000);
        Tue, 01 Dec 2020 19:39:15 -0000
Date:   Tue, 1 Dec 2020 12:39:15 -0700
From:   Rob Herring <robh@kernel.org>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     linux-crypto@vger.kernel.org,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Gross <mgross@linux.intel.com>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
Message-ID: <20201201193915.GA930982@robh.at.kernel.org>
References: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
 <20201116185846.773464-2-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116185846.773464-2-daniele.alessandrelli@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Nov 2020 18:58:44 +0000, Daniele Alessandrelli wrote:
> From: Declan Murphy <declan.murphy@intel.com>
> 
> Add device-tree bindings for the Intel Keem Bay Offload Crypto Subsystem
> (OCS) Hashing Control Unit (HCU) crypto driver.
> 
> Signed-off-by: Declan Murphy <declan.murphy@intel.com>
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> Acked-by: Mark Gross <mgross@linux.intel.com>
> ---
>  .../crypto/intel,keembay-ocs-hcu.yaml         | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
