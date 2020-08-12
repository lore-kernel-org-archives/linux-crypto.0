Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BE0C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD8452080C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHLMmX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 08:42:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgHLMmW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 08:42:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k5q4v-00997m-Jt; Wed, 12 Aug 2020 14:42:01 +0200
Date:   Wed, 12 Aug 2020 14:42:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Scott Dial <scott@scottdial.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ryan Cox <ryan_cox@byu.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Message-ID: <20200812124201.GF2154440@lunn.ch>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
 <20200810133427.GB1128331@bistromath.localdomain>
 <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
 <20200812100443.GF1128331@bistromath.localdomain>
 <CY4PR0401MB36524B348358B23A8DFB741AC3420@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB36524B348358B23A8DFB741AC3420@CY4PR0401MB3652.namprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> With networking protocols you often also have a requirement to minimize
> packet reordering, so I understand it's a careful balance. But it is possible
> to serialize the important stuff and still do the crypto out-of-order, which
> would be really beneficial on _some_ platforms (which have HW crypto
> acceleration but no such CPU extensions) at least.

Many Ethernet PHYs are also capable of doing MACSeC as they
send/receive frames. Doing it in hardware in the PHY avoids all these
out-of-order and latency issues. Unfortunately, we are still at the
early days for PHY drivers actually implementing MACSeC offload. At
the moment only the Microsemi PHY and Aquantia PHY via firmware in the
Atlantic NIC support this.

	 Andrew
