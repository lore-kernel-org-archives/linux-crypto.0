Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DCFCD4846
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 16:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjIVQfM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjIVQfL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2023 12:35:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2D4114
        for <linux-crypto@vger.kernel.org>; Fri, 22 Sep 2023 09:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695400461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vliUwCegH4eIRf5XC0HvBAS7inlKlSLddwzJmmiHBAg=;
        b=hy7t+mnV+4o7S2cwWWO0SOuUPjuvcxCAlkpnNDPCEm7+Q4U8MaBkc+hz9jafkPBHM+0cVb
        ltH5JFCYP9YVGSbcLa3MsolNKiWViUcLrHgSdJptSwvJguH4r//6/TVJdxvuhwfTo1sNa9
        O9r7lKs2Vj4PfQWIZ77pxvqX23ppyRc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-CdRADtmcNDOxspbYMYAbBg-1; Fri, 22 Sep 2023 12:34:18 -0400
X-MC-Unique: CdRADtmcNDOxspbYMYAbBg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53A851C05B13;
        Fri, 22 Sep 2023 16:34:17 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E784720268D6;
        Fri, 22 Sep 2023 16:34:16 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id CF52130C1C0A; Fri, 22 Sep 2023 16:34:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id CA2403FB77;
        Fri, 22 Sep 2023 18:34:16 +0200 (CEST)
Date:   Fri, 22 Sep 2023 18:34:16 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Hrivnak <mhrivnak@redhat.com>,
        Eric Garver <egarver@redhat.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com
Subject: [PATCH v2] qat: fix deadlock in backlog processing
In-Reply-To: <ZQ2vJNs/7ZzY44z1@gcabiddu-mobl1.ger.corp.intel.com>
Message-ID: <ed935382-98ee-6f5d-2f-7c6badfd3abb@redhat.com>
References: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com> <ZQ2vJNs/7ZzY44z1@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi


On Fri, 22 Sep 2023, Giovanni Cabiddu wrote:

> Hi Mikulas,
> 
> many thanks for reporting this issue and finding a solution.
> 
> On Thu, Sep 21, 2023 at 10:53:55PM +0200, Mikulas Patocka wrote:
> > I was evaluating whether it is feasible to use QAT with dm-crypt (the 
> > answer is that it is not - QAT is slower than AES-NI for this type of 
> > workload; QAT starts to be benefical for encryption requests longer than 
> > 64k).
> Correct. Is there anything that we can do to batch requests in a single
> call?

Ask Herbert Xu. I think it would complicate the design of crypto API.

> Sometime ago there was some work done to build a geniv template cipher
> and optimize dm-crypt to encrypt larger block sizes in a single call,
> see [1][2]. Don't know if that work was completed.
>
> >And I got some deadlocks.
> Ouch!
> 
> > The reason for the deadlocks is this: suppose that one of the "if"
> > conditions in "qat_alg_send_message_maybacklog" is true and we jump to the
> > "enqueue" label. At this point, an interrupt comes in and clears all
> > pending messages. Now, the interrupt returns, we grab backlog->lock, add
> > the message to the backlog, drop backlog->lock - and there is no one to
> > remove the backlogged message out of the list and submit it.
> Makes sense. In my testing I wasn't able to reproduce this condition.

I reproduced it with this:
Use a system with two Intel(R) Xeon(R) Gold 5420+ processors
Use a kernel 6.6-rc2
Patch the kernel, so that dm-crypt uses QAT - that is, in 
	drivers/md/dm-crypt.c, replace all strings 
	"CRYPTO_ALG_ALLOCATES_MEMORY" with "0"
Use .config from RHEL-9.4 beta and compile the kernel
On the system, disable hyperthreading with
	"echo off >/sys/devices/system/cpu/smt/control"
Activate dm-crypt on the top of nvme:
	"cryptsetup create cr /dev/nvme3n1 --sector-size=4096"
Run fio in a loop:
	"while true; do
		fio --ioengine=psync --iodepth=1 --rw=randwrite --direct=1 
		--end_fsync=1 --bs=64k --numjobs=56 --time_based 
		--runtime=10 --group_reporting --name=job 
		--filename=/dev/mapper/cr
	done"

With this setup, I get a deadlock in a few iterations of fio.

> > I fixed it with this patch - with this patch, the test passes and there
> > are no longer any deadlocks. I didn't want to add a spinlock to the hot
> > path, so I take it only if some of the condition suggests that queuing may
> > be required.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> The commit message requires a bit of rework to describe the change.

I improved the message and I send a second version of the patch.

> Also, deserves a fixes tag.

"Fixes" tag is for something that worked and that was broken in some 
previous commit. A quick search through git shows that QAT backlogging was 
broken since the introduction of QAT.

