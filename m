From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/2] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 1 Oct 2015 23:15:19 +0800
Message-ID: <20151001151519.GA28373@gondor.apana.org.au>
References: <20150922163352.18101.85685.stgit@tstruk-mobl1>
 <20150922163403.18101.92452.stgit@tstruk-mobl1>
 <20151001134536.GA27555@gondor.apana.org.au>
 <560D48B0.8090502@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36774 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbbJAPPZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 11:15:25 -0400
Content-Disposition: inline
In-Reply-To: <560D48B0.8090502@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 07:52:32AM -0700, Tadeusz Struk wrote:
> On 10/01/2015 06:45 AM, Herbert Xu wrote:
> > On Tue, Sep 22, 2015 at 09:34:03AM -0700, Tadeusz Struk wrote:
> >>
> >>  struct akcipher_request {
> >>  	struct crypto_async_request base;
> >> -	void *src;
> >> -	void *dst;
> >> -	unsigned int src_len;
> >> -	unsigned int dst_len;
> >> +	struct scatterlist *src;
> >> +	struct scatterlist *dst;
> >> +	unsigned int out_len;
> > 
> > I think src_len/dst_len should be kept as the SG list may contain
> > more entries than the ones that you need to process.
> > 
> Herbert,
> Could you still apply it and the "Add mpi sgl helpers" on top
> and I'll add the src_len/dst_len in an incremental patch?
> It will make it easier for me.

Well I don't think we need out_len with dst_len being there so
this would be adding and then removing out_len for no good reason.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
