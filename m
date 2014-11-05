From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2] crypto: caam: fix error reporting
Date: Wed, 5 Nov 2014 10:43:32 -0600
Message-ID: <20141105104332.bdc904792193d714bd9d4951@freescale.com>
References: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
	<1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<horia.geanta@freescale.com>, <marex@denx.de>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:22269
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805AbaKEQsv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Nov 2014 11:48:51 -0500
In-Reply-To: <1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 5 Nov 2014 11:21:24 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> The error code returned by hardware is four bits wide with an expected
> zero MSB. A hardware error condition where the error code can get between
> 0x8 and 0xf will trigger an out of bound array access on the error
> message table.
> This patch fixes the invalid array access following such an error and
> reports the condition.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---

no v2 change info?  All I noticed is the additional string for
"queue manager interface", which, without its implementation fn,
intoduces an inconsistency wrt NULL checking, so this comment:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg12105.html

still applies.

Thanks,

Kim
