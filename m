From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/8] s390: add System z hardware support for CTR mode
Date: Wed, 27 Apr 2011 12:37:20 +0200
Message-ID: <1303900640.3495.12.camel@localhost.localdomain>
References: <20110419192913.888086020@linux.vnet.ibm.com>
	 <20110419193248.399099652@linux.vnet.ibm.com>
	 <20110426063437.GA19539@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:60925 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab1D0KhX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2011 06:37:23 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3RAbLKr010399
	for <linux-crypto@vger.kernel.org>; Wed, 27 Apr 2011 10:37:21 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3RAcPuJ1740928
	for <linux-crypto@vger.kernel.org>; Wed, 27 Apr 2011 11:38:25 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3RAbLRD000472
	for <linux-crypto@vger.kernel.org>; Wed, 27 Apr 2011 04:37:21 -0600
In-Reply-To: <20110426063437.GA19539@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-04-26 at 16:34 +1000, Herbert Xu wrote:
> On Tue, Apr 19, 2011 at 09:29:17PM +0200, jang@linux.vnet.ibm.com wrote:
> >
> > @@ -664,11 +784,6 @@ static int __init aes_s390_init(void)
> >  	if (ret)
> >  		goto cbc_aes_err;
> >  
> > -	/* skip XTS if MSA-4 is not available */
> > -	if ((stfle(facility_bits, 2) <= 0) ||
> > -	    !(facility_bits[1] & (1ULL << (63 - (77 - 64)))))
> > -		goto out;
> 
> Any reason why this hunk is here?

This hunk is a left-over from development in the XTS patch and
superfluous so it should be removed. Should I repost the whole series?

Thanks, Jan

> Cheers,
