Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA3AC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5249620679
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574272809;
	bh=hK5DVOMtFQ1EervJLDJRvgW13ZbQtHEdbetGsj+Djzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ses2sJ7eGoqhJCEm2jVCzPK6h8GMgQA3/WouumqCBcmPaY0gGMP4Y65L8bv8I2RdV
	 dZo5QtlQjfcCsUX4DNb5m43dVrGH9/iCkFhVszFKIXRN10ojzwPVRaLe0vsj8R03WJ
	 o4hWnEh1vbm4mZuy+Vt4QrZKFfativEUPZIm/E0g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfKTSAF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:00:05 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43993 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfKTSAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 13:00:04 -0500
Received: by mail-oi1-f196.google.com with SMTP id l20so558472oie.10;
        Wed, 20 Nov 2019 10:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x8ePvXP6yBjIswFN0sdVge4OwEb8RGh4Ff5OcAFkAGM=;
        b=UobEsz8O83ZOT1fk+r1aN1pBFnI/DzPRis9I31vzUQHaDy1pAlG3/OJ02bgNp6e8X4
         +Pr3gtP7AI5IcmOAD3X6EnQzZDAxzA3oxn2Ki0cRWuAWd5o9Jv3z6ynrKmhT8n+at80x
         p6GYIbQc6qKCwuOdDcBuMLZhCGKR7gPu9xwIkuBcNQvk7osvm31fz8HJYeBvbb2zF0FZ
         /vJrjx22Ptpf2ZNHZVINIk7HSiLq//5geeK/n1GTqT9+3AnJNI/T+a0YiXwz/ifXJjyV
         eUEhkzSlTjzCqj5vIQCigmLjl4Vz4eVcIA+6Q6MFfDgx5Psy7J12XlF7UJTVuAgUTpxc
         yPyw==
X-Gm-Message-State: APjAAAUiEi7WFDWq9lpO1UCZli9SAJzE516dcj/syTI4Vt9Zu0aDjimV
        18xkx/JT2t/FvcmRfykhbQ==
X-Google-Smtp-Source: APXvYqzDJfTkwXh/5EwhxyVPxH0tUWubEzVqDD9sGhy5+DHuWlRO4ADPw/t8mbBv7JzFCN3xOHULzg==
X-Received: by 2002:a54:4407:: with SMTP id k7mr4009997oiw.129.1574272802323;
        Wed, 20 Nov 2019 10:00:02 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m20sm5915810otr.47.2019.11.20.10.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 10:00:01 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:00:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, alexandre.torgue@st.com,
        lionel.debieve@st.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: Re: [PATCH] dt-bindings: rng: Convert stm32 RNG bindings to
 json-schema
Message-ID: <20191120180001.GA9839@bogus>
References: <20191115100854.17938-1-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115100854.17938-1-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 15 Nov 2019 11:08:54 +0100, Benjamin Gaignard wrote:
> Convert the STM32 RNG binding to DT schema format using json-schema
> Remove interrupt from the json-schema because it is not used by the driver.
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  .../devicetree/bindings/rng/st,stm32-rng.txt       | 25 -----------
>  .../devicetree/bindings/rng/st,stm32-rng.yaml      | 48 ++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 25 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> 

Applied, thanks.

Rob
