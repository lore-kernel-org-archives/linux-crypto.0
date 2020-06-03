Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20A9C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 12:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 868EB2067B
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 12:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFCM0B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:26:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60130 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgFCM0A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 08:26:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jgSSg-0004RW-1G; Wed, 03 Jun 2020 22:25:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Jun 2020 22:25:38 +1000
Date:   Wed, 3 Jun 2020 22:25:38 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com,
        dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
Message-ID: <20200603122537.GA31719@gondor.apana.org.au>
References: <20200601160418.171851200@debian-a64.vm>
 <20200602220516.GA20880@silpixa00400314>
 <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 03, 2020 at 04:31:54AM -0400, Mikulas Patocka wrote:
>
> > Should we just retry a number of times and then fail?
> 
> It's better to get stuck in an infinite loop than to cause random I/O 
> errors. The infinite loop requires reboot, but it doesn't damage data on 
> disks.
> 
> The proper solution would be to add the request to a queue and process the 
> queue when some other request ended - but it would need substantial 
> rewrite of the driver. Do you want to rewrite it using a queue?
> 
> > Or, should we just move to the crypto-engine?
> 
> What do you mean by the crypto-engine?

crypto-engine is the generic queueing mechanism that any crypto
driver can use to implement the queueing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
