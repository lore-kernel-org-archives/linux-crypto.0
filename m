From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 07:23:42 +0100
Message-ID: <20160624062342.GA2506@sbenedet-virtual-machine>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
 <20160624060649.GA21165@localhost>
 <20160624061012.GA16850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, fengguang.wu@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcFXGXo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 02:23:44 -0400
Content-Disposition: inline
In-Reply-To: <20160624061012.GA16850@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 02:10:12PM +0800, Herbert Xu wrote:
> On Fri, Jun 24, 2016 at 07:06:49AM +0100, Salvatore Benedetto wrote:
> >
> > can you squash the following patch?
> 
> No, please prune anything that we don't use from ecc.c.

We do use the symbol in question, and I'm pretty sure we use
all of crypto/ecc.c. I was going to send a patch where
I remove the net/bluetooth/ecc.c

How do you want me to proceed with this build failure?
Do you want me to send a new patch so that you can revert
3c4b23901a0c766879dff680cd6bdab47bcdbbd2 ?

Thanks,
Salvatore

> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
