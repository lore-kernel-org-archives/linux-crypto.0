From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Thu, 28 May 2015 09:54:41 -0700
Message-ID: <55674851.9050903@intel.com>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1> <20150506193648.9329.27232.stgit@tstruk-mobl1> <20150511063222.GB2316@gondor.apana.org.au> <555F777D.1030509@intel.com> <20150523054734.GA14239@gondor.apana.org.au> <55608C9F.7040500@intel.com> <20150528040856.GB3849@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:38587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbbE1QyZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 12:54:25 -0400
In-Reply-To: <20150528040856.GB3849@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/27/2015 09:08 PM, Herbert Xu wrote:
> Do you have a specific piece of hardware in mind? What are its
> capabilities?

I'm going to use it with Intel's DH985xcc accelerator. It can accelerate
RSA, DH, ECDSA and ECDH just to name the most commonly used.
But I don't want to add anything that is device specific.
I just want it to be flexible enough so that new algorithms can be easily added.

> 
> If we are going to go with just contiguous memory then we might
> as well just do u8 *src, *dst, unsigned int slen, dlen.
> 
> The whole point of the SG complexity is to deal with non-contiguous
> memory (e.g., fragmented packets with IPsec).  If you can't do that
> then why add the SG complexity?

If we do this that way then we will be able to pass only one input and one
output parameter. There are cases when we will need more that this.
For instance for ECDSA signature generation we need one input param hash(m)
and two output parameters (r, s).
So I have used the SG for that. This is not to deal with non-contiguous memory,
but to pass more in/out parameters. Each parameter will need to occupy contiguous space in memory.
I will update the comment to make it more clear.
If you have other idea how to do this I will be happy to try it.
Regards,
T
