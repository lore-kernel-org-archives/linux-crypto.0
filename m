From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/8] s390: add System z hardware support for CTR mode
Date: Wed, 04 May 2011 10:31:22 +0200
Message-ID: <1304497882.2517.10.camel@localhost.localdomain>
References: <20110419192913.888086020@linux.vnet.ibm.com>
	 <20110419193248.399099652@linux.vnet.ibm.com>
	 <20110426063437.GA19539@gondor.apana.org.au>
	 <1303900640.3495.12.camel@localhost.localdomain>
	 <20110427104004.GA1697@gondor.apana.org.au>
	 <20110504051057.GA7005@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:34646 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1EDIcd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2011 04:32:33 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate5.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p448WWAL031711
	for <linux-crypto@vger.kernel.org>; Wed, 4 May 2011 08:32:32 GMT
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p448Xgmu2216174
	for <linux-crypto@vger.kernel.org>; Wed, 4 May 2011 09:33:43 +0100
Received: from d06av12.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p448WVe6017653
	for <linux-crypto@vger.kernel.org>; Wed, 4 May 2011 02:32:31 -0600
In-Reply-To: <20110504051057.GA7005@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2011-05-04 at 15:10 +1000, Herbert Xu wrote:
> On Wed, Apr 27, 2011 at 08:40:04PM +1000, Herbert Xu wrote:
> > On Wed, Apr 27, 2011 at 12:37:20PM +0200, Jan Glauber wrote:
> >
> > > This hunk is a left-over from development in the XTS patch and
> > > superfluous so it should be removed. Should I repost the whole series?
> > 
> > No worries.  I'll just kill it in the combined XTS patch.
> 
> OK, it's all applied and I will push it out in a jiffy.  Please
> double-check to see if I've mangled any of the patches.

Looks good, thanks for merging!
Jan

> Thanks,
