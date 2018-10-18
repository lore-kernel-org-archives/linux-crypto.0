Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64DBC5ACCC
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Oct 2018 18:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58CF92098A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Oct 2018 18:25:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58CF92098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbeJSC1r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Oct 2018 22:27:47 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41447 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbeJSC1r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 22:27:47 -0400
Received: by mail-oi1-f194.google.com with SMTP id l197-v6so24791020oib.8;
        Thu, 18 Oct 2018 11:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KXhBMyxzWWa4j7MFH1Ln1pqY6tnuSQTijJ8LU0Itl1o=;
        b=NOW4/OAlU7QvZXaqVNO8iDU16fFv60r/nhiJSxmm1KnHVap2mOnU/57m+qv8f5dxUm
         w/2q9hWSl5R7Er+3uffUErcrj0wPsnF7FMdG+xzJxMJqTzpnzNBawEp/5krBH9+H8mEB
         OGqG0DC8ZS3Eg65vhRXlsNNdNitSlbL1e6z05vaN9bwlYxqTcj/e1/uwtkOJ4OzMv0Jl
         ouleY24oUnu8Dk4Kkr74y2+zxszJGjtZYKuEDl4vZzHOuiSaqaBZtg3ZXGIKboLcg5yf
         9gy6QhK9bO1zsAa1Q/CaUmFXIiUBUQiZLlypw+KeQSnTM8R2/zpIFSGxRYrpl7UIAEdd
         806Q==
X-Gm-Message-State: ABuFfogXjCDZ6JVVEHlVAc0pfW0/pG1oHxEyIsTmjyJUbAi/8LRk916+
        uIkQ1gvKmagQFFxUNfEVZg==
X-Google-Smtp-Source: ACcGV62SB2akFVl9zfUYZzcl1ImQbgj7Dq7/TR1L73ZzyEqalOgjezK6djni9Nlu1D1hpzll5Wqi/w==
X-Received: by 2002:aca:df87:: with SMTP id w129-v6mr15660431oig.241.1539887134160;
        Thu, 18 Oct 2018 11:25:34 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k68-v6sm7323378oib.35.2018.10.18.11.25.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 11:25:33 -0700 (PDT)
Date:   Thu, 18 Oct 2018 13:25:32 -0500
From:   Rob Herring <robh@kernel.org>
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Message-ID: <20181018182532.GA28722@bogus>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
 <4536b5b5b101ab6a4197fb4891f775ddeb519847.1539779579.git.leonard.crestez@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <4536b5b5b101ab6a4197fb4891f775ddeb519847.1539779579.git.leonard.crestez@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181018182532.KHseiZL74PM43J8x4w-eWVIW-oPqh3erNzMrlfVgzQ8@z>

On Wed, 17 Oct 2018 12:37:51 +0000, Leonard Crestez wrote:
> Explicit clock enabling is required on 6sll and 6ull so mention that
> standard clock bindings are used.
> 
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/fsl-dcp.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
