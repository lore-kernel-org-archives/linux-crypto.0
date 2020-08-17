Return-Path: <SRS0=OEQH=B3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E015C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 08:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F2C22080D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 08:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597651660;
	bh=brGKh7glX5r5oiJ5N4dduRMuN53pF28YcimSGGrgpKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IfGu/l2JjNhymncV1r1383kGwQCMXWqugVv+gcA/uTSatUGMsUIuNW8DOsu7Tp7t7
	 lMPHvkxhLdepTkO9tz5Cmoo2/A57Cwp64C9cT0djvXOso5+jzSp9AjmfEZ4HBmmGI4
	 LnH+USCSX82Y2JMALo1mnWJNbDjroYW9KLKNO3vM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHQIHg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgHQIHf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Aug 2020 04:07:35 -0400
Received: from dragon (unknown [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D2720758;
        Mon, 17 Aug 2020 08:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597651655;
        bh=brGKh7glX5r5oiJ5N4dduRMuN53pF28YcimSGGrgpKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z9SiSTSNK4ZGq5qzaEX4UGpdRQLuI5evIPschXW1F8xJeSZfDBOKgyYOSkcv6GCGZ
         bThQsKb6Tfdi/eQNHmA/gMjyPVVCBuAJaaKY0sybfjOmR5gAIt1FIYVETtj6zlPlyR
         IZYI5SUsWrtU/ub0hx4bFP3T9FR8o4S4m86qE7MM=
Date:   Mon, 17 Aug 2020 16:07:19 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] hwrng: add support for i.MX6 rngb
Message-ID: <20200817080718.GD16951@dragon>
References: <20200715152604.10407-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200715152604.10407-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 15, 2020 at 06:25:59PM +0300, Horia Geantă wrote:
> Add support for RNGB found in some i.MX6 SoCs (6SL, 6SLL, 6ULL, 6ULZ),
> based on RNGC driver (drivers/char/hw_random/imx-rngc.c).
> 
> This driver claims support also for RNGB (besides RNGC),
> and is currently used only by i.MX25.
> 
> Note:
> 
> Several NXP SoC from QorIQ family (P1010, P1023, P4080, P3041, P5020)
> also have a RNGB, however it's part of the CAAM
> (Cryptograhic Accelerator and Assurance Module) crypto accelerator.
> In this case, RNGB is managed in the caam driver
> (drivers/crypto/caam/), since it's tightly related to
> the caam "job ring" interface, not to mention CAAM internally relying on
> RNGB as source of randomness.
> 
> On the other hand, the i.MX6 SoCs with RNGB have a DCP
> (Data Co-Processor) crypto accelerator and this block and RNGB
> are independent.
> 
> Changelog:
> v4
> -remove unneeded compatible strings from the driver
> v3
> -mention in the DT binding the compatibility with "fsl,imx25-rngb"
> -collected Reviewed-by
> v2
> -update rngb DT binding with compatible strings for i.MX6 SoCs
> 
> Horia Geantă (5):
...
>   ARM: dts: imx6sl: fix rng node
>   ARM: dts: imx6sll: add rng
>   ARM: dts: imx6ull: add rng

Applied these 3, thanks.

Shawn
