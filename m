From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [HIFN] Use softirq kernel mapping in bh context.
Date: Tue, 25 Nov 2008 23:17:39 +0800
Message-ID: <20081125151739.GA29096@gondor.apana.org.au>
References: <12271034133347-git-send-email-zbr@ioremap.net> <20081124140535.GD18313@gondor.apana.org.au> <20081124145240.GA13844@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53376 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752795AbYKYPVq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 10:21:46 -0500
Content-Disposition: inline
In-Reply-To: <20081124145240.GA13844@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 24, 2008 at 05:52:40PM +0300, Evgeniy Polyakov wrote:
> Use KM_SOFTIRQ instead of KM_IRQ in tasklet context.
> Added bug_on on input no-page condition.
> 
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

Patch applied.  Thanks Evgeniy!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
