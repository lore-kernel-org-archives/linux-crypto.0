Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEBDC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 21:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A8564FFD
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 21:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhCHVxg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:53:36 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:41148 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhCHVxZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 16:53:25 -0500
Received: by mail-il1-f182.google.com with SMTP id c10so10266044ilo.8;
        Mon, 08 Mar 2021 13:53:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LX5PpicIOZawGnwZFfoDpkcC/MADa83hSMM3P3xoxmo=;
        b=dzCm9T5PtHkGXEvDTDcc3nmTv8pqEKwYiMVB5WLzQ/4yWKCAApgqYLy/SnQUTzTfpC
         izYADNWNgEQDbPe6G6NDLtaefP65WlO9vSB+cBZHAz45zUn2r/J1+qP4aGvzVPHY63jx
         iUPvPTvot+TlHHd5O9unTRq8LsIOu3dL+MbnSgOfJInd3TK0XdqQUx2OMqyTuQhAItvv
         7g3f1Tw8rghSG0rXyiGS5eMaz/H5LPyxOKhiMQyvLMDo1r20gjkf9Q3XwEo/QuWLlBFb
         /BYl5WSMcvbbfPd/TZmEoE51SbJwDzKeQC0fxnnTuONuZRRHMMdWHdqK3WPjqiHSUY/o
         hB0g==
X-Gm-Message-State: AOAM530Oi/+1cR56dCVoeQGfRSrmkkShCxGQuGbaTa+u1OVz/SbaQIv8
        o6cQoPi2lTuP/IIywbNDYA==
X-Google-Smtp-Source: ABdhPJyN7vXM8TddFG1CDCKGglHi9zZzgm+iG3VF4UQDAI4HFs6mqLB3lobOg7yIiXWp5nsUuZjtLw==
X-Received: by 2002:a05:6e02:1c2a:: with SMTP id m10mr21383555ilh.17.1615240404507;
        Mon, 08 Mar 2021 13:53:24 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id u15sm6845506iln.84.2021.03.08.13.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 13:53:24 -0800 (PST)
Received: (nullmailer pid 3019369 invoked by uid 1000);
        Mon, 08 Mar 2021 21:53:22 -0000
Date:   Mon, 8 Mar 2021 14:53:22 -0700
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Tian Tao <tiantao6@hisilicon.com>, Ray Jui <rjui@broadcom.com>,
        Matt Mackall <mpm@selenic.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] dt-bindings: rng: bcm2835: document reset support
Message-ID: <20210308215322.GA3019335@robh.at.kernel.org>
References: <20210305070132.2986-1-noltari@gmail.com>
 <20210305070132.2986-3-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210305070132.2986-3-noltari@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 05 Mar 2021 08:01:31 +0100, Álvaro Fernández Rojas wrote:
> brcm,bcm6368-rng controllers require resetting the IPSEC clock in order to get
> a functional RNG.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v6: fix dt-bindings warnings.
>  v5: no changes.
>  v4: pass dt_binding_check.
>  v3: make resets required if brcm,bcm6368-rng.
>  v2: document reset support.
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml         | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
