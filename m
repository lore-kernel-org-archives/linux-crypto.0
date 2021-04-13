Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15DEC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 16:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCF46613A9
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 16:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344304AbhDMQbL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 12:31:11 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:41513 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbhDMQbL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 12:31:11 -0400
Received: by mail-oi1-f171.google.com with SMTP id x77so8190766oix.8;
        Tue, 13 Apr 2021 09:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Fo9ynsWoOvjEDoA9rCufsxRsqoZFiKZeBGSRsYcae4=;
        b=KdyVdzvQRGm5c1yX2/LOkZyBNkzE1WVSf1TSGT4biR7GAdVHYq8l5Iw3SxFZVfMKjI
         vYrUZjtu7UtgeluGUK2uAZ0KioTs8ryCkZks5rnkMhXahaFmza2qvFG/SCL2tQK8u+Fg
         tHsZlyslU6acjfrm2yiGx3tqvSAwjldalq+rnS7ivHH2ni/FTzjVj0qzG2iXwE4L3Wwm
         t4PiU2gZ8KCnUO1PtfqT4njAWoeEx/nfSH7JOuBih6rH64qaxPfwexJztBESaCGkS4pZ
         AKX8X28IO6yArZvsnKX6tu2cYZBSXswuHBO4OLZ6AKy4SvfpARE+4Ys5DbcKrr7P0wLs
         9+Lg==
X-Gm-Message-State: AOAM530xMcWKYrhbWXiNsAwQL8GtMIMx5n167PMoegc42QJThs+54jHi
        gu/HRwx8SkJ5+M1yLWaSc4zPT69IoA==
X-Google-Smtp-Source: ABdhPJyP+OMLVTCrbMHkczAPOr/izOKao5pcDItX7d2aoEVcYxVkmmkMR+lt894gpm3hS5qy2p6Xmg==
X-Received: by 2002:a05:6808:13c6:: with SMTP id d6mr572724oiw.155.1618331451206;
        Tue, 13 Apr 2021 09:30:51 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u66sm1345350oif.23.2021.04.13.09.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 09:30:50 -0700 (PDT)
Received: (nullmailer pid 1789421 invoked by uid 1000);
        Tue, 13 Apr 2021 16:30:48 -0000
Date:   Tue, 13 Apr 2021 11:30:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kishon Vijay Abraham <kishon@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, Praneeth Bajjuri <praneeth@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: ti,sa2ul: Add new compatible
 for AM64
Message-ID: <20210413163048.GA1788635@robh.at.kernel.org>
References: <20210316220558.GA3754419@robh.at.kernel.org>
 <20210413091559.154169-1-vaibhavgupta40@gmail.com>
 <20210413091559.154169-2-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413091559.154169-2-vaibhavgupta40@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 13 Apr 2021 14:45:57 +0530, Vaibhav Gupta wrote:
> From: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> Add the AM64 version of sa2ul to the compatible list.
> 
> [v_gupta@ti.com: Conditional dma-coherent requirement, clocks]
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Vaibhav Gupta <v_gupta@ti.com>
> ---
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 24 ++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
