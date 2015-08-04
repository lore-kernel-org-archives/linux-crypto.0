From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Tue, 4 Aug 2015 20:47:26 +0800
Message-ID: <20150804124726.GA29660@gondor.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
 <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
 <55BBDD1F.4020208@intel.com>
 <20150802012354.GB10055@gondor.apana.org.au>
 <55BF9E4E.6020006@intel.com>
 <20150804095909.GA28167@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43515 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbbHDMrc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 08:47:32 -0400
Content-Disposition: inline
In-Reply-To: <20150804095909.GA28167@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 04, 2015 at 05:59:09PM +0800, Herbert Xu wrote:
> On Mon, Aug 03, 2015 at 10:01:02AM -0700, Tadeusz Struk wrote:
> >
> > There is one problem that I missed before.
> > We can shutdown a qat device and bring it back up via ioct.
> > Before we shut the last device we also unregister the algorithms.
> > Then we can bring them up again, but it fails without resetting the flags.
> 
> Good catch.  However it's not as simple as that.  We have a bigger
> problem here.

In order to make progress I'm going to fold your patch into my
series and push it into cryptodev.

I'll try to come up with a proper fix for this after I'm done
with the AEAD stuff.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
