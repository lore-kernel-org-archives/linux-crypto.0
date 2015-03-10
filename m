From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] crypto: OCTEON MD5 bugfix + SHA modules
Date: Tue, 10 Mar 2015 20:58:07 +1100
Message-ID: <20150310095807.GA17913@gondor.apana.org.au>
References: <1425845267-14413-1-git-send-email-aaro.koskinen@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
	linux-kernel@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:57194 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbCJJ6W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 05:58:22 -0400
Content-Disposition: inline
In-Reply-To: <1425845267-14413-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 08, 2015 at 10:07:40PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> The first patch is a bug fix for OCTEON MD5 aimed for 4.0-rc cycle.

Please send such bug fixes in a separate series in future.
For this one in particular it does not appear to be critical
enough to go in straight away so I have pushed it into cryptodev
along with the rest.

> The remaining patches add SHA1/SHA256/SHA512 modules. I have tested
> these on the following OCTEON boards and CPUs with 4.0-rc2:
> 
> 	D-Link DSR-1000N:	CN5010p1.1-500-SCP
> 	EdgeRouter Lite:	CN5020p1.1-500-SCP
> 	EdgeRouter Pro:		CN6120p1.1-1000-NSP
> 
> All selftests are passing. With tcrypt, I get the following numbers
> on speed compared to the generic modules:

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
