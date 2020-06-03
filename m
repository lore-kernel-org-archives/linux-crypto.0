Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED48C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 19:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 005BB2074B
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 19:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TkN2FzRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgFCTyS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 15:54:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgFCTyS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 15:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591214056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UmrhG4IpG9XYrvMtWBeioylGxVeUfvM852WdA4iW0x8=;
        b=TkN2FzRtGdI6OnJU5KU8Ks+KjTnVUJlEApSLz2exHEJ/zCqCjhD1bZYlUVhp3+I5yL0Tl2
        SHp9SHsJhWrQHp1J/UH89RHysQdrO87+rB5+gbii/oUYAg+ncm+H/sgJydfrq9b6WMySZU
        4Ow10eMq4EdUEH5xOBbVe1P9LZxPDXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-f9A2ahqWOSu050C_7RR1FQ-1; Wed, 03 Jun 2020 15:54:15 -0400
X-MC-Unique: f9A2ahqWOSu050C_7RR1FQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8ED9107ACCD;
        Wed,  3 Jun 2020 19:54:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A022419C58;
        Wed,  3 Jun 2020 19:54:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 053JsAO2014032;
        Wed, 3 Jun 2020 15:54:10 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 053Js9Us014024;
        Wed, 3 Jun 2020 15:54:09 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 3 Jun 2020 15:54:09 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com,
        dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com, ahsan.atta@intel.com
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
In-Reply-To: <20200603165526.GA94360@silpixa00400314>
Message-ID: <alpine.LRH.2.02.2006031553170.9890@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200601160418.171851200@debian-a64.vm> <20200602220516.GA20880@silpixa00400314> <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com> <20200603165526.GA94360@silpixa00400314>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Wed, 3 Jun 2020, Giovanni Cabiddu wrote:

> > > > +bool adf_should_back_off(struct adf_etr_ring_data *ring)
> > > > +{
> > > > +	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
> > > How did you came up with 15/16?
> > 
> > I want the sender to back off before the queue is full, to avoid 
> > busy-waiting. There may be more concurrent senders, so we want to back off 
> > at some point before the queue is full.
> Yes, I understood this. My question was about the actual number.
> 93% of the depth of the queue.

I just guessed the value. If you have some benchmark, you can try 
different values, to test if they perform better.

Mikulas

