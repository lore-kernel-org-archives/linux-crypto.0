Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE67C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 18:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 619D22098B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 18:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592331810;
	bh=h96pX3kj7dYEFYjTWnRdrQFgB9YLpLSutCA+J+4ZzuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=P2PPdQx0g7/OrlGFx8IcU6Gf0ZC9HNpjexuoc3fv02iokFYm6WJ3FuiBRdAK5GRju
	 QXtLMxWW4XpVCPJy1YBGurjtHB0M/E+EuaRrFnw+7Hy1iNK7iuGow1RZTxASyhNzrm
	 lhqfTysznkz+rElok64a4OP2vB2boXzIWvOOCaE4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgFPSX3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 14:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgFPSX3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 14:23:29 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88845208D5;
        Tue, 16 Jun 2020 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592331808;
        bh=h96pX3kj7dYEFYjTWnRdrQFgB9YLpLSutCA+J+4ZzuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1NbpAzSD+fa23xHR4jDxv4/ZGz4o6ym6JxV449gwnyurEOJ/e8gJO+qTDxENFdAg2
         xKM3CdXM4pJXxBm9v34WJJTXYypagtSGKTadWSOH6v3+PSDsUoaZmrywBcs201igty
         yLSvDV7ATi7rwXuvgx78PJIBP0Ixc2cgyW82sil8=
Date:   Tue, 16 Jun 2020 11:23:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/4] crypto: fix the drivers that don't
 respect CRYPTO_TFM_REQ_MAY_SLEEP
Message-ID: <20200616182327.GE207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616175022.GD207319@gmail.com>
 <alpine.LRH.2.02.2006161416510.12390@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161416510.12390@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 16, 2020 at 02:18:17PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 16 Jun 2020, Eric Biggers wrote:
> 
> > On Tue, Jun 16, 2020 at 11:02:50AM -0400, Mikulas Patocka wrote:
> > > Fix the crypto drivers that don't respect CRYPTO_TFM_REQ_MAY_SLEEP. If
> > > CRYPTO_TFM_REQ_MAY_SLEEP is not set, the driver must not do allocation
> > > that sleeps.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > I think you need to split this up per driver with a proper explanation and a
> > "Fixes:" tag for each driver.
> > 
> > Also, these bugs should have been detected by the crypto self-tests already,
> > since they test having preemption disabled and CRYPTO_TFM_REQ_MAY_SLEEP cleared.
> > Can you double check whether these are all valid fixes?  One thing to watch out
> > for is that CRYPTO_TFM_REQ_MAY_SLEEP only applies to the function call like
> > crypto_skcipher_encrypt() itself.  If the implementation is asynchronous and the
> > request gets processed in the background (i.e. if crypto_skcipher_encrypt()
> > returns -EINPROGRESS), the background work doesn't have to honor
> > CRYPTO_TFM_REQ_MAY_SLEEP.
> > 
> > - Eric
> 
> I can only compile-test this patch. I don't have the hardware.
> 

I'm just asking for you to check the code extra carefully.  The fact that the
self-tests should have been detecting this type of bug implies that these might
not actually be valid fixes.

However, we do know that not all crypto drivers are being actively tested with
the latest self-tests and with kernel debugging options enabled.  So it's
expected that some are indeed broken.

- Eric
