Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CE6C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 10:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiCVKC0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 06:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiCVKCZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 06:02:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD4E7522B;
        Tue, 22 Mar 2022 03:00:58 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h16so9588537wmd.0;
        Tue, 22 Mar 2022 03:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=vv65An+/8FCaKhiLwRvwgZsqnuTpBsIUWxuVuK2VbD8=;
        b=AawhzADKmRd2EZUcWfAotrNv4BD4tjVV7cX0YgNPqx7VxFIa5Gkfwj2rZrgswpb8bh
         O8PHDWTLdtf8xSZFgnsbIGCyqjUKtSxQi+kv4OnyrR5bOrKOtT4d3zNQBXBF2slsXF5M
         byNuLFzFWF8fXMj00rjpgpwfqQDViW3pqYMmeafZaHSmMahARgaOecyKppqnerck/XxK
         i+FlGud9OYp/qj6+7CLQYYv7Ivxv1ZdDTBxYGvaS2e3U2hNwDmRntmDS8ACFoHXtLB5b
         go/4K2MqNc8XSaHsHY1ur8WUsEb1zoGJDlrQuKv2iErQLDjRCIwVX7cayjH1gu8j8c8s
         ZvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vv65An+/8FCaKhiLwRvwgZsqnuTpBsIUWxuVuK2VbD8=;
        b=5nh83CGc982lNU4HkxxXccQMVc4114z1JvyjlkvIqcSpQMV5JdnCLi7LMnKpfFuplg
         TLO9XSjIXEf5tsoUQBWo3NcBKeeR5OsHclVJoA5qE4nN+n6nzRB8/cl9OL1JrQjjyAPE
         Gc5Bor//kBCaBwMMbYaoWnixsGTznq4rGJ2gickMJ0gbReWvaoo180jzFcGCezmY40nB
         jijvKcEAtxVFFshSk3/6VFCcies+jLBVg026S/0mGVvLXnegdqpTSlrix9254alaMlpl
         bLx0jRBIqzmZmJgpAwSy5k3dykqP3+QdT6X50nKfDvSylY6WxyscFoUIHGcL9crL1t3l
         d43w==
X-Gm-Message-State: AOAM533+MbqHQQNxUDqFUe2/vTaNajO9KNpqxNdrjINQ6Av8Lf4jDCJz
        BwLGYuM61QT+Ze1uAc4ebIc=
X-Google-Smtp-Source: ABdhPJzJ3q75PtMwrEHjracDCTSz0PLPTsKFJlK0bJ/mKJiAvFxe247QOYCgyJ/JPmeFZjsIZh87rw==
X-Received: by 2002:a5d:59a3:0:b0:203:d9fa:6968 with SMTP id p3-20020a5d59a3000000b00203d9fa6968mr22225332wrr.585.1647943256641;
        Tue, 22 Mar 2022 03:00:56 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id 14-20020a056000154e00b00203f8adde0csm12161019wry.32.2022.03.22.03.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 03:00:56 -0700 (PDT)
Date:   Tue, 22 Mar 2022 11:00:54 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, kbusch@kernel.org, axboe@kernel.dk
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: crypto: crc64-rocksoft-generic test failed (wrong result) on test
 vector 0
Message-ID: <YjmeVttXDd/FPwUP@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

Booting an arm64_defconfig with BigEndian lead to:
alg: shash: crc64-rocksoft-generic test failed (wrong result) on test vector 0, cfg=\"init+update+final aligned buffer\"

Reproductible on the virt qemu machine.

Furthermore, none of crc64 files have clear MAINTAINERS entry.

Regards
