Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEB2C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Apr 2022 06:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbiDZGQL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 02:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiDZGQK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 02:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65A90369D9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 23:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650953582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IgcCC54HWlFAQ3ErnpZAkoxSmmx2K6ZzpSDRxVFvmN0=;
        b=a02P7hfV8YQKv0+t+DnzTFYWhueJlaeqHNMwhuyeorZA5V0L2LcA8AHgVmxfVtDGRLuPaQ
        SkWe0qIp+LuvUmd2TUjvvQzV7IWJj4HuV4Xsu9k2m07K2IR/qT7VxnUqeCZyH+h2Uoip4g
        EST7LHUGu9PwKznMVxjg6U7ZQ8bidjs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-5FDza5UWPN2NgMl2lChe2Q-1; Tue, 26 Apr 2022 02:13:00 -0400
X-MC-Unique: 5FDza5UWPN2NgMl2lChe2Q-1
Received: by mail-lf1-f69.google.com with SMTP id h4-20020a0565123c8400b00471f8c2a09eso3438396lfv.10
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 23:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IgcCC54HWlFAQ3ErnpZAkoxSmmx2K6ZzpSDRxVFvmN0=;
        b=48g4/wwCwlDPy5Q4gtRoS5C5OK4vmDsso7W4h5dH0uiRH5S0kZPEz8zsCftMTUcIfo
         dzSfVMVGUxebRHQnXPIjihvWKPrNUuuDFX6yDg56dNDLXVctM2yDcKWMuxE0QpumsHXI
         Q7R5N/1/Z5Hcv6ZJOcBsn80XmJy04nljdxq1RK+BMgHmh2OH5JdsSfI8dBnNBAoK6Zyi
         Aphk1vWJooM9y3E6OU/kUhMGtrXBto5C7bgRG4BjpC270XwTbNef6Zgth3ZzGDBfd2sf
         CVyc9vDOZ2cCADX+cMoU4wJNbIqBUwlM/JJ6jVEnFijh5ZaBhw/Pd0YoygjPWEuBqkTh
         XgxQ==
X-Gm-Message-State: AOAM531NiKZ8UZ4mVZAZPJ/Hi3ddf+217r/N8O4Yrx4ekIO4MpmCFZKZ
        +0JqwfsZk6PJWAfgGFNlV50yOgTZyjKkXALwe0jVlbe7x6OGLNT/ESRGjQMR9/v+8QmesZelU4z
        5v793uYBXxLCaB4/nJDFGCtPHQKuSHZ35Ygi0rR/r
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id p21-20020a056512139500b00446d38279a5mr15311158lfa.210.1650953579434;
        Mon, 25 Apr 2022 23:12:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmOmSK4d0erkiX3LcwazyGWu55/BLRoP/5cllUj+Rcjf7WbhkerrOUWV1AhC8Rspd9uYKFT8uXgYeiP46dGSM=
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id
 p21-20020a056512139500b00446d38279a5mr15311140lfa.210.1650953579139; Mon, 25
 Apr 2022 23:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220424104140.44841-1-pizhenwei@bytedance.com> <20220424104140.44841-2-pizhenwei@bytedance.com>
In-Reply-To: <20220424104140.44841-2-pizhenwei@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Apr 2022 14:12:47 +0800
Message-ID: <CACGkMEu+V6-+OTDnEJH+zORF6SSRhPjVWAyBWQ259RHKtNiShA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] virtio-crypto: change code style
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     "Gonglei (Arei)" <arei.gonglei@huawei.com>, mst <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 24, 2022 at 6:45 PM zhenwei pi <pizhenwei@bytedance.com> wrote:
>
> Use temporary variable to make code easy to read and maintain.
>         /* Pad cipher's parameters */
>         vcrypto->ctrl.u.sym_create_session.op_type =
>                 cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
>         vcrypto->ctrl.u.sym_create_session.u.cipher.para.algo =
>                 vcrypto->ctrl.header.algo;
>         vcrypto->ctrl.u.sym_create_session.u.cipher.para.keylen =
>                 cpu_to_le32(keylen);
>         vcrypto->ctrl.u.sym_create_session.u.cipher.para.op =
>                 cpu_to_le32(op);
> -->
>         sym_create_session = &ctrl->u.sym_create_session;
>         sym_create_session->op_type = cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
>         sym_create_session->u.cipher.para.algo = ctrl->header.algo;
>         sym_create_session->u.cipher.para.keylen = cpu_to_le32(keylen);
>         sym_create_session->u.cipher.para.op = cpu_to_le32(op);
>
> The new style shows more obviously:
> - the variable we want to operate.
> - an assignment statement in a single line.

