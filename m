Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E28C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 12:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354888AbiEMM3Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 08:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiEMM3Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 08:29:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D0F14249A
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 05:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652444962;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5KwufUflIN0+si5g5sPE5FPx8DWaH5QC9MTJ9abHStk=;
        b=SxO8NglYj7UZWX7PZf69tMp5jxpfjRvs8/aMEx//WXfz+2t0kLHnXKJKLQCnXs9E/RP1xo
        fu9h9mRl23t9n7fIdd2aKhiW4NtqtlRZAT3Ncr8pKK0+MDKG9/DDulU5Ek8KM+a/7Tx728
        ZwDULd5byqaXjuzjPub3HHaebsZl1NY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-iVsCinzTPRipcbI6YnuQgg-1; Fri, 13 May 2022 08:29:19 -0400
X-MC-Unique: iVsCinzTPRipcbI6YnuQgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC60D1C05AF5;
        Fri, 13 May 2022 12:29:18 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F969C33AE5;
        Fri, 13 May 2022 12:29:16 +0000 (UTC)
Date:   Fri, 13 May 2022 13:29:13 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>, arei.gonglei@huawei.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com
Subject: Re: [External] [PATCH v5 5/9] crypto: Implement RSA algorithm by
 hogweed
Message-ID: <Yn5PGWPbP9C4k4wD@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-6-pizhenwei@bytedance.com>
 <Yn45CxgJ+KNIxXek@redhat.com>
 <90F3B18B-9B7E-423C-A909-45D4527A6B3C@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90F3B18B-9B7E-423C-A909-45D4527A6B3C@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 13, 2022 at 08:26:14PM +0800, 何磊 wrote:
> 
> 
> > On May 13, 2022, at 6:55 PM, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > 
> > On Thu, Apr 28, 2022 at 09:59:39PM +0800, zhenwei pi wrote:
> >> From: Lei He <helei.sig11@bytedance.com>
> >> 
> >> Implement RSA algorithm by hogweed from nettle. Thus QEMU supports
> >> a 'real' RSA backend to handle request from guest side. It's
> >> important to test RSA offload case without OS & hardware requirement.
> >> 
> >> Signed-off-by: lei he <helei.sig11@bytedance.com>
> >> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> >> ---
> >> crypto/akcipher-nettle.c.inc | 432 +++++++++++++++++++++++++++++++++++
> >> crypto/akcipher.c            |   4 +
> >> crypto/meson.build           |   4 +
> >> crypto/rsakey-builtin.c.inc  | 209 +++++++++++++++++
> >> crypto/rsakey-nettle.c.inc   | 154 +++++++++++++
> >> crypto/rsakey.c              |  44 ++++
> >> crypto/rsakey.h              |  94 ++++++++
> >> meson.build                  |  11 +
> >> 8 files changed, 952 insertions(+)
> >> create mode 100644 crypto/akcipher-nettle.c.inc
> >> create mode 100644 crypto/rsakey-builtin.c.inc
> >> create mode 100644 crypto/rsakey-nettle.c.inc
> >> create mode 100644 crypto/rsakey.c
> >> create mode 100644 crypto/rsakey.h


> >> +static int qcrypto_nettle_rsa_decrypt(QCryptoAkCipher *akcipher,
> >> +                                      const void *enc, size_t enc_len,
> >> +                                      void *data, size_t data_len,
> >> +                                      Error **errp)
> >> +{
> >> +    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)akcipher;
> >> +    mpz_t c;
> >> +    int ret = -1;
> >> +    if (enc_len > rsa->priv.size) {
> >> +        error_setg(errp, "Invalid buffer size");
> >> +        return ret;
> >> +    }
> > 
> > Again please report the invalid & expected sizes in the message
> > 
> > We don't need to validate 'data_len' in the decrypt case,
> > as you did in encrypt ?
> 
> In the decrypt case, it is difficult (and unnecessary) to check 'data_len' before 
> we completing the decryption action. If the plaintext buffer is too small, 
> following ‘rsa_decrypt’ will return an error, and it should be valid to pass a very 
> large buffer.
> 
> According to the pkcs#1 stardard, the length of ciphertext should always equal
> to key size, and the length of plaintext can be any value in range [1, key_size - 11]:
> 
> https://datatracker.ietf.org/doc/html/rfc2437#section-7.2

Ok, thanks for explaining.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

