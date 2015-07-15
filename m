From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH  v2 3/3] crypto: qat - Add support for RSA algorithm
Date: Wed, 15 Jul 2015 08:14:51 -0700
Message-ID: <55A678EB.4020604@intel.com>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1> <20150714183259.18949.581.stgit@tstruk-mobl1> <20150715130333.GA2006@gondor.apana.org.au> <55A676BF.3090500@intel.com> <20150715150939.GA3347@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:15400 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbbGOPPU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 11:15:20 -0400
In-Reply-To: <20150715150939.GA3347@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/15/2015 08:09 AM, Herbert Xu wrote:
>> This is even more complicated because the user can first allocate request
>> > and then call setkey causing fallback. I'm now thinking about adding the
>> > limitation to rsa generic or I can still use rsa-generic which I know that
>> > its ctx is smaller than mine. What do you think?
> This would preclude any future assembly implementations from being
> used.  Besides this is how we implement fallbacks everywhere else
> in the crypto API so I don't see why this one should be different.

Are you ok if I just add the same constrains to rsa-generic?

> 
>> The rsa_parse_key helper in the rsa generic that parses the key in BER format
>> > produces the MPIs.I didn't want to add yet another BER parser here. Should I?
> I don't see why not.  Certainly beats having to go in and out of
> MPIs.

Ok will do that.
Thanks,
T
