From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 00/10] add 842 hw compression for PowerNV platform
Date: Mon, 11 May 2015 15:21:07 +0800
Message-ID: <20150511072107.GB2789@gondor.apana.org.au>
References: <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
 <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39551 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbEKHVh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 03:21:37 -0400
Content-Disposition: inline
In-Reply-To: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 07, 2015 at 01:49:11PM -0400, Dan Streetman wrote:
>
> v3 changes the sw and hw crypto drivers to use the same alg name "842",
> and different driver names, "842-generic" and "842-nx"

All applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
