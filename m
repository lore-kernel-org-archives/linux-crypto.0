Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C776C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Apr 2022 10:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348874AbiDZKpK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 06:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348961AbiDZKo7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 06:44:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39E942601
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650969293;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KtGuWPPIAuIhHsklidM2yMTGEn7vTMVZjRfQnOlbXVg=;
        b=KknF1EDDH60TVOD+/2N+UloJu78NBule/u39DGZqJCkWXG2wqD8NGZYr9jH/0QVMtbM91B
        8rATth0QTGoCwiLuGZBjdo+5cx0rrwrj15GgpECkFeX85W60a0M6G4sR/z6sJsK7OLBOI5
        +I3OzLZ+EqfiD6Hy37yuLLMiLnRgZzs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-9mIwJ_YuNHmK_a_28fK5Hg-1; Tue, 26 Apr 2022 06:34:50 -0400
X-MC-Unique: 9mIwJ_YuNHmK_a_28fK5Hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA53185A7A4;
        Tue, 26 Apr 2022 10:34:50 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9502AC159B3;
        Tue, 26 Apr 2022 10:34:48 +0000 (UTC)
Date:   Tue, 26 Apr 2022 11:34:46 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v4 2/8] crypto-akcipher: Introduce akcipher types to qapi
Message-ID: <YmfKxistn+fCjvr1@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
 <20220411104327.197048-3-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220411104327.197048-3-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 11, 2022 at 06:43:21PM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Introduce akcipher types, also include RSA related types.
> 
> Signed-off-by: Lei He <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  qapi/crypto.json | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)

snip

> +##
> +# @QCryptoAkCipherOptions:
> +#
> +# The options that are available for all asymmetric key algorithms
> +# when creating a new QCryptoAkCipher.
> +#
> +# Since: 7.1
> +##
> +{ 'union': 'QCryptoAkCipherOptions',
> +  'base': { 'algorithm': 'QCryptoAkCipherAlgorithm' },
> +  'discriminator': 'algorithm',
> +  'data': { 'rsa': 'QCryptoAkCipherOptionsRSA' }}

I mistakenly suggested 'algorithm' here, but for consistency
with other fields, I should have said just 'alg'.

With that change

  Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

