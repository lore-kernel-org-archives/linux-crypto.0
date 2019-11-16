Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5728C43141
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 19:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 905A920740
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 19:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eG8Ac8nL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfKPTry (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 14:47:54 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36006 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfKPTrx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 14:47:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so14956323wrx.3;
        Sat, 16 Nov 2019 11:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kF8bADSuYOyZZ04T0VZZ38WxPOWk9q6i2kAOnZ54aEI=;
        b=eG8Ac8nL9fJJ4dAxSlZ5w1mlOPQ/aZ44+2vKtS/iCw26fv8FTKt6AqpoUMiPu3pOBr
         Wm46KJ9wUiA9nhrMoDOjF80R3DNyRC8bbZ/wono9/fKwCBzuAqiDb20MjxrXNtAsY6De
         xhEIgdFubj2LpSMBCDZZAdpMbZAbYZhggITGNS/o+rMfp0jaNipFl4Hq+nFiJVhl+1Uh
         0JpZbxWG3JUXhbZZ4U7Huzleg/97V3LYFyoVYvXQYTG120n8YyULMVrGXOmtuuBGJeoT
         qlr2Fgp4DE3rpVMiXtX2fj8CKHK2833jMMxeacBhAk5/2WzPrTakAsOuIGzxz3DJPKcy
         1KuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kF8bADSuYOyZZ04T0VZZ38WxPOWk9q6i2kAOnZ54aEI=;
        b=BHMW4R5RfhWANla4+AW2CN3TKIbko+oBe+Vpfc7jk0Jbhlj0pIA178x8Aisuwc74XN
         I3HpXaaKZ2wD0WgZg4vP5hTwqPeb0IGdG49zqaBGxJZlcdiMdlfRtlIn8A2DcsUo9zQm
         KtsRMqWQ1AQm//bmdcpPvsJG/bL9sBHfVzMGopwViEYhLFABGtaQK11zawbTFk703gk5
         DrNh/mYxiFG5s6kDJh/KUEgfryAG2odr2TKS+EmD1g/+i6mQocwgVHQWduY/7ggGMwOr
         IMQQuW0HETh+/NtOPC0kaPp1XL/MVb3ELyH7vAmV5E+2kbSXLLv9VjEFpzkLcPabPOt5
         laOg==
X-Gm-Message-State: APjAAAWqnyutIzTALx0eKB45Lg6EP5KygeLTV5GaoAvf/DntzU/S0vd0
        O3ZxzkOOWproGaA7Mg4B5oc=
X-Google-Smtp-Source: APXvYqx1+kz8MC/TEjt8V8DXDIvq8MBgjf1a9D6+6mE2GxlbPdRhZqxKarPwAbTsKLoRZIFBdux2BA==
X-Received: by 2002:adf:8543:: with SMTP id 61mr13202158wrh.171.1573933671822;
        Sat, 16 Nov 2019 11:47:51 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 76sm15319821wma.0.2019.11.16.11.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2019 11:47:51 -0800 (PST)
Date:   Sat, 16 Nov 2019 20:47:48 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 -next] crypto: sun8i-ce - Fix memdup.cocci warnings
Message-ID: <20191116194748.GA23118@Red>
References: <20191109024403.47106-1-yuehaibing@huawei.com>
 <20191112072314.145064-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112072314.145064-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 12, 2019 at 07:23:14AM +0000, YueHaibing wrote:
> Use kmemdup rather than duplicating its implementation
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: fix patch title 'sun8i-ss' -> 'sun8i-ce'
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
