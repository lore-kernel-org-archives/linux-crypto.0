From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: 842 - remove WARN inside printk
Date: Wed, 23 Dec 2015 18:25:28 +0800
Message-ID: <20151223102528.GB1205@gondor.apana.org.au>
References: <5671C83C.7@infradead.org>
 <1450720330-30676-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Haren Myneni <haren@linux.vnet.ibm.com>,
	linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47217 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbbLWKZw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 05:25:52 -0500
Content-Disposition: inline
In-Reply-To: <1450720330-30676-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 21, 2015 at 12:52:10PM -0500, Dan Streetman wrote:
> Remove the WARN() from the beN_to_cpu macro, which is used as a param to a
> pr_debug() call.  With a certain kernel config, this printk-in-printk
> results in the no_printk() macro trying to recursively call the
> no_printk() macro, and since macros can't recursively call themselves
> a build error results.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
