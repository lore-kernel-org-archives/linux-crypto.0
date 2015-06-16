From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 12:06:05 +0800
Message-ID: <20150616040605.GA20597@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
 <20150616000519.GA16973@gondor.apana.org.au>
 <557F83DF.2090003@intel.com>
 <20150616022751.GA19040@gondor.apana.org.au>
 <557F8CCA.2080405@intel.com>
 <20150616032511.GA19977@gondor.apana.org.au>
 <557F99A6.3010904@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57159 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbFPEGW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 00:06:22 -0400
Content-Disposition: inline
In-Reply-To: <557F99A6.3010904@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 08:36:06PM -0700, Tadeusz Struk wrote:
> On 06/15/2015 08:25 PM, Herbert Xu wrote:
> > The current parse_key function requires all three number to be
> > present, n, e, and d, no?
> 
> No, it will handle whatever it will find. So if a public key will be passed it will only set "n" and "e".
> If a private key will be passed it will set all three "n", "e", and "d".
> Then during operation I check if there is everything that's required.

AFAICS the ASN1 parser will call all three functions and bomb out
if any one of them fails.  If you did make them all optional then
you'd need to check to ensure that at least n and e are present.

Also all your test vectors contain private keys.  Please add at
least one that contains a public key only to test this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
