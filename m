Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0CDC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 11:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 276572086C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 11:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfBTLmQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:42:16 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:60580 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfBTLmQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 06:42:16 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 24E42201C6;
        Wed, 20 Feb 2019 12:42:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WMpVL7F_cdzT; Wed, 20 Feb 2019 12:42:08 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E78F220068;
        Wed, 20 Feb 2019 12:42:08 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 20 Feb 2019
 12:42:08 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6C6503182665;
 Wed, 20 Feb 2019 12:42:08 +0100 (CET)
Date:   Wed, 20 Feb 2019 12:42:08 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Eric Biggers <ebiggers3@gmail.com>, <linux-crypto@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [RFC PATCH] crypto: pcrypt - forbid recursive instantiation
Message-ID: <20190220114208.GD3087@gauss3.secunet.de>
References: <20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de>
 <20180310232231.19191-1-ebiggers3@gmail.com>
 <20180323002152.GA30497@gondor.apana.org.au>
 <20180408225528.GH685@sol.localdomain>
 <20180409085807.2cwvr5cocz6gfbmv@gauss3.secunet.de>
 <20180409190739.GC203367@gmail.com>
 <20180418053533.wuo6bj2okqdu2hrf@gauss3.secunet.de>
 <20190220040628.673rc2ffs7dxepu2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190220040628.673rc2ffs7dxepu2@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: FD6684C0-7348-4FE6-BD15-5F195D739C50
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 12:06:28PM +0800, Herbert Xu wrote:
> On Wed, Apr 18, 2018 at 07:35:33AM +0200, Steffen Klassert wrote:
> > 
> > Yes sure, I just wanted to know if it is worth to think about
> > preventing template recursions. If there is a valid usecase,
> > then we don't even need to think in this direction.
> > 
> > While I think each pcrypt instance should have it's own
> > padata instance on the long run, it would be good to have
> > a not so intrusive fix that can be backported to the stable
> > trees.
> 
> Steffen, has there been any progress on this work?

I had a look on what we need to use separate padata
instances for each pcrypt instance. But that's comlicated
and will create incompatibilities on the sysfs cpuset
configuration options. So that's not really a thing that
could be a fix.

> 
> We need to fix this soon or we'll have to disable pcrypt because
> it is a security issue.
> 
> It's not just about nested templates either.  You can trigger
> the same issue where a pcrypt instance over an AEAD algorithm
> that uses a fallback which also happens to be pcrypt.

Would it be possible to forbid pcrypt for algorithms
that needs a fallback?

If I see this correct, only crypto algorithms used by
HW crypto accelerators need a fallback to software
crypto. HW crypto can't benefit from pcrypt anyway,
so it would be no loss to disable pcrypt in that case.

We could use the initial fix from Eric in combination
with disableing pcrypt for algorithms that need a fallback.

