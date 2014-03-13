From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/3 V2] crypto: Fix the pointer voodoo in unaligned ahash
Date: Thu, 13 Mar 2014 05:01:00 +0100
Message-ID: <201403130501.00589.marex@denx.de>
References: <1389720829-5963-1-git-send-email-marex@denx.de> <201403130220.29346.marex@denx.de> <20140313015624.GA2680@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:38017 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCMEBD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2014 00:01:03 -0400
In-Reply-To: <20140313015624.GA2680@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, March 13, 2014 at 02:56:25 AM, Herbert Xu wrote:
> On Thu, Mar 13, 2014 at 02:20:29AM +0100, Marek Vasut wrote:
> > OK, understood. But shall we not preserve the request intact in case a
> > crypto- api function called crypto_ahash_final() with request which has
> > .priv already set? Then we would have really funny corruption of the
> > request going on and I'm not sure that'd be nice.
> 
> The priv field is only ever used by ahash.c so how can this happen?
> The crypto API refers to code in the API itself, excluding drivers
> and users.

OK, I agree with you that people plumbing in the API itself will know what 
they're doing.

btw. can you please check the V3 of 3/3 for the fixup of the base.completion() 
call ? I will then do tests and roll V4 of the series.

Best regards,
Marek Vasut
