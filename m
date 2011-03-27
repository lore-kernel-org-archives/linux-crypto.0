From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] picoxcell-crypto: fix possible status FIFO overflow
Date: Sun, 27 Mar 2011 10:50:16 +0800
Message-ID: <20110327025016.GA23269@gondor.apana.org.au>
References: <1300886781-19415-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54363 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1C0CuT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Mar 2011 22:50:19 -0400
Content-Disposition: inline
In-Reply-To: <1300886781-19415-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 23, 2011 at 01:26:21PM +0000, Jamie Iles wrote:
> The SPAcc's have 2 equally sized FIFO's - a command FIFO and a status
> FIFO.  The command FIFO takes the requests that are to be performed and
> the status FIFO reports the results.  It is possible to get into the
> situation where there are more free spaces in the command FIFO than the
> status FIFO if we don't empty the status FIFO quickly enough resulting
> in a possible overflow of the status FIFO.  This can result in incorrect
> status being reported in the status FIFO.
> 
> Make sure that when we are submitting requests the number of requests
> that have been dispatched but not yet popped from the status FIFO does
> not exceed the size of a single FIFO.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
