From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Date: Tue, 4 Nov 2014 10:57:57 +0200
Message-ID: <54589515.2010903@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
 <20141103134716.775acd39d6334c6f8aeca151@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<horia.geanta@freescale.com>, <marex@denx.de>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:52933
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbaKDI6F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Nov 2014 03:58:05 -0500
In-Reply-To: <20141103134716.775acd39d6334c6f8aeca151@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim,

>> Actually, our static code analyzer did not see this one.
> 
> ok, so the patch technically isn't fixing anything broken, then.

Are you saying the code isn't broken _because_ a static tool analyser
did not see anything wrong here?


> the new code just added a new condition, which doesn't invalidate
> the comment.  And simply removing the comment as opposed to amending
> it is a bit overkill.

You are partially right, but will the staggering lack of comments in the
caam driver be fixed by duplicating a cascade of three ifs into english?


>> It is indeed simpler but does it consider also the missing error codes
>> at index 1 and 5? Just checking for an upper bound is not enough.
>
> no, the existing code already handles that.  Note that newer
> documentation fills the 1 and 5 slots, too.

If you have the new error codes please send them to me for an update.


>> On the other hand, if the error field is only three bits wide instead of
>> four as stated by the documentation, a better fix means using a three
>> bit mask instead of reporting an invalid error code.
> 
> true, but then we'd introduce a direct discrepancy with the
> documentation, and thus h/w.

You basically ask me to agree that if there are no _documented_ error
codes between 0x8 and 0xf then I should trust that they will never come
up on a 4 bit field.

Do you want me to drop the patch and pretend there is nothing to see?


Cristian S.
