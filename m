Return-Path: <SRS0=OEQH=B3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B94C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 21:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB8D2076E
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597700040;
	bh=zUIHPn0fiMVBjP6AtjdPRZgYmIr1c7dW4GGEeQNKxgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AoOXBtFH8dSd06sJ2wSbglS4hK5YOcdWnkF5Ug2B6mKaSaCGbYWgIz+aSiVu5zmp8
	 SLLfqWqBHuGwt635bZfj4NNbyQX4CaILRLeOtzMx6K5pnUKGe5hnjw7qjNLBoIWSEC
	 ViXvwB4gbCdFM+VsU8xAYggDRpxa5vIUGCbeO1OQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHQVd4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Aug 2020 17:33:56 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:43111 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQVdz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Aug 2020 17:33:55 -0400
Received: by mail-il1-f194.google.com with SMTP id e11so7861113ils.10;
        Mon, 17 Aug 2020 14:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y26AUZsyfNVUh6ICj3yzwOQFlf2RG5cAsljrSSMJoho=;
        b=Gly5u0gxcGMMP2W5s7uVDruHijmGgnHCDH7HZQVzBnjyWVaUq1oeDFaVXZ2bvfcjEw
         Y2p4KN49txD2++U2dOZpSu4GVMBL5Suq97GLOB4y48r75LD1efyRm06qYs6agEyMsBno
         5AyrEMvV2nZsPOa3FoCkSlg68pLp3lmZnUujcISk3aV8okTJ8e2skt2Pfrb1S66G17xd
         6htAP3CK00b7sIIOomDYOrzEVZ5L8P+KSj19HK5S1TD7fBLN3qJwTA/kzyIaPlz8plO7
         hMTkdPvITqhooh51Yfk0F1lPginmL2qQY7I/oSgVSo8Vyz9ZnFZfNTW8fVq9dM5wbNB5
         DDcA==
X-Gm-Message-State: AOAM532zaUCcpkPS7naatLJwCACglE82FVPDtATlFRGPpBBQw/aMgm1w
        bTQFPIo6qJSa5cfrfNEdtJy4eTTdLw==
X-Google-Smtp-Source: ABdhPJzLjIdeN/K96y7VXE0TMMMxcF9JBXe5OV2h/t9Fi3FVbaAJUvikWYZGTKTeXhH3pnVMZWPEEw==
X-Received: by 2002:a05:6e02:a:: with SMTP id h10mr15101609ilr.193.1597700034718;
        Mon, 17 Aug 2020 14:33:54 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id b74sm10643886ilb.64.2020.08.17.14.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 14:33:54 -0700 (PDT)
Received: (nullmailer pid 1605136 invoked by uid 1000);
        Mon, 17 Aug 2020 21:33:50 -0000
Date:   Mon, 17 Aug 2020 15:33:50 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anson Huang <Anson.Huang@nxp.com>
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        festevam@gmail.com, s.trumtrar@pengutronix.de,
        devicetree@vger.kernel.org, Linux-imx@nxp.com, shawnguo@kernel.org,
        davem@davemloft.net, marex@denx.de,
        linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
        robh+dt@kernel.org, kernel@pengutronix.de,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: crypto: Convert i.MX SCC to json-schema
Message-ID: <20200817213350.GA1605082@bogus>
References: <1596595410-26921-1-git-send-email-Anson.Huang@nxp.com>
 <1596595410-26921-2-git-send-email-Anson.Huang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596595410-26921-2-git-send-email-Anson.Huang@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 05 Aug 2020 10:43:29 +0800, Anson Huang wrote:
> Convert the i.MX SCC binding to DT schema format using json-schema.
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---
>  .../devicetree/bindings/crypto/fsl-imx-scc.txt     | 21 ---------
>  .../devicetree/bindings/crypto/fsl-imx-scc.yaml    | 52 ++++++++++++++++++++++
>  2 files changed, 52 insertions(+), 21 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.yaml
> 

Applied, thanks!
