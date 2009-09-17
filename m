From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
 operational modes
Date: Thu, 17 Sep 2009 16:18:24 -0400
Message-ID: <4AB29990.30303@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au> <20090917124351.GA26276@hmsreliant.think-freely.org> <20090917153951.GB19535@gondor.apana.org.au> <20090917170824.GB26276@hmsreliant.think-freely.org> <20090917201622.GA22003@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZIQUVJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 16:21:09 -0400
In-Reply-To: <20090917201622.GA22003@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/17/2009 04:16 PM, Herbert Xu wrote:
> On Thu, Sep 17, 2009 at 01:08:24PM -0400, Neil Horman wrote:
>>
>> Just so that I'm clear on what your suggesting, you're approach would be to
>> register two algs in ansi_cprng, a 'raw' cprng, and a 'fips compliant cprng'
>> underneath that used the raw cprng as a base, but implemented the continuity
>> test underneath it?  If so, yeah, I can get behind that idea.  I'll spin a new
>> set of patches shortly.
>
> Yes, exactly like how we structure the raw CTR and RFC3686 which
> is CTR tailored for IPsec.

Yeah, I like that solution as well, does feel less dirty. So 
essentially, in fips mode, we'd wind up using fips(ansi_cprng) or 
similar, while the self-tests are done against raw ansi_cprng, correct?

-- 
Jarod Wilson
jarod@redhat.com
