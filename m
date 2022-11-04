Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437B7C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Nov 2022 07:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiKDHa4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Nov 2022 03:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKDHay (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2022 03:30:54 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115441CB19
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 00:30:50 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h9so5908843wrt.0
        for <linux-crypto@vger.kernel.org>; Fri, 04 Nov 2022 00:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=orgUum75kO3mxGZKGpA9/prw1jAc40FrjMlN50pgpP8=;
        b=iV29rlj5LEzTTuolIj6HfjVxTpts9vywAncmtY33E8bL3TvUTOxTqR+r0TS7FXHAqn
         Lq/qZUGSJnZgm7VP+BTyGm9CFfSuV8B6c36Sy7+wDvu1AGjq39dyuTMfRBgjteHBLZd7
         TZWxDJ9WoHdmJaWDpoobJWz32Em+Nx9nTg8KQ1wgpl1AM2yz5Eof/+RwGlIdQRb2ObBD
         AScw+6Y2icp96gbEW9GQzpCGgphYx0+Q50zJQX/bSr7A69xsi1vItqinv4vAKfIgu3V5
         fcu7cRuGt/1DBNYfowMSzIYUsYX10I67VU4jJeU85aIjAXUxMZK99Uh4/fSQOViwnYQk
         AP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=orgUum75kO3mxGZKGpA9/prw1jAc40FrjMlN50pgpP8=;
        b=5a8s3K+nM0FCQGmtel4/GN7Iv2RaIBEPg8aBrqttuHwkr6JJ8SOSw72wb1LcDmFups
         vEln6JZP97FfqeznP7bvN83ZnJmMYt0/FVOnLTGhkip0KZeCEw8O9N2wt4RltYHjDnh3
         aBtf+oxk7x4Wuza2UY7Vzw/d2ZmEYirRpBgNZp7i3+/hpwxBgdhCttkZZrWkzEE/UhSC
         C2Y875YijUU14IozrVON8ipdKMZeBRX6cz7Rtlgp0akWEwQ0uFEfEt1OyB7Fs1xKS4Zc
         7jqCtZFEau09BLimu0FqdVuoS7qx8IXoJBEOfCgjnuzPxMN6RHVLKlb/phZVHxWxkNf3
         usew==
X-Gm-Message-State: ACrzQf09fvuiFtQPUe2N2ed2NMRbw/Uqdgbp9AZirGs00IzX3FfXjlL0
        wwzbMrni4d4abcis390aVXIM3g==
X-Google-Smtp-Source: AMsMyM6HO7azKIgRXgvhDjn9z4jfxA3QL9eOdmQYZ8skG4pF0vM71JR0bJOOgP1RFq7AEwM9PShlZg==
X-Received: by 2002:a5d:6181:0:b0:22e:3db0:67a2 with SMTP id j1-20020a5d6181000000b0022e3db067a2mr21962144wru.257.1667547048514;
        Fri, 04 Nov 2022 00:30:48 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id l6-20020a5d5266000000b00236a16c00ffsm2701107wrc.43.2022.11.04.00.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 00:30:47 -0700 (PDT)
Date:   Fri, 4 Nov 2022 08:30:42 +0100
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, heiko@sntech.de,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] crypto: Remove surplus dev_err() when using
 platform_get_irq()
Message-ID: <Y2S/osIvNJzs1jU5@Red>
References: <20221101021751.89362-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221101021751.89362-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Nov 01, 2022 at 10:17:51AM +0800, Yang Li a écrit :
> There is no need to call the dev_err() function directly to print a
> custom message when handling an error from either the platform_get_irq()
> or platform_get_irq_byname() functions as both are going to display an
> appropriate error message in case of a failure.
> 
> ./drivers/crypto/rockchip/rk3288_crypto.c:351:2-9: line 351 is
> redundant because platform_get_irq() already prints an error
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2677
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---

Hello

The subject should start by "crypto: rockchip:"

Otherwise it is:
Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
