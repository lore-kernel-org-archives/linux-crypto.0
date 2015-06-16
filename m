From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 19:46:28 -0700
Message-ID: <557F8E04.7000209@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150615235954.GC16562@gondor.apana.org.au> <557F883C.5040207@intel.com> <20150616022947.GB19040@gondor.apana.org.au>
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
Received: from mga03.intel.com ([134.134.136.65]:19101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbFPCqy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:46:54 -0400
In-Reply-To: <20150616022947.GB19040@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 07:29 PM, Herbert Xu wrote:
>> I thought that the ctx needs to be available for implementations to store private data.
>> > This way we can allocate and store any type of key in the <alg>_parse_key() helper and still have the cxt
>> > available for implementations to use for their stuff (e.g. HW context).
> No for symmetric key algorithms we always store the key in the
> context and never in the tfm proper.
> 
> Think about it, the generic tfm doesn't have any idea on what
> the key contains so how can it store it? Only the implementation
> knows the key format and can store it in a useful way.

Ok I wanted to handle everything in the parse_key helper without any help from the implementation.
I can change the helper to return the key and implementation will store it in the ctx. Is this
what you are suggesting?
