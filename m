From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Wed, 03 Oct 2007 15:43:58 -0500
Message-ID: <1191444238.2477.114.camel@faith.austin.ibm.com>
References: <200710020547.l925l9in011560@faith.austin.ibm.com>
	 <20071003102149.GA8203@gondor.apana.org.au>
	 <20071003102845.GA8364@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tgraf@suug.sh
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:60792 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbXJCUsA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 16:48:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l93Klxs7023060
	for <linux-crypto@vger.kernel.org>; Wed, 3 Oct 2007 16:47:59 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l93KlwLO377764
	for <linux-crypto@vger.kernel.org>; Wed, 3 Oct 2007 14:47:58 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l93Klw5K012092
	for <linux-crypto@vger.kernel.org>; Wed, 3 Oct 2007 14:47:58 -0600
In-Reply-To: <20071003102845.GA8364@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-10-03 at 18:28 +0800, Herbert Xu wrote:
> On Wed, Oct 03, 2007 at 06:21:49PM +0800, Herbert Xu wrote:
> 
> > static void __ctr_inc_byte(u8 *a, int size)
> > {
> > 	__be8 *b = (__be8 *)(a + size);
> > 	u8 c;
> > 
> > 	do {
> > 		c = be8_to_cpu(*--b) + 1;
> > 		*b = cpu_to_be8(c);
> > 		if (c)
> > 			break;
> > 	} while (--size);
> 
> This should be a for loop and we can make it inline too.
> 
Besides being used in ctr_inc_quad(), isn't __ctr_inc_byte() also
allowing for counters that might be less than an integer or 4 bytes? 
  
Regards,
Joy
