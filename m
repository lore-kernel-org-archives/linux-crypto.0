From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 2/3] augment the testmgr code to set TEST_MODE flag on
 all rng instances
Date: Wed, 16 Sep 2009 16:57:12 -0400
Message-ID: <4AB15128.3060503@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090916161339.GE11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbZIPVAC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 17:00:02 -0400
In-Reply-To: <20090916161339.GE11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/16/2009 12:13 PM, Neil Horman wrote:
> patch 2/3: Update testmgr code to place any rng it tests in TEST_MODE
>
> This patch instructs the testmgr code to place all rng allocations that it makes
> into test mode, so that in the event that it has internal mechanisms that may
> affect the testing of the RNG, they won't affect the outcome of the test they
> are preforming.
>
> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>

With these same additions, my fips crypto test code arrives at expected 
results still as well.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com
