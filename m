From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v3 3/3] crypto: add tests vectors for RSA
Date: Thu, 04 Jun 2015 09:28:41 -0700
Message-ID: <55707CB9.7090307@intel.com>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1> <20150603224424.22310.24677.stgit@tstruk-mobl1> <3173099.iDVlNMTGc2@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbbFDQ3F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 12:29:05 -0400
In-Reply-To: <3173099.iDVlNMTGc2@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan
On 06/03/2015 05:15 PM, Stephan Mueller wrote:
> May I ask that the outbuf_enc is memcmp()ed with an expected value? This check 
> is required for FIPS 140-2 compliance. Without that memcmp, FIPS 140-2 
> validations will not be successful.

Sure, I will do that. I wasn't aware that this was required.

> 
> Sorry for bringing that one up just now: 512 and 1024 bit test vectors will 
> not be helpful for several use cases, including FIPS. I can offer to give you 
> 2k or 3k vectors.

I have one 2K vector from openSSL fips so I'll use it instead of the 512 one.

> Besides, wouldn't one vector be sufficient?

I think there is no harm to have these 3 vectors to make sure an implementation
is well tested.
