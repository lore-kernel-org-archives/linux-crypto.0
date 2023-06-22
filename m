Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E01BEB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 12:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjFVMCI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 08:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjFVMBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 08:01:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51D21FF2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 05:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687435151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTTkA2sp2q9Z2LAXZ1QDFqA4SF11T5ulFHu3zl8eY5M=;
        b=HKcWs6DPAhU6wfPnHBl6G6Jy2lxAo47NSLCmBXEfeoO9iYb2vuqc8aqpgKWA5HPgrcvnV+
        saFjDIBqwl6RgNIDlRcw7k3z1ZPXrFs7namUC2su4EBicuGWq4G+hS35jVJEvKJSVAHjkB
        bQ612WGXELIjTpKkJMoDMLcARRUFHX8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-6Z1yo4sGOmWQee1pLM60Cw-1; Thu, 22 Jun 2023 07:59:10 -0400
X-MC-Unique: 6Z1yo4sGOmWQee1pLM60Cw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-514a6909c35so4474354a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 04:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687435149; x=1690027149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTTkA2sp2q9Z2LAXZ1QDFqA4SF11T5ulFHu3zl8eY5M=;
        b=UydW6eRzKz7iuaAihlM517CE5RiwHmKVnVGMor8Ny5OyG21fGQYsTldm0ReZ3Saska
         +EsG0YdnGyBjeuQuKyhE2DU1L9smMlyggIe/ONpvAdipf3MgpmhOA8VGKGDgeiZi8TbP
         CjUnqltNjL9AeUh9iw7k6VUrUN2wK+JqgiJ2kRgh0Xaa9XFxU1u/6KkGKQb6NB0OfAQa
         TVJ0D+PJA5/K4tOf+9QyzOnDJdBN3iVyVjzbqxIdGHt8/ZlXUvzk5EVVrN1P+DcTAZxn
         gGK102lhLxj21ATYpRYtZs65zo9jNLJJ3/calujCTG5LySOrZa7L+7hqF1n4p996vjED
         SmBw==
X-Gm-Message-State: AC+VfDyy8VnS6QACQ/4Qn+p0kNp2B9l0ffj3agSzosY8lKlZiQNKNSuH
        HC5HjASinH29WuadcdeCY9NbXMQucc2EHx8z4M1sKcN8K8uPk6w6LsQLwDNIX2jj3A3lV0HkeXu
        4lYI7B0C/PHR8y1HTqo+PYCon
X-Received: by 2002:a17:907:da2:b0:988:e8e1:6360 with SMTP id go34-20020a1709070da200b00988e8e16360mr8670200ejc.8.1687435149350;
        Thu, 22 Jun 2023 04:59:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ60H5p6tlUuyW+YXWTMB9vjFrAWl14WNSb9PT+fUHAJkRDpLgoKLJFf4fBEpXMrE8mEIpD8PQ==
X-Received: by 2002:a17:907:da2:b0:988:e8e1:6360 with SMTP id go34-20020a1709070da200b00988e8e16360mr8670182ejc.8.1687435149020;
        Thu, 22 Jun 2023 04:59:09 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1ef:2a1f:ee44:7b4f:4310:5b81])
        by smtp.gmail.com with ESMTPSA id x17-20020a170906711100b009884f015a44sm4484108ejj.49.2023.06.22.04.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 04:59:08 -0700 (PDT)
Date:   Thu, 22 Jun 2023 07:59:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fixup potential cpu stall
Message-ID: <20230622075819-mutt-send-email-mst@kernel.org>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 09:18:14PM +0800, Xianting Tian wrote:
> Cpu stall issue may happen if device is configured with multi queues
> and large queue depth, so fix it.


I applied this after tweaking commit log to address Greg's comments.
In the future I expect you guys to do such tweaks yourself.

> Xianting Tian (3):
>   virtio-crypto: fixup potential cpu stall when free unused bufs
>   virtio_console: fixup potential cpu stall when free unused bufs
>   virtio_bt: fixup potential cpu stall when free unused bufs
> 
>  drivers/bluetooth/virtio_bt.c              | 1 +
>  drivers/char/virtio_console.c              | 1 +
>  drivers/crypto/virtio/virtio_crypto_core.c | 1 +
>  3 files changed, 3 insertions(+)
> 
> -- 
> 2.17.1

