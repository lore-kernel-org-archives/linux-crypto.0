From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] header file for SHA definitions
Date: Tue, 9 Oct 2007 22:44:29 +0800
Message-ID: <20071009144429.GA20675@gondor.apana.org.au>
References: <1191857611.7760.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jan.glauber@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1111 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753273AbXJIOok (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2007 10:44:40 -0400
Content-Disposition: inline
In-Reply-To: <1191857611.7760.27.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 08, 2007 at 03:33:31PM +0000, Jan Glauber wrote:
> There are currently several SHA implementations that all define their own
> initialization vectors and size values. Since this values are idential
> move them to a header file under include/crypto.
> 
> The Patch should apply to cryptodev-2.6.
> 
> Signed-off-by: Jan Glauber <jang@de.ibm.com>

Looks good.  Patch applied.  Thanks Jan!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
