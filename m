From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
 operational modes
Date: Thu, 17 Sep 2009 08:28:08 -0400
Message-ID: <4AB22B58.5050105@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZIQMaY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 08:30:24 -0400
In-Reply-To: <20090917033729.GA13826@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/16/2009 11:37 PM, Herbert Xu wrote:
> On Wed, Sep 16, 2009 at 12:04:56PM -0400, Neil Horman wrote:
>>
>> 	So the question is, how do I make this RNG fips compliant without
>> breaking some subset of users out there that rely on the predictability of the
>> CPRNG?  The solution I've come up with is a dynamic flag.  This patch series
>
> What user apart from the test vector relies on the predictability?

As far as I know, only the internal self-tests and fips testing rely on 
the predictability without the first value consumed internally. However, 
in theory, being able to disable the continuity check could also be of 
benefit to some throughput-intensive operation, particularly on an 
embedded system.

The monte carlo self-tests could obviously compensate for the internally 
consumed value without altering the end result, but the single-iteration 
tests could not. We're using self-test vectors that were published by 
NIST right now, so I'd rather avoid having to alter them.

-- 
Jarod Wilson
jarod@redhat.com
