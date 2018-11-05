Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728798AbeKEWI2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 17:08:28 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA5CkMVr051030
        for <linux-crypto@vger.kernel.org>; Mon, 5 Nov 2018 07:48:52 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2njk9vqynh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 07:48:52 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 5 Nov 2018 12:48:49 -0000
Subject: Re: [PATCH v2 0/2] crypto: streebog - add Streebog hash function
From: Mimi Zohar <zohar@linux.ibm.com>
To: Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Mon, 05 Nov 2018 07:48:33 -0500
In-Reply-To: <20181103055145.ndvxd7nbnoqtwrk5@sole.flsd.net>
References: <20181010121254.12220-1-vt@altlinux.org>
         <20181012061659.mextetc3v7urqkzx@gondor.apana.org.au>
         <20181012064105.bchujbwoaszrcu3l@sole.flsd.net>
         <20181017060851.r5mxvpq3l2ycvpio@gondor.apana.org.au>
         <20181103055145.ndvxd7nbnoqtwrk5@sole.flsd.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1541422113.21115.44.camel@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2018-11-03 at 08:51 +0300, Vitaly Chikunov wrote:
> Herbert,
> 
> On Wed, Oct 17, 2018 at 02:08:51PM +0800, Herbert Xu wrote:
> > On Fri, Oct 12, 2018 at 09:41:05AM +0300, Vitaly Chikunov wrote:
> > >
> > > It is the first part of attempts to add to the Integrity subsystem
> > > ability of verifying file and module signatures by Russian GOST
> > > algorithms.
> > 
> > It would be better if these patches are posted together.  That
> > way we don't end up with a situation where the algorithm goes into
> > the kernel but the ultimate user is rejected.
> 
> IMA does not need any particular patching inside of their subtree to
> support new hash, because it is using any hash registered in Hash Info
> which is still under crypto subtree. I added appropriate patch into v3
> which is already posted a week ago, and tested it to work correctly with
> ima_appraise=fix.

That's true, but the target subsystem should be made aware of the new
usage.

Thanks, Herbert.

Mimi
