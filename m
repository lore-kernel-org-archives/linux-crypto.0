Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3493BC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 08:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00E35208C3
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 08:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="c8ARjWzA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLKIyJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:54:09 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41701 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbfLKIyB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 03:54:01 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so23092986wrw.8
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 00:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5iP6qLz80iBtx8uj1NS/MPhGSpmZTCTVh6sCTJysrc8=;
        b=c8ARjWzAt6axhISj3z4yZRPa4j50bI+OmBH8uaPMftZ9ezYqgHHmGBCM9dTVcpw4nH
         W5Y8hWQ1FYH/k1PTJClQ5Eh0C4Ju6bfW6LzdtC4yRNPNe8iAJI6vrEIEdoDzDThI2nMa
         L/eouCnlfJ5j0BP9q4pefV+7kA3GCgBlXUFIU7j77G/inHiIX5YB0g9UVBs1UUObhoDP
         43q2Xl17ocUeMvX37J/mqZ2TXKEc1JcE8KNyartpFCpJOe/2nrH87pUkIFoOnOyPGd+I
         q8NEaeHRr7kH/SbsqVDTA/tI/wvbrD7dO6op2+ylbCO0r6cvaQN+LWHZaMD+FDVmheIJ
         a6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5iP6qLz80iBtx8uj1NS/MPhGSpmZTCTVh6sCTJysrc8=;
        b=Rdg+OnVWU/4NmbzI/Pa3G5mkb4LDU/GtWP8kHTZ4Q9WySWS/We7/JcteXL+f/g7lYv
         k7wP+FQzOGkRb+kMUguKOmUhS3JoqytsfmfmuwwzlLW8v7aX9Ma5W5HJfrUdzpdS6U51
         purO6sotpsZMeCdz+kPD/IdPY/ktL4hcr/+5tlrQNBfs33xfb69HM5VpMRu89Tp7ZetY
         e8Ko5Q8KnpN/lESfh+VOco50Sq/wy/7OvnCDVY7pJU8poBcNN4ezr2GnqwAbXR+b41fx
         cE8pQaW6pOi+8KnlTQwgeVjr2jY73srWw7KK/Ka04PZAxs47rS+r9lgJY1MK3vnNvQAo
         Cr5Q==
X-Gm-Message-State: APjAAAX2lZNjgKiK4dVqNhifaxhVpQz8ggqVPVIhesm5y6AfURrhfQ6F
        753sS8/ULVlx2fmnyJv1323vglWqp/ZAMg==
X-Google-Smtp-Source: APXvYqw7oj1/5xynuU2wcErQC7AhNFHU3qJy1sNOsKCmruWaGx2kAo1GkI1bmKuWnqJ3li9xBiLgDA==
X-Received: by 2002:a5d:6408:: with SMTP id z8mr2487559wru.122.1576054438340;
        Wed, 11 Dec 2019 00:53:58 -0800 (PST)
Received: from [192.168.1.62] (176-150-251-154.abo.bbox.fr. [176.150.251.154])
        by smtp.gmail.com with ESMTPSA id a127sm1515519wmh.43.2019.12.11.00.53.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 00:53:57 -0800 (PST)
Subject: Re: [PATCHv1 0/3] Enable crypto module on Amlogic GXBB SoC platform
To:     Anand Moon <linux.amoon@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20191211084112.971-1-linux.amoon@gmail.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <a4610efc-844a-2d43-5db1-cf813102e701@baylibre.com>
Date:   Wed, 11 Dec 2019 09:53:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211084112.971-1-linux.amoon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hi,


On 11/12/2019 09:41, Anand Moon wrote:
> Below changes enable cryto module on Amlogic GXBB SoC.
> 
> I was realy happy to get this feature working on Odroid C2 SBC.
> I will try on other SBC in the future.
> 
> Tested with loading tcrypt module.
> # sudo modprobe tcrypt sec=1 mode=200
> [sudo] password for alarm:
> [  903.867059] tcrypt:
> [  903.867059] testing speed of async ecb(aes) (ecb(aes-arm64)) encryption
> [  903.870265] tcrypt: test 0 (128 bit key, 16 byte blocks): 1922107 operations in 1 seconds (30753712 bytes)
> [  904.872802] tcrypt: test 1 (128 bit key, 64 byte blocks): 679032 operations in 1 seconds (43458048 bytes)
> [  905.872717] tcrypt: test 2 (128 bit key, 256 byte blocks): 190190 operations in 1 seconds (48688640 bytes)
> [  906.872793] tcrypt: test 3 (128 bit key, 1024 byte blocks): 49014 operations in 1 seconds (50190336 bytes)
> [  907.872808] tcrypt: test 4 (128 bit key, 1472 byte blocks): 34342 operations in 1 seconds (50551424 bytes)
> [  908.876828] tcrypt: test 5 (128 bit key, 8192 byte blocks): 6199 operations in 1 seconds (50782208 bytes)
> 
> -Anand
> 
> Anand Moon (3):
>   arm64: dts: amlogic: adds crypto hardware node for GXBB SoCs
>   dt-bindings: crypto: Add compatible string for amlogic GXBB SoC
>   crypto: amlogic: Add new compatible string for amlogic GXBB SoC
> 
>  .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml |  1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi            | 10 ++++++++++
>  drivers/crypto/amlogic/amlogic-gxl-core.c              |  1 +
>  3 files changed, 12 insertions(+)
> 

Wow, I'm surprised it works on GXBB, Amlogic completely removed HW crypto for GXBB in all their
vendor BSPs, in Linux, U-Boot and ATF chain.

Could you run more tests to be sure it's really functional ?

Neil
