Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87584C33CA3
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 10:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB4C2067D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 10:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578566595;
	bh=YNqb12KEnTIPfkhGZEULgW7dTJYPnkCVqbWis7dT6TU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1is1uBeFCtgKKzNKhnDaf+u5sqgLH2KMwDrSl0kDfGBRArGmIOmQK9KCJgBuxjJS2
	 YeaB6G6g/MDRLq5c5T/kO3X3P5TJKJ2f+mMv2wzWuqpofRiSYIxnS8qe/cMQrAjBm2
	 mSOIM5PuxIYssIFYUP5C+pu/6Xr9hP+LxG+gDlIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgAIKnE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 05:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbgAIKnC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 05:43:02 -0500
Received: from T480 (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25AE2067D;
        Thu,  9 Jan 2020 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578566582;
        bh=YNqb12KEnTIPfkhGZEULgW7dTJYPnkCVqbWis7dT6TU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZiIMUBCmB6il2OBWLC4G23Lk2FnsUJAMrGmvcmZYsfVPMfhitVMg4Cw5aoxAj8vz
         jXAadX+HGRf6R4yJCMjHXEnuJsRohyBD66Zph83bmygqrD18ZauYYTvaI3QTl4YhEl
         aJSlmauHVbuyCuJqnUowPFOH0ugzEefrdUVg8zQw=
Date:   Thu, 9 Jan 2020 18:42:54 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: imx8mn: add crypto node
Message-ID: <20200109104254.GQ4456@T480>
References: <20200106200154.30643-1-horia.geanta@nxp.com>
 <20200106200154.30643-2-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200106200154.30643-2-horia.geanta@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 06, 2020 at 10:01:54PM +0200, Horia Geantă wrote:
> Add node for CAAM - Cryptographic Acceleration and Assurance Module.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Applied, thanks.
