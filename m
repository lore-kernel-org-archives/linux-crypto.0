Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AEFECDE32
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C5C42150D
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfnZvDGa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C5C42150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbeJQUnq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:43:46 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40279 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbeJQUnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:43:46 -0400
Received: by mail-oi1-f194.google.com with SMTP id j68-v6so20936647oib.7;
        Wed, 17 Oct 2018 05:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8f2MWGigH5X5oEjoqFaeKPsTcmN2VjqAB7dIhDSGv8=;
        b=AfnZvDGaRl96PPxHVLF+HuMgD+/Ms6NNoHp7kywhRAk2l7cdC/c6xBRgqljY8FJxCJ
         cTZ/ExGdO+/cmoGDfV6dRnNgX2okdySoJSbcJjaHKV4WYR0t+iwfTADVw0SNfd0pOzG/
         UdP72PLCrmB8fB+UVYADVn8U10cmSvasdfWtL+EXsjcBviTj42VwH8959GIMF9c+IuUs
         4oKwOXqhGTHtLhj+hXGXM36uyeIZmO3yvQSPZx5ZtNtx5AKOU6+3pqy7i7y8Ua6bvaXO
         rBNeXZBYiZPTlyktti+HKlbZFhZN+c9+Ziu+cuy8LXCVtNKJksBHru6isn6qWxHQSQet
         fA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8f2MWGigH5X5oEjoqFaeKPsTcmN2VjqAB7dIhDSGv8=;
        b=YU04zcXon4wd79MjUPism2QhNaGLVNgcbZLZPH4CEeow5Y7YRoEBea8n80LN/XJWlO
         ukuclE+7AbGuQJpeHtCc2doppfQ+Gfqq6GxOF+ibIoWko7ETidoNoliPjHUKbUXG/hkK
         tzHmoclCuYoIvZpGdvyBjyBuNGNuluE7zJtja4u9Kxn78YEL7gbJX9b83ipyF+/KKppF
         Atp+OdEdlhzc3CRBv0wJPZyOxnPz8pFb0XMifbkeZLZGlglmTgi6HrAimYVly/ucf/H7
         0WJYZnkT38Qv8FFUq+MP3V4xqGcPOOXZFptKwFlmNS36wOsfgj7QS/DFr7WVmyDOFaSv
         1YNg==
X-Gm-Message-State: ABuFfogeWeSg1CA0ZFjCRwsDN5SUqYoWWFjN5CDXsJ4xrwXXk5KxiOol
        Em1JtD+bQ2gKFr6nzcBvb2XdxBLlZcDbQWTkcFw=
X-Google-Smtp-Source: ACcGV62TCjhXlbBRbRdHpx5qjdbUhfHohtP+P/5LIR5XhEcJq0gRCBKNjJcbUpKW5hiRnF8Q5Cc/qZ+QX8HAG1pW3hA=
X-Received: by 2002:aca:e385:: with SMTP id a127-v6mr14891988oih.261.1539780492117;
 Wed, 17 Oct 2018 05:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539779579.git.leonard.crestez@nxp.com> <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
In-Reply-To: <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 17 Oct 2018 09:48:21 -0300
Message-ID:
 <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017124821.ErBaraZXJk0sxKZDtglkDFbSq-HFqAD4e9YcgFZ0WEI@z>

Hi Leonard,

On Wed, Oct 17, 2018 at 9:38 AM Leonard Crestez <leonard.crestez@nxp.com> wrote:
>
> On 6ull and 6sll the DCP block has a clock which needs to be explicitly
> enabled.
>
> Add minimal handling for this at probe/remove time.
>
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> ---

Please always explain what changed from the previous patch version.

> +       /* Restart the DCP block. */
> +       ret = stmp_reset_block(sdcp->base);
> +       if (ret) {
> +               dev_err(dev, "Failed reset\n");
> +               goto err_disable_unprepare_clk;
> +       }

This seems like an unrelated change that should be in a separate patch.

Also, this was not present in v3, so it is better to explain that this
has been introduced in v4.
