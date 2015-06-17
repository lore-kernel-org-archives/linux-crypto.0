From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v7 0/3] crypto: Introduce Public Key Encryption API
Date: Wed, 17 Jun 2015 09:06:23 -0700
Message-ID: <55819AFF.3010605@intel.com>
References: <20150616173050.1248.21847.stgit@tstruk-mobl1> <20150617091453.GB11190@gondor.apana.org.au>
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
Received: from mga02.intel.com ([134.134.136.20]:14636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258AbbFQQGk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 12:06:40 -0400
In-Reply-To: <20150617091453.GB11190@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/17/2015 02:14 AM, Herbert Xu wrote:
>> This patch set introduces a Public Key Encryption API.
>> > What is proposed is a new crypto type called crypto_akcipher_type,
>> > plus new struct akcipher_alg and struct crypto_akcipher, together with number
>> > of helper functions to register akcipher type algorithms and allocate
>> > tfm instances. This is to make it similar to how the existing crypto
>> > API works for the ablkcipher, ahash, and aead types.
>> > The operations the new interface will allow to provide are:
>> > 
>> > 	int (*sign)(struct akcipher_request *req);
>> > 	int (*verify)(struct akcipher_request *req);
>> > 	int (*encrypt)(struct akcipher_request *req);
>> > 	int (*decrypt)(struct akcipher_request *req);
> All applied with two minor changes.  First of all I made AKCIPHER
> invisible to the user like the other type config options.  I also
> added a missing select on ASN1 that broke my build.

Thank you very much for all your help with this Herbert
