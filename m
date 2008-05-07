From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 10/n]: Move command descriptor setup to seperate function
Date: Wed, 7 May 2008 17:11:01 +0400
Message-ID: <20080507131101.GH23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <4821A595.807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35537 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYEGNLN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:11:13 -0400
Content-Disposition: inline
In-Reply-To: <4821A595.807@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:50:29PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> commit 163c74fc4f18d086bbb7f114d55bc7dac939d6b7
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Wed May 7 13:11:59 2008 +0200
> 
>     [HIFN]: Move command descriptor setup to seperate function
>     
>     Move command descriptor setup to seperate function as preparation
>     for the following DMA setup fixes.
>     
>     Note 1: also fix a harmless typo while moving it: sa_idx is initialized
>     	to dma->resi instead of dma->cmdi.

Yep, resource and command indexes should be always equal.

>     Note 2: errors from command descriptor setup are not propagated back,
>     	anymore, they can't be handled anyway and all conditions leading
>     	to errors should be checked earlier.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

I have no objections, thanks Patrick.
Ack.


-- 
	Evgeniy Polyakov
