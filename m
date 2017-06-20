From: Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH v2 0/3] add support of hardware random generator on
 MediaTek MT7622
Date: Wed, 21 Jun 2017 00:08:14 +0800
Message-ID: <1497974894.31931.8.camel@mtkswgap22>
References: <cover.1497280813.git.sean.wang@mediatek.com>
         <20170620034009.GD17764@gondor.apana.org.au>
         <1497968477.27946.5.camel@mtkswgap22> <20170620145933.GA4177@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, <mpm@selenic.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <clabbe.montjoie@gmail.com>, <prasannatsmkumar@gmail.com>,
        <romain.perier@free-electrons.com>, <shannon.nelson@oracle.com>,
        <weiyongjun1@huawei.com>, <devicetree@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>
To: Torsten Duwe <duwe@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:10120 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751052AbdFTQI3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 12:08:29 -0400
In-Reply-To: <20170620145933.GA4177@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-06-20 at 16:59 +0200, Torsten Duwe wrote:
> On Tue, Jun 20, 2017 at 10:21:17PM +0800, Sean Wang wrote:
> > Hi Herbert,
> > 
> > thanks for effort reviewing on those patches.
> > 
> > By the way, also loop in Torsten
> > 
> > Could you kindly guide me how to determine appropriate 
> > rng->ops.quality value used by the driver?
> > 
> > I have tested with rngtest on mtk-cir and the result is got as
> > the below log shown.  If the rngtest always gives the result for
> > success rate over 99.8%, can I set the rng->ops.quality 998?
> > 
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 998
> > rngtest: FIPS 140-2 failures: 2
> 
> No! You'd have to determine the failure threshold of the test and
> apply some math to find a lower boundary of your RNG's entropy.
> 
> What the quality is for: your RNG produces bits, but not all of them
> are completely independent of each other i.e. not completely random.
> So you simply lower the quality rating to express the net entropy
> contained in the data stream.
> 
> 	Torsten
> 


Hi Torsten,

Understood, appreciate your quick and clear explanation.
 
For the math, is there existing any well-known or recommended
open source software assisting identify the lower boundary of
RNG entropy? I think the logic should be common for all RNGs.

thanks again

	Sean


	Sean
