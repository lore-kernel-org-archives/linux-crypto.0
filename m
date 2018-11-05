Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728850AbeKEWVL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 17:21:11 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA5CxDRj142213
        for <linux-crypto@vger.kernel.org>; Mon, 5 Nov 2018 08:01:31 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2njn6yu6r2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 08:01:28 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 5 Nov 2018 13:01:25 -0000
Subject: Re: [PATCH v2 0/2] crypto: streebog - add Streebog hash function
From: Mimi Zohar <zohar@linux.ibm.com>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Mon, 05 Nov 2018 08:01:10 -0500
In-Reply-To: <20181105125537.ux4eehruuncqukli@sole.flsd.net>
References: <20181010121254.12220-1-vt@altlinux.org>
         <20181012061659.mextetc3v7urqkzx@gondor.apana.org.au>
         <20181012064105.bchujbwoaszrcu3l@sole.flsd.net>
         <20181017060851.r5mxvpq3l2ycvpio@gondor.apana.org.au>
         <20181103055145.ndvxd7nbnoqtwrk5@sole.flsd.net>
         <1541422113.21115.44.camel@linux.ibm.com>
         <20181105125537.ux4eehruuncqukli@sole.flsd.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1541422870.21115.51.camel@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2018-11-05 at 15:55 +0300, Vitaly Chikunov wrote:
> Mimi,
> 
> On Mon, Nov 05, 2018 at 07:48:33AM -0500, Mimi Zohar wrote:
> > On Sat, 2018-11-03 at 08:51 +0300, Vitaly Chikunov wrote:
> > > On Wed, Oct 17, 2018 at 02:08:51PM +0800, Herbert Xu wrote:
> > > > On Fri, Oct 12, 2018 at 09:41:05AM +0300, Vitaly Chikunov wrote:
> > > > >
> > > > > It is the first part of attempts to add to the Integrity subsystem
> > > > > ability of verifying file and module signatures by Russian GOST
> > > > > algorithms.
> > > > 
> > > > It would be better if these patches are posted together.  That
> > > > way we don't end up with a situation where the algorithm goes into
> > > > the kernel but the ultimate user is rejected.
> > > 
> > > IMA does not need any particular patching inside of their subtree to
> > > support new hash, because it is using any hash registered in Hash Info
> > > which is still under crypto subtree. I added appropriate patch into v3
> > > which is already posted a week ago, and tested it to work correctly with
> > > ima_appraise=fix.
> > 
> > That's true, but the target subsystem should be made aware of the new
> > usage.
> 
> Did you mean by re-sending the patch with Cc to linux-integrity? Or
> something more?

Just as future reference.  For now, please feel free to add my
Reviewed-by on the "crypto: streebog - register Streebog in hash info
for IMA" patch.

Mimi
