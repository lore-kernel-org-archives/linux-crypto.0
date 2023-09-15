Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C2EEE6456
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjIOKnR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjIOKnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:43:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560F01AB
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:43:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bf5c314a57so16220715ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694774590; x=1695379390; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dN5Npi/twQ/rZMPsE8ovHM0kv5s6YAp+fw+vX1oJeY=;
        b=WYv6tobQtzl8ahIKCFVdZkGbujLvlhtzgCKyUfI8prI54LQLM0r7wwfbc2mMBtAic7
         0+zSzf/v8mEp5sRJnpo6rkBaH6D87xxDDeStMVpBXesdP8O7EFflTLf1mJGvBP+PkMe8
         NTnwgAkJLwsMqX2wHhL7p0X7KppXaaeTH6qEqy3ry7H2hgRu8h4i8zjkOmpaG5PS+kSp
         /PodgU/TpO6KPSfVS3VoKHc5sxRoLB9ghwl3CX4trQlPmPvEvUARSPV+jqxxjmqvBjYi
         TeeIVlh6J9itEu/wcZOPu/TOnfYCgkRpPJVnsAxiI/s0+QHyfMsNCqxulM/ffmK/bOeU
         m/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694774590; x=1695379390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dN5Npi/twQ/rZMPsE8ovHM0kv5s6YAp+fw+vX1oJeY=;
        b=F6graWrr8r9qzBpN3tI6d7WztdOyg0Q/oPyAiff/5l/nqUbjUHlH9V8XU8LwgDN77I
         jBBZZc1oNwDixGXr7OWRZK0ppWyPIAEJvWE4LPL7ZbgtzSv9Xy7a8L079q3LhlU+YtDD
         ZawZbqSfpr2KOwAG1e5G4fpM0gcbmriXGykIC8iYQXVOsDkZ1HgdHG4Fev9TtPEhb6JE
         viKPWPBiIO/UOBo3g/+BA4J4UzKwiQ9bsX0R9Wfu06PanldQq9IrTpOFARDgLlxQ3tmd
         xISy+KOFLCVVCDD7mSeHRk5L7jYcCa7D6PQgvWCWUHpU7j/4JKW52ZVg3LH9RFjRVFae
         r6FA==
X-Gm-Message-State: AOJu0YxtvAYlhq6O7McRizimgIMF2UP5hVmTHwiF5zpzyc3ANUM4TQV5
        2kyn9SLZ/8lsYJ+AQHkq3fXgMwzVDWzF7g==
X-Google-Smtp-Source: AGHT+IGRlFaTu29W6AAMFDfecftLNyUHJThN6iaRCPXo6rP4IuXZF7nP7qUlxwFbOYhvXJWv8z95BQ==
X-Received: by 2002:a17:903:1107:b0:1c4:3294:74ca with SMTP id n7-20020a170903110700b001c4329474camr1119010plh.17.1694774589653;
        Fri, 15 Sep 2023 03:43:09 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id k3-20020a170902694300b001bba373919bsm3152255plt.261.2023.09.15.03.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:43:09 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Fri, 15 Sep 2023 18:43:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lu Jialin <lujialin4@huawei.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guo Zihua <guozihua@huawei.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] crypto: Fix hungtask for PADATA_RESET
Message-ID: <ZQQ1PYBPm1xqK/hJ@gondor.apana.org.au>
References: <20230904133341.2528440-1-lujialin4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904133341.2528440-1-lujialin4@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 04, 2023 at 01:33:41PM +0000, Lu Jialin wrote:
> We found a hungtask bug in test_aead_vec_cfg as follows:
> 
> INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Call trace:
>  __switch_to+0x98/0xe0
>  __schedule+0x6c4/0xf40
>  schedule+0xd8/0x1b4
>  schedule_timeout+0x474/0x560
>  wait_for_common+0x368/0x4e0
>  wait_for_completion+0x20/0x30
>  wait_for_completion+0x20/0x30
>  test_aead_vec_cfg+0xab4/0xd50
>  test_aead+0x144/0x1f0
>  alg_test_aead+0xd8/0x1e0
>  alg_test+0x634/0x890
>  cryptomgr_test+0x40/0x70
>  kthread+0x1e0/0x220
>  ret_from_fork+0x10/0x18
>  Kernel panic - not syncing: hung_task: blocked tasks
> 
> For padata_do_parallel, when the return err is 0 or -EBUSY, it will call
> wait_for_completion(&wait->completion) in test_aead_vec_cfg. In normal
> case, aead_request_complete() will be called in pcrypt_aead_serial and the
> return err is 0 for padata_do_parallel. But, when pinst->flags is
> PADATA_RESET, the return err is -EBUSY for padata_do_parallel, and it
> won't call aead_request_complete(). Therefore, test_aead_vec_cfg will
> hung at wait_for_completion(&wait->completion), which will cause
> hungtask.
> 
> The problem comes as following:
> (padata_do_parallel)                 |
>     rcu_read_lock_bh();              |
>     err = -EINVAL;                   |   (padata_replace)
>                                      |     pinst->flags |= PADATA_RESET;
>     err = -EBUSY                     |
>     if (pinst->flags & PADATA_RESET) |
>         rcu_read_unlock_bh()         |
>         return err
> 
> In order to resolve the problem, we replace the return err -EBUSY with
> -EAGAIN, which means parallel_data is changing, and the caller should call
> it again.
> 
> v3:
> remove retry and just change the return err.
> v2:
> introduce padata_try_do_parallel() in pcrypt_aead_encrypt and
> pcrypt_aead_decrypt to solve the hungtask.
> 
> Signed-off-by: Lu Jialin <lujialin4@huawei.com>
> Signed-off-by: Guo Zihua <guozihua@huawei.com>
> ---
>  crypto/pcrypt.c | 4 ++++
>  kernel/padata.c | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