Still hundreds of lines of changes, I'd leave this change to other
mainters to dedice.

Thanks

>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Gonglei <arei.gonglei@huawei.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  .../virtio/virtio_crypto_akcipher_algs.c      | 40 ++++++-----
>  .../virtio/virtio_crypto_skcipher_algs.c      | 72 +++++++++----------
>  2 files changed, 59 insertions(+), 53 deletions(-)
>
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index f3ec9420215e..20901a263fc8 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -106,23 +106,27 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
>         unsigned int inlen;
>         int err;
>         unsigned int num_out = 0, num_in = 0;
> +       struct virtio_crypto_op_ctrl_req *ctrl;
> +       struct virtio_crypto_session_input *input;
>
>         pkey = kmemdup(key, keylen, GFP_ATOMIC);
>         if (!pkey)
>                 return -ENOMEM;
>
>         spin_lock(&vcrypto->ctrl_lock);
> -       memcpy(&vcrypto->ctrl.header, header, sizeof(vcrypto->ctrl.header));
> -       memcpy(&vcrypto->ctrl.u, para, sizeof(vcrypto->ctrl.u));
> -       vcrypto->input.status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
> +       ctrl = &vcrypto->ctrl;
> +       memcpy(&ctrl->header, header, sizeof(ctrl->header));
> +       memcpy(&ctrl->u, para, sizeof(ctrl->u));
> +       input = &vcrypto->input;
> +       input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
>
> -       sg_init_one(&outhdr_sg, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
> +       sg_init_one(&outhdr_sg, ctrl, sizeof(*ctrl));
>         sgs[num_out++] = &outhdr_sg;
>
>         sg_init_one(&key_sg, pkey, keylen);
>         sgs[num_out++] = &key_sg;
>
> -       sg_init_one(&inhdr_sg, &vcrypto->input, sizeof(vcrypto->input));
> +       sg_init_one(&inhdr_sg, input, sizeof(*input));
>         sgs[num_out + num_in++] = &inhdr_sg;
>
>         err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
> @@ -134,12 +138,12 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
>                !virtqueue_is_broken(vcrypto->ctrl_vq))
>                 cpu_relax();
>
> -       if (le32_to_cpu(vcrypto->input.status) != VIRTIO_CRYPTO_OK) {
> +       if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
>                 err = -EINVAL;
>                 goto out;
>         }
>
> -       ctx->session_id = le64_to_cpu(vcrypto->input.session_id);
> +       ctx->session_id = le64_to_cpu(input->session_id);
>         ctx->session_valid = true;
>         err = 0;
>
> @@ -149,7 +153,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
>
>         if (err < 0)
>                 pr_err("virtio_crypto: Create session failed status: %u\n",
> -                       le32_to_cpu(vcrypto->input.status));
> +                       le32_to_cpu(input->status));
>
>         return err;
>  }
> @@ -161,23 +165,27 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
>         struct virtio_crypto *vcrypto = ctx->vcrypto;
>         unsigned int num_out = 0, num_in = 0, inlen;
>         int err;
> +       struct virtio_crypto_op_ctrl_req *ctrl;
> +       struct virtio_crypto_inhdr *ctrl_status;
>
>         spin_lock(&vcrypto->ctrl_lock);
>         if (!ctx->session_valid) {
>                 err = 0;
>                 goto out;
>         }
> -       vcrypto->ctrl_status.status = VIRTIO_CRYPTO_ERR;
> -       vcrypto->ctrl.header.opcode = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION);
> -       vcrypto->ctrl.header.queue_id = 0;
> +       ctrl_status = &vcrypto->ctrl_status;
> +       ctrl_status->status = VIRTIO_CRYPTO_ERR;
> +       ctrl = &vcrypto->ctrl;
> +       ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION);
> +       ctrl->header.queue_id = 0;
>
> -       destroy_session = &vcrypto->ctrl.u.destroy_session;
> +       destroy_session = &ctrl->u.destroy_session;
>         destroy_session->session_id = cpu_to_le64(ctx->session_id);
>
> -       sg_init_one(&outhdr_sg, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
> +       sg_init_one(&outhdr_sg, ctrl, sizeof(*ctrl));
>         sgs[num_out++] = &outhdr_sg;
>
> -       sg_init_one(&inhdr_sg, &vcrypto->ctrl_status.status, sizeof(vcrypto->ctrl_status.status));
> +       sg_init_one(&inhdr_sg, &ctrl_status->status, sizeof(ctrl_status->status));
>         sgs[num_out + num_in++] = &inhdr_sg;
>
>         err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
> @@ -189,7 +197,7 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
>                !virtqueue_is_broken(vcrypto->ctrl_vq))
>                 cpu_relax();
>
> -       if (vcrypto->ctrl_status.status != VIRTIO_CRYPTO_OK) {
> +       if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
>                 err = -EINVAL;
>                 goto out;
>         }
> @@ -201,7 +209,7 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
>         spin_unlock(&vcrypto->ctrl_lock);
>         if (err < 0) {
>                 pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
> -                       vcrypto->ctrl_status.status, destroy_session->session_id);
> +                       ctrl_status->status, destroy_session->session_id);
>         }
>
>         return err;
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index a618c46a52b8..e3c5bc8d6112 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -123,6 +123,9 @@ static int virtio_crypto_alg_skcipher_init_session(
>         int op = encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT : VIRTIO_CRYPTO_OP_DECRYPT;
>         int err;
>         unsigned int num_out = 0, num_in = 0;
> +       struct virtio_crypto_op_ctrl_req *ctrl;
> +       struct virtio_crypto_session_input *input;
> +       struct virtio_crypto_sym_create_session_req *sym_create_session;
>
>         /*
>          * Avoid to do DMA from the stack, switch to using
> @@ -135,24 +138,22 @@ static int virtio_crypto_alg_skcipher_init_session(
>
>         spin_lock(&vcrypto->ctrl_lock);
>         /* Pad ctrl header */
> -       vcrypto->ctrl.header.opcode =
> -               cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
> -       vcrypto->ctrl.header.algo = cpu_to_le32(alg);
> +       ctrl = &vcrypto->ctrl;
> +       ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
> +       ctrl->header.algo = cpu_to_le32(alg);
>         /* Set the default dataqueue id to 0 */
> -       vcrypto->ctrl.header.queue_id = 0;
> +       ctrl->header.queue_id = 0;
>
> -       vcrypto->input.status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
> +       input = &vcrypto->input;
> +       input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
>         /* Pad cipher's parameters */
> -       vcrypto->ctrl.u.sym_create_session.op_type =
> -               cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
> -       vcrypto->ctrl.u.sym_create_session.u.cipher.para.algo =
> -               vcrypto->ctrl.header.algo;
> -       vcrypto->ctrl.u.sym_create_session.u.cipher.para.keylen =
> -               cpu_to_le32(keylen);
> -       vcrypto->ctrl.u.sym_create_session.u.cipher.para.op =
> -               cpu_to_le32(op);
> -
> -       sg_init_one(&outhdr, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
> +       sym_create_session = &ctrl->u.sym_create_session;
> +       sym_create_session->op_type = cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
> +       sym_create_session->u.cipher.para.algo = ctrl->header.algo;
> +       sym_create_session->u.cipher.para.keylen = cpu_to_le32(keylen);
> +       sym_create_session->u.cipher.para.op = cpu_to_le32(op);
> +
> +       sg_init_one(&outhdr, ctrl, sizeof(*ctrl));
>         sgs[num_out++] = &outhdr;
>
>         /* Set key */
> @@ -160,7 +161,7 @@ static int virtio_crypto_alg_skcipher_init_session(
>         sgs[num_out++] = &key_sg;
>
>         /* Return status and session id back */
> -       sg_init_one(&inhdr, &vcrypto->input, sizeof(vcrypto->input));
> +       sg_init_one(&inhdr, input, sizeof(*input));
>         sgs[num_out + num_in++] = &inhdr;
>
>         err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
> @@ -180,20 +181,18 @@ static int virtio_crypto_alg_skcipher_init_session(
>                !virtqueue_is_broken(vcrypto->ctrl_vq))
>                 cpu_relax();
>
> -       if (le32_to_cpu(vcrypto->input.status) != VIRTIO_CRYPTO_OK) {
> +       if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
>                 spin_unlock(&vcrypto->ctrl_lock);
>                 pr_err("virtio_crypto: Create session failed status: %u\n",
> -                       le32_to_cpu(vcrypto->input.status));
> +                       le32_to_cpu(input->status));
>                 kfree_sensitive(cipher_key);
>                 return -EINVAL;
>         }
>
>         if (encrypt)
> -               ctx->enc_sess_info.session_id =
> -                       le64_to_cpu(vcrypto->input.session_id);
> +               ctx->enc_sess_info.session_id = le64_to_cpu(input->session_id);
>         else
> -               ctx->dec_sess_info.session_id =
> -                       le64_to_cpu(vcrypto->input.session_id);
> +               ctx->dec_sess_info.session_id = le64_to_cpu(input->session_id);
>
>         spin_unlock(&vcrypto->ctrl_lock);
>
> @@ -211,30 +210,30 @@ static int virtio_crypto_alg_skcipher_close_session(
>         struct virtio_crypto *vcrypto = ctx->vcrypto;
>         int err;
>         unsigned int num_out = 0, num_in = 0;
> +       struct virtio_crypto_op_ctrl_req *ctrl;
> +       struct virtio_crypto_inhdr *ctrl_status;
>
>         spin_lock(&vcrypto->ctrl_lock);
> -       vcrypto->ctrl_status.status = VIRTIO_CRYPTO_ERR;
> +       ctrl_status = &vcrypto->ctrl_status;
> +       ctrl_status->status = VIRTIO_CRYPTO_ERR;
>         /* Pad ctrl header */
> -       vcrypto->ctrl.header.opcode =
> -               cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION);
> +       ctrl = &vcrypto->ctrl;
> +       ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION);
>         /* Set the default virtqueue id to 0 */
> -       vcrypto->ctrl.header.queue_id = 0;
> +       ctrl->header.queue_id = 0;
>
> -       destroy_session = &vcrypto->ctrl.u.destroy_session;
> +       destroy_session = &ctrl->u.destroy_session;
>
>         if (encrypt)
> -               destroy_session->session_id =
> -                       cpu_to_le64(ctx->enc_sess_info.session_id);
> +               destroy_session->session_id = cpu_to_le64(ctx->enc_sess_info.session_id);
>         else
> -               destroy_session->session_id =
> -                       cpu_to_le64(ctx->dec_sess_info.session_id);
> +               destroy_session->session_id = cpu_to_le64(ctx->dec_sess_info.session_id);
>
> -       sg_init_one(&outhdr, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
> +       sg_init_one(&outhdr, ctrl, sizeof(*ctrl));
>         sgs[num_out++] = &outhdr;
>
>         /* Return status and session id back */
> -       sg_init_one(&status_sg, &vcrypto->ctrl_status.status,
> -               sizeof(vcrypto->ctrl_status.status));
> +       sg_init_one(&status_sg, &ctrl_status->status, sizeof(ctrl_status->status));
>         sgs[num_out + num_in++] = &status_sg;
>
>         err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
> @@ -249,11 +248,10 @@ static int virtio_crypto_alg_skcipher_close_session(
>                !virtqueue_is_broken(vcrypto->ctrl_vq))
>                 cpu_relax();
>
> -       if (vcrypto->ctrl_status.status != VIRTIO_CRYPTO_OK) {
> +       if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
>                 spin_unlock(&vcrypto->ctrl_lock);
>                 pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
> -                       vcrypto->ctrl_status.status,
> -                       destroy_session->session_id);
> +                       ctrl_status->status, destroy_session->session_id);
>
>                 return -EINVAL;
>         }
> --
> 2.20.1
>

