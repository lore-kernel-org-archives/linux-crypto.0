Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B32C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47AF920786
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agWxHX6h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgFPPBW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:01:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22024 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729378AbgFPPBV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 11:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592319680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qmH81i5EvkQGNxIUerlyGiqGCwul1+ubQ1Y2Fp1www=;
        b=agWxHX6hciyYaumvHgUxNahICp05CFOizuJOdPe7spTr2kNlgGMgUMuBlVNURrty6aCas3
        fc74DUZBJuu91Ec5KCdajIQJVOOGvoeoB/OtQ/CUn/OW/APFH8CBtViBYzZCHVxvh/bd7G
        pL+xR+VnPXoim7OYNeMxNxpnj9kaayg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-JU5yxV5NN8ezmn8l1PxUIg-1; Tue, 16 Jun 2020 11:01:07 -0400
X-MC-Unique: JU5yxV5NN8ezmn8l1PxUIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D00778CFF30;
        Tue, 16 Jun 2020 15:01:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC5547FE95;
        Tue, 16 Jun 2020 15:01:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05GF11mo028805;
        Tue, 16 Jun 2020 11:01:01 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05GF10rb028801;
        Tue, 16 Jun 2020 11:01:01 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 16 Jun 2020 11:01:00 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: crypto API and GFP_ATOMIC
In-Reply-To: <20200610121106.GA23137@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Wed, 10 Jun 2020, Herbert Xu wrote:

> On Wed, Jun 10, 2020 at 08:02:23AM -0400, Mikulas Patocka wrote:
> >
> > Yes, fixing the drivers would be the best - but you can hardly find any 
> > person who has all the crypto hardware and who is willing to rewrite all 
> > the drivers for it.
> 
> We don't have to rewrite them straight away.  We could mark the
> known broken ones (or the known working ones) and then dm-crypt
> can allocate only those using the types/mask to crypto_alloc.
> 
> Cheers,

I triaged the drivers in drivers/crypto and unfortunatelly, most of them 
do memory allocation in the encryption routine. Some of the do GFP_KERNEL 
allocation even in the absence of CRYPTO_TFM_REQ_MAY_SLEEP.

I'm sending the patches:

The first patch adds a new flag CRYPTO_ALG_ALLOCATES_MEMORY.

The second patch passes CRYPTO_ALG_ALLOCATES_MEMORY through the crypto API 
stack (please check it - I am not an expert in this area).

The third patch sets CRYPTO_ALG_ALLOCATES_MEMORY on drivers that allocate 
memory in the encrypt/decrypt routine.

The fourth patch fixes the drivers that use GFP_KERNEL in non-blocking 
context.

Mikulas

