From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH v2] crypto: caam: fix error reporting
Date: Thu, 6 Nov 2014 10:01:08 +0200
Message-ID: <545B2AC4.3090505@freescale.com>
References: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
	<1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
 <20141105104332.bdc904792193d714bd9d4951@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<horia.geanta@freescale.com>, <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0148.outbound.protection.outlook.com ([157.56.111.148]:23785
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbaKFIBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 03:01:20 -0500
In-Reply-To: <20141105104332.bdc904792193d714bd9d4951@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim, Herbert,


On 11/05/2014 06:43 PM, Kim Phillips wrote:
> On Wed, 5 Nov 2014 11:21:24 +0200
> Cristian Stoica <cristian.stoica@freescale.com> wrote:
> 
>> The error code returned by hardware is four bits wide with an expected
>> zero MSB. A hardware error condition where the error code can get between
>> 0x8 and 0xf will trigger an out of bound array access on the error
>> message table.
>> This patch fixes the invalid array access following such an error and
>> reports the condition.
>>
>> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
>> ---

> no v2 change info?  All I noticed is the additional string for
> "queue manager interface", which, without its implementation fn,

Yes. Thanks for review. That and the updated comment.

> intoduces an inconsistency wrt NULL checking, so this comment:

No. There is no inconsistency in the handling. Please be more specific.

> 
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg12105.html
>
> still applies.

Which comment? You refer to a whole email. My rebutal still applies
though and I think your version is inferior wrt handling the issue.

Feel free to send a competing patch for review though.

Herbert, consider that without a fix one way or another, there is a
potential kernel attack vector through the error reporting function of
the caam driver.


Cristian S.
