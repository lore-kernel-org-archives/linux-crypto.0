From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mv_cesa - fix final callback not ignoring
	input data
Date: Tue, 28 Feb 2012 19:30:04 +1100
Message-ID: <20120228083004.GA31292@gondor.apana.org.au>
References: <20120225073806.GA19079@gondor.apana.org.au> <1330341424-27438-1-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@kernel.org,
	#@zimbra.vipri.net, 3.0+@zimbra.vipri.net
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:54886 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756821Ab2B1IaL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Feb 2012 03:30:11 -0500
Content-Disposition: inline
In-Reply-To: <1330341424-27438-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 27, 2012 at 12:17:04PM +0100, Phil Sutter wrote:
> Broken by commit 6ef84509f3d439ed2d43ea40080643efec37f54f for users
> passing a request with non-zero 'nbytes' field, like e.g. testmgr.
> 
> Cc: <stable@kernel.org> # 3.0+
> Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>


Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
