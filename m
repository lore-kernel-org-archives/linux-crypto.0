Return-Path: <SRS0=MSze=AS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD40C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 14:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 167A920775
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 14:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdOF9UeY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgGGO6I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:58:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54478 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727936AbgGGO6I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 10:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594133887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HA5WMwxscQ78XPUobFav00uOAsyHepNEfosz5Ea/uJ8=;
        b=gdOF9UeYW3VLdJ6pm8PBbmNdJ7AemlOL966nRbuT9Rc+zKEGpyop4CD8u2D9OJCADYDVIT
        O+S1PRh+7azzD+Z6FWeMGfF50+Nvij/fMuKxqMkDyoHQ/78hqWXZSTnPWjh9bI6WhO6yU/
        kPJAIP9dePNV9tVKv1f+6zByo+otjCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-gKEQs8PXN_q4VqK0W0v_Dw-1; Tue, 07 Jul 2020 10:58:05 -0400
X-MC-Unique: gKEQs8PXN_q4VqK0W0v_Dw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84B0A108BD0D;
        Tue,  7 Jul 2020 14:58:04 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AD335C1B2;
        Tue,  7 Jul 2020 14:58:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 067Ew1T3013602;
        Tue, 7 Jul 2020 10:58:01 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 067Ew1xA013598;
        Tue, 7 Jul 2020 10:58:01 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 7 Jul 2020 10:58:00 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     linux-crypto@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 0/6] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <20200706185403.GA736284@gmail.com>
Message-ID: <alpine.LRH.2.02.2007071049240.13237@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200701045217.121126-1-ebiggers@kernel.org> <alpine.LRH.2.02.2007010358390.6597@file01.intranet.prod.int.rdu2.redhat.com> <20200706185403.GA736284@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Mon, 6 Jul 2020, Eric Biggers wrote:

> On Wed, Jul 01, 2020 at 03:59:10AM -0400, Mikulas Patocka wrote:
> > Thanks for cleaning this up.
> > 
> > Mikulas
> 
> Do you have any real comments on this?
> 
> Are the usage restrictions okay for dm-crypt?
> 
> - Eric

I think that your patch series is OK.

dm-crypt submits crypto requests with size aligned on 512 bytes. The start 
of the crypto request is usually aligned on 512 bytes, but not always - 
XFS with SLUB_DEBUG will send bios with misaligned bv_offset (but the bio 
vectors don't cross a page).

Mikulas

