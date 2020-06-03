Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43D2C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 08:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4562204EF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 08:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XiXQZlQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgFCIcD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 04:32:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59915 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726123AbgFCIcD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 04:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591173121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vkeVxA/zhwqG4/6AGws5hEt6QBsQvR60ExyhAzUC90U=;
        b=XiXQZlQ+cswxAYErrqUyd2A3/xxk+eRmR+VQnS7gsVxMmtbVPN3cwabgpi4jcLqWUON6hx
        pdUvQ175uvL39SSStNLJ2nkYOsjoa200tte0LFVl0rUng64bdLyHxwbAveqqOK42XzA3X/
        xWh8kX5i6LDBcf/RkGWqFjjWMSozpb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-wnrmj7lAO1ObML6LIFMvOw-1; Wed, 03 Jun 2020 04:31:59 -0400
X-MC-Unique: wnrmj7lAO1ObML6LIFMvOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 811EF107ACCA;
        Wed,  3 Jun 2020 08:31:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FD2519C4F;
        Wed,  3 Jun 2020 08:31:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 0538VshI016653;
        Wed, 3 Jun 2020 04:31:54 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 0538VsTC016649;
        Wed, 3 Jun 2020 04:31:54 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 3 Jun 2020 04:31:54 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com,
        dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
In-Reply-To: <20200602220516.GA20880@silpixa00400314>
Message-ID: <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200601160418.171851200@debian-a64.vm> <20200602220516.GA20880@silpixa00400314>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Tue, 2 Jun 2020, Giovanni Cabiddu wrote:

> Hi Mikulas,
> 
> thanks for your patch. See below.
> 
> > +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> > +again:
> > +	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> >  	if (ret == -EAGAIN) {
> > -		qat_alg_free_bufl(ctx->inst, qat_req);
> > -		return -EBUSY;
> > +		qat_req->backed_off = backed_off = 1;
> > +		cpu_relax();
> > +		goto again;
> >  	}
> I am a bit concerned about this potential infinite loop.
> If an error occurred on the device and the queue is full, we will be
> stuck here forever.
> Should we just retry a number of times and then fail?

It's better to get stuck in an infinite loop than to cause random I/O 
errors. The infinite loop requires reboot, but it doesn't damage data on 
disks.

The proper solution would be to add the request to a queue and process the 
queue when some other request ended - but it would need substantial 
rewrite of the driver. Do you want to rewrite it using a queue?

> Or, should we just move to the crypto-engine?

What do you mean by the crypto-engine?

> > -	do {
> > -		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> > -	} while (ret == -EAGAIN && ctr++ < 10);
> > -
> > +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> checkpatch: line over 80 characters - same in every place
> adf_should_back_off is used.

Recently, Linus announced that we can have larger lines than 80 bytes.
See bdc48fa11e46f867ea4d75fa59ee87a7f48be144

> >  static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
> > Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.c
> > +++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
> > @@ -114,10 +114,19 @@ static void adf_disable_ring_irq(struct
> >  	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
> >  }
> >  
> > +bool adf_should_back_off(struct adf_etr_ring_data *ring)
> > +{
> > +	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
> How did you came up with 15/16?

I want the sender to back off before the queue is full, to avoid 
busy-waiting. There may be more concurrent senders, so we want to back off 
at some point before the queue is full.

> checkpatch: WARNING: line over 80 characters
> 
> > +}
> > +
> >  int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
> >  {
> > -	if (atomic_add_return(1, ring->inflights) >
> > -	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
> > +	int limit = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
> > +
> > +	if (atomic_read(ring->inflights) >= limit)
> > +		return -EAGAIN;

> Can this be removed and leave only the condition below?
> Am I missing something here?

atomic_read is light, atomic_add_return is heavy. We may be busy-waiting 
here, so I want to use the light instruction. Spinlocks do the same - when 
they are spinning, they use just a light "read" instruction and when the 
"read" instruction indicates that the spinlock is free, they execute the 
read-modify-write instruction to actually acquire the lock.

> > +
> > +	if (atomic_add_return(1, ring->inflights) > limit) {
> >  		atomic_dec(ring->inflights);
> >  		return -EAGAIN;
> >  	}

Mikulas

