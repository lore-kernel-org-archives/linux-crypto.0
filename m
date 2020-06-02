Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F05C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 11:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD336206E2
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 11:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HH8Yd7gT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgFBLxO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:53:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726110AbgFBLxO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 07:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591098793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dt4SIhmc8J+qDrogNFXsD1xCPzLaE3ZqzBrlUatmphc=;
        b=HH8Yd7gTaQ8E9WIrizIAMwFbNJClt30sKsliWFJ1P6feVApfqtgBTHUbVUVtESE4ZaF4ym
        QfMZFwDhwHNado3etDn0kXxMRhLjwOvAdYg+rE6kTCmGvwQZN1HNOxVnqRkDXEWFPAMDJw
        aQmuByW0j2K8Su4pdBguraitATflS4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-4wbinrFPPy-6cY2Z0hlrUw-1; Tue, 02 Jun 2020 07:53:11 -0400
X-MC-Unique: 4wbinrFPPy-6cY2Z0hlrUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C32B41052508;
        Tue,  2 Jun 2020 11:53:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA67E5D9CC;
        Tue,  2 Jun 2020 11:53:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 052Br7gp025558;
        Tue, 2 Jun 2020 07:53:07 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 052Br5eN025554;
        Tue, 2 Jun 2020 07:53:05 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 2 Jun 2020 07:53:05 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Mike Snitzer <msnitzer@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
cc:     dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com
Subject: [PATCH 5/4] dm-integrity: sleep and retry on allocation errors
In-Reply-To: <20200601160421.912555280@debian-a64.vm>
Message-ID: <alpine.LRH.2.02.2006020752170.25489@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200601160421.912555280@debian-a64.vm>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dm-integrity: sleep and retry on allocation errors

Some hardware crypto drivers use GFP_ATOMIC allocations in the request
routine. These allocations can randomly fail - for example, they fail if
too many network packets are received.

If we propagated the failure up to the I/O stack, it would cause I/O
errors. So, we sleep and retry.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-04-05 21:11:02.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2020-06-02 13:49:36.000000000 +0200
@@ -859,6 +859,7 @@ static void complete_journal_encrypt(str
 static bool do_crypt(bool encrypt, struct skcipher_request *req, struct journal_completion *comp)
 {
 	int r;
+retry:
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      complete_journal_encrypt, comp);
 	if (likely(encrypt))
@@ -874,6 +875,10 @@ static bool do_crypt(bool encrypt, struc
 		reinit_completion(&comp->ic->crypto_backoff);
 		return true;
 	}
+	if (r == -ENOMEM) {
+		msleep(1);
+		goto retry;
+	}
 	dm_integrity_io_error(comp->ic, "encrypt", r);
 	return false;
 }

