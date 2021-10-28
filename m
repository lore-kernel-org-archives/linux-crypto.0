Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0FBC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04C56044F
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhJ1KOI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 06:14:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1KOG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 06:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635415899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lf5038czWxD5TVdb3xzJS31yq5LDU7rgKUOZR2ujX9Y=;
        b=ScE/ShA+qF1HzfNI3oqvvxiZAD2q7zPDEWBC2fxPTXNh2wm5L+N7W5jpSbWPEiNJgVs0OZ
        LzFXLaeybsu8q6REGAJHqfTZKFKQEsuYLl49o6+M9S5JyhR3qjYG9Wu3I+94MKhScl+j7u
        O4eMwQ3F2qc/j1pssZ6QN1HPbPJuqGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-CeVCjHmJNmOCLy6xJIUSjw-1; Thu, 28 Oct 2021 06:11:33 -0400
X-MC-Unique: CeVCjHmJNmOCLy6xJIUSjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67BAD10A8E02;
        Thu, 28 Oct 2021 10:11:31 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E635D60C04;
        Thu, 28 Oct 2021 10:11:12 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     amit@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org,
        Dmitriy Vyukov <dvyukov@google.com>, rusty@rustcorp.com.au,
        akong@redhat.com, Alexander Potapenko <glider@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 0/4] hwrng: virtio - add an internal buffer
Date:   Thu, 28 Oct 2021 12:11:07 +0200
Message-Id: <20211028101111.128049-1-lvivier@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
v2:=0D
fixes issue reported by syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.c=
om=0D
by reseting data_idx to 0 when the buffer is submitted not when it is=0D
received as the consumer checks for data_avail, not only for the completion=
.=0D
=0D
Laurent Vivier (4):=0D
  hwrng: virtio - add an internal buffer=0D
  hwrng: virtio - don't wait on cleanup=0D
  hwrng: virtio - don't waste entropy=0D
  hwrng: virtio - always add a pending request=0D
=0D
 drivers/char/hw_random/virtio-rng.c | 86 ++++++++++++++++++++++-------=0D
 1 file changed, 65 insertions(+), 21 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

