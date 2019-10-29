Return-Path: <SRS0=WkI6=YW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF0BCA9EC4
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 22:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A088F208E3
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 22:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572387190;
	bh=lu1nxI8+9N623VkJ26kGaLD7N1mRE47ps/nLy05o3Ec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SQKZz84+kL+S/jKSrcOIyBDNtWE/YDYq9QqeFjAmQfBltaRdcJpRYxmBqA+U0K3lO
	 NMEuaTpMRxUUe5aMWRUp3LHYLaVzKCXabez43W0obTS2+dlOAAMlMhsrfByVvvSlRw
	 rgIMUF8PQK8w7jR+QN6zaOoATt3R4ZJmzR/gDLU4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfJ2WNJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Oct 2019 18:13:09 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42804 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2WNJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Oct 2019 18:13:09 -0400
Received: by mail-oi1-f195.google.com with SMTP id i185so225707oif.9;
        Tue, 29 Oct 2019 15:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oKV+VkD2DdLQv5MCcveFFga4dSybCX7/fU89+oYDxR8=;
        b=IGcOudBvHHrP5/HSXt8iSZon27UasckUYtXYfv7jg3uckgwNFpZDDbKMOVoGCdz1Jx
         9/eD+aggHPTRRi8CBYdG0XbipjEeeby94LaR+RgXjDL88Lo15G6XQKFxoudHLjzRgtWV
         y/9uvgY2glH5anLayEaFnZwKxHuXGxGAGpimmyTonZyGBU3lUPAfPcR+2AlpA8J/FdJq
         8QNfkw8MIy6itE6ImiTnaGn62UrwB/1n8DnJ+6SzkWP9Nk2O6qKxcPKoMyi7oTErFWvn
         vn0zUw10baT1vZiq91rLlcVh+8LxJVgq1Bi5sr+gDnhAga1yIyFFgTFzJjwdT5YPYaGd
         EV+A==
X-Gm-Message-State: APjAAAVJSsAV6jzTcpyXZXJOXOpoPu7dvqlbdm2z9xyuGll32cgUdFIJ
        I1L2AvfOmzjvHS7oXyqIrQ==
X-Google-Smtp-Source: APXvYqxsN+GBu3MaKoONq+C2yXPVIcU2r2yLhUUeyvn7t7rGsRioCNtBVsty+HQhQ1Qf7BrTURpZhA==
X-Received: by 2002:a05:6808:8e:: with SMTP id s14mr6236745oic.57.1572387187587;
        Tue, 29 Oct 2019 15:13:07 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o23sm91770otp.79.2019.10.29.15.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 15:13:06 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:13:06 -0500
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, p.zabel@pengutronix.de,
        robh+dt@kernel.org, wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 2/4] dt-bindings: crypto: Add DT bindings
 documentation for sun8i-ss Security System
Message-ID: <20191029221306.GA26741@bogus>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
 <20191025185128.24068-3-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025185128.24068-3-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Oct 2019 20:51:26 +0200, Corentin Labbe wrote:
> This patch adds documentation for Device-Tree bindings of the
> Security System cryptographic offloader driver.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  .../bindings/crypto/allwinner,sun8i-ss.yaml   | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
