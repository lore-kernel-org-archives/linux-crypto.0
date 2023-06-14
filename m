Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C25BEB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 17:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjFNRrL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 13:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbjFNRqx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 13:46:53 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361C71720
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:52 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f8c5d0b19dso10504975e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686764810; x=1689356810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lzvZItVXWj7Fm3dpt0cy7Q1fFjOE2nErFj2dQ042GeY=;
        b=hmsYpe5ougKzE7tgwwFGqBa1AOzW8K6nhqS+tC9vYUxsKM+47j2X7imD+RxXv1SLF4
         J1LynbR1DYW5St42KMIqbxHKt33vNT9EFHG1h8nJAJZ2EFdZ/ThE7qvdSklbUX6RgeST
         dRODVPz0wMP2thPYEo6iPxpUfwyWyV+GQLNTscXHwPWWKjZvqDZTewq/GiBoCcu4oGgm
         pQM//vXikTp14Vebbl3xOv0zDd1pBZhNW4bxiMaXF/DBhmjbaliwTkPvshHJs8bE9RG+
         YkCTMTmljrWU9t1CKUeOe1a1KUEeBCxlOYIgFUhdyjmmKvD3oMNkuEAdawaVO5KbZdyy
         L/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686764810; x=1689356810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lzvZItVXWj7Fm3dpt0cy7Q1fFjOE2nErFj2dQ042GeY=;
        b=cjjcrHCNa0ws0wexmWlvmZQctEN939MIo9fYIimginp0ftLtuc6qKp+rqEEB0RpSkq
         cxSBCF+3vEaB7JdSeBR6ur5/h6qQ3SQe4xEBkKl1xem/M7e89Axkn3bRqtg0o1ximRPn
         JkkhVtCNB6GRvTvYzyMEEm0Pfs/0l+vYM/QgdvoOJN6j2z9Gfl5EyHrckeiGS+MEBHHE
         GpLasA/x/uX5vF0hd0vfcUup0xBRJM6sEhOq60d48yBsw0+8sa5M5KjxrgcPKWGmCiKM
         lEP42+ADDAVZDQaP6X0LrnIBMIznmEUY8PvgTkUa+JpqnClBu8gY3YAcsP6o6LoQky/e
         sDnA==
X-Gm-Message-State: AC+VfDyHJ8NtXGseeCtUJcbNCCZbpeydih2+aC8Lj3rhzahaqRvIcS0H
        CNHhHjUyW7Au+KHqaAoUfMhi3ac5USmOdOmv5TI=
X-Google-Smtp-Source: ACHHUZ4hja7oRvWwXVXRpEQrYEDib7oARRRdvU+GnBSdcfg64rhKwiAWYejr1P6GOrV9050gfRUVmw==
X-Received: by 2002:a5d:68c4:0:b0:30f:c601:63d9 with SMTP id p4-20020a5d68c4000000b0030fc60163d9mr6644634wrw.65.1686764810661;
        Wed, 14 Jun 2023 10:46:50 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m4-20020a056000180400b0030633152664sm18738740wrh.87.2023.06.14.10.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 10:46:50 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH-next 0/3] crypto: cmac - clone fixes
Date:   Wed, 14 Jun 2023 18:46:40 +0100
Message-Id: <20230614174643.3836590-1-dima@arista.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Make cipher cloning possible in atomic contexts + prevent use-after-free
on the crypto algorithm.
Those seems to be all pitfalls I found while adapting TCP-AO patches to
use crypto clone-tfm and dropping per-CPU requests allocations.

Cc: Bob Gilligan <gilligan@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Francesco Ruggeri <fruggeri05@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org

Thanks,
            Dmitry

Dmitry Safonov (3):
  crypto: api - Remove crypto_init_ops()
  crypto: api - Provide gfp mask for tfm allocation
  crypto: cipher - On clone do crypto_mod_get()

 crypto/algapi.c         |  2 +-
 crypto/api.c            | 20 +++-----------------
 crypto/cipher.c         |  9 +++++++--
 crypto/internal.h       |  2 +-
 include/crypto/algapi.h |  1 -
 5 files changed, 12 insertions(+), 22 deletions(-)


base-commit: b16049b21162bb649cdd8519642a35972b7910fe
-- 
2.40.0

