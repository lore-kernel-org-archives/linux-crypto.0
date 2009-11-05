From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX for .32] crypto, gcm, fix another complete call in
	complete fuction
Date: Thu, 5 Nov 2009 09:23:06 -0500
Message-ID: <20091105142306.GA1910@gondor.apana.org.au>
References: <1257216017.30470.1183.camel@yhuang-dev.sh.intel.com> <20091103155339.GC9186@gondor.apana.org.au> <1257301423.22519.172.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38546 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756806AbZKEOXF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2009 09:23:05 -0500
Content-Disposition: inline
In-Reply-To: <1257301423.22519.172.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 04, 2009 at 10:23:43AM +0800, Huang Ying wrote:
> 
> I have seen one example, in gcm_encrypt_done, which is called when
> encryption phase finished in asynchronous mode. The areq passed in may
> be in the context of pctx->u.abreq (due to cryptd etc). Then hash phase
> begin, and ghash is called, which operates on pctx->u.ahreq (share same
> memory of pctx->u.abreq) and its context. Now, *areq may be destroyed.

I see.  Another way to handle this is to create a second function
for the completion functions that takes req->data directly rather
than dereferencing req again.  Then you can simply call it directly
on the sync path.

Something like:

done2(struct aead_request *req, int err)
{
	do real work
}

done(struct crypto_async_request *areq, int err)
{
	done2(areq->data, err)
}

sync_path(struct crypto_async_request *areq, int err)
{
	struct aead_request *req = areq->data;

	if (!err) {
		err = next_step(req);
		if (err == -EINPROGRESS || err == -EBUSY)
			return;
	}

	done2(req, err);
}

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
