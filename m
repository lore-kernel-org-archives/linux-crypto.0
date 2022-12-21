Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C908CC4167B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 15:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiLUP0T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 10:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiLUPZ5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 10:25:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3823723385
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 07:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671636312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jLkifaRNie+5yBb4doLK/fF+FjvTU5/fCmZUYbo0qww=;
        b=NnxsC9S4F5le5SVW5kzavtjPLrlxNFyKJ894rQ9SoSl71mE2xl8lYiXq7w4m/sgxZ5gjbr
        TamXollyH6AbXdGVEgG70mvdSV6R7Pc8vEPI1wMWsM34PQow5FowJGQsFpC9f50YxHhfsh
        IbeARsRXqVrB6AryI2T/pIzQ38Mr350=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-TRlVveCQM5SxUo97QfWSnA-1; Wed, 21 Dec 2022 10:25:07 -0500
X-MC-Unique: TRlVveCQM5SxUo97QfWSnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 870461C09C93;
        Wed, 21 Dec 2022 15:25:06 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-25.brq.redhat.com [10.40.208.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34CD414152F4;
        Wed, 21 Dec 2022 15:25:04 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     nstange@suse.de
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        smueller@chronox.de, vdronov@redhat.com
Subject: Re: [PATCH 0/4] Trivial set of FIPS 140-3 related changes
Date:   Wed, 21 Dec 2022 16:24:00 +0100
Message-Id: <20221221152400.8515-1-vdronov@redhat.com>
In-Reply-To: <20221108142025.13461-1-nstange@suse.de>
References: <20221108142025.13461-1-nstange@suse.de>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Nicolai, Robert, Herbert, all,

I would like to revive this older upstream email thread. I would like
to address notes from reviewers (namely, Robert) by additional patches
so the whole patchset can be accepted. This should ease our future
kernel work re: FIPS.

The below 2 patches address (I hope) both notes Robert and Herbert have
provided (thanks!). I hope the whole patchset can be accepted then.

Logically my 2 patches should follow [PATCH 1/4] and be patches 2 and 3.
Herbert is it possible to reorder them when accepting?

Thank you! and

Best regards,
Vladis

Vladis Dronov (2):
  crypto: xts - drop xts_check_key()
  crypto: xts - drop redundant xts key check

