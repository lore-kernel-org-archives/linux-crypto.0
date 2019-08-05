Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1CAC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 13:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B9E2075B
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 13:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfHENMR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 09:12:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52875 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbfHENMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 09:12:16 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8CCE060008;
        Mon,  5 Aug 2019 13:12:14 +0000 (UTC)
Date:   Mon, 5 Aug 2019 15:12:13 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Message-ID: <20190805131213.GM14470@kwain>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805090725.GH14470@kwain>
 <MN2PR20MB29730648846013A67753624ECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190805095424.GJ14470@kwain>
 <MN2PR20MB2973944BBF39EB11537E3163CADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190805124328.GK14470@kwain>
 <MN2PR20MB2973ECE2AB0598E32E088EDECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973ECE2AB0598E32E088EDECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 05, 2019 at 01:02:08PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > 
> > Using this function that is designed to sleep with a delay of 0 and
> > designed to timeout with a value of 1 does not seem to follow what the
> > function is designed for :) It could work but I would suggest to keep
> > the polling as it is in the patch in this case.
> > 
> Ok, will do. Does that mean that patch 4/4 is good as is?
> i.e. can I add an "Acked-by: Antoine Tenart" line when I resubmit?

Sure, the rest of the patch looked good and you can add:

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
