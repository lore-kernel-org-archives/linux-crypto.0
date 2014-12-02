From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 03/17] crypto: ansi_cprng - Eliminate ctx->I
Date: Tue, 2 Dec 2014 09:52:49 -0500
Message-ID: <20141202145249.GE3388@hmsreliant.think-freely.org>
References: <20141202083314.17647.qmail@ns.horizon.com>
 <20141202083707.17996.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42014 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaLBOwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 09:52:53 -0500
Content-Disposition: inline
In-Reply-To: <20141202083707.17996.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:37:07AM -0500, George Spelvin wrote:
> It's also not necessary.  We do have to change some debugging
> output.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>  crypto/ansi_cprng.c | 39 ++++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 19 deletions(-)
> 
I'm only ok with removing I if you can continue to be able to output it.  given
that I is listed as part of the test sequences that NIST provides, I'd like to
be able to compare the values.
Neil
