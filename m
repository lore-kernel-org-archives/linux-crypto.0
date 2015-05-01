From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 2/2] crypto: RSA: KEYS: convert rsa and public key
 to new PKE API
Date: Fri, 01 May 2015 12:27:58 -0700
Message-ID: <5543D3BE.3000904@intel.com>
References: <20150430223658.10157.32631.stgit@tstruk-mobl1> <20150430223647.10157.82156.stgit@tstruk-mobl1> <4394.1430497303@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, corbet@lwn.net, keescook@chromium.org,
	qat-linux@intel.com, jwboyer@redhat.com, richard@nod.at,
	d.kasatkin@samsung.com, linux-kernel@vger.kernel.org,
	steved@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	jdelvare@suse.de, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:10759 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbbEATbG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 15:31:06 -0400
In-Reply-To: <4394.1430497303@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/01/2015 09:21 AM, David Howells wrote:
>> +			.verify = RSA_verify_signature,
>> > +			.capabilities = PKEY_CAN_VERIFY,
> Can we keep .verify_signature as the name of the first.  The second is
> redundant given the function pointers.

I'm thinking that .verify will be more generic. If in the future
we would like to implement something that verifies not a signature, but
for instance is a number is a prime, then we can register a "prime" alg
that implements verify and returns true if a number is a prime.   

> 
> Given that X.509 certs can hang around for a very long time, having a tfm in
> the cert is probably a bad idea as it may pin resources such as crypto h/w.
> 
>> > -	ctx->cert->pub->pkey_algo = PKEY_ALGO_RSA;
>> > -
> I think you need this rather than the above.  You should only get the tfm when
> you actually need it.
> 

That's a good point.
Thank you David for all your comments. I'll rework my patches and send v2 soon.
I'll also try to integrate it with your sign-file as you suggested.
Thanks
T
