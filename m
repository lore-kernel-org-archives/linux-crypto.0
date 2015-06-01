From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Mon, 01 Jun 2015 10:52:24 -0700
Message-ID: <556C9BD8.3050709@intel.com>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1> <20150506193648.9329.27232.stgit@tstruk-mobl1> <20150511063222.GB2316@gondor.apana.org.au> <555F777D.1030509@intel.com> <20150523054734.GA14239@gondor.apana.org.au> <55608C9F.7040500@intel.com> <20150528040856.GB3849@gondor.apana.org.au> <55674851.9050903@intel.com> <20150601054857.GA10460@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60211 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbbFARwL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 13:52:11 -0400
In-Reply-To: <20150601054857.GA10460@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/31/2015 10:48 PM, Herbert Xu wrote:
> On Thu, May 28, 2015 at 09:54:41AM -0700, Tadeusz Struk wrote:
>>
>> If we do this that way then we will be able to pass only one input and one
>> output parameter. There are cases when we will need more that this.
>> For instance for ECDSA signature generation we need one input param hash(m)
>> and two output parameters (r, s).
> 
> There is no reason why you couldn't encode that within one stream.
> As far as as the user is concerned the output is one entity, i.e.,
> the signature.  The fact that it is made up of two numbers is of
> no concern to the API.  It's a technicality for the algorithm to
> sort out.
> 
>> So I have used the SG for that. This is not to deal with non-contiguous memory,
>> but to pass more in/out parameters. Each parameter will need to occupy contiguous space in memory.
>> I will update the comment to make it more clear.
>> If you have other idea how to do this I will be happy to try it.
> 
> If you really wanted to do this then you should be using a simple
> (u8 *, unsigned int) pair but I don't really think this is at all
> necessary.
> 

Ok, I'll rework this to take one char *src and one *dst ptrs.
Thanks
T
