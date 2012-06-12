From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RFC: support for MV_CESA with TDMA
Date: Tue, 12 Jun 2012 19:39:41 +0800
Message-ID: <20120612113941.GA14757@gondor.apana.org.au>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
 <20120612100437.GD14078@gondor.apana.org.au>
 <20120612102452.GE9122@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:46194 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395Ab2FLLjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 07:39:44 -0400
Content-Disposition: inline
In-Reply-To: <20120612102452.GE9122@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 12, 2012 at 12:24:52PM +0200, Phil Sutter wrote:
> 
> It does break mv_cesa on Orion-based devices (precisely those with IDMA
> instead of TDMA). I am currently working on a version which supports
> IDMA, too. Since all CESA-equipped hardware comes with either TDMA or
> IDMA, that version then should improve all platforms without breaking
> any.

Thanks for the explanation.  I'll wait for your new patches :)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
