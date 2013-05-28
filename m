From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] crypto: caam - fix SEQ IN PTR command when RTO or
 PRE bit is set
Date: Tue, 28 May 2013 17:50:57 +0800
Message-ID: <20130528095057.GC24414@gondor.apana.org.au>
References: <1368455877-1759-1-git-send-email-andrei.varvara@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Kim.Phillips@freescale.com,
	AFLEMING@freescale.com, vakul@freescale.com
To: Andrei Varvara <andrei.varvara@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:52108 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933873Ab3E1JvB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 05:51:01 -0400
Content-Disposition: inline
In-Reply-To: <1368455877-1759-1-git-send-email-andrei.varvara@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 13, 2013 at 02:37:57PM +0000, Andrei Varvara wrote:
> SEQ IN PTR command does not require pointer if RTO or PRE bit is set
> Updated desc_constr.h accordingly.
> 
> Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
> Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
> Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>

All applied to cryptodev.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
