Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A53C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 17:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DED611C9
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 17:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbhIVRKq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 13:10:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236705AbhIVRKp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 13:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632330555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SHrxHOUJFC7SXjO6oPt56HM9d80tm/abAg5EY0FI59M=;
        b=X7FXEWQiQ6PjhXFJNeNgvBLE0+qxWo0K5/6udE6E8HOgJ4wcAp7MjRa1l9SFhT1J7Did63
        X38hISAQOXjFA/s2I9m3jTanI0YLJS0+n5Ir5xUVtyZguk6aEeXM/q+KivHVik380vl954
        Q3p9/UdQqqw/NezEh9UHUPemH41g1Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-bqVte1b5PcW-zOzon214Pw-1; Wed, 22 Sep 2021 13:09:11 -0400
X-MC-Unique: bqVte1b5PcW-zOzon214Pw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93E261023F4D;
        Wed, 22 Sep 2021 17:09:08 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.192.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F001E970E0;
        Wed, 22 Sep 2021 17:09:04 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Dmitriy Vyukov <dvyukov@google.com>,
        rusty@rustcorp.com.au, amit@kernel.org, akong@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH 0/4] hwrng: virtio - add an internal buffer
Date:   Wed, 22 Sep 2021 19:08:59 +0200
Message-Id: <20210922170903.577801-1-lvivier@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hwrng core uses two buffers that can be mixed in the virtio-rng queue.=0D
=0D
This series fixes the problem by adding an internal buffer in virtio-rng.=0D
=0D
Once the internal buffer is added, we can fix two other problems:=0D
=0D
- to be able to release the driver without waiting the device releases the=
=0D
  buffer=0D
=0D
- actually returns some data when wait=3D0 as we can have some already=0D
  available data=0D
=0D
It also tries to improve the performance by always having a buffer in=0D
the queue of the device.=0D
=0D
Laurent Vivier (4):=0D
  hwrng: virtio - add an internal buffer=0D
  hwrng: virtio - don't wait on cleanup=0D
  hwrng: virtio - don't waste entropy=0D
  hwrng: virtio - always add a pending request=0D
=0D
 drivers/char/hw_random/virtio-rng.c | 84 +++++++++++++++++++++--------=0D
 1 file changed, 63 insertions(+), 21 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

