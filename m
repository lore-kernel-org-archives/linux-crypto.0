Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73ACAC05027
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 16:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjBBQwJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 11:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjBBQwF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 11:52:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC846DFC3
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 08:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675356677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JTzAWBEi5HSO9Co7j9eqLuzQVPsmDG7KdLe0XlcpLzA=;
        b=f3k0aAGVu7/S7COiTfJKlz6B8WVbnO2icXp0gnYhCuvM71V1APN9Qfj9V1LYl0gke8Yf36
        muqTcDQWeY/gOGS/2v0D0VQPwlizWHfPnwF7XGvzBqrlbGzk8l2ATfKyUkZoMHy7tvr2r+
        p/Ti1yYKTKsF2NtNJ1x31CGn704/zbI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-K6cCMn1KMrqr7W21tGCfZA-1; Thu, 02 Feb 2023 11:51:16 -0500
X-MC-Unique: K6cCMn1KMrqr7W21tGCfZA-1
Received: by mail-qk1-f197.google.com with SMTP id a6-20020a05620a102600b00729952b4c73so1634167qkk.6
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 08:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JTzAWBEi5HSO9Co7j9eqLuzQVPsmDG7KdLe0XlcpLzA=;
        b=JwnTU5eXqiyVjetgh7BuY67XHCGn9Xyd1+diWsGhQ92uLRLwqsF7VaXguLa8FD9iA7
         MYGVGeUk3hVXAKu1yh4nNls1cb244qeKiyhfjVswRR+Y9LEvAYuLfeH5OfTu1bGE3erc
         03xOYrUyWnptOZp2w4lwpKAXtTE5dfUpgYlf39XnrLtv1OA8lFe03BPhpnXswlwSZp4i
         5t64SsW5kHl2yjGC2g+DCuNfumSP+ptIoUHpfYRgq2cMCRQtm/9RYapuEERZTVqB3kDa
         kj09bFJPWy6d14k4P+EGNO+i/f6uNaIoRWsvQJ7XbLTrb8jsBRyJKW21xYfEEsbh5g96
         yJOw==
X-Gm-Message-State: AO0yUKU5/W+OsEugA4LLVM46aGh++xqe3oknTinfWrCH1AJjhll6DK5w
        1NOe+1311xc37tYqpkZQmfPV5kOHkrGcTqOATNEdjGy2gQtFcxsJrUP+lNLblzKI3zdoKiqC0Hl
        fz4fVrLqMz7bV3zLxX+HyipcL7WyDqpqnj3iuIfH5
X-Received: by 2002:ac8:5bcb:0:b0:3b8:4aed:5e35 with SMTP id b11-20020ac85bcb000000b003b84aed5e35mr755704qtb.377.1675356675868;
        Thu, 02 Feb 2023 08:51:15 -0800 (PST)
X-Google-Smtp-Source: AK7set9CdlG5MCbspTLzaIYSjOuDOOu9+Li9sUJHoDTil1GB7T0FTEtXJ34q3qGH8hAtfqWNRKuEkLMS14ckMfg0JSQ=
X-Received: by 2002:ac8:5bcb:0:b0:3b8:4aed:5e35 with SMTP id
 b11-20020ac85bcb000000b003b84aed5e35mr755698qtb.377.1675356675572; Thu, 02
 Feb 2023 08:51:15 -0800 (PST)
MIME-Version: 1.0
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Thu, 2 Feb 2023 17:51:04 +0100
Message-ID: <CAMusb+TdiP=RJ_gQ0K8Wx1_6MoNBfb=7QUrvEeJcF3G45Yo-aA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Fiona Trahe <fiona.trahe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

 Hi, Giovanni, all,

On Wed, Feb 1, 2023 at 4:59 PM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> When preparing an AER-CTR request, the driver copies the key provided by
> the user into a data structure that is accessible by the firmware.
> If the target device is QAT GEN4, the key size is rounded up by 16 since
> a rounded up size is expected by the device.
> If the key size is rounded up before the copy, the size used for copying
> the key might be bigger than the size of the region containing the key,
> causing an out-of-bounds read.
>
> Fix by doing the copy first and then update the keylen.
>
> This is to fix the following warning reported by KASAN:
>
>         [  138.150574] BUG: KASAN: global-out-of-bounds in qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
>         [  138.150641] Read of size 32 at addr ffffffff88c402c0 by task cryptomgr_test/2340
>
>         [  138.150651] CPU: 15 PID: 2340 Comm: cryptomgr_test Not tainted 6.2.0-rc1+ #45
>         [  138.150659] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0087.D13.2208261706 08/26/2022
>         [  138.150663] Call Trace:
>         [  138.150668]  <TASK>
>         [  138.150922]  kasan_check_range+0x13a/0x1c0
>         [  138.150931]  memcpy+0x1f/0x60
>         [  138.150940]  qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
>         [  138.151006]  qat_alg_skcipher_init_sessions+0xc1/0x240 [intel_qat]
>         [  138.151073]  crypto_skcipher_setkey+0x82/0x160
>         [  138.151085]  ? prepare_keybuf+0xa2/0xd0
>         [  138.151095]  test_skcipher_vec_cfg+0x2b8/0x800
>
> Fixes: 67916c951689 ("crypto: qat - add AES-CTR support for QAT GEN4 devices")
> Cc: <stable@vger.kernel.org>
> Reported-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index b4b9f0aa59b9..b61ada559158 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -435,8 +435,8 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
>         } else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
>                 ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
>                                              ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
> -               keylen = round_up(keylen, 16);
>                 memcpy(cd->ucs_aes.key, key, keylen);
> +               keylen = round_up(keylen, 16);
>         } else {
>                 memcpy(cd->aes.key, key, keylen);
>         }
> --
> 2.39.1
>

Thanks, the fix seems to be working. It was tested on "Intel(R) Xeon(R)
Platinum 8468H / Sapphire Rapids 4 skt (SPR) XCC-SP, Qual E-3
stepping" machine with 8086:4940 (rev 40) QAT device:

Without the fix:

# dmesg | grep KASAN
[  142.612847] BUG: KASAN: global-out-of-bounds in
qat_alg_skcipher_init_com.isra.0+0x2fe/0x440 [intel_qat]

With the fix:

# dmesg | grep KASAN
<no output>

So,

Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Tested-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

