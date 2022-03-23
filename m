Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BADEC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 15:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244929AbiCWPDE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 11:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiCWPDC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 11:03:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 310C37460A
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 08:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648047692;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=nV8tfFGM1AQ/P90Zz8juXEcegOc8r+b10AqC7hoVW0w=;
        b=YiDha/Ynb0C07GwRjPzWDJaaIVar1wNV/H0OzmYhB6P6hLARz78Co5YSFokIRBbnKgh1GF
        QK72Sq2XcX44+cVooV+tuQJTtrV1OkiuIkLdg+Gok1PwxAkcBR21/IY7+5hMkOIedKbilS
        0sAi8p9/PUOk3e4EEBHhGmXJBq8lC44=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-JM6FYdXaO_29lV7-FHIALw-1; Wed, 23 Mar 2022 11:01:22 -0400
X-MC-Unique: JM6FYdXaO_29lV7-FHIALw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4A043838065;
        Wed, 23 Mar 2022 15:00:58 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B9ECC15D6F;
        Wed, 23 Mar 2022 15:00:56 +0000 (UTC)
Date:   Wed, 23 Mar 2022 15:00:54 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com,
        herbert@gondor.apana.org.au, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, Lei He <helei.sig11@bytedance.com>
Subject: Re: [PATCH v3 2/6] crypto-akcipher: Introduce akcipher types to qapi
Message-ID: <Yjs2JshB8ZASiHJT@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323024912.249789-3-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323024912.249789-3-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 10:49:08AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Introduce akcipher types, also include RSA & ECDSA related types.
> 
> Signed-off-by: Lei He <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  qapi/crypto.json | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/qapi/crypto.json b/qapi/crypto.json
> index 1ec54c15ca..d44c38e3b1 100644
> --- a/qapi/crypto.json
> +++ b/qapi/crypto.json
> @@ -540,3 +540,89 @@
>    'data': { '*loaded': { 'type': 'bool', 'features': ['deprecated'] },
>              '*sanity-check': 'bool',
>              '*passwordid': 'str' } }
> +##
> +# @QCryptoAkcipherAlgorithm:
> +#
> +# The supported algorithms for asymmetric encryption ciphers
> +#
> +# @rsa: RSA algorithm
> +# @ecdsa: ECDSA algorithm
> +#
> +# Since: 7.0
> +##
> +{ 'enum': 'QCryptoAkcipherAlgorithm',
> +  'prefix': 'QCRYPTO_AKCIPHER_ALG',
> +  'data': ['rsa', 'ecdsa']}

What were your intentions wrt  ecdsa - the nettle impl in this patch
series doesn't appear to actually support ecdsa. Are you intending to
add this in later versions of this patch series, or do it as separate
work at a later date ?


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

