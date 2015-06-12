From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v4 2/4] crypto: add PKE API
Date: Thu, 11 Jun 2015 23:50:06 -0700
Message-ID: <557A811E.7010208@intel.com>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1> <20150611190543.31826.357.stgit@tstruk-mobl1> <20150612025940.GC30982@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13073 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbbFLGua (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2015 02:50:30 -0400
In-Reply-To: <20150612025940.GC30982@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/11/2015 07:59 PM, Herbert Xu wrote:
>> +int crypto_akcipher_setkey(struct crypto_akcipher *tfm,
>> > +			   const struct public_key *pkey)
>> > +{
>> > +	if (tfm->pkey)
>> > +		akcipher_free_key(tfm->pkey);
>> > +
>> > +	return akcipher_clone_key(tfm, pkey);
>> > +}
> No please do not expose the struct public_key crap to the new
> API.  The key should be completely opaque to entities outside
> of the algorithm.  So make it raw and read out the MPIs from
> it.
> 
> The contents of the function must go into the algorithm setkey
> function, not the crypto API.  So RSA would read out however
> many MPIs it needs and verify it, and so on.

Should I make it MPI[] rather than void *
