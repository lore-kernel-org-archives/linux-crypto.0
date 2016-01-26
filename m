From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_hash: creating 0 sized array in hash_accept
Date: Tue, 26 Jan 2016 22:46:13 +0800
Message-ID: <20160126144613.GA23202@gondor.apana.org.au>
References: <56A6119C.1080203@oracle.com>
 <20160125135846.GB8256@gondor.apana.org.au>
 <56A77411.5030209@oracle.com>
 <20160126140724.GA22685@gondor.apana.org.au>
 <56A7831E.5020208@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38093 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbcAZOqT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 09:46:19 -0500
Content-Disposition: inline
In-Reply-To: <56A7831E.5020208@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2016 at 09:30:54AM -0500, Sasha Levin wrote:
>
> The C spec forbids it, so ubsan complains :)

If you really care about this then please send a patch that adds
?: 1 to the size.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
