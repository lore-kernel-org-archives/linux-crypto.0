Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1383C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFDF7212F5
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfFXOU1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 10:20:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44702 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfFXOU1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 10:20:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hfPpU-0008DH-QT; Mon, 24 Jun 2019 22:20:20 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hfPpP-00052w-Ja; Mon, 24 Jun 2019 22:20:15 +0800
Date:   Mon, 24 Jun 2019 22:20:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Message-ID: <20190624142015.udlec3ho57a47hps@gondor.apana.org.au>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619122737.GB3254@kwain>
 <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620131512.GB4642@kwain>
 <AM6PR09MB35236CA6971A1B6D03AB9BD4D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620154259.GE4642@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620154259.GE4642@kwain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 20, 2019 at 05:42:59PM +0200, Antoine Tenart wrote:
>
> Yes, you either have to choice to put it in /lib/firmware (and in the
> linux-firmwares project!) or to convince people to allow releasing this.

I agree.  We should not be adding firmware into the driver itself.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
