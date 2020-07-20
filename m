Return-Path: <SRS0=2iMm=A7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F1FC433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 08:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7136D2176B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 08:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="a13MgTJM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgGTIko (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jul 2020 04:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgGTIko (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jul 2020 04:40:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AB3C061794
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2020 01:40:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z15so16924422wrl.8
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2020 01:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BlDAyGJ84Q1MRWobMfZ2vz9Jimz7XhVN3a5fTfxyjNs=;
        b=a13MgTJMMzogWZOltIcLHCW2hq/KoC1zE+dDLltAUYUmzQdrJr6tjEV7VvDiZhuwlR
         Yo8nZFNRL38L5Dz8X3OVwcnAstv4WrCyEZHaDPLuhZfmcSQsxB0yh4k+Pe0dq3B8lgom
         a1fVL49DUFm6GOW+EQ7e26z7d3pBDRTjIUH9n9fv1VxnnqvNe7NxWTODXkZ6KoRJ+Ylj
         0+HOSJBs6HCVE4vDY2IN7+CoX41S4wpZ/s2smuQtKTkSdez12xKk3wazc7/uVQ8UGx2M
         RuhaboOxHn15h63TyfYdNKSvO2uY9NF0qNgfmuZY4FZn3R5ymv2GcWg7pRdUAKBHR5t9
         h3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BlDAyGJ84Q1MRWobMfZ2vz9Jimz7XhVN3a5fTfxyjNs=;
        b=eYmcIyq+aTJ25MshFKrpwjhwmHFGHF+RsFvOH4YRyM1wB9WxHDdtsJ8Nf6gcG1DiQq
         7FWp9y/cIlzUQPNYUJ48MzloLFfc98hgzVwtiKz1NG5JkjKzMQ2t1P0OSOlr23bcQ4/z
         ehgqZkIaqrKJZp8ilNTsh/HKSrlTZoACRDiFZycXhw327bGXpB8q8mrxlyoVyu1e7lUp
         XBDxMHaxlw1CtNviOeu6XUHax41keRAmSGRQORSoa07rVk9XqKXk8JEyWOkGRABbj3Jb
         zIa+eQ9oj9KVo47F2vUacBH2aZIrnEExR5pk0BHQ71c653frkG8dhapCwnGDAX1zmKWB
         0ZZQ==
X-Gm-Message-State: AOAM532eMiBjrNN8XFhnwr0kCzgo/aAT90iSXObLBp+0N8cjqGzjNqfV
        KBwJ0y4k/pIPG4m4eUNVjNU8HA==
X-Google-Smtp-Source: ABdhPJxvqyPIo2tbAstdzEdwSSMus8KQtHJorvgTkfjy+Kqv+jAGv/J+zdFKKQEDaZRQHlz2b5jYvw==
X-Received: by 2002:adf:f60b:: with SMTP id t11mr22778978wrp.249.1595234442821;
        Mon, 20 Jul 2020 01:40:42 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x11sm29153952wmc.26.2020.07.20.01.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 01:40:42 -0700 (PDT)
Date:   Mon, 20 Jul 2020 10:40:40 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: amlogic: Convert to DEFINE_SHOW_ATTRIBUTE
Message-ID: <20200720084040.GA23952@Red>
References: <20200716090411.13573-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716090411.13573-1-miaoqinglang@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 16, 2020 at 05:04:11PM +0800, Qinglang Miao wrote:
> From: Liu Shixin <liushixin2@huawei.com>
> 
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 

Acked-by: Corentin Labbe <clabbe@baylibre.com>
Tested-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
