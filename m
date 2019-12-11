Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658ECC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E34214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfLKJ2C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:28:02 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:53326 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLKJ2C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:28:02 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieyHc-00086w-WE; Wed, 11 Dec 2019 17:27:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieyHW-0003GG-03; Wed, 11 Dec 2019 17:27:42 +0800
Date:   Wed, 11 Dec 2019 17:27:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     Anand Moon <linux.amoon@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCHv1 0/3] Enable crypto module on Amlogic GXBB SoC platform
Message-ID: <20191211092741.totwucrkversjbav@gondor.apana.org.au>
References: <20191211084112.971-1-linux.amoon@gmail.com>
 <a4610efc-844a-2d43-5db1-cf813102e701@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4610efc-844a-2d43-5db1-cf813102e701@baylibre.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 11, 2019 at 09:53:56AM +0100, Neil Armstrong wrote:
> 
> On 11/12/2019 09:41, Anand Moon wrote:
> > [sudo] password for alarm:
> > [  903.867059] tcrypt:
> > [  903.867059] testing speed of async ecb(aes) (ecb(aes-arm64)) encryption
> 
> Wow, I'm surprised it works on GXBB, Amlogic completely removed HW crypto for GXBB in all their
> vendor BSPs, in Linux, U-Boot and ATF chain.
> 
> Could you run more tests to be sure it's really functional ?

Well as you can see from the tcrypt output, it's actually using
aes-arm64 which is certainly not the amlogic driver.  Presumably
the amlogic driver failed to load/register.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
