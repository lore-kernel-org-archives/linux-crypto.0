From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Subject: RE: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 07:15:49 +0000
Message-ID: <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <14565196.xaXq375WQg@tauon.atsec.com>
 <82844e4b56c9475fabf22b3fe12b53bb@aptaiexm02f.ap.qualcomm.com>
 <1526134.1iUazSISyZ@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9004 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbcHJSHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 14:07:46 -0400
In-Reply-To: <1526134.1iUazSISyZ@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

NIST SP 800-22-rev1a and NIST SP 800-90B are used together to evaluate the amount of min entropy the source provides, and not to decide if the source has passed the tests or failed. See

https://github.com/usnistgov/SP800-90B_EntropyAssessment

The goal is often to make sure the input entropy is more than the entropy we expect from the output.

Thanks,
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Wednesday, August 10, 2016 2:52 PM
To: Pan, Miaoqing <miaoqing@qti.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>; Matt Mackall <mpm@selenic.com>; miaoqing@codeaurora.org; Valo, Kalle <kvalo@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-crypto@vger.kernel.org; jason@lakedaemon.net; Sepehrdad, Pouyan <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Mittwoch, 10. August 2016, 06:46:31 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> Would you please provide a recent NIST document which asks the entropy 
> source to pass the NIST randomness tests ?

See FIPS 140-2 IG 7.15 which explicitly references SP800-22.

Ciao
Stephan
