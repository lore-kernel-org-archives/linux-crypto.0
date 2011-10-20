From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: picoxcell: add dependency on HAVE_CLK
Date: Thu, 20 Oct 2011 14:10:47 +0200
Message-ID: <20111020121047.GA4001@gondor.apana.org.au>
References: <1317421601-7487-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41521 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1JTMKv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Oct 2011 08:10:51 -0400
Content-Disposition: inline
In-Reply-To: <1317421601-7487-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 30, 2011 at 11:26:41PM +0100, Jamie Iles wrote:
> The picoxcell crypto driver requires the clk API, but the platform in
> mainline does not currently support it.  Add an explicit dependency on
> HAVE_CLK to avoid build breakage.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
