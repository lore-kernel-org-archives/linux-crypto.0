From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Fri, 5 Jun 2015 16:38:03 +0200
Message-ID: <201506051638.03892.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <201506041734.40053.marex@denx.de> <20150605035433.GB527@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:41645 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423953AbbFEOjD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2015 10:39:03 -0400
In-Reply-To: <20150605035433.GB527@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, June 05, 2015 at 05:54:33 AM, Herbert Xu wrote:
> On Thu, Jun 04, 2015 at 05:34:39PM +0200, Marek Vasut wrote:
> > Is this really a valid way to go about crypto -- introduce all kinds
> > of obscure nuances into the API which are driver specific at best ?
> 
> So what do you suggest?

Well what about extending the API ?

Since Jay seems to be looking at the keyslots as well, it might make sense
to consider the "DCP key" as a special case of a "fixed" keyslot.

In general, it would probably make sense to add a flag to .setkey() to
store the key in a keyslot. The keyslot allocation would be up to the
driver. In case all keyslots would be full, the setkey() with the flag
set would simply fail. This would imply you would need to have a counterpart
function to .setkey() to free keyslots -- something like .unsetkey() .

The .setkey() could also be extended with one more argument, integer one,
to let users select which fixed keyslot to load the key from. Wouldn't
that resolve the issue with multiple fixed keyslots too ?

Best regards,
Marek Vasut
