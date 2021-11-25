Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C68C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Nov 2021 18:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356746AbhKYSJ3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Nov 2021 13:09:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhKYSH3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Nov 2021 13:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637863457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=uqHYC6pMdILCZt4L46t3fYUcohv6tOiNRcfAVmZ0lZA=;
        b=AX44U2Yt3XjNwY/ajB1oxIo/wQqpc+H7mNJI980qCXpd2KnzfAx7XJljXiNp0Td9UNDwwc
        B0qF62wJERbHqlSBZaGUsle9HQiNoMhp6NOWz5Ndd0itgSV685R+dF372GOjAYcNwa5Mvj
        sjo4A2gmvhhBRODKCpvFOJ39216raeI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-DH4lC_pANT6uNJx8fwnPfw-1; Thu, 25 Nov 2021 13:04:16 -0500
X-MC-Unique: DH4lC_pANT6uNJx8fwnPfw-1
Received: by mail-ed1-f69.google.com with SMTP id v1-20020aa7cd41000000b003e80973378aso5991005edw.14
        for <linux-crypto@vger.kernel.org>; Thu, 25 Nov 2021 10:04:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uqHYC6pMdILCZt4L46t3fYUcohv6tOiNRcfAVmZ0lZA=;
        b=O4Ogu1MmLEjiy1oWxuHVoHCrqHralk8+yiXJKfEciwr0idoUDLSMDMfW9AoGraM895
         Hrtc8rh2dMqLZhTn+ozHmRTaZqWNSJR1/MAPP7zWV81Y4bGZ+yDKYYRMmx1bCRru/uOA
         nUNMqJmFqQtVayWEQwly+0pGJ+CaWiLVGXuY9mGtL4/5ARce7ZJWJq3oET8Sgzzl18yF
         uWo2peF846+RfjRkrcQInDe7NN++KJY1y/S7S4cI+xu6wXZVvdRYK6cDlOUaWKSq4bK0
         A2Ng2j20rbYg8j8z+UsQwIIvhNLsZcUZkFw3LvnnkR5uWAVjcBMoaWa/ywA8w+6EXr/4
         ErQQ==
X-Gm-Message-State: AOAM533KvPY4EIAVYqrL1bpt5yvW3LxRWnMwcdeCIBGX/f7CJRhjGzFT
        OoKoZXDXo1f6YmhGPoa4td7y4nYgpQOK3F8P9HTERiJcTgikRlKSlcY4AJ/WgeFidEIYuNyu1fs
        7x2NNGl9IqsXZU6Lk7r9Fa/sC
X-Received: by 2002:a17:906:5951:: with SMTP id g17mr34494244ejr.315.1637863454844;
        Thu, 25 Nov 2021 10:04:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUwyeLJh7uyU1G5zbFj303QzV/bRNx8rnoSzog0EBaXN/XxDE9bEwdzbCGmSFxfoUoiZ3rxA==
X-Received: by 2002:a17:906:5951:: with SMTP id g17mr34494215ejr.315.1637863454657;
        Thu, 25 Nov 2021 10:04:14 -0800 (PST)
Received: from redhat.com ([176.12.197.47])
        by smtp.gmail.com with ESMTPSA id h10sm2399113edj.1.2021.11.25.10.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 10:04:14 -0800 (PST)
Date:   Thu, 25 Nov 2021 13:04:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] hwrng: virtio - unregister device before reset
Message-ID: <20211125180343.134505-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

unregister after reset is clearly wrong - device
can be used while it's reset. There's an attempt to
protect against that using hwrng_removed but it
seems racy since access can be in progress
when the flag is set.

Just unregister, then reset seems simpler and cleaner.
NB: we might be able to drop hwrng_removed in a follow-up patch.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

NB: lightly tested. Don't know much about rng. Any reviewers?


 drivers/char/hw_random/virtio-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index b2bf78b25630..e856df7e285c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -179,9 +179,9 @@ static void remove_common(struct virtio_device *vdev)
 	vi->data_avail = 0;
 	vi->data_idx = 0;
 	complete(&vi->have_data);
-	virtio_reset_device(vdev);
 	if (vi->hwrng_register_done)
 		hwrng_unregister(&vi->hwrng);
+	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 	ida_simple_remove(&rng_index_ida, vi->index);
 	kfree(vi);
-- 
MST

