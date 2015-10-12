From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hash import/export
Date: Mon, 12 Oct 2015 09:44:49 +0800
Message-ID: <20151012014449.GA22774@gondor.apana.org.au>
References: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39897 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbbJLBo6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 21:44:58 -0400
Content-Disposition: inline
In-Reply-To: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 11, 2015 at 08:34:27PM +0100, Russell King - ARM Linux wrote:
> 
> Is there any reason a driver can't define its own structure to be
> exported here which can be shared between each of the different methods
> it supports?

For algorithms in general you can use any format you like and there
is no restriction.  However, for specific algorithms such as crc32c
and family there is a requirement to use a fixed format.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
