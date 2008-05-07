From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 7 May 2008 16:42:20 +0400
Message-ID: <20080507124220.GA23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <48219FF6.2090009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57716 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbYEGMm1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:42:27 -0400
Content-Disposition: inline
In-Reply-To: <48219FF6.2090009@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:26:30PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> I'm not entirely sure about the alignmask change at the end of
> this patch, is an alignmask of 1 correct if no source buffer
> alignment is required, but the destination buffer should be
> (doesn't have to be though) 4 byte aligned?

> commit f76618d53e82c8905214e889a3f79f1816c680fb
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Wed May 7 12:44:15 2008 +0200
> 
>     [HIFN]: Fix data alignment checks
>     
>     The check for misalignment of the scatterlist data has two bugs:
>     
>     - the source buffer doesn't need to be aligned at all
>     - the destination buffer and its size needs to be aligned to a multiple
>       of 4, not to the crypto alg blocksize
>     

If memory serves me right, both src and dst addresses have to be 4 bytes
aligned. Protocol alignment is not needed.

If it is not the issue, then I have no objections.

-- 
	Evgeniy Polyakov
