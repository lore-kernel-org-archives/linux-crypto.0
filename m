Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F17C432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629C320731
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574469593;
	bh=gv9pxvgutuySJOL4jAp7Sn50N2BeMDsbJvO3Q8sIxxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RIRdSh87ps4yXWXxS7Rj22W2OXgSrPvaHHWMAmEUBGFdLJP8AR9+rK7WE+C6L7tzL
	 nvbZADG/04WdHYDd8uVrMvWS6FaNPdqqLZhYh4De2P3Vkx9ayTMN/bOlKU0msDrTTX
	 FlIK0JI6JfUwviSICL0PklF4IaMbDsO3kqYfMKsE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKWAjw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 19:39:52 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37214 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAjw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 19:39:52 -0500
Received: by mail-ot1-f66.google.com with SMTP id d5so7797925otp.4;
        Fri, 22 Nov 2019 16:39:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tEgHxCiyiX1vvVmymHFYVTUbODIbpTwPwyJWeOdOzsw=;
        b=qb5tY8LSdp1kdAtsevy+g4bauZLPdinL756/2GiLNpXLZETJYA83hlhms2DY1froNX
         5OlnvVVKn+hli0yPq52cWpGdv/Dm+x7WTB58g5qYHW3L3UNMPWDMpE4/IJMmADNeNBli
         cbbiIWiYGcnWPf2iwFMViWvP2UTgYg5YTxM7J2h5fPxMx6Z90hfz15nSnHT7lHZ49SFm
         gATydOT5isq0f7mYsW22zUacoUjPF8pMZYv+bY9HNpnMPiqxaMpvGu3RJmP/kbUsqk0A
         XzNePINk0pibQxidy1jt7cr9aWD5l/2hou70Q4qshFcbgM3XiLfdA+JECDBveuvAaawa
         8sig==
X-Gm-Message-State: APjAAAUCJfOieUHOWltiNgo0tUpL7AqH35lN5S+TmUPvgAhrcXfpV2CA
        swAEf6kfrrP/C5olUdC79g==
X-Google-Smtp-Source: APXvYqxyABAixVX6UI5qvZ5b6JowXXc/TuRvG5WegziVxYCjLu6SH7n/ghlJ1SoD2w77Id8T2Mgupg==
X-Received: by 2002:a05:6830:2006:: with SMTP id e6mr13247748otp.260.1574469590171;
        Fri, 22 Nov 2019 16:39:50 -0800 (PST)
Received: from localhost (ip-70-5-93-147.ftwttx.spcsdns.net. [70.5.93.147])
        by smtp.gmail.com with ESMTPSA id u143sm2632482oia.14.2019.11.22.16.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:39:49 -0800 (PST)
Date:   Fri, 22 Nov 2019 18:39:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Stephen Brennan <stephen@brennan.io>
Cc:     stephen@brennan.io, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/4] dt-bindings: rng: add BCM2711 RNG compatible
Message-ID: <20191123003948.GA13973@bogus>
References: <20191120031622.88949-1-stephen@brennan.io>
 <20191120031622.88949-2-stephen@brennan.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120031622.88949-2-stephen@brennan.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 Nov 2019 19:16:19 -0800, Stephen Brennan wrote:
> From: Stefan Wahren <wahrenst@gmx.net>
> 
> The BCM2711 has a RNG200 block, so document its compatible string.
> 
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> ---
>  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
