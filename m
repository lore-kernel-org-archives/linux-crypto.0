Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A355CA9EC0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 13:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFDE220717
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 13:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbfJ1NAs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 09:00:48 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51583 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbfJ1NAr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 09:00:47 -0400
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1iP4dN-0003D8-Tx; Mon, 28 Oct 2019 14:00:33 +0100
Message-ID: <7bbd6c77117d2391f6669a9eb958730717ea295c.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner sun8i-ss cryptographic
 offloader
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, mark.rutland@arm.com,
        mripard@kernel.org, robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Date:   Mon, 28 Oct 2019 14:00:28 +0100
In-Reply-To: <20191025185128.24068-2-clabbe.montjoie@gmail.com>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
         <20191025185128.24068-2-clabbe.montjoie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Corentin,

On Fri, 2019-10-25 at 20:51 +0200, Corentin Labbe wrote:
> The Security System is an hardware cryptographic offloader present
> on Allwinner SoCs A80 and A83T.
> It is different from the previous sun4i-ss.
> 
> This driver supports AES cipher in CBC and ECB mode.
> 
> Acked-by: Maxime Ripard <mripard@kernel.org>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
[...]
> +static int sun8i_ss_probe(struct platform_device *pdev)
> +{
> +	struct sun8i_ss_dev *ss;
> +	int err, irq;
> +	u32 v;
> +
> +	ss = devm_kzalloc(&pdev->dev, sizeof(*ss), GFP_KERNEL);
> +	if (!ss)
> +		return -ENOMEM;
[...]
> +
> +	ss->reset = devm_reset_control_get(&pdev->dev, NULL);

It looks like this driver could use devm_reset_control_get_shared() to
get a (clk-like) refcounted reset control. Otherwise, please use
devm_reset_control_get_exclusive() instead of devm_reset_control_get().

See the kerneldoc comment for reset_control_get_shared() for details.

regards
Philipp

