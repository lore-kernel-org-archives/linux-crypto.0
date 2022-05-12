Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FEFC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 May 2022 10:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiELKF3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 May 2022 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345766AbiELKFZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 May 2022 06:05:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCE5D65419
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2022 03:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652349923;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZQZZr9GX6q77pDkTASbX7SqttFBcQsXJ17/Aanrbuc=;
        b=RfVsfXiVliO9iHFIVl8lcnJ4TXZpbr848mSZoizvbhHu/wSxg8PFjV1GslUayA7qiy29oH
        2dcM7uA6f4HX3Xz0W+9UEVGaEOvhArWieY1LdnbQR8RBVdeZ2k7MoJVXl8mFzd6QV3lkmh
        KAZJO54C+Jrake4ZR4z5gA/j1H6C4f8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-83Lelki5OuC4Xj43ANXsZw-1; Thu, 12 May 2022 06:05:18 -0400
X-MC-Unique: 83Lelki5OuC4Xj43ANXsZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEAC63C19033;
        Thu, 12 May 2022 10:05:17 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E0102166B26;
        Thu, 12 May 2022 10:04:53 +0000 (UTC)
Date:   Thu, 12 May 2022 11:04:50 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v5 3/9] crypto: Introduce akcipher crypto class
Message-ID: <Ynzbwq1f+KgMO5LW@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-4-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220428135943.178254-4-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 28, 2022 at 09:59:37PM +0800, zhenwei pi wrote:
> Introduce new akcipher crypto class 'QCryptoAkCIpher', which supports
> basic asymmetric operations: encrypt, decrypt, sign and verify.
> 
> Suggested by Daniel P. Berrangé, also add autoptr cleanup for the new
> class. Thanks to Daniel!
> 
> Co-developed-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  crypto/akcipher.c         | 102 ++++++++++++++++++++++++
>  crypto/akcipherpriv.h     |  55 +++++++++++++
>  crypto/meson.build        |   1 +
>  include/crypto/akcipher.h | 158 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 316 insertions(+)
>  create mode 100644 crypto/akcipher.c
>  create mode 100644 crypto/akcipherpriv.h
>  create mode 100644 include/crypto/akcipher.h

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

