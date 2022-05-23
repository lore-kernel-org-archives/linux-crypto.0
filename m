Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DA0C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 23 May 2022 09:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiEWJpg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 May 2022 05:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiEWJpc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 May 2022 05:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 150FF30F55
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2022 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653299126;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocPWUnTNxYB1vHWd9G80pd/UKNHwdEAKdqCKI4wtbyY=;
        b=OCRC8u8jpXkau9tOsGiViSBjZMZhr7ZffgSY8LvUkIxAhKQZILzvmBzdN3B8dNXCx+Tety
        5TgSzrEAPDxSRrCNPHnhJRCSWueglOh6hKCAG5QnPsOgCvT/Tp081+Burwg4a2EU4KN39D
        Yi+KzuqIpWIQYEgywaoiKkY3S8kwinY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-c4FBIXseO5adpR3pVgjv5g-1; Mon, 23 May 2022 05:45:23 -0400
X-MC-Unique: c4FBIXseO5adpR3pVgjv5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C38B802A5B;
        Mon, 23 May 2022 09:45:23 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F2E32026D6A;
        Mon, 23 May 2022 09:45:21 +0000 (UTC)
Date:   Mon, 23 May 2022 10:45:19 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v6 7/9] test/crypto: Add test suite for crypto akcipher
Message-ID: <YotXr4K39xsiS//O@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220514005504.1042884-1-pizhenwei@bytedance.com>
 <20220514005504.1042884-8-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220514005504.1042884-8-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 14, 2022 at 08:55:02AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Add unit test and benchmark test for crypto akcipher.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>  tests/bench/benchmark-crypto-akcipher.c | 157 ++++++
