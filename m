From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: talitos - pass correct interrupt status to
 error handler
Date: Fri, 10 Oct 2008 17:58:48 -0500
Message-ID: <20081010175848.a6ce7bd5.kim.phillips@freescale.com>
References: <1223323740.24986.12.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Lee Nipper <lee.nipper@freescale.com>, Vishnu@freescale.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:51393 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYJJWv4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2008 18:51:56 -0400
In-Reply-To: <1223323740.24986.12.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 06 Oct 2008 15:09:00 -0500
Lee Nipper <lee.nipper@freescale.com> wrote:

> From: Kim Phillips <kim.phillips@freescale.com>
> 
> since we ack early, the re-read interrupt status in talitos_error
> may be already updated with a new value.  Pass the error ISR value
> directly in order to report and handle the error based on the correct
> error status.
> 
> Also remove unused error tasklet.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
> ---

Herbert, I noticed your crypto update pull request was missing this
patch series (and the off-by-one fix from Suresh).  I realize they were
posted a bit late, but are they under consideration for 2.6.28?

Kim
