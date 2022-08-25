Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3171ECAAD5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 22:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbiHYWb2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 18:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244445AbiHYWb1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 18:31:27 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67968B941E
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 15:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661466685; x=1693002685;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=pXWRUr7yy74YSO6PolHsHDXM3uM60SKPSfU0sqhXVlw=;
  b=Yf9/Pne6aTwx27UTP6hucrCasFvT348ITLvezBKTZXP6ewc3FmK7NBfC
   KfKuZIQkMvPuO9cbK/Aw/ZfZMMIQE7CCpG2PwOSKpxWNT45Fo7/2kSKBi
   WZf6HpeMdWC02MH94z/yuGSzzYYpWZ2fhsukq13pCC0RDd8ue/x5VC1Vu
   KTPJKGFs2nf2HcGrPIUO3Pm5eHdT4Kd5ms/Jye1p41372PwUrmEhJvGhf
   7FN3RtHR9JeNpmIyAcBzkFW8/b3sLDLtnFTXI+7wXp0DmmKCxe9MFqNTe
   Sb/z93HrD9uVJ2ZuiuAMx5nW+QR8wpv3V4ikawhBHf1204FDk5QHWh+38
   w==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654531200"; 
   d="scan'208";a="208130141"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2022 06:31:24 +0800
IronPort-SDR: OSAknwsD9vhFrYcj7LYSsk+ACQIOR4qw2yy9RdZpileSPgQRqn8zj9+dEvvWbm0lV7IJUSZRED
 6CCPIbml8w12W2Fu0ZE5CBtqXEU2Z6W5LImOb8xOGHuNiAzl4eeELcpobC2701e1XlyZ6Yz+iG
 ufIU1Eyqq84LIxfJPPAAZLo1/mBWBnJpO0qfiUmQt1LU6U02F/njNr8x5JiixP4pkyJtPQ9hiI
 4wbPRKPQQWjrLW90jJINcudbo3YFHId44N44HbwH5wCDnc0RxctIN9L219TrMfYWr4yijW1oPR
 cPshbaTLrYHak3+pJe2F1lUm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2022 14:52:00 -0700
IronPort-SDR: ZBW03yyp7m6q+AHE+GNEhSdKu0VtzhnmPi5XN7TeMxLXtWMKp6vX3pbcE8WcySo9s00Qx+1CGU
 m7Un/aBPSaVMFXipZTW4H93Xs1lZtneV0rH4cv4O1ST/CuZ/+z9f5p+i/+4r3PJFobo3wEajTw
 C1EX1q0bj5I2LtP6omOKadl/bjtemyVXVX+BakcDne4J7M7rN/+KBNZ9y2JchEh3vTQ4DLJMzi
 qi+3dIxX1uNoE/uNqg6NzHOS2+w/G9KWw+Ek1v0Ty4zel0FReHYo5cP9XttY3FzMQ5g7g0D/6L
 t5k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2022 15:31:24 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MDHkM5CGrz1Rwry
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 15:31:23 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661466682; x=1664058683; bh=pXWRUr7yy74YSO6PolHsHDXM3uM60SKPSfU
        0sqhXVlw=; b=DS5CoFc3iYU7cDPy9qH82TgEIsNMbhoT3C6WeVO1k1n8lfF5jOd
        4QX9dz+jZ2zBT6lYcxg+KWIWNsTkP0T39GuuYt+Fb54L+Ay16HMoRx/umfqkrCTA
        5g07OD/6ZWQNFpgrYTCY3b5VmwPIe8ZVeKZjxn3TcnZkMTLaDFOZPDoCaKqF7Yu0
        M57XRvGIQ4ULgKrfH+zmolhYlxi9tLSaf3wHIfcYiq0AucN2J/i/m6EHR3ZASpwa
        y4jnhHL1vOGRndZWTAVPX6+j9lVqy63Znj9K+/KI1ssi/+aLLozx85ixW9f3Xqhd
        u67xga7LZad0mOnZ764Wv9X5dqdJcnCFLTw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dxqUwUg8VYmr for <linux-crypto@vger.kernel.org>;
        Thu, 25 Aug 2022 15:31:22 -0700 (PDT)
Received: from [10.225.163.46] (unknown [10.225.163.46])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MDHk850sGz1RtVk;
        Thu, 25 Aug 2022 15:31:12 -0700 (PDT)
Message-ID: <bb0728d1-20fd-8b6d-5d42-a0c76b6d3e4b@opensource.wdc.com>
Date:   Fri, 26 Aug 2022 07:31:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/5] dt-bindings: ata: drop minItems equal to maxItems
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <sean@poorly.run>, Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Marek Vasut <marex@denx.de>,
        Krishna Manikandan <quic_mkrishn@quicinc.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org
References: <20220825113334.196908-1-krzysztof.kozlowski@linaro.org>
 <20220825113334.196908-2-krzysztof.kozlowski@linaro.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220825113334.196908-2-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/25/22 20:33, Krzysztof Kozlowski wrote:
> minItems, if missing, are implicitly equal to maxItems, so drop
> redundant piece to reduce size of code.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  Documentation/devicetree/bindings/ata/brcm,sata-brcm.yaml       | 1 -
>  .../devicetree/bindings/ata/cortina,gemini-sata-bridge.yaml     | 2 --
>  Documentation/devicetree/bindings/ata/sata_highbank.yaml        | 1 -
>  3 files changed, 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ata/brcm,sata-brcm.yaml b/Documentation/devicetree/bindings/ata/brcm,sata-brcm.yaml
> index 235a93ac86b0..3766cc80cb17 100644
> --- a/Documentation/devicetree/bindings/ata/brcm,sata-brcm.yaml
> +++ b/Documentation/devicetree/bindings/ata/brcm,sata-brcm.yaml
> @@ -30,7 +30,6 @@ properties:
>            - const: brcm,bcm-nsp-ahci
>  
>    reg:
> -    minItems: 2
>      maxItems: 2
>  
>    reg-names:
> diff --git a/Documentation/devicetree/bindings/ata/cortina,gemini-sata-bridge.yaml b/Documentation/devicetree/bindings/ata/cortina,gemini-sata-bridge.yaml
> index 21a90975593b..529093666508 100644
> --- a/Documentation/devicetree/bindings/ata/cortina,gemini-sata-bridge.yaml
> +++ b/Documentation/devicetree/bindings/ata/cortina,gemini-sata-bridge.yaml
> @@ -22,7 +22,6 @@ properties:
>      maxItems: 1
>  
>    resets:
> -    minItems: 2
>      maxItems: 2
>      description: phandles to the reset lines for both SATA bridges
>  
> @@ -32,7 +31,6 @@ properties:
>        - const: sata1
>  
>    clocks:
> -    minItems: 2
>      maxItems: 2
>      description: phandles to the compulsory peripheral clocks
>  
> diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.yaml b/Documentation/devicetree/bindings/ata/sata_highbank.yaml
> index 49679b58041c..f23f26a8f21c 100644
> --- a/Documentation/devicetree/bindings/ata/sata_highbank.yaml
> +++ b/Documentation/devicetree/bindings/ata/sata_highbank.yaml
> @@ -52,7 +52,6 @@ properties:
>      minItems: 1
>      maxItems: 8
>      items:
> -      minItems: 2
>        maxItems: 2
>  
>    calxeda,tx-atten:


-- 
Damien Le Moal
Western Digital Research
