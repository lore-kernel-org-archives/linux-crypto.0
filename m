Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97ECC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 08:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ECCB20809
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 08:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgG1IuZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 04:50:25 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:44469 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgG1IuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 04:50:24 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4BG9Ns6mg5z37rL;
        Tue, 28 Jul 2020 10:50:21 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4BG9NT21J9z2xjv;
        Tue, 28 Jul 2020 10:50:01 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.10) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 28 Jul
 2020 10:47:31 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Marco Felsch <m.felsch@pengutronix.de>
CC:     Fabio Estevam <festevam@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "Matt Mackall" <mpm@selenic.com>, Shawn Guo <shawnguo@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] hwrng: imx-rngc - setup default RNG quality
Date:   Tue, 28 Jul 2020 10:47:29 +0200
Message-ID: <2473540.1Sv8tvBx5K@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200728074817.hlevn7ex2hckdbvi@pengutronix.de>
References: <CAOMZO5ASnj7SpjjAEpWjRK-vMpFFKU00=rxKeBtaMSKE9pkX1g@mail.gmail.com> <20200727124552.4336-1-ceggers@arri.de> <20200728074817.hlevn7ex2hckdbvi@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.10]
X-RMX-ID: 20200728-105003-4BG9NT21J9z2xjv-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Marco,

On Tuesday, 28 July 2020, 09:48:17 CEST, Marco Felsch wrote:
> Hi Christian,
> 
> On 20-07-27 14:45, Christian Eggers wrote:
> > When hw_random device's quality is non-zero, it will automatically fill
> > the kernel's entropy pool at boot.  For this purpose, one conservative
> > quality value is being picked up as the default value.
> 
> IMHO your value is not conservative enough and the commit message should
> explain why we should use 900. Unfortunately I had not enough time to
> send my patch addressing this. However please check my commit message
> why 900 is not good:
ok, you caught me. I found the value of 900 in several other drivers and 
simply took it. Even parts of my commit message were simply copied...

As I have no real idea about determining the right quality, I will leave this 
task for you :-)

Thanks
Christian



