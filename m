From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Fri, 01 May 2015 11:17:44 -0700
Message-ID: <5543C348.9060004@intel.com>
References: <20150430223652.10157.86151.stgit@tstruk-mobl1> <20150430223647.10157.82156.stgit@tstruk-mobl1> <4227.1430496240@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, linux-kernel@vger.kernel.org, steved@redhat.com,
	vgoyal@redhat.com, james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:11168 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbEASUv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 14:20:51 -0400
In-Reply-To: <4227.1430496240@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/01/2015 09:04 AM, David Howells wrote:
>> +config CRYPTO_PKE
> I would prefer CRYPTO_PKEY and pkey rather than pke generally and algo rather
> than alg where possible - this will have more consistency with what we have
> now.
> 
> I understand, however, that in core crypto code, 'alg' is used.

I'm fine with pkey. Herbert do you have preference with regards 'algo' vs 'alg'?

>>  #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
>> > +#define CRYPTO_ALG_TYPE_PKE		0x0000000b
>> >  #define CRYPTO_ALG_TYPE_RNG		0x0000000c
> Will filling a hole cause a problem with something that got obsoleted?

I hope not. I checked as far back as 2.6.18 and I don't see any clash.
Herbert, what do you think?

> 
>> +struct pke_request {
>> > +	struct crypto_async_request base;
>> > +	const struct public_key *pk;
>> > +	const struct public_key_signature *pks;
>> > +};
> I recommend:
> 
> 	pk -> key or pkey
> 	pks -> sig or signature

no problem

> 
>> +	u8 pub_mpis;	/* Number of MPIs in public key */
>> > +	u8 sec_mpis;	/* Number of MPIs in secret key */
>> > +	u8 sig_mpis;	/* Number of MPIs in a signature */
> Keep member names as:
> 
> 	u8		n_pub_mpi;	/* Number of MPIs in public key */
> 	u8		n_sec_mpi;	/* Number of MPIs in secret key */
> 	u8		n_sig_mpi;	/* Number of MPIs in a signature */

same here.
thanks
