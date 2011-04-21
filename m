From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390: add fallback for unsupported XTS-384 mode
Date: Thu, 21 Apr 2011 21:54:31 +0800
Message-ID: <20110421135431.GA431@gondor.apana.org.au>
References: <1303391899.10786.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Gerald =?iso-8859-1?Q?Sch=E4fer?= <geraldsc@de.ibm.com>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60477 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1DUNyj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2011 09:54:39 -0400
Content-Disposition: inline
In-Reply-To: <1303391899.10786.18.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 21, 2011 at 03:18:19PM +0200, Jan Glauber wrote:
> Hi Herbert,
> 
> this is the fallback code for XTS. It should fit on top of the s390 series.

OK, I'll combine this with the original XTS patch so that it's
bisectable.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
