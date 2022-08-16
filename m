Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9011AC2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 10:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbiHPK11 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 06:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiHPKZg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 06:25:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B72A6D552
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 01:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660639411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lQ8+OX5Xxy8OFHIKMeBXHvilaHMyPM9qIfwd9KvB9T8=;
        b=bBvPSVTqfWaEkvyHhHGu6WgzaOZl2freu03oTlKFFxXme/h0MPtTtur4b1wvRk6E9Jas/I
        /hXN15m/Ntibai9KtTxjGhVzTWqfLuhbbMD5ll1CVGshxMJjil+GMXkkKI09U1uGsrRLRO
        6YKj+dbx1+Bg/1fyTIODxW18//tJcZI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-4aHqlQ0qMYyl0Vu7-JyTVA-1; Tue, 16 Aug 2022 04:43:24 -0400
X-MC-Unique: 4aHqlQ0qMYyl0Vu7-JyTVA-1
Received: by mail-wr1-f70.google.com with SMTP id v20-20020adf8b54000000b002216d3e3d5dso1675475wra.12
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 01:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lQ8+OX5Xxy8OFHIKMeBXHvilaHMyPM9qIfwd9KvB9T8=;
        b=evKPDukvd220VAr5JO2KwgK5FobM0lD3mq75xi/I9Ue3y51MWDKEyAOpIV02SPwJWf
         ZC1KuTYivy0PgrTGibjcHK49iucRCYQ2WDIDYsXVVevM0ArvlqUXUhCXp74ANmXcVork
         979EntgMN7VeeSIQHN0LBNt5mZO+H89pnkiZZIoIaLtbG/1rlRh9bLq4zDOQBM7R1Grh
         LTUjX7ydLqyNj3dkwlqPG7K5jNgk/gH5xrY01xK+6eCLG+qv1BtcorukfYY2DVgjej33
         5miQkeTRSfZxpGStCfhZz4a6oEmFMFz4+gR5RDPfpVzbHDFo3WkcAtJIyM86ECLBHxmC
         JRIg==
X-Gm-Message-State: ACgBeo0sRTXYO3cNZ/HL8Da1p5OwJ4bU0HH5TYvSZu6uQAauZHkXFR04
        F90X0IkpSRiLgvwosg7Ig+juzZuwU8ao/gX9cduM4XUEtCoInozlgzeu9DQqi9w0yCz8YVoB3GX
        TYZakFDp54dr38QeyoH+fMG7f
X-Received: by 2002:a05:6000:a1a:b0:21f:10a3:924 with SMTP id co26-20020a0560000a1a00b0021f10a30924mr11187430wrb.650.1660639403152;
        Tue, 16 Aug 2022 01:43:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6cDAFFABxm0UC6KHn6bIybMZn2ombgjhUlsi97ISnZjBMZOQIY2aI+6s7bBLYzIu9Hq0irDw==
X-Received: by 2002:a05:6000:a1a:b0:21f:10a3:924 with SMTP id co26-20020a0560000a1a00b0021f10a30924mr11187420wrb.650.1660639402874;
        Tue, 16 Aug 2022 01:43:22 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id u8-20020a05600c19c800b003a5f3de6fddsm7193442wmq.25.2022.08.16.01.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:43:22 -0700 (PDT)
