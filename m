Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A920FC47404
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F6C206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebDLvX1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfJNFYI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:24:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43733 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfJNFYH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:24:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id j18so17998721wrq.10;
        Sun, 13 Oct 2019 22:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xve2QTvqqiIPdY2swYgSXv/9sUgWk5VFoJkt1OR92XM=;
        b=ebDLvX1bdKNXz7niKOTITJlttM2yqn+U5mSeSdx27Nw37ZJBHchbVsxjnm9S+9kdFS
         ZUPGWBIqR9kAzDAWdVzk1t8JqcBFqs1q0++geYj+3QVKD7PtyvGb+YiEXMx4GzEUR7AH
         xApeg3UjxYXIBBcsg4SBLCS7X7p+s0j7/CQ0vEFQB+YAEvTfLT+tExNJpWrVnUCzrpDj
         1zw7IjL4AuuM7xemnvCOXOIAWfTbvKQF4kApFHr1wdiYHROp2NXzb9HMtlBJMuaoc+M8
         Z4m2nm1Tu8246UrIeeP3hv7/bawLQ2ImT+Y7C0UJnCWONfVGDZ+Qi484My6zd3b43CeG
         yfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xve2QTvqqiIPdY2swYgSXv/9sUgWk5VFoJkt1OR92XM=;
        b=nr3LhvXQ8lnalwRgnRkwUV5tmmbV628JNW2ZSXDUpnrz+PiB7Km/E2XeMIJEHchA+i
         lAys2G1GPFnCj8GKGOxazwe4vlxdU7ASpo+7voBt59TGTg3iN1K9/p1lmhZuSt6tq9Bt
         j4L/Rh1Q+TeOpOp1GDgF285StEoAUZjYq+GyFAoyzLLShVL31RqYvdsVKtp4NDf2Xb2L
         WHQDDvibTAUkzYLqM5kkXA40/E8Mgxwk9mALnZq9d3jRR6dDOdf9U+c0K4He51+Y5nZ/
         00ibcDokEJug7Eurx3PFG4xUnLWK89+MFigGaFWKaOJas03WMSIcy0DTQ7+Ljbd8wjWb
         qxjQ==
X-Gm-Message-State: APjAAAWiwCtaXtcEn5wefhZKOFDvLCDhppBa7OXFKvnWvUf5dmWxVXbn
        2itpYdf7Kw4q67yq7Dasaw4=
X-Google-Smtp-Source: APXvYqzKonVFcIAEMzbOIakcFdq1lvZBSxABTbSM+x411K7O0LoCDjIwqijCbmQF+KV9mHQY1ymlRA==
X-Received: by 2002:adf:9ec7:: with SMTP id b7mr1185229wrf.221.1571030645335;
        Sun, 13 Oct 2019 22:24:05 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n17sm16898743wrp.37.2019.10.13.22.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 22:24:04 -0700 (PDT)
Date:   Mon, 14 Oct 2019 07:24:02 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] crypto: add amlogic crypto offloader driver
Message-ID: <20191014052402.GA30688@Red>
References: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 07:18:35AM +0200, Corentin Labbe wrote:
> Hello
> 
> This serie adds support for the crypto offloader present on amlogic GXL
> SoCs.
> 
> Tested on meson-gxl-s905x-khadas-vim and meson-gxl-s905x-libretech-cc
> 
> Regards
> 

Oups sorry please ignore this patchset, I forgot to send from my work address.
