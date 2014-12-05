From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] staging: crypto: fixed style error in af_alg.c
Date: Fri, 5 Dec 2014 08:53:12 -0500
Message-ID: <20141205135312.GC22670@titan.lakedaemon.net>
References: <1417757920-11886-1-git-send-email-Joshua@cybercrimetech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Joshua I. James" <joshua@cybercrimetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47315 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750965AbaLENxR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 08:53:17 -0500
Content-Disposition: inline
In-Reply-To: <1417757920-11886-1-git-send-email-Joshua@cybercrimetech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 05, 2014 at 02:38:40PM +0900, Joshua I. James wrote:
> From: "Joshua I. James" <joshua@cybercrimetech.com>
> 
> Fixed style error identified by checkpatch.
> 
> ERROR: space required before the open parenthesis '('
> +               switch(cmsg->cmsg_type) {
> 
> Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
> ---
>  crypto/af_alg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Subject line, and this change really doesn't justify a patch by itself.
If Herbert prefers them merged into one, I'd include this change,
otherwise, I'd drop it.

It'd also be a good idea to run ./scripts/get_maintainer.pl on your
patch to determine who to include in the To/Cc on the next version of
this series.

thx,

Jason.
