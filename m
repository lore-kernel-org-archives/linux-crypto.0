Return-Path: <SRS0=OEQH=B3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96372C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 21:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2752072D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 21:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597700375;
	bh=Je/YzZWJ1KzQtwlFETxshgLz9HlGjQL/pqAHvFFNf94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jkUclhgcRAqqQ+zecM8L0N1x6BvtspieFt8G0uL9ASEhBRX73CaDaAj/3RypkV0Zj
	 HcweSJ9jFygNMaEcNJevxqzlCV3il7Hmd/Mm/NvmxFj/Uqgn1A0gk8PA7empgmhPBc
	 y6sC8Pl6guhY0Q3lYowMdnof8vSU503AsT3UVPGU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHQVje (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Aug 2020 17:39:34 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:36848 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgHQVjd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Aug 2020 17:39:33 -0400
Received: by mail-il1-f193.google.com with SMTP id z3so15859491ilh.3;
        Mon, 17 Aug 2020 14:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mw5wVwSExTMkeVX3ToMtDjg6KBaBweiQKzPEGQFQbxI=;
        b=FRirZIULmrNh1VlmCVdWev7PGEtgYPHLeNecjGqs72zZGnexh+cn2bWp06U1PVshNg
         ukybd+yfRNv7ek+/+OvVcuyjeCPvyWiDBKdtX0LEaRVScuQYtQBnb69tM/GK10iLj1Hb
         Lvsc9U7SI9lq+/WmTLF7dVuvbyOpb84k4lb2OqVZCSTB9GHUe2dWHv+i5OfKvbW6lK/Q
         EBWK2cTqsknfUHfezuNn96mI+UbvjEqlDbgw5PKAbUgelc9Nph6hYV/gPVEwupv9vKIL
         hCx1CVzu+05hTg4X81WvP6rjMpHSjweMF0aUKTmqu+xKtZFJN8Iyh3m62amYwuv72cfG
         dCkw==
X-Gm-Message-State: AOAM531qJV2nEt8t92GU9eIn+n6EE2Ach9YYGr/5TKdj8rVoJ3wJE7k8
        wZS5gNnW9H2LVHsl9L4mTKOmSU/0fA==
X-Google-Smtp-Source: ABdhPJz4xy1sZuMoMg+yUZJPmhtdp5Jkw7yxfPY8U6JrabWfyvP6WnDM7FeHKFHOcaQfdWi4ADhMiQ==
X-Received: by 2002:a92:dc81:: with SMTP id c1mr14028147iln.284.1597700372365;
        Mon, 17 Aug 2020 14:39:32 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id m7sm10154817ilq.45.2020.08.17.14.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 14:39:31 -0700 (PDT)
Received: (nullmailer pid 1614839 invoked by uid 1000);
        Mon, 17 Aug 2020 21:39:28 -0000
Date:   Mon, 17 Aug 2020 15:39:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anson Huang <Anson.Huang@nxp.com>
Cc:     linux-crypto@vger.kernel.org, mpm@selenic.com,
        linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
        festevam@gmail.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, Linux-imx@nxp.com, vz@mleia.com,
        horia.geanta@nxp.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] dt-bindings: rng: Convert i.MX to json-schema
Message-ID: <20200817213928.GA1614783@bogus>
References: <1596608884-13205-1-git-send-email-Anson.Huang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596608884-13205-1-git-send-email-Anson.Huang@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 05 Aug 2020 14:28:04 +0800, Anson Huang wrote:
> Convert the i.MX rng binding to DT schema format using json-schema.
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---
>  Documentation/devicetree/bindings/rng/imx-rng.txt  | 23 ----------
>  Documentation/devicetree/bindings/rng/imx-rng.yaml | 50 ++++++++++++++++++++++
>  2 files changed, 50 insertions(+), 23 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/imx-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/imx-rng.yaml
> 

Applied, thanks!
