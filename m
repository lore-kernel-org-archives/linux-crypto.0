Return-Path: <SRS0=xc0K=7W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15C9C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 17:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B84A20734
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 17:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kt4MMDbG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgFIRLV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jun 2020 13:11:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48127 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727831AbgFIRLU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jun 2020 13:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591722680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=wTWjkLuR1CQrC45Qa4cmUqgN0ps5OP9L9ilxG5fSrto=;
        b=Kt4MMDbGQZcTVyHsgbwTSIWRHvDoDe9sHCd3GBqexskXjLn081aMvLAzNysDtlIsfqF+6Y
        iBfwjELHWmAlynUXJCPKVfO5MkQDIGF0ICzSG4w4MCV/HE8usk7LvYs7c6tm93tC9xhjgL
        I0uxj/ZYPyCIB5XHkRZulbuNzZnuZmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-wKA04OWwPM-jg9xuYEm2Ww-1; Tue, 09 Jun 2020 13:11:18 -0400
X-MC-Unique: wKA04OWwPM-jg9xuYEm2Ww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29157107B7E5;
        Tue,  9 Jun 2020 17:11:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D6B25F9DC;
        Tue,  9 Jun 2020 17:11:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 059HB6Tw031653;
        Tue, 9 Jun 2020 13:11:06 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 059HB6RA031649;
        Tue, 9 Jun 2020 13:11:06 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 9 Jun 2020 13:11:05 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
cc:     linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: crypto API and GFP_ATOMIC
Message-ID: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

I've found out that a lot of hardware crypto drivers use GFP_ATOMIC. Some 
of them switch between GFP_ATOMIC and GFP_KERNEL based on the flag 
CRYPTO_TFM_REQ_MAY_SLEEP.

dm-crypt and dm-integrity don't use CRYPTO_TFM_REQ_MAY_SLEEP (because 
GFP_KERNEL allocation requests can recurse back to the block device 
drivers and cause deadlocks).

So, basically, the crypto requests submitted by dm-crypt and dm-integrity 
can fail anytime. I'd like to ask, how to handle these random -ENOMEM 
return codes. If we pass -ENOMEM back to the block device stack, it could 
cause random I/O errors and data corruption.

The question is - if the crypto request returns -ENOMEM, could we sleep 
and retry it? I thought about it - the problem could be, if the crypto 
requests proceeds hafway through and then returns -ENOMEM, and if we 
retried it, it would cause data corruption, because part of the data would 
be decrypted twice.

Is it safe to assume that when we get -ENOMEM, the crypto driver didn't 
modify anything?

Do you have another idea how to solve this problem?

Mikulas

