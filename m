From: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX -v2 for .32] crypto, gcm, fix another complete call in
 complete fuction
Date: Tue, 10 Nov 2009 10:49:59 +0800
Message-ID: <1257821399.22519.2410.camel@yhuang-dev.sh.intel.com>
References: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com>
	 <20091109190250.GC9588@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45831 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKJCtz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2009 21:49:55 -0500
In-Reply-To: <20091109190250.GC9588@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2009-11-10 at 03:02 +0800, Herbert Xu wrote: 
> On Mon, Nov 09, 2009 at 03:24:14PM +0800, Huang Ying wrote:
> > The flow of the complete function (xxx_done) in gcm.c is as follow:
> 
> Thanks the patch looks pretty good overall.
> 
> > -static void gcm_hash_final_done(struct crypto_async_request *areq,
> > -				int err)
> > +static void __gcm_hash_final_done(struct aead_request *req,
> > +				  struct crypto_gcm_req_priv_ctx *pctx,
> > +				  int err)
> 
> Just one nit though, do we really need to carry this pctx around
> everywhere? It seems to me that it's always crypto_gcm_reqctx(req),
> no?

Yes. This is for performance only. Because crypto_gcm_reqctx(req) is not
so trivial (it needs access tfm), and used by every xxx_done function,
so I think it is better to just call crypto_gcm_reqctx once and pass it
down. Do you think so?

Best Regards,
Huang Ying

