Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E1AC433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Mar 2022 14:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiCMOxj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Mar 2022 10:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiCMOxi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Mar 2022 10:53:38 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B353989CD5
        for <linux-crypto@vger.kernel.org>; Sun, 13 Mar 2022 07:52:30 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id g26so26104469ybj.10
        for <linux-crypto@vger.kernel.org>; Sun, 13 Mar 2022 07:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lduXrnkF4K9zyGc1RLVWB0WnN6+qmXS3MBXJcwH+LO8=;
        b=bguZj7vUz40UXa0VAZtwXmAgNs/TSPKxJaRnkeGbtGYcLRqnXeQJ5mNefRhkRRE8EZ
         voGsDX/OzrIZ7coKhsfStmL8eFYgiUhOQvzdwKZj/M2EZ10jLKJEhOVcFB+/yX9JtVXN
         xq84GEERo82iFqA/wUYqaG9vNxP3F6IUl7AjsL6kvcj3M18xHQU1BaKVvtOnZEWCEb58
         XEnLR6HRn+BivsJ83SwaK3t46dZvVUXZSxTJ6TqMnJYxhuvRFRqjwL2Rg8k7HY5Ocqxd
         iElgfQnXXCd0FwVkP62MkVWqJ9rRt4xdBHa2fCWLzRcYYtoTJ3VDiYGI/a1510KB5qTH
         WT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lduXrnkF4K9zyGc1RLVWB0WnN6+qmXS3MBXJcwH+LO8=;
        b=tFI/UICCnq5HG7zWs4GR46NcAxQE2yHfvoCP1l0dLOOh8JDr3wA/LXwPSU4JROw+uk
         xhbqEeCEtlgBJGQGgJx6w5kiM47Cak2EWZ88p8YlODoX4F0mCuLDuEHJRUDtwSVW3fmM
         Y1jlUk3+y7Cur5DkFb9RLMqpox24Dr/rJFyFpogA7xzyMckieCEtTyPnhsXf+FpMUi4t
         57l3qfvFuWOkbCf6YXLBKltSTgY+yDeBg0/9gzGc+E64Sq1SmYPWnWUXjzhUyLmfu48A
         ZpW5/uPzabMtB8QwPkciY+yMOadIGnXX6Rk9OOcgQj5T0xHS3rLzTvKbTG7VsooO2ISp
         fwyQ==
X-Gm-Message-State: AOAM531qcMaH0YAPkDHZea3xq8kh48H5fBYhqGM46yuVAb2RsxEHZjTU
        89ZtjpV1l5os/k0Gm0nqA2LkGWmizJOPLhcBaJH7aQ==
X-Google-Smtp-Source: ABdhPJxDrm3r88J9xcwXrTqXOIueR+AolY3TjsyymxjQiW+qJgp1E/hSM4poIiMA07epL9yv7UOSR9iNUaTBHbnXm5M=
X-Received: by 2002:a25:7804:0:b0:628:ec4c:989b with SMTP id
 t4-20020a257804000000b00628ec4c989bmr13960359ybc.428.1647183149860; Sun, 13
 Mar 2022 07:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220311081909.1661934-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20220311081909.1661934-1-yoshihiro.shimoda.uh@renesas.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 13 Mar 2022 16:52:20 +0200
Message-ID: <CAOtvUMc67nT_hVJ8C5pnAQfSGSGtae79OJtadgD8wZC3dcNRLA@mail.gmail.com>
Subject: Re: [RFC/PATCH] crypto: ccree - fix a race of enqueue_seq() in send_request_init()
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Dung Nguyen <dung.nguyen.zy@renesas.com>,
        cristian.marussi@arm.com, Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Mar 11, 2022 at 10:19 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
>
> From: Dung Nguyen <dung.nguyen.zy@renesas.com>
>
> When loading ccree.ko, after registering cipher algorithm at
> cc_cipher_alloc() and cc_hash_alloc() -> send_request_init() ->
> enqueue_seq() has called to pushing descriptor into HW.
>
> On other hand, if another thread have called to encrypt/decrypt
> cipher (cc_cipher_encrypt/decrypt) -> cc_send_request() ->
> cc_do_send_request() -> enqueue_seq() while send_request_init()
> is running, the thread also has called to pushing descriptor into HW.
> And then, it's possible to overwrite data.
>
> The cc_do_send_request() locks mgr->hw_lock, but send_request_init()
> doesn't lock mgr->hw_lock before enqueue_seq() is called. So,
> send_request_init() should lock mgr->hw_lock before enqueue_seq() is
> called.
>
> This issue is possible to cause the following way in rare cases:
> - CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dn
> - insmod ccree.ko & insmod tcrypt.ko