>  tests/bench/meson.build                 |   1 +
>  tests/bench/test_akcipher_keys.inc      | 537 ++++++++++++++++++
>  tests/unit/meson.build                  |   1 +
>  tests/unit/test-crypto-akcipher.c       | 711 ++++++++++++++++++++++++
>  5 files changed, 1407 insertions(+)
>  create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>  create mode 100644 tests/bench/test_akcipher_keys.inc
>  create mode 100644 tests/unit/test-crypto-akcipher.c
> 
> diff --git a/tests/bench/benchmark-crypto-akcipher.c b/tests/bench/benchmark-crypto-akcipher.c
> new file mode 100644
> index 0000000000..c6c80c0be1
> --- /dev/null
> +++ b/tests/bench/benchmark-crypto-akcipher.c
> @@ -0,0 +1,157 @@
> +/*
> + * QEMU Crypto akcipher speed benchmark
> + *
> + * Copyright (c) 2022 Bytedance
> + *
> + * Authors:
> + *    lei he <helei.sig11@bytedance.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * (at your option) any later version.  See the COPYING file in the
> + * top-level directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "crypto/init.h"
> +#include "crypto/akcipher.h"
> +#include "standard-headers/linux/virtio_crypto.h"
> +
> +#include "test_akcipher_keys.inc"
> +
> +static bool keep_running;
> +
> +static void alarm_handler(int sig)
> +{
> +    keep_running = false;
> +}
> +
> +static QCryptoAkCipher *create_rsa_akcipher(const uint8_t *priv_key,
> +                                            size_t keylen,
> +                                            QCryptoRSAPaddingAlgorithm padding,
> +                                            QCryptoHashAlgorithm hash)
> +{
> +    QCryptoAkCipherOptions opt;
> +    QCryptoAkCipher *rsa;
> +
> +    opt.alg = QCRYPTO_AKCIPHER_ALG_RSA;
> +    opt.u.rsa.padding_alg = padding;
> +    opt.u.rsa.hash_alg = hash;
> +    rsa = qcrypto_akcipher_new(&opt, QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
> +                               priv_key, keylen, &error_abort);
> +    return rsa;
> +}
> +
> +static void test_rsa_speed(const uint8_t *priv_key, size_t keylen,
> +                           size_t key_size)
> +{
> +#define BYTE 8
> +#define SHA1_DGST_LEN 20
> +#define DURATION_SECONDS 10
> +#define PADDING QCRYPTO_RSA_PADDING_ALG_PKCS1
> +#define HASH QCRYPTO_HASH_ALG_SHA1
> +
> +    g_autoptr(QCryptoAkCipher) rsa =
> +        create_rsa_akcipher(priv_key, keylen, PADDING, HASH);
> +    g_autofree uint8_t *dgst = NULL;
> +    g_autofree uint8_t *signature = NULL;
> +    size_t count;
> +
> +    dgst = g_new0(uint8_t, SHA1_DGST_LEN);
> +    memset(dgst, g_test_rand_int(), SHA1_DGST_LEN);
> +    signature = g_new0(uint8_t, key_size / BYTE);
> +
> +    g_test_message("benchmark rsa%lu (%s-%s) sign in %d seconds", key_size,
> +                   QCryptoRSAPaddingAlgorithm_str(PADDING),
> +                   QCryptoHashAlgorithm_str(HASH),
> +                   DURATION_SECONDS);

Needs to be '%zu' here and several other places in this file for any
parameter which is 'size_t'.

> +    alarm(DURATION_SECONDS);
> +    g_test_timer_start();
> +    for (keep_running = true, count = 0; keep_running; ++count) {
> +        g_assert(qcrypto_akcipher_sign(rsa, dgst, SHA1_DGST_LEN,
> +                                       signature, key_size / BYTE,
> +                                       &error_abort) > 0);
> +    }
> +    g_test_timer_elapsed();
> +    g_test_message("rsa%lu (%s-%s) sign %lu times in %.2f seconds,"
> +                   " %.2f times/sec ",
> +                   key_size,  QCryptoRSAPaddingAlgorithm_str(PADDING),
> +                   QCryptoHashAlgorithm_str(HASH),
> +                   count, g_test_timer_last(),
> +                   (double)count / g_test_timer_last());
> +
> +    g_test_message("benchmark rsa%lu (%s-%s) verify in %d seconds", key_size,
> +                   QCryptoRSAPaddingAlgorithm_str(PADDING),
> +                   QCryptoHashAlgorithm_str(HASH),
> +                   DURATION_SECONDS);
> +    alarm(DURATION_SECONDS);
> +    g_test_timer_start();
> +    for (keep_running = true, count = 0; keep_running; ++count) {
> +        g_assert(qcrypto_akcipher_verify(rsa, signature, key_size / BYTE,
> +                                         dgst, SHA1_DGST_LEN,
> +                                         &error_abort) == 0);
> +    }
> +    g_test_timer_elapsed();
> +    g_test_message("rsa%lu (%s-%s) verify %lu times in %.2f seconds,"
> +                   " %.2f times/sec ",
> +                   key_size, QCryptoRSAPaddingAlgorithm_str(PADDING),
> +                   QCryptoHashAlgorithm_str(HASH),
> +                   count, g_test_timer_last(),
> +                   (double)count / g_test_timer_last());
> +}
> +
> +static void test_rsa_1024_speed(const void *opaque)
> +{
> +    size_t key_size = (size_t)opaque;
> +    test_rsa_speed(rsa1024_priv_key, sizeof(rsa1024_priv_key), key_size);
> +}
> +
> +static void test_rsa_2048_speed(const void *opaque)
> +{
> +    size_t key_size = (size_t)opaque;
> +    test_rsa_speed(rsa2048_priv_key, sizeof(rsa2048_priv_key), key_size);
> +}
> +
> +static void test_rsa_4096_speed(const void *opaque)
> +{
> +    size_t key_size = (size_t)opaque;
> +    test_rsa_speed(rsa4096_priv_key, sizeof(rsa4096_priv_key), key_size);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +    char *alg = NULL;
> +    char *size = NULL;
> +    g_test_init(&argc, &argv, NULL);
> +    g_assert(qcrypto_init(NULL) == 0);
> +    struct sigaction new_action, old_action;
> +
> +    new_action.sa_handler = alarm_handler;
> +
> +    /* Set up the structure to specify the new action. */
> +    sigemptyset(&new_action.sa_mask);
> +    new_action.sa_flags = 0;
> +    sigaction(SIGALRM, NULL, &old_action);
> +    g_assert(old_action.sa_handler != SIG_IGN);
> +    sigaction(SIGALRM, &new_action, NULL);

sigaction doesn't exist on Windows so this fails to compile.
I'd suggest processing a constant amount of data, as the other
benchmark programs do, rather than trying to run for a constant
amount of time.

> +
> +#define ADD_TEST(asym_alg, keysize)                    \
> +    if ((!alg || g_str_equal(alg, #asym_alg)) &&       \
> +        (!size || g_str_equal(size, #keysize)))        \
> +        g_test_add_data_func(                          \
> +        "/crypto/akcipher/" #asym_alg "-" #keysize,    \
> +        (void *)keysize,                               \
> +        test_ ## asym_alg ## _ ## keysize ## _speed)
> +
> +    if (argc >= 2) {
> +        alg = argv[1];
> +    }
> +    if (argc >= 3) {
> +        size = argv[2];
> +    }
> +
> +    ADD_TEST(rsa, 1024);
> +    ADD_TEST(rsa, 2048);
> +    ADD_TEST(rsa, 4096);
> +
> +    return g_test_run();
> +}


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

