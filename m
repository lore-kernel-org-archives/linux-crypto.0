Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8360C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 18:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A0920737
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 18:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="UEzW/FmU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgDCSnM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 14:43:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42128 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbgDCSnM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 14:43:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15so9689718wrx.9
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 11:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+GPTHnyl90NKm5LFkBR8XEvQYiiIQK4VWKFTWEH8l7Q=;
        b=UEzW/FmUc6Y87LrNXHBdZVEXYR9PNYI3Hz7s5zu+DhV2oo6ILIw97n1TNuAaO8OO3V
         cVuNsH0w8wMGwAmKWEYsnPD9jn3IfogOHz4yvf56FxctDpvYcn0oR5Hq2HbhH4rIEeQw
         yaFUS+mxjBOHfBxSSg4RrJOrDHmYTb+dfyx/RFSmXQtL5HifxD07iIGZ1lfE5E2yin/L
         CCJTFx8x5Yb5Cy2V0EwGswwtJoccb1jzeyeVangH/XLUsHJ0Ro0cVqBW4hjJwBYNTkUv
         xSrcyWxjhz8KbemjeEimnC5rpu1qDamE8Etjcm9zhj4KnrEmMMj0XtPbfgQ3GyslLyre
         yj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+GPTHnyl90NKm5LFkBR8XEvQYiiIQK4VWKFTWEH8l7Q=;
        b=XER4H3Bvyom5OEP0u4MHFDk8HKaLkIBheexte7QNnbItS7HxJFg0a2PO++OHzrikyf
         zkY4+qgVSWKS7UhMLkl1rGTFOZHGmGSNY2hulTUJr3/VDhhu98pZu2ZM85+T+Hm416L6
         alEidbfAhtxix1z23oQKgagjvgDBG3ZA/z/T6TSofUV4KGvbuP89ZpALraaWRBm8M6F3
         7bhc2KSRWmboPWRcSQxqexPtmyuXyu/zk/l/lV+jXfGNgSkcnVDhJ0fKeb1h/LHSoFQW
         3bB+K33RALHpkyq/RJZWFCVvpMtK5djydKUrHdgXe8DpuRSsZ9lUuRukZOhmXjqEiFdl
         cltg==
X-Gm-Message-State: AGi0PuZL2Q4UqbTapyg2jidH0ijXJwTHQoucQ9ww7diP/BoutR+ep2Ig
        a6YUXKWJjJIEZN4XgI7H8+ZPHw==
X-Google-Smtp-Source: APiQypKiItekYd3SJpDys2lSSUlpMDrJD00tTpiCHgh4jCy85JaOxsj6rWEUzvyolaiXMgOAyByoYg==
X-Received: by 2002:a5d:4d8c:: with SMTP id b12mr10236625wru.35.1585939390612;
        Fri, 03 Apr 2020 11:43:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id p5sm13681907wrg.49.2020.04.03.11.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 11:43:09 -0700 (PDT)
Date:   Fri, 3 Apr 2020 20:43:07 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     narmstrong@baylibre.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5]crypto: amlogic - Delete duplicate dev_err in
 meson_crypto_probe()
Message-ID: <20200403184307.GB15205@Red>
References: <20200403111429.11876-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403111429.11876-1-tangbin@cmss.chinamobile.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 03, 2020 at 07:14:29PM +0800, Tang Bin wrote:
> When something goes wrong, platform_get_irq() will print an error message,
> so in order to avoid the situation of repeat output，we should remove
> dev_err here.
> 
> Changes from v4:
>  - rewrite the code, because the code in v4 is wrong, sorry.
> 
> Changes form v3:
>  - fix the theme writing error.
> 
> Changes from v2:
>  - modify the theme format and content description.
>  - reformat the patch, it's the wrong way to resubmit a new patch that
>    should be modified on top of the original. The original piece is:
>    https://lore.kernel.org/patchwork/patch/1219611/
> 
> Changes from v1:
>  - the title has changed, because the description is not very detailed.
>  - the code has been modified, because it needs to match the theme.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---

Hello

The changelog should not be in the commit message.
You should set them after the "---" line

Thanks
