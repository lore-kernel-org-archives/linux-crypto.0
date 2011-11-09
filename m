From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: talitos - fix descriptor buffer access code
Date: Tue, 8 Nov 2011 19:39:30 -0600
Message-ID: <20111108193930.b5c2cf0c3027aff90e7dbd7c@freescale.com>
References: <20111108193457.db068c56fe6db067e4d9057c@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:46572
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718Ab1KIBlO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 20:41:14 -0500
In-Reply-To: <20111108193457.db068c56fe6db067e4d9057c@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 8 Nov 2011 19:34:57 -0600
Kim Phillips <kim.phillips@freescale.com> wrote:

> commit 3e721ae (crypto: talitos - handle descriptor not found in
> error path) used the wrong offset method to access a channel's
> descriptor buffer registers - the TALITOS_DESCBUF macro
> doesn't take a channel argument.  Fix it to use the
> base chan[x].reg offset instead.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---

scratch this - I got confused working on a merge branch.

existing code is fine - ignore me.

Kim
