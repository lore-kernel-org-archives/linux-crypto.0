From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/8] tcrypt: disable 384 bit key XTS test
Date: Wed, 20 Apr 2011 17:19:52 +0200
Message-ID: <1303312792.10786.12.camel@localhost.localdomain>
References: <20110419192913.888086020@linux.vnet.ibm.com>
	 <20110419193250.074519442@linux.vnet.ibm.com>
	 <20110420003350.GB10285@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:37734 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1DTPT5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2011 11:19:57 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3KFJrR5024031
	for <linux-crypto@vger.kernel.org>; Wed, 20 Apr 2011 15:19:53 GMT
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3KFKo5W1765528
	for <linux-crypto@vger.kernel.org>; Wed, 20 Apr 2011 16:20:50 +0100
Received: from d06av10.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3KFJqqB018905
	for <linux-crypto@vger.kernel.org>; Wed, 20 Apr 2011 09:19:53 -0600
In-Reply-To: <20110420003350.GB10285@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2011-04-20 at 08:33 +0800, Herbert Xu wrote:
> On Tue, Apr 19, 2011 at 09:29:20PM +0200, jang@linux.vnet.ibm.com wrote:
> > From: Jan Glauber <jang@linux.vnet.ibm.com>
> > 
> > XTS mode is only defined for 256 and 512 bit key lengths. s390 only
> > implements these two modes and running the test with a 384 bit key
> > will stop the speed test with an error. Remove the superfluous key
> > lenght.
> > 
> > Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
> 
> That's a limitation specific to your hardware.  As the existing xts
> currently supports 384-bit keys, we can't remove it for compatibility
> reasons.  So please add it as a fallback to your implementation.

I see, will try to hack something together.

Bad thing is, we don't even have a test vector for the 384 bit key length
and the standards don't provide one.

Should I resend when I'm finished or would you like to drop this patch
from the series?

Cheers,
Jan