Thank you very much Dung and Yoshihiro!

This is a very good catch and an issue we have missed indeed.

>
> Signed-off-by: Dung Nguyen <dung.nguyen.zy@renesas.com>
> [shimoda: revise the subject/description]
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  I believe we should fix this race. But, as I wrote the desciption
>  above, there is in rare cases. So, I marked this patch as RFC.
>
>  drivers/crypto/ccree/cc_request_mgr.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree=
/cc_request_mgr.c
> index 887162df50f9..eef40022258b 100644
> --- a/drivers/crypto/ccree/cc_request_mgr.c
> +++ b/drivers/crypto/ccree/cc_request_mgr.c
> @@ -513,6 +513,7 @@ int send_request_init(struct cc_drvdata *drvdata, str=
uct cc_hw_desc *desc,
>
>         set_queue_last_ind(drvdata, &desc[(len - 1)]);
>
> +       spin_lock_bh(&req_mgr_h->hw_lock);
>         /*
>          * We are about to push command to the HW via the command registe=
rs
>          * that may reference host memory. We need to issue a memory barr=
ier
> @@ -520,6 +521,7 @@ int send_request_init(struct cc_drvdata *drvdata, str=
uct cc_hw_desc *desc,
>          */
>         wmb();
>         enqueue_seq(drvdata, desc, len);
> +       spin_unlock_bh(&req_mgr_h->hw_lock);
>
>         /* Update the free slots in HW queue */
>         req_mgr_h->q_free_slots =3D
> --
> 2.25.1
>

Having said that, adding a lock here is not the best solution. To be
effective, the lock should be taken before the call to
cc_queues_status() and released only after the updating of the free
slots.
However, while doing so will ensure there is no race condition with
regard to writing to the hardware control registers, it does not deal
at all with the case the hardware command FIFO is full due to
encryption/decryption requests.
This is by design, as the whole purpose of a seperate init time only
send_request variant is to avoid these complexities, under the
assumption that all access to the hardware is serialised at init time.

Therefore, a better solution is to switch the order of algo
allocations so that the hash is allocated first, prior to any other
alg that might be using the hardware FIFO and thus guaranteeing
synchronized access and available FIFO space.

Can you please verify that the following patch indeed resolves the
issue for you?

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_dri=
ver.c
index 790fa9058a36..7d1bee86d581 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -529,24 +529,26 @@ static int init_cc_resources(struct
platform_device *plat_dev)
                goto post_req_mgr_err;
        }

-       /* Allocate crypto algs */
-       rc =3D cc_cipher_alloc(new_drvdata);
+       /* hash must be allocated first due to use of send_request_init()
+        * and dependency of AEAD on it
+        */
+       rc =3D cc_hash_alloc(new_drvdata);
        if (rc) {
-               dev_err(dev, "cc_cipher_alloc failed\n");
+               dev_err(dev, "cc_hash_alloc failed\n");
                goto post_buf_mgr_err;
        }

-       /* hash must be allocated before aead since hash exports APIs */
-       rc =3D cc_hash_alloc(new_drvdata);
+       /* Allocate crypto algs */
+       rc =3D cc_cipher_alloc(new_drvdata);
        if (rc) {
-               dev_err(dev, "cc_hash_alloc failed\n");
-               goto post_cipher_err;
+               dev_err(dev, "cc_cipher_alloc failed\n");
+               goto post_hash_err;
        }

        rc =3D cc_aead_alloc(new_drvdata);
        if (rc) {
                dev_err(dev, "cc_aead_alloc failed\n");
-               goto post_hash_err;
+               goto post_cipher_err;
        }

        /* If we got here and FIPS mode is enabled
@@ -558,10 +560,10 @@ static int init_cc_resources(struct
platform_device *plat_dev)
        pm_runtime_put(dev);
        return 0;

-post_hash_err:
-       cc_hash_free(new_drvdata);
 post_cipher_err:
        cc_cipher_free(new_drvdata);
+post_hash_err:
+       cc_hash_free(new_drvdata);
 post_buf_mgr_err:
         cc_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
@@ -593,8 +595,8 @@ static void cleanup_cc_resources(struct
platform_device *plat_dev)
                (struct cc_drvdata *)platform_get_drvdata(plat_dev);


Thanks again!
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
