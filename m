From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: testmgr - clean alg_test_null entries in
 alg_test_descs[]
Date: Thu, 6 Dec 2012 17:19:28 +0800
Message-ID: <20121206091928.GB15870@gondor.apana.org.au>
References: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
 <20121113094737.25071.88732.stgit@localhost6.localdomain6>
 <20121113.135345.1177053994589244695.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59460 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754060Ab2LFJTc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Dec 2012 04:19:32 -0500
Content-Disposition: inline
In-Reply-To: <20121113.135345.1177053994589244695.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 13, 2012 at 01:53:45PM -0500, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Tue, 13 Nov 2012 11:47:37 +0200
> 
> > Currently alg_test_null entries set .suite values to zero, which is unneeded.
> > So perform clean-up of null test entries.
> > 
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
