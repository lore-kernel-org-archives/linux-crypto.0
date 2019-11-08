Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324B6FA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 102AF21882
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbfKHIvK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:51:10 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:46971 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHIvK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:51:10 -0500
X-Originating-IP: 86.206.246.123
Received: from localhost (lfbn-tou-1-421-123.w86-206.abo.wanadoo.fr [86.206.246.123])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 251B3240004;
        Fri,  8 Nov 2019 08:51:07 +0000 (UTC)
Date:   Fri, 8 Nov 2019 09:51:06 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: inside-secure - Fixed authenc w/ (3)DES fails on
 Macchiatobin
Message-ID: <20191108085106.GC111259@kwain>
References: <1573199165-8279-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20191108083810.GB111259@kwain>
 <MN2PR20MB2973F06785376947972AA751CA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973F06785376947972AA751CA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 08, 2019 at 08:40:29AM +0000, Pascal Van Leeuwen wrote:
> > On Fri, Nov 08, 2019 at 08:46:05AM +0100, Pascal van Leeuwen wrote:
> > > Fixed 2 copy-paste mistakes made during commit 13a1bb93f7b1c9 ("crypto:
> > > inside-secure - Fixed warnings on inconsistent byte order handling")
> > > that caused authenc w/ (3)DES to consistently fail on Macchiatobin (but
> > > strangely work fine on x86+FPGA??).
> > > Now fully tested on both platforms.
> > 
> > Can you add a Fixes: tag?
> > 
> Sure I can :-) If I know what I should put in such a Fixes: tag?
> (I'm off Googling now, but a response here might be faster :-)

:)

Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on inconsistent byte order handling")

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
