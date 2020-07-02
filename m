Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C206FC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 08:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1D3E20720
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 08:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgGBI2F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgGBI2E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 04:28:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D16CC08C5C1
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2020 01:28:04 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1jquZQ-0006VX-Ql; Thu, 02 Jul 2020 10:27:48 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1jquZN-0004K1-AR; Thu, 02 Jul 2020 10:27:45 +0200
Date:   Thu, 2 Jul 2020 10:27:45 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Franck Lenormand <franck.lenormand@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Martin Kaiser <martin@kaiser.cx>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 4/5] ARM: dts: imx6ull: add rng
Message-ID: <20200702082745.gkgkjdrybbeaars4@pengutronix.de>
References: <20200621145658.12528-1-horia.geanta@nxp.com>
 <20200621145658.12528-5-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200621145658.12528-5-horia.geanta@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:27:19 up 229 days, 23:45, 232 users,  load average: 0.02, 0.10,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20-06-21 17:56, Horia Geantă wrote:
> Add node for the RNGB block.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---

Reviewed-by: Marco Felsch <m.felsch@pengutronix.de> 
