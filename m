Return-Path: <SRS0=68iz=XL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013D4C49ED7
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 20:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD2820830
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 20:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391358AbfIPUXa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Sep 2019 16:23:30 -0400
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:44494 "EHLO
        emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732809AbfIPUXa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Sep 2019 16:23:30 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2019 16:23:29 EDT
Received: from darkstar.musicnaut.iki.fi (85-76-81-183-nat.elisa-mobile.fi [85.76.81.183])
        by emh07.mail.saunalahti.fi (Postfix) with ESMTP id C0897B008C;
        Mon, 16 Sep 2019 23:17:50 +0300 (EEST)
Date:   Mon, 16 Sep 2019 23:17:50 +0300
From:   Aaro Koskinen <aaro.koskinen@iki.fi>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-crypto@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <t-kristo@ti.com>, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 0/7] Non-urgent fixes and improvments for omap3-rom-rng
Message-ID: <20190916201750.GF8201@darkstar.musicnaut.iki.fi>
References: <20190914210300.15836-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914210300.15836-1-tony@atomide.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Sat, Sep 14, 2019 at 02:02:53PM -0700, Tony Lindgren wrote:
> Here are fixes and improvments for omap3-rom-rng that's been broken for
> a while.

Thanks, for the whole series:

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

A.
