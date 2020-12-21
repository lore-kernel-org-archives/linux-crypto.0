Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF4FC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 22:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F41229CA
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 22:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgLUWxX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Dec 2020 17:53:23 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:32989 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgLUWxX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Dec 2020 17:53:23 -0500
Received: by mail-oi1-f175.google.com with SMTP id d203so12938005oia.0;
        Mon, 21 Dec 2020 14:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C9iutd2vvAw4BVRtr1Ptz+HDHNvn0GlAdfaXvMhcHF4=;
        b=isZh3LXGvdekEx1ig5Y5gLUVK+wweavcdu4AT0Zz4Pgxwbvtrlo7ICS98scuTzoVTh
         Q5GFScZSgVYFSSFmdk2ktPtWVK7f3xuTG7CliOrjsbAW+CZ1T4f2Mo//lwdEMjfdvC4T
         GqnzXq95iep1PYvpiRLiZlB/zV/WjC+JRjERWx29dj7cWfAgcpaTi2OP8dEUkzaERVQq
         ViN2hAoRWnwtCy6KUetGdKcrsRz4WckAH96lnoQkQjvGfMkN9YrjnlkYmVGpGcHfhNQm
         0cpeMP7v37glu/Mo+LAje5fQucEqafIE86aFqhfp/LYVW20CksbM4zNaAFZfeSMn5X2L
         MO2g==
X-Gm-Message-State: AOAM531VKVpf2JI9iRzcLY56uU2MoD472o/H7SzwwXLnSYQTCjG07NES
        H+foPXYa6xQ2cYSrq5NxGg==
X-Google-Smtp-Source: ABdhPJwUMowpxi+lc9HEd0bxek9he5bQ30qsb0QEoS3fjOzeeoceLadSSKZCI6/msTJCS8IaNcLQXw==
X-Received: by 2002:aca:ed51:: with SMTP id l78mr12407844oih.144.1608591162069;
        Mon, 21 Dec 2020 14:52:42 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id p132sm2769466oia.41.2020.12.21.14.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 14:52:41 -0800 (PST)
Received: (nullmailer pid 722396 invoked by uid 1000);
        Mon, 21 Dec 2020 22:52:38 -0000
Date:   Mon, 21 Dec 2020 15:52:38 -0700
From:   Rob Herring <robh@kernel.org>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     Elena Reshetova <elena.reshetova@intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 5/6] dt-bindings: crypto: Add Keem Bay ECC bindings
Message-ID: <20201221225238.GA722337@robh.at.kernel.org>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <20201217172101.381772-6-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217172101.381772-6-daniele.alessandrelli@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Dec 2020 17:21:00 +0000, Daniele Alessandrelli wrote:
> From: Prabhjot Khurana <prabhjot.khurana@intel.com>
> 
> Add Keem Bay Offload and Crypto Subsystem (OCS) Elliptic Curve
> Cryptography (ECC) device tree bindings.
> 
> Signed-off-by: Prabhjot Khurana <prabhjot.khurana@intel.com>
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> ---
>  .../crypto/intel,keembay-ocs-ecc.yaml         | 47 +++++++++++++++++++
>  MAINTAINERS                                   |  7 +++
>  2 files changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
