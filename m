Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577AFEB64DC
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jul 2023 15:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjGCPVs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jul 2023 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjGCPVr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2023 11:21:47 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C0FD;
        Mon,  3 Jul 2023 08:21:45 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-57722942374so55785377b3.1;
        Mon, 03 Jul 2023 08:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688397705; x=1690989705;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1nlFNiWBGjT79s+TDoJWb+KEl6wO2BXh4mDpz1hVVgI=;
        b=cD0QycFMhoG5IKwO+t0fCr/obn7kNO1vRLruJ/TF6q5RPjPPOoe2z0M5+XJego18zC
         TfV1NUsOHD40U0oePG5zVkXoD7MnR+WVMyjbGnFsIxqZdehGDhJN8sCPrS6jpF2budPY
         8ZqZHl5KhQ8pq4M+C2gUyjNJaVPi/9pjuJM6xHOIXTkQs7R1YmxxMyVygAdlGwYlOpEI
         6nesyOQs31WS+YYrL6i4JqZkstM08//QfIU3PrseYV9TKfgP0BzDVo5XsPEpqd+NYSKz
         ER+xBiIM1Xo3yJN8OoxrPIOf0+/NRKclPndDvC5V2FcGYbztQV93DML2OgbzV4rIexmt
         wodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688397705; x=1690989705;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1nlFNiWBGjT79s+TDoJWb+KEl6wO2BXh4mDpz1hVVgI=;
        b=C4WjBJ3s3C4KIed+VL/B6QhfNGz4ndnAPtMNV4Uj89XDzcIhF9C6RscUkwBzQkdyZs
         EXppOINOYR9LWPHwERa+aQ4Ip749/bxf63K8FrWo8CtD2kM/OfTihWE3rSpmBk39AmOi
         LJFgoK8fVzk51R7H30+XTngTniBK4EWzaSwI8t3sbor/j5QnFYV+QA6Z7b/ZPKB7kPb0
         rQVcCB+sMjdlW37cIkjrj1rffmJNYC0u3/mpQO1TkFCiTZ5UfhQdUEcBo+JwfB2jcq7K
         Vcymnm7vKIvxLYUf+Z7kYYwfuSUr5BacOZOyaDwFBV7EvkHYxEoJfrQmsMJdR3800wX8
         Nduw==
X-Gm-Message-State: ABy/qLZZoaYlIcpM4OAeZOCHvLAfsfrVCqYjwWnvxBq0/Df1etXHnNXH
        LAtnNZxzUctAou+zbzM/cI4c7kqHalWyltFUwuWuxp14acc=
X-Google-Smtp-Source: APBJJlE3cUSMFqsEKEGQdOQOsSRokmJ99kCBJs7x0Wvucr81LXIuVRDDGEbRETCuJYh9y/c/8I93tLIn6A8rqZYLcjQ=
X-Received: by 2002:a25:69c8:0:b0:ba8:6c1f:f5ad with SMTP id
 e191-20020a2569c8000000b00ba86c1ff5admr10660205ybc.29.1688397704856; Mon, 03
 Jul 2023 08:21:44 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Mon, 3 Jul 2023 17:21:34 +0200
Message-ID: <CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com>
Subject: Regression bisected to "crypto: af_alg: Convert af_alg_sendpage() to
 use MSG_SPLICE_PAGES"
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

It seems that the commit:

commit fb800fa4c1f5aee1238267252e88a7837e645c02
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jun 6 14:08:55 2023 +0100

   crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES

...causes a segfault in libkcapi's test suite. A simplified reproducer:

git clone https://github.com/smuellerDD/libkcapi/
cd libkcapi
autoreconf -i
./configure --enable-kcapi-test
make
./bin/kcapi -x 2 -s  -c "gcm(aes)" -i aac774c39e399e7d6371ec1d \
    -k 38bd9eb2cb29cc42ac38d6cdbe116760 \
    -a 5dbb2884f3fe93664613e863c3bd2572855cf808765880ef1fa5787ceef8c793 \
    -t 34a21cc3562f0ba141d73242e5a3b666 \
    -q d127b39d365d16246d2866b2ebabd201

The last command prints the result and then segfaults in a cleanup
free(3) call. Before the mentioned commit it printed the result and
completed successfully. I haven't dug any deeper to figure out the
root cause.

Cheers,
Ondrej
