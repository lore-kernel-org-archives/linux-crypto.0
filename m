Return-Path: <SRS0=fE7s=RX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E048DC4360F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 19:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86542190A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553111945;
	bh=gp5n0il2dP3M7PXopfzX/0v2fTUPNCVmnzViLurpi2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=khqsh7npU/V0alDsQnvDbsF9tjpIiYZbRou1CR4K+8OtHK3LnKMzSyrZo0k1zG9Ir
	 tkSr85/RjQg6YxqKfYe03+Aa0sRPNKkOauXXCrrR3yG1NVVr6Pl9COAsJZZhSdaH56
	 vywBNZoUszvQS3HUI0hYOa1MZWwXJ94UaMEEZ41c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfCTT7E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:59:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46646 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbfCTT7D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Mar 2019 15:59:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id o1so4140890wrs.13;
        Wed, 20 Mar 2019 12:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Set6nLx7VA7za62jApDxAnNgGkHuhZYBfmaEV0aRmkM=;
        b=GdL/8oAE/I3x4rhT3XYRWeTznJggSd4B3uPHikrfqpHd4QL+aSUWNTrK4Cnv0822G0
         qkg3+9NtKFm3WPJBB8wUMaUOSrSc1sxltPjwEu7d8UY8TR+aeHWb709vnlUBEodq3NpH
         iUvgGlzKRlFs5otn4ik2eszWB1XgYjw9Lyv7uDCYtjKpkMB/jUfS57hOQWeOg0QQs/Ps
         sizoDdMnSXZqb30wWJBKuOC9DgCfB/UK4aMghWfTaZ3n8dVPOZcEEhajTMajrKMp+lqS
         kmIKv83f2wrofNY4ixywHUUFwojtAGIoOdvG5lRnetSLswQOv7wejiyEseJ4jlEdNxNl
         VWXA==
X-Gm-Message-State: APjAAAWlJTSjmMUAgcj4h2U3BmbduL3/H7n9AfdTPDUp4zKx6WlRDMOO
        YRCOjcgDh3KGudfOu8oHgqM=
X-Google-Smtp-Source: APXvYqxScdNZ9esBRpbCleJvja+bsu4THzGjS7Ri4GCl0bM0mHtB8jpo0pqOB+jhjzDwW2KrWvRYJQ==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr4561108wrr.269.1553111941786;
        Wed, 20 Mar 2019 12:59:01 -0700 (PDT)
Received: from kozik-lap ([194.230.155.153])
        by smtp.googlemail.com with ESMTPSA id n13sm4414450wrw.67.2019.03.20.12.59.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 12:59:00 -0700 (PDT)
Date:   Wed, 20 Mar 2019 20:58:58 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 1/3] arm64: dts: exynos: add SlimSSS for Exynos5433
Message-ID: <20190320195858.GB9956@kozik-lap>
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
 <CGME20190222122203eucas1p19a77c1cb72526ce36e99542926fd5a17@eucas1p1.samsung.com>
 <20190222122144.19024-2-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190222122144.19024-2-k.konieczny@partner.samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 22, 2019 at 01:21:42PM +0100, Kamil Konieczny wrote:
> Add DT node for SlimSSS (aka Slim SecuritySubSystem) in Exynos5433 SoC.
> The users can use compatibility "samsung,exynos5433-slim-sss".
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  arch/arm64/boot/dts/exynos/exynos5433.dtsi | 9 +++++++++

Thanks, applied.

Best regards,
Krzysztof

