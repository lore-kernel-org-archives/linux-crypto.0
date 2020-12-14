Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9A8C2BB48
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 19:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB122255F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 19:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502297AbgLNTBS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502254AbgLNTBI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 14:01:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89582C0613D6
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 11:00:28 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1kot57-0007WT-Ky; Mon, 14 Dec 2020 20:00:25 +0100
Message-ID: <f9e4f7269c93306784e9106f4eb8a6c874973143.camel@pengutronix.de>
Subject: CAAM RNG trouble
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Date:   Mon, 14 Dec 2020 20:00:24 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

I've been looking into a CAAM RNG issue for a while, where I could need
some input from people knowing the CAAM hardware better than I do.
Basically the issue is that on some i.MX6 units the RNG functionality
sometimes fails with this error:
caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.

I can tell that it is related to the entropy delay. On all failing
units the RNG4 gets instantiated with the default entropy delay of
3200. If I dial up the delay to 3600 or 4000 the RNG works reliably. As
a negative test I changed the initial delay to 400. With this change
all units are able to successfully instantiate the RNG handles at an
entropy delay of 2000 or 2400, but then reliably fail at getting random
data with the error shown above. I guess the issue is related to
prediction resistance on the handles, which causes the PRNG to be re-
seeded from the TRNG fairly often.

Now I don't have a good idea on how to arrive at a reliably working
entropy delay setting, as apparently the simple "are we able to
instantiate the handle" check is not enough to actually guarantee a
working RNG setup. Any suggestions?

Regards,
Lucas

