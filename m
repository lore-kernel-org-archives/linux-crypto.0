Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDB6C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 May 2022 07:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiEIHra (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 May 2022 03:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiEIH2D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 May 2022 03:28:03 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E7821AC
        for <linux-crypto@vger.kernel.org>; Mon,  9 May 2022 00:24:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l18so24984763ejc.7
        for <linux-crypto@vger.kernel.org>; Mon, 09 May 2022 00:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z5Clk3XYXTp+vmz5f/jeXgXYH06mx9BqefglYqriuK0=;
        b=KHHanOPHMJzQqw6GMXaDS9KVtVOGdklcaRuC/OvfhXffD6M69QJz260KKpWqqYpaCA
         6A3/Sdd5SwhVxkmqbwke+bGMT8WU5XQaU+DQMTDdqVgMivB5VcoAO8MFNkMepLy5OuAI
         WSTxjSIUmFpuz0fenzMVdz5HU+R7DCnoYTCWXUtu9dhTO/Ni4katAVIPuzZzuhL7+8DC
         J/ywTVxCEkeLABC7V0SeijP1PduRx5nIPfdQd/hWqvwFnSE2b01bEU8zcLUKoUYROl5p
         bgXeMuPwatUa3smZHrf2Qk3yntrVkqaTXwBdEnUsooZEZ1QYjzOjRAJY9Xcf6gHaoWmU
         U1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z5Clk3XYXTp+vmz5f/jeXgXYH06mx9BqefglYqriuK0=;
        b=0DDRceA7ABiphCNuPMmvnnfLMk14mjOvF+ZNbzU3CnM22JyFiVm3hlyeaXy5S66W3x
         GwRkfs7UjfBcZmWxTYheJEZpD496sbg5liQkhErCKe8gvmEU4kBqvLL2cexZo2ZUmqVI
         4A/KWLFtHctTwIj2jLdjskc/4vTsD3F1VWm7jO6yynkntrlvq/P72JCDu/jBPg5zUfeR
         WT/RkxMvCufmliNoxjqJdj4NfsiJk3S7h5x3gW2B6jgNp35EIVcHEEFoVUJpMxHD0pMP
         PZo1U6TQT0Jv/CY1BGoOVnODYITIxg9SAbdHNGuK6fb/qATpIoTAe/XgkBXvJIokdqfc
         sp9A==
X-Gm-Message-State: AOAM531m44KR9w6QZVolJRgEY8aB3NQ0bW4z6jge1qsvzTDi/sOeEE+J
        ZJRTEvuUf98zoa0VPMAMEwTUWA==
X-Google-Smtp-Source: ABdhPJxsCeAGzJhiVxk3d02pleP/R1atUtuQTe5bS4dXtMXLktM0/4uRbPSxOhKyBgBzGzmTexDkXQ==
X-Received: by 2002:a17:907:a40d:b0:6f3:d1e4:9d7b with SMTP id sg13-20020a170907a40d00b006f3d1e49d7bmr13391190ejc.69.1652081036476;
        Mon, 09 May 2022 00:23:56 -0700 (PDT)
Received: from [192.168.0.242] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id md17-20020a170906ae9100b006f3ef214e30sm4799652ejb.150.2022.05.09.00.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 00:23:55 -0700 (PDT)
Message-ID: <0c44d40e-cded-cf35-b836-baff156f36d7@linaro.org>
Date:   Mon, 9 May 2022 09:23:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v7 25/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>, heiko@sntech.de,
        ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
References: <20220508185957.3629088-1-clabbe@baylibre.com>
 <20220508185957.3629088-26-clabbe@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220508185957.3629088-26-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/05/2022 20:59, Corentin Labbe wrote:
> The latest addition to the rockchip crypto driver need to update the
> driver bindings.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
