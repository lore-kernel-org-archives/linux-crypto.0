From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 10:27:51 +0800
Message-ID: <20150616022751.GA19040@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
 <20150616000519.GA16973@gondor.apana.org.au>
 <557F83DF.2090003@intel.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:56991 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbFPC2G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:28:06 -0400
Content-Disposition: inline
In-Reply-To: <557F83DF.2090003@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 07:03:11PM -0700, Tadeusz Struk wrote:
> On 06/15/2015 05:05 PM, Herbert Xu wrote:
> >> > + * @setkey:	Function invokes the algorithm specific set key function, which
> >> > + *		knows how to decode and interpret the BER encoded key
> > We should split this into two functions: setpubkey and setprivkey.
> > 
> 
> The two functions will be almost identical. We can do it this way if we want to check
> if all the required elements of the key are provided. Currently I'm checking this in the
> actual operation.

Right now your RSA setkey function only works if you supply both
the public key and the private key.  If the user supplies only one
key how are you going to tell whether it's public or private?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
