Return-Path: <SRS0=jZ+Q=44=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF8AC10F25
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Mar 2020 06:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 051F1208C4
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Mar 2020 06:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583909266;
	bh=09xRglgut9wsKNqhMN+lYAhB+2AmpWjTxiVBHIOfKJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=r63lAAWilMhcDZSmI5Ajt8YlFuljyg25z4P8fhCW+oVbff0pD4RelvM2S4yv6yWcS
	 d5xBQOLeObNoz24umzxj0R2656jcjuLIBLYu5Xsq0E10uq18aHB3kjekbr98EGiXSw
	 Oroz/2+z6CerocTP+4604hzK9oorX8STJhet/LIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgCKGrm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgCKGrm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Mar 2020 02:47:42 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 362F0208C4;
        Wed, 11 Mar 2020 06:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583909261;
        bh=09xRglgut9wsKNqhMN+lYAhB+2AmpWjTxiVBHIOfKJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l82pKlcdyVMEuc3WGbjgIMBCw3Vn+rUtSL4GTkYbYXxjGOXkUtF/hrHUAqNXyi7pJ
         1iUa70qTt5qftBq7k65jm86p6WQv2dKNqsbqj5VSi+Ek8PNJjW0A/chn3M5UbBEaOg
         Trge2PdfCvVCsIN/4ouLov2FDc/T0gLjE23348b0=
Date:   Wed, 11 Mar 2020 14:47:33 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     =?iso-8859-1?Q?Andr=E9?= Draszik <git@andred.net>
Cc:     linux-kernel@vger.kernel.org,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 4/6] arm64: dts: imx8mq: add snvs clock to pwrkey
Message-ID: <20200311064733.GH29269@dragon>
References: <20200225161201.1975-1-git@andred.net>
 <20200225161201.1975-4-git@andred.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200225161201.1975-4-git@andred.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 04:11:59PM +0000, André Draszik wrote:
> On i.MX8MM, the SNVS requires a clock. This is similar to the clock
> bound to the SNVS RTC node, but if the SNVS RTC driver isn't enabled,
> then SNVS doesn't work, and as such the pwrkey driver doesn't
> work (i.e. hangs the kernel, as the clock isn't enabled).
> 
> Also see commit ec2a844ef7c1
> ("ARM: dts: imx7s: add snvs rtc clock")
> for a similar fix.
> 
> Signed-off-by: André Draszik <git@andred.net>

Applied, thanks.
