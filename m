Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB557C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 23 May 2022 09:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiEWJoM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 May 2022 05:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiEWJoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 May 2022 05:44:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A67F733E1B
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2022 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653299017;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=zHdaX4lkGani+Ef/QKOcwQCasmJossQLNme43RH2O2E=;
        b=S+yvvpJ0Dc5azf7B6C2y7SQm16lzM+TKBgOm4VUkbDkTgNKDeETrzvtlj1Zl4E7eKO77KZ
        GchXAN/+vLimNtLz3EPHcbsHwnfmFgaXU0ghAVS+gX1z6UopliiBmKo/RG6uSu0c++yJgK
        aoTmKfvP/zHCpQ2nZ1BgnzjVVkJxPVc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-DkwGMmLoPDWOy0-HAxylew-1; Mon, 23 May 2022 05:43:35 -0400
X-MC-Unique: DkwGMmLoPDWOy0-HAxylew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77D8085A5B9;
        Mon, 23 May 2022 09:43:35 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06B592026D6A;
        Mon, 23 May 2022 09:43:33 +0000 (UTC)
Date:   Mon, 23 May 2022 10:43:31 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v6 5/9] crypto: Implement RSA algorithm by hogweed
Message-ID: <YotXQz6rydXN+AtH@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220514005504.1042884-1-pizhenwei@bytedance.com>
 <20220514005504.1042884-6-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220514005504.1042884-6-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 14, 2022 at 08:55:00AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Implement RSA algorithm by hogweed from nettle. Thus QEMU supports
> a 'real' RSA backend to handle request from guest side. It's
> important to test RSA offload case without OS & hardware requirement.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  crypto/akcipher-nettle.c.inc | 451 +++++++++++++++++++++++++++++++++++
>  crypto/akcipher.c            |   4 +
>  crypto/meson.build           |   4 +
>  crypto/rsakey-builtin.c.inc  | 200 ++++++++++++++++
>  crypto/rsakey-nettle.c.inc   | 158 ++++++++++++
>  crypto/rsakey.c              |  44 ++++
>  crypto/rsakey.h              |  94 ++++++++
>  meson.build                  |  11 +
>  8 files changed, 966 insertions(+)
>  create mode 100644 crypto/akcipher-nettle.c.inc
>  create mode 100644 crypto/rsakey-builtin.c.inc
>  create mode 100644 crypto/rsakey-nettle.c.inc
>  create mode 100644 crypto/rsakey.c
>  create mode 100644 crypto/rsakey.h


> diff --git a/crypto/rsakey.h b/crypto/rsakey.h
> new file mode 100644
> index 0000000000..17bb22333d
> --- /dev/null
> +++ b/crypto/rsakey.h
> @@ -0,0 +1,94 @@
> +
> +#ifndef QCRYPTO_RSAKEY_H
> +#define QCRYPTO_RSAKEY_H
> +
> +#include <nettle/bignum.h>

This should be removed -it isn't needed and breaks build on
without-nettle build configurations.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

