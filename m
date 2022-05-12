Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F75FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 12 May 2022 09:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352152AbiELJjM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 May 2022 05:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352175AbiELJjK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 May 2022 05:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 642DCBA9A3
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2022 02:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652348347;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLKLgA7d5d1qjLjAxbAiC2y0ZsRTe2UXXmSPURXjo2c=;
        b=C1UmPh1XKfKhuOy4UgMk3erHP5EaBMX69mmjjVhupK2kxtLEuD+peBzR6cHcEm547H+mxZ
        zA5lEuglsCj20d4xc2EwpvM64nHV1z5N5gR0sDdu7UVbHFAe4cuLFLhJ+nq3SQ+XkmF7e/
        MZtCFgl+m1TNNSYWqz6BLXGYEl05lHE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-XsdZg6wLObCxVseVbxSDLQ-1; Thu, 12 May 2022 05:39:04 -0400
X-MC-Unique: XsdZg6wLObCxVseVbxSDLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB30585A5BE;
        Thu, 12 May 2022 09:39:03 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B1E34010A13;
        Thu, 12 May 2022 09:39:00 +0000 (UTC)
Date:   Thu, 12 May 2022 10:38:57 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v5 7/9] test/crypto: Add test suite for crypto akcipher
Message-ID: <YnzVsRW9DiyhbuIm@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-8-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220428135943.178254-8-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 28, 2022 at 09:59:41PM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Add unit test and benchmark test for crypto akcipher.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>  tests/bench/benchmark-crypto-akcipher.c | 157 ++++++
>  tests/bench/meson.build                 |   4 +
>  tests/bench/test_akcipher_keys.inc      | 537 ++++++++++++++++++
>  tests/unit/meson.build                  |   1 +
>  tests/unit/test-crypto-akcipher.c       | 711 ++++++++++++++++++++++++
>  5 files changed, 1410 insertions(+)
>  create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>  create mode 100644 tests/bench/test_akcipher_keys.inc
>  create mode 100644 tests/unit/test-crypto-akcipher.c


> diff --git a/tests/bench/meson.build b/tests/bench/meson.build
> index 00b3c209dc..f793d972b6 100644
> --- a/tests/bench/meson.build
> +++ b/tests/bench/meson.build
> @@ -23,6 +23,10 @@ if have_block
>    }
>  endif
>  
> +benchs += {
> +    'benchmark-crypto-akcipher': [crypto],
> +}

This needs to moved above a bit to be include the 'if have_block'
section above, otherwise it breaks the build when using --disable-system


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

