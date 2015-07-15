From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH  v2 3/3] crypto: qat - Add support for RSA algorithm
Date: Wed, 15 Jul 2015 08:19:16 -0700
Message-ID: <55A679F4.7050903@intel.com>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1> <20150714183259.18949.581.stgit@tstruk-mobl1> <20150715130333.GA2006@gondor.apana.org.au> <55A676BF.3090500@intel.com> <20150715150939.GA3347@gondor.apana.org.au> <55A678EB.4020604@intel.com> <20150715151644.GA3508@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbGOPTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 11:19:44 -0400
In-Reply-To: <20150715151644.GA3508@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/15/2015 08:16 AM, Herbert Xu wrote:
>> Are you ok if I just add the same constrains to rsa-generic?
> Yes that would work.  Of course if any future hardware implementation
> wanted to support other key sizes we'd have to add a fallback to qat.

That's ok. I like the lazy approach for now.
Thanks Herbert. 
