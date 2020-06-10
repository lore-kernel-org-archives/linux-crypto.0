Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A239C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 12:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7550D2074B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 12:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0qKoJFb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgFJMC4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jun 2020 08:02:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33769 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728753AbgFJMC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jun 2020 08:02:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591790575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TNsoGvRQNqCDBEQwQWNi/36A0peQaj7a5rcaN6nMm74=;
        b=O0qKoJFbCQHlE+jEGkzuweQIFACfqUkJnE/Kv6U0Th3mvK0fTus4FqsGJyeMMhyRbSRWFF
        K5WMU87Mm7XnUcxpPsAsR331XDPC4ailQQ6ESSNbaen77OBKi5q+R9Yav8KX4vG+w4+d/j
        eagnXIKb8FRw7XbdPho9vSGTol9/eAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-MecNFB9ROaaure0ci4G0eg-1; Wed, 10 Jun 2020 08:02:53 -0400
X-MC-Unique: MecNFB9ROaaure0ci4G0eg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3826100A8EE;
        Wed, 10 Jun 2020 12:02:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C28088FF86;
        Wed, 10 Jun 2020 12:02:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05AC2Ono028363;
        Wed, 10 Jun 2020 08:02:24 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05AC2OLN028359;
        Wed, 10 Jun 2020 08:02:24 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 10 Jun 2020 08:02:23 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: crypto API and GFP_ATOMIC
In-Reply-To: <20200610010450.GA6449@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Wed, 10 Jun 2020, Herbert Xu wrote:

> On Tue, Jun 09, 2020 at 01:11:05PM -0400, Mikulas Patocka wrote:
> >
> > Do you have another idea how to solve this problem?
> 
> I think the better approach would be to modify the drivers to not
> allocate any memory.  In general, any memory needed by the driver
> to fulfil a request *should* be allocated within the crypto request
> object.  That's why we have the reqsize field to indicate how much
> memory could be needed per request.
> 
> Thanks,

Yes, fixing the drivers would be the best - but you can hardly find any 
person who has all the crypto hardware and who is willing to rewrite all 
the drivers for it.

Another possibility - I was thinking about setting 
CRYPTO_TFM_REQ_MAY_SLEEP in dm-crypt and calling the crypto function under 
memalloc_noio_save. But there are some drivers that do GFP_ATOMIC 
allocation regardless of CRYPTO_TFM_REQ_MAY_SLEEP.

Mikulas

