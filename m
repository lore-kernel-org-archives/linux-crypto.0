From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 19:21:48 -0700
Message-ID: <557F883C.5040207@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150615235954.GC16562@gondor.apana.org.au>
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
Received: from mga11.intel.com ([192.55.52.93]:56691 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbbFPCVw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:21:52 -0400
In-Reply-To: <20150615235954.GC16562@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 04:59 PM, Herbert Xu wrote:
>> > +struct crypto_akcipher {
>> > +	void *key;
> Having a void * pointer here is useless.  The normal way of doing
> it is to place the key into the tfm context.

I thought that the ctx needs to be available for implementations to store private data.
This way we can allocate and store any type of key in the <alg>_parse_key() helper and still have the cxt
available for implementations to use for their stuff (e.g. HW context).
