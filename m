From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: af_alg - Add nokey compatibility path
Date: Sat, 9 Jan 2016 13:41:03 +0800
Message-ID: <20160109054103.GA11188@gondor.apana.org.au>
References: <5687BA0F.3020104@gmail.com>
 <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
 <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au>
 <568A66B2.4090307@gmail.com>
 <20160108124851.GA5425@gondor.apana.org.au>
 <568FFE18.6090900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36530 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcAIFlS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jan 2016 00:41:18 -0500
Content-Disposition: inline
In-Reply-To: <568FFE18.6090900@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 08, 2016 at 07:21:12PM +0100, Milan Broz wrote:
>
> > Yes algif_hash would need the same compatibility patch and I'm
> > working on that.
> 
> Ok, I fixed this already.

Can you please test the two patches that I sent for algif_hash?

> So it is used in production but just for this specific case.

OK I will add something similar to the algif_hash has_setkey
logic for cipher_null.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
