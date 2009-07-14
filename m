From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Bogus sha1 implementation in crypto4xx
Date: Tue, 14 Jul 2009 15:46:29 +0200
Message-ID: <20090714134629.GI20288@secunet.com>
References: <20090714130600.GA11081@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hsiao <jhsiao@amcc.com>, Shasi Pulijala <spulijala@amcc.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:37011 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZGNNnu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2009 09:43:50 -0400
Content-Disposition: inline
In-Reply-To: <20090714130600.GA11081@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 14, 2009 at 09:06:00PM +0800, Herbert Xu wrote:
> 
> This hasn't caused a problem before because we haven't started
> using ahash yet, apart from tcrypt which is single-threaded.
> I'm currently in the process of converting authenc (hence IPsec)
> across, which means that we will soon rely on the fact that
> you can have multiple hash operations ongoing at once.
> 

As I pointed out already, I'm working on converting IPsec to ahash too.
So perhaps we can share the work to do not all the work twice.
I have ahash versions of authenc and ah4/ah6. The authenc ahash version
needs a hack in esp to be able to chain all scatterlist in authenc and I
wanted to look over it again before I post. 

Today I finished with ah4/ah6. This needs still some tests but I could post
these two in the next days if you have not converted them it yet.
