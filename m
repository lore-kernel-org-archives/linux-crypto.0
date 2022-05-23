Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30939C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 23 May 2022 09:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiEWJqm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 May 2022 05:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiEWJqf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 May 2022 05:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C2AE64C1
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2022 02:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653299190;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=hhtlmlKxSNsXkQSBYy7jFqr7wJq7OZFvbfv9iGDXvX4=;
        b=ObpKHdxAW6y+S5G8JAgz1UMzSOHq/XBSkZlZ4CiqePihkdcNgjimW7CyM6XoL/j2aA/EPU
        Tjxi9J/MbPR2c1mX/7fC2LppNHFo3n8e0a+MuQ6P4w6+C+A40/BOhPBG9dkVGVq5HBnsjM
        AI7Q6NPlwpqtQlbSBwB6vrI0JmHy4OM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-9MW44G2oO_K3RO6XZJNU3Q-1; Mon, 23 May 2022 05:46:28 -0400
X-MC-Unique: 9MW44G2oO_K3RO6XZJNU3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDBD9811E75;
        Mon, 23 May 2022 09:46:27 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB1C4C27E8A;
        Mon, 23 May 2022 09:46:26 +0000 (UTC)
Date:   Mon, 23 May 2022 10:46:24 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v6 4/9] crypto: add ASN.1 DER decoder
Message-ID: <YotX8KouIzrVjX2R@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220514005504.1042884-1-pizhenwei@bytedance.com>
 <20220514005504.1042884-5-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220514005504.1042884-5-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 14, 2022 at 08:54:59AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Add an ANS.1 DER decoder which is used to parse asymmetric
> cipher keys
> 
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> ---
>  crypto/der.c                 | 189 +++++++++++++++++++++++
>  crypto/der.h                 |  81 ++++++++++
>  crypto/meson.build           |   1 +
>  tests/unit/meson.build       |   1 +
>  tests/unit/test-crypto-der.c | 290 +++++++++++++++++++++++++++++++++++
>  5 files changed, 562 insertions(+)
>  create mode 100644 crypto/der.c
>  create mode 100644 crypto/der.h
>  create mode 100644 tests/unit/test-crypto-der.c
> 

> diff --git a/tests/unit/meson.build b/tests/unit/meson.build
> index 264f2bc0c8..a8af85128d 100644
> --- a/tests/unit/meson.build
> +++ b/tests/unit/meson.build
> @@ -47,6 +47,7 @@ tests = {
>    'ptimer-test': ['ptimer-test-stubs.c', meson.project_source_root() / 'hw/core/ptimer.c'],
>    'test-qapi-util': [],
>    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c'],
> +  'test-crypto-der': [crypto],
>  }

This needs to be moved to later in this file where the other
test-crypto-XXXX rules are, otherwise it fails to build
on a configuration  --without-system --without-tools.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

