Return-Path: <SRS0=py82=2N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C04C2D0C0
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Dec 2019 08:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AA41206B7
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Dec 2019 08:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577090945;
	bh=uvYiO42x44YwlznJ7gGjnpYImsGJkvZIZYZtUbyi6m8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=E1MjaZK1uh1eq2xUzQQbMuOUeig3lUGrOdU4GefKwfPO3y/m/1Aoy1To8H4N0SzOW
	 umLeBI1k4Hn504tzsZ2Y52z9dCZUOzA3cfnYUAmttsyW4ogfS9djhvs5R+Xv/22Sdj
	 TlYb7Mp5R+9OaGeoPDkZus+S7M4QckNvmSGvckoE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfLWItB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Dec 2019 03:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfLWItA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Dec 2019 03:49:00 -0500
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1BF9206B7;
        Mon, 23 Dec 2019 08:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577090940;
        bh=uvYiO42x44YwlznJ7gGjnpYImsGJkvZIZYZtUbyi6m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDjgnKiRH93jW3yw/feZhiXW0rZVZN9Op6eXsCKfvGN1nqcyPsWATnlOdHQv22q8O
         UcVpWK+RBuuzkSXcWFfFc4zJElIqCjJaui9QbLqjgypvfKWY6aRSYIYpszC4Ru958D
         Yx5bmSXgxYXRwf2V1cIywEoBXC9mXo3i8r5EJdSo=
Date:   Mon, 23 Dec 2019 16:48:35 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH V3 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Message-ID: <20191223084834.GW11523@dragon>
References: <20191218130616.13860-1-aford173@gmail.com>
 <20191218130616.13860-3-aford173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218130616.13860-3-aford173@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 18, 2019 at 07:06:16AM -0600, Adam Ford wrote:
> Both the i.MX8MQ and i.MX8M Mini support the CAAM driver, but it
> is currently not enabled by default.
> 
> This patch enables this as a module.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>

Applied, thanks.
