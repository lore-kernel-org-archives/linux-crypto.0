Return-Path: <SRS0=jZ+Q=44=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1023C10F27
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Mar 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA31D21D7E
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Mar 2020 06:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583909015;
	bh=v3Kb+BE2jej1X8dtgFX8w+1zK9ac6+08Ps4La6EyeUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bCTCYFeYZqwZY7ocahmbhjLeujBr6FDvMoysVvbWAg+9SUaA3aoMKMeIgxy8pH0kp
	 CeaGnMmh93ehGz5gvuDSfmuQqDPyVE4lJYX94Iy7wXW9n2zc7+U9qYYJ9k28rvecZu
	 bOvgLijjfWPRgZ3v8oxJayadPmsAhK2RXf0aUtqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCKGnc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKGnc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Mar 2020 02:43:32 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA7C21655;
        Wed, 11 Mar 2020 06:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583909011;
        bh=v3Kb+BE2jej1X8dtgFX8w+1zK9ac6+08Ps4La6EyeUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTNZDK9xVIJKDweX9qVjLncu2FEeKgdVih0D6ZD8ogyGWuuGQjsK6SvRtE0ea5h5C
         GWlPD31eLZD1/gZagIjHLTFauIIgXIWZ/KYrvq/Fu5PI8I3CrRmljkMCYrXKUJwpgB
         7jOO8CJgSo4k4aNkeMjwrbqF69v9vQmmvrRMeVPs=
Date:   Wed, 11 Mar 2020 14:43:20 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     =?iso-8859-1?Q?Andr=E9?= Draszik <git@andred.net>
Cc:     linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
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
Subject: Re: [PATCH v2 2/6] ARM: dts: imx7s: add snvs clock to pwrkey
Message-ID: <20200311064320.GF29269@dragon>
References: <20200225161201.1975-1-git@andred.net>
 <20200225161201.1975-2-git@andred.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200225161201.1975-2-git@andred.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 04:11:57PM +0000, André Draszik wrote:
> On i.MX7, the SNVS requires a clock. This is similar to the clock
> bound to the SNVS RTC node, but if the SNVS RTC driver isn't enabled,
> then SNVS doesn't work, and as such the pwrkey driver doesn't
> work (i.e. hangs the kernel, as the clock isn't enabled).
> 
> Also see commit ec2a844ef7c1
> ("ARM: dts: imx7s: add snvs rtc clock")
> for a similar fix.
> 
> Signed-off-by: André Draszik <git@andred.net>
> Acked-by: Rob Herring <robh@kernel.org>

Applied, thanks.
