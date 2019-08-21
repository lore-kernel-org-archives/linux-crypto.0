Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F33CC3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 18:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED7B22D6D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566413721;
	bh=gqx8psvrGWH6QzfOz52e/EwoMsaoWafbb+qRXkGM4Fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=w1FZyLw88Q412l3XpPLmoBrkUQ1uH75BKeTEqsmPUzHy9UGRcfwORFdtFKVESpJZY
	 mzK9ucU7TH9wk0ebTsUjrJTnR1WPJCN7U1b/T2PDZ94WIj2oZjB6FlN1TbHTrOECHC
	 VnPbKY/D/3tCIT+7InzcLJM0b/SKSknIQrOqjygM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfHUSzU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 14:55:20 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36436 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbfHUSzU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 14:55:20 -0400
Received: by mail-oi1-f193.google.com with SMTP id n1so2426811oic.3;
        Wed, 21 Aug 2019 11:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rERMOO22DxL02BmdSf/5QgCf7VKhnIC3ZuuGwFUZfRU=;
        b=kH+R7HOlv9Dp1/c58GFwAcnfN9n1mScgZ7tR8fxs1ZUkaLF0OPRH5xDTwxwz/mkWO/
         06H2DCu+QYkc+2GLyPcN0ZW8ocmNiX7S8ION/CJci5wr9dN92/ELz+rUSDxY66qsRPiX
         7hCs+4H4s9RAMEmky2hbNLSP56CC8if1JYO+gX2T6ssQxN49+sHXOv/ca+Xxko43a8Lv
         5JyCp22I65k2+ZN5Bj53aR4CDBYAWe0IpE1QSmh1uBUl356wRW/0UltmWK56qHrPsdR8
         /Ogd5TFSvb88rYGTZp4zxesfIODmNekFdpzyrm2RVeYnBbeIn3SpX1vXCxnbbH5ycE/e
         tWaA==
X-Gm-Message-State: APjAAAUOaIEMlPgl4mFCdLCquBZDwWBsLMEN0BxNK5VazZruS04R5Wa0
        nJYbqp6a3mMae8U7mjs96w==
X-Google-Smtp-Source: APXvYqz3JEcVbf68CAFziNoluNLQIdlZjFRfx0/mCbuwzLOzZfuB14oQi8LCeZrqjqzIB3eeM0xdWQ==
X-Received: by 2002:aca:dbc3:: with SMTP id s186mr1125505oig.179.1566413719162;
        Wed, 21 Aug 2019 11:55:19 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h33sm8044610otb.55.2019.08.21.11.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 11:55:18 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:55:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Fabien Parent <fparent@baylibre.com>
Cc:     robh+dt@kernel.org, matthias.bgg@gmail.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>
Subject: Re: [PATCH] dt-bindings: rng: mtk-rng: Add documentation for MT8516
Message-ID: <20190821185518.GA32228@bogus>
References: <20190805130215.20499-1-fparent@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805130215.20499-1-fparent@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon,  5 Aug 2019 15:02:15 +0200, Fabien Parent wrote:
> This commit adds the device-tree documentation for the RNG IP on the
> MediaTek MT8516 SoC.
> 
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
>  Documentation/devicetree/bindings/rng/mtk-rng.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks.

Rob
