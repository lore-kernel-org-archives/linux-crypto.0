From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: caam - Clamp AEAD SG list by input length
Date: Mon, 08 Jun 2015 07:34:23 -0700
Message-ID: <5575A7EF.7090404@intel.com>
References: <20150608083824.GA26193@gondor.apana.org.au> <55759CA6.8070108@intel.com> <20150608135325.GA31073@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbFHOeP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 10:34:15 -0400
In-Reply-To: <20150608135325.GA31073@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/08/2015 06:53 AM, Herbert Xu wrote:
> On Mon, Jun 08, 2015 at 06:46:14AM -0700, Tadeusz Struk wrote:
>> On 06/08/2015 01:38 AM, Herbert Xu wrote:
>>> +static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
>>> +	struct scatterlist *sg, unsigned int total,
>>> +	struct sec4_sg_entry *sec4_sg_ptr)
>>> +{
>>> +	do {
>>> +		unsigned int len = min(sg_dma_len(sg), total);
>>> +
>>> +		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg), len, 0);
>>> +		sec4_sg_ptr++;
>>> +		sg = sg_next(sg);
>>> +		total -= len;
>>> +	} while (total);
>>> +	return sec4_sg_ptr - 1;
>>> +}
>>
>> Is req->assoclen guaranteed to be assoc->length aligned?
> 
> No req->assoclen can be any length.  What is the problem?

There is no problem, just asking.