Date:   Tue, 16 Aug 2022 04:43:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     arei.gonglei@huawei.com, herbert@gondor.apana.org.au,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com
Subject: Re: [PATCH] crypto-virtio: fix memory-leak
Message-ID: <20220816044118-mutt-send-email-mst@kernel.org>
References: <20220816075916.23651-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816075916.23651-1-helei.sig11@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 16, 2022 at 03:59:16PM +0800, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> Fix memory-leak for virtio-crypto akcipher request, this problem is
> introduced by 59ca6c93387d3(virtio-crypto: implement RSA algorithm).
> The leak can be reproduced and tested with the following script
> inside virtual machine:
> 
> #!/bin/bash
> 
> LOOP_TIMES=10000
> 
> # required module: pkcs8_key_parser, virtio_crypto
> modprobe pkcs8_key_parser # if CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
> modprobe virtio_crypto # if CONFIG_CRYPTO_DEV_VIRTIO=m
> rm -rf /tmp/data
> dd if=/dev/random of=/tmp/data count=1 bs=230
> 
> # generate private key and self-signed cert
> openssl req -nodes -x509 -newkey rsa:2048 -keyout key.pem \
> 		-outform der -out cert.der  \
> 		-subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=always.com/emailAddress=yy@always.com"
> # convert private key from pem to der
> openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER -out key.der
> 
> # add key
> PRIV_KEY_ID=`cat key.der | keyctl padd asymmetric test_priv_key @s`
> echo "priv key id = "$PRIV_KEY_ID
> PUB_KEY_ID=`cat cert.der | keyctl padd asymmetric test_pub_key @s`
> echo "pub key id = "$PUB_KEY_ID
> 
> # query key
> keyctl pkey_query $PRIV_KEY_ID 0
> keyctl pkey_query $PUB_KEY_ID 0
> 
> # here we only run pkey_encrypt becasuse it is the fastest interface
> function bench_pub() {
> 	keyctl pkey_encrypt $PUB_KEY_ID 0 /tmp/data enc=pkcs1 >/tmp/enc.pub
> }
> 
> # do bench_pub in loop to obtain the memory leak
> for (( i = 0; i < ${LOOP_TIMES}; ++i )); do
> 	bench_pub
> done
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>

trash below pls drop.


> # Please enter the commit message for your changes. Lines starting
> # with '#' will be kept; you may remove them yourself if you want to.
> # An empty message aborts the commit.
> #
> # Date:      Tue Aug 16 11:53:30 2022 +0800
> #
> # On branch master
> # Your branch is ahead of 'origin/master' by 1 commit.
> #   (use "git push" to publish your local commits)
> #
> # Changes to be committed:
> #	modified:   drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> #
> # Untracked files:
> #	cert.der
> #	key.der
> #	key.pem
> #
> 
> # Please enter the commit message for your changes. Lines starting
> # with '#' will be kept; you may remove them yourself if you want to.
> # An empty message aborts the commit.
> #
> # Date:      Tue Aug 16 11:53:30 2022 +0800
> #
> # On branch master
> # Your branch is ahead of 'origin/master' by 1 commit.
> #   (use "git push" to publish your local commits)
> #
> # Changes to be committed:
> #	modified:   drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> #
> # Untracked files:
> #	cert.der
> #	key.der
> #	key.pem
> #
> 
> # Please enter the commit message for your changes. Lines starting
> # with '#' will be kept; you may remove them yourself if you want to.
> # An empty message aborts the commit.
> #
> # Date:      Tue Aug 16 11:53:30 2022 +0800
> #
> # On branch master
> # Your branch is ahead of 'origin/master' by 1 commit.
> #   (use "git push" to publish your local commits)
> #
> # Changes to be committed:
> #	modified:   drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> #
> # Untracked files:
> #	cert.der
> #	key.der
> #	key.pem
> #
> ---

with commit log fixed:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

>  drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index 2a60d0525cde..168195672e2e 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -56,6 +56,10 @@ static void virtio_crypto_akcipher_finalize_req(
>  	struct virtio_crypto_akcipher_request *vc_akcipher_req,
>  	struct akcipher_request *req, int err)
>  {
> +	kfree(vc_akcipher_req->src_buf);
> +	kfree(vc_akcipher_req->dst_buf);
> +	vc_akcipher_req->src_buf = NULL;
> +	vc_akcipher_req->dst_buf = NULL;
>  	virtcrypto_clear_request(&vc_akcipher_req->base);
>  
>  	crypto_finalize_akcipher_request(vc_akcipher_req->base.dataq->engine, req, err);
> -- 
> 2.20.1

