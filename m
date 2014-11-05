From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Date: Wed, 5 Nov 2014 11:27:37 +0200
Message-ID: <5459ED89.2080109@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
	<20141103134716.775acd39d6334c6f8aeca151@freescale.com>
	<54589515.2010903@freescale.com>
 <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<horia.geanta@freescale.com>, <marex@denx.de>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Kim,

On 11/04/2014 06:57 PM, Kim Phillips wrote:
> On Tue, 4 Nov 2014 10:57:57 +0200
> Cristian Stoica <cristian.stoica@freescale.com> wrote:

>> Do you want me to drop the patch and pretend there is nothing to see?
> 
> no, fixing potential bugs preemptively is fine; I'd just like to
> know that's the case: it wasn't clear from the original commit
> message whether the problem occurred on a new h/w revision, in which
> case I'd have like to have seen the driver updated with support for
> the new error codes.

This is a preemptive fix. I did not see a problem in the field with any
hardware, recent or old.

Cristian S.
