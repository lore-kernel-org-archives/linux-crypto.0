From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 19:03:11 -0700
Message-ID: <557F83DF.2090003@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150616000519.GA16973@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27526 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbbFPCDQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:03:16 -0400
In-Reply-To: <20150616000519.GA16973@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 05:05 PM, Herbert Xu wrote:
>> > + * @setkey:	Function invokes the algorithm specific set key function, which
>> > + *		knows how to decode and interpret the BER encoded key
> We should split this into two functions: setpubkey and setprivkey.
> 

The two functions will be almost identical. We can do it this way if we want to check
if all the required elements of the key are provided. Currently I'm checking this in the
actual operation.

>> > + *
>> > + * @reqsize:	Request context size required by algorithm implementation
>> > + * @base:	Common crypto API algorithm data structure
>> > + */
>> > +struct akcipher_alg {
>> > +	int (*sign)(struct akcipher_request *req);
>> > +	int (*verify)(struct akcipher_request *req);
>> > +	int (*encrypt)(struct akcipher_request *req);
>> > +	int (*decrypt)(struct akcipher_request *req);
>> > +	int (*maxsize)(struct crypto_akcipher *tfm);
> Hmm, we could actually get rid of maxsize by just having each
> function check the dst_len and if it is insufficient write the
> required length in it and then return an error.

Can do it that way too.
Thanks for your feedback. I will send v6 soon.
Thanks
T
