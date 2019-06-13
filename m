Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC09EC31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 848192082C
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404325AbfFMQw1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:52:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56480 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbfFMDOA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 23:14:00 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hbGBa-0004Tx-6t; Thu, 13 Jun 2019 11:13:58 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hbGBX-0001u2-TG; Thu, 13 Jun 2019 11:13:55 +0800
Date:   Thu, 13 Jun 2019 11:13:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v3 0/4] s390/crypto: Use -ENODEV instead of -EOPNOTSUPP
Message-ID: <20190613031355.7vya4vwhr3eia5g4@gondor.apana.org.au>
References: <20190612133306.10231-1-david@redhat.com>
 <20190612150850.GA4038@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612150850.GA4038@osiris>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 05:08:50PM +0200, Heiko Carstens wrote:
> On Wed, Jun 12, 2019 at 03:33:02PM +0200, David Hildenbrand wrote:
> > s390x crypto is one of the rare modules that returns -EOPNOTSUPP instead of
> > -ENODEV in case HW support is not available.
> > 
> > Convert to -ENODEV, so e.g., systemd's systemd-modules-load.service
> > ignores this error properly.
> > 
> > v2 -> v3:
> > - "s390/pkey: Use -ENODEV instead of -EOPNOTSUPP"
> > -- Also convert pkey_clr2protkey() as requested by Harald
> > - Add r-b's (thanks!)
> > 
> > v1 -> v2:
> > - Include
> > -- "s390/crypto: ghash: Use -ENODEV instead of -EOPNOTSUPP"
> > -- "s390/crypto: prng: Use -ENODEV instead of -EOPNOTSUPP"
> > -- "s390/crypto: sha: Use -ENODEV instead of -EOPNOTSUPP"
> > 
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Cc: Harald Freudenberger <freude@linux.ibm.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > 
> > David Hildenbrand (4):
> >   s390/pkey: Use -ENODEV instead of -EOPNOTSUPP
> >   s390/crypto: ghash: Use -ENODEV instead of -EOPNOTSUPP
> >   s390/crypto: prng: Use -ENODEV instead of -EOPNOTSUPP
> >   s390/crypto: sha: Use -ENODEV instead of -EOPNOTSUPP
> 
> Should I pick these up so they can go upstream via the s390 tree?

Sure Heiko.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