> > 
> > ---
> >  drivers/crypto/intel/qat/qat_common/qat_algs_send.c |   31 ++++++++++++--------
> >  1 file changed, 20 insertions(+), 11 deletions(-)
> > 
> > Index: linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > +++ linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > @@ -40,16 +40,6 @@ void qat_alg_send_backlog(struct qat_ins
> >  	spin_unlock_bh(&backlog->lock);
> >  }
> >  
> > -static void qat_alg_backlog_req(struct qat_alg_req *req,
> > -				struct qat_instance_backlog *backlog)
> > -{
> > -	INIT_LIST_HEAD(&req->list);
> Is the initialization of an element no longer needed?

It was never needed. list_add_tail calls __list_add and __list_add 
overwrites new->next and new->prev without reading them. So, there's no 
need to initialize them.

> > -
> > -	spin_lock_bh(&backlog->lock);
> > -	list_add_tail(&req->list, &backlog->list);
> > -	spin_unlock_bh(&backlog->lock);
> > -}
> > -
> >  static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> >  {
> >  	struct qat_instance_backlog *backlog = req->backlog;
> > @@ -71,8 +61,27 @@ static int qat_alg_send_message_maybackl
> >  	return -EINPROGRESS;
> >  
> >  enqueue:
> > -	qat_alg_backlog_req(req, backlog);
> > +	spin_lock_bh(&backlog->lock);
> > +
> > +	/* If any request is already backlogged, then add to backlog list */
> > +	if (!list_empty(&backlog->list))
> > +		goto enqueue2;
> >  
> > +	/* If ring is nearly full, then add to backlog list */
> > +	if (adf_ring_nearly_full(tx_ring))
> > +		goto enqueue2;
> > +
> > +	/* If adding request to HW ring fails, then add to backlog list */
> > +	if (adf_send_message(tx_ring, fw_req))
> > +		goto enqueue2;
> In a nutshell, you are re-doing the same steps taking the backlog lock.
> 
> It should be possible to re-write it so that there is a function that
> attempts enqueuing and if it fails, then the same is called again taking
> the lock.
> If you want I can rework it and resubmit.

Yes, if you prefer it this way, I reworked the patch so that we execute 
the same code with or without the spinlock held.

> > +
> > +	spin_unlock_bh(&backlog->lock);
> > +	return -EINPROGRESS;
> > +
> > +enqueue2:
> > +	list_add_tail(&req->list, &backlog->list);
> > +
> > +	spin_unlock_bh(&backlog->lock);
> >  	return -EBUSY;
> >  }
> 
> [1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1276510.html
> [2] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1428293.html
> 
> Regards,
> 
> -- 
> Giovanni
> 

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] qat: fix deadlock in backlog processing

I was testing QAT with dm-crypt and I got some deadlocks.

The reason for the deadlocks is this: suppose that one of the "if"
conditions in "qat_alg_send_message_maybacklog" is true and we jump to the
"enqueue" label. At this point, an interrupt comes in and clears all
pending messages. Now, the interrupt returns, we grab backlog->lock, add
the message to the backlog, drop backlog->lock - and there is no one to
remove the backlogged message out of the list and submit it.

In order to fix the bug, we must hold the spinlock backlog->lock when we 
perform test for free space in the ring - so that the test for free space 
and adding the request to a backlog is atomic and can't be interrupted by 
an interrupt. Every completion interrupt calls qat_alg_send_backlog which 
grabs backlog->lock, so holding this spinlock is sufficient to synchronize 
with interrupts.

I didn't want to add a spinlock unconditionally to the hot path for 
performance reasons, so I take it only if some of the condition suggests 
that queuing may be required.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/crypto/intel/qat/qat_common/qat_algs_send.c |   23 ++++++++++----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
===================================================================
--- linux-2.6.orig/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
+++ linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
@@ -40,22 +40,14 @@ void qat_alg_send_backlog(struct qat_ins
 	spin_unlock_bh(&backlog->lock);
 }
 
-static void qat_alg_backlog_req(struct qat_alg_req *req,
-				struct qat_instance_backlog *backlog)
-{
-	INIT_LIST_HEAD(&req->list);
-
-	spin_lock_bh(&backlog->lock);
-	list_add_tail(&req->list, &backlog->list);
-	spin_unlock_bh(&backlog->lock);
-}
-
 static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
 {
 	struct qat_instance_backlog *backlog = req->backlog;
 	struct adf_etr_ring_data *tx_ring = req->tx_ring;
 	u32 *fw_req = req->fw_req;
+	bool locked = false;
 
+repeat:
 	/* If any request is already backlogged, then add to backlog list */
 	if (!list_empty(&backlog->list))
 		goto enqueue;
@@ -68,11 +60,20 @@ static int qat_alg_send_message_maybackl
 	if (adf_send_message(tx_ring, fw_req))
 		goto enqueue;
 
+	if (unlikely(locked))
+		spin_unlock_bh(&backlog->lock);
 	return -EINPROGRESS;
 
 enqueue:
-	qat_alg_backlog_req(req, backlog);
+	if (!locked) {
+		spin_lock_bh(&backlog->lock);
+		locked = true;
+		goto repeat;
+	}
+
+	list_add_tail(&req->list, &backlog->list);
 
+	spin_unlock_bh(&backlog->lock);
 	return -EBUSY;
 }
 

