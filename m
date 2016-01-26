From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_hash: creating 0 sized array in hash_accept
Date: Tue, 26 Jan 2016 22:07:24 +0800
Message-ID: <20160126140724.GA22685@gondor.apana.org.au>
References: <56A6119C.1080203@oracle.com>
 <20160125135846.GB8256@gondor.apana.org.au>
 <56A77411.5030209@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47660 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332AbcAZOHc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 09:07:32 -0500
Content-Disposition: inline
In-Reply-To: <56A77411.5030209@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2016 at 08:26:41AM -0500, Sasha Levin wrote:
>
> This seems to be happening with "digest_null".

In that case this is expected as digest_null obviously has no
state.  So why is a zero-length array disallowed by ubsan?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
