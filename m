Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8B3C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 03:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7952076C
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 03:12:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GIlJUKzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388588AbgEYDM3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 May 2020 23:12:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388178AbgEYDM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 May 2020 23:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590376348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnz+SecxbJF4VB67gTuVQUxZ7oOwMLV+o3t+dmPe5pU=;
        b=GIlJUKzzlS9LB2JX9KtglBoDkMHN/kiSeRLdq/IRBCyKt++bA0Oh84vp2wda9xfj5DBba/
        RnnPme8mGPOM6JyOsxXDYlWUC5Mf5r140iWczvu2Mty/TolXRJbAlWSA2EDhbjf2dkUBwl
        BukRfNWZ9TnJvVbJoR3rJSJn+KIGNKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-nEBiy2TBMrq5N4laMrxC4w-1; Sun, 24 May 2020 23:12:26 -0400
X-MC-Unique: nEBiy2TBMrq5N4laMrxC4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0919C1009440;
        Mon, 25 May 2020 03:12:24 +0000 (UTC)
Received: from [10.72.13.226] (ovpn-13-226.pek2.redhat.com [10.72.13.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1C4B5D9DC;
        Mon, 25 May 2020 03:12:16 +0000 (UTC)
Subject: Re: [PATCH 1/2] crypto: virtio: fix src/dst scatterlist calculation
To:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        linux-crypto@vger.kernel.org
Cc:     Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, LABBE Corentin <clabbe@baylibre.com>
References: <20200525005627.707-1-longpeng2@huawei.com>
 <20200525005627.707-2-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <25cff618-601c-e899-a3cc-b289863a7407@redhat.com>
Date:   Mon, 25 May 2020 11:12:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525005627.707-2-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 2020/5/25 上午8:56, Longpeng(Mike) wrote:
> The system will crash when we insmod crypto/tcrypt.ko whit mode=38.
>
> Usually the next entry of one sg will be @sg@ + 1, but if this sg element
> is part of a chained scatterlist, it could jump to the start of a new
> scatterlist array. Let's fix it by sg_next() on calculation of src/dst
> scatterlist.
>
> BTW I add a check for sg_nents_for_len() its return value since
> sg_nents_for_len() function could fail.
>
> Cc: Gonglei <arei.gonglei@huawei.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: virtualization@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
>
> Reported-by: LABBE Corentin <clabbe@baylibre.com>
> Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> ---
>   drivers/crypto/virtio/virtio_crypto_algs.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
> index 372babb44112..2fa1129f96d6 100644
> --- a/drivers/crypto/virtio/virtio_crypto_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> @@ -359,8 +359,14 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>   	unsigned int num_out = 0, num_in = 0;
>   	int sg_total;
>   	uint8_t *iv;
> +	struct scatterlist *sg;
>   
>   	src_nents = sg_nents_for_len(req->src, req->cryptlen);
> +	if (src_nents < 0) {
> +		pr_err("Invalid number of src SG.\n");
> +		return src_nents;
> +	}
> +
>   	dst_nents = sg_nents(req->dst);
>   
>   	pr_debug("virtio_crypto: Number of sgs (src_nents: %d, dst_nents: %d)\n",
> @@ -446,12 +452,12 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>   	vc_sym_req->iv = iv;
>   
>   	/* Source data */
> -	for (i = 0; i < src_nents; i++)
> -		sgs[num_out++] = &req->src[i];
> +	for (sg = req->src, i = 0; sg && i < src_nents; sg = sg_next(sg), i++)


Any reason sg is checked here?

I believe it should be checked in sg_nents_for_len().


> +		sgs[num_out++] = sg;
>   
>   	/* Destination data */
> -	for (i = 0; i < dst_nents; i++)
> -		sgs[num_out + num_in++] = &req->dst[i];
> +	for (sg = req->dst, i = 0; sg && i < dst_nents; sg = sg_next(sg), i++)
> +		sgs[num_out + num_in++] = sg;


I believe sg should be checked in sg_nents().

Thanks


>   
>   	/* Status */
>   	sg_init_one(&status_sg, &vc_req->status, sizeof(vc_req->status));

