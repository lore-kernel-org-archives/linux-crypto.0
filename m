Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D23C34047
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1EB824125
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582057351;
	bh=cuY6GffN1D6FKkueSHMC79T6UaDEtc9x/7YijKXMjk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zMe2fNiSWxKqdUlVMMAeHfIo2z7H/wWspaJMM9gpT+0PIsnKya1yzMAPXFxY7f6fG
	 K3XPHHRQXI/Ud7beqqIJMjlGy+BvYe0q7/Gv+3t+7IC0xFTfVZpnSIbG6PqcCt2e/o
	 Mm5a+QehNlZyK36m2SHoFSwDbS31kfMYgTf0+CtI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgBRUWb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:22:31 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34817 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgBRUWb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 15:22:31 -0500
Received: by mail-ot1-f65.google.com with SMTP id r16so20874678otd.2;
        Tue, 18 Feb 2020 12:22:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=daaBBUCEuUnfQegTP2Av5TymJI2QUIcyEiCvs2F4N30=;
        b=lx98B+BkRjgqJDDTJml3z4YVlRtdJI9dN1U8tq6pHudHOTr3WGtVSFRE/HFhYxq5bf
         2fjv065hsCQbBr8gscE4sIDejoWiqw3FaZO4AjVXGKomvopPNEiMP8q5qt9QQKV9GDJt
         MadQC7e/SpEktCZf9OGQKtG1HT1srz9QEFSIuqJYgRFWtiVWvr3R+hetzTaU/ATKiYvU
         ZBcs9rgUt906VKWFnG4u34q7sxcytN6t1QVI3Kafb8Y3GOX5eqbqTrP+AS6ilTKgks3I
         cRSmjPqRgZD6BuHN3KZzS7Ost0HeVPBj0sngxajpxXWz4GTVtrT0NlRahRx8+7KEu/Wc
         GC4Q==
X-Gm-Message-State: APjAAAV7Om6yvDQ30cNOJr9QQBolBwqhbZMq7QarsCAru049JtrTfrb0
        3ABf9kEnAiqBNFNIItwmqw==
X-Google-Smtp-Source: APXvYqwqwigdE85PJLju+tigx//D3sGJaqkmcCThEM1Iof93GR5UE9/jRUX02608MzMqd9pP9mjWEA==
X-Received: by 2002:a05:6830:160c:: with SMTP id g12mr12807531otr.82.1582057350380;
        Tue, 18 Feb 2020 12:22:30 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b145sm1537508oii.31.2020.02.18.12.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 12:22:29 -0800 (PST)
Received: (nullmailer pid 3281 invoked by uid 1000);
        Tue, 18 Feb 2020 20:22:29 -0000
Date:   Tue, 18 Feb 2020 14:22:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Message-ID: <20200218202229.GA2533@bogus>
References: <1581847450-22924-1-git-send-email-hadar.gat@arm.com>
 <1581847450-22924-2-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581847450-22924-2-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 16 Feb 2020 12:04:08 +0200, Hadar Gat wrote:
> The Arm CryptoCell is a hardware security engine. This patch adds DT
> bindings for its TRNG (True Random Number Generator) engine.
> 
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  .../devicetree/bindings/rng/arm-cctrng.yaml        | 50 ++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/arm-cctrng.yaml: properties:arm,rosc-ratio: {'allOf': [{'$ref': '/schemas/types.yaml#/definitions/uint32-array'}], 'maxItems': 4} is not valid under any of the given schemas (Possible causes of the failure):
	/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/arm-cctrng.yaml: properties:arm,rosc-ratio: 'description' is a required property

Documentation/devicetree/bindings/Makefile:12: recipe for target 'Documentation/devicetree/bindings/rng/arm-cctrng.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/rng/arm-cctrng.example.dts] Error 1
Makefile:1263: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1238733
Please check and re-submit.
