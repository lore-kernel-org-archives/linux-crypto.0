Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58B7EE6425
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 07:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjIOHVL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 03:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjIOHVK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 03:21:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DCEA1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 00:21:05 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31dcf18f9e2so1686310f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 00:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694762464; x=1695367264; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Yz+a3+Hs1UEV0kLM4A4/qmBfCV6+T8xxpBGh+tYU6M=;
        b=y2ZidhVuZ3RpctyxnI9ShDtlknpuc35utMEaLMHggtv4F0SUHrZ1axr6978LPcv05M
         gHxMSQFcR3Jmv8PqP2yIBOmAWbkdZDGPoU+xFJGsvOO11k+TJqilskgvSW+d0POlothF
         a63fnesxf0hoB6j4Bp+xjrV9y+9j5itIDpeu8OyaEsAuN4ZErhKpuYYqZu7KHCzmmDIx
         55Ll2vmiLWKYqU/7k/1aiFcn5QLDjrtIU5XbU0FpSKsQ8A2thHM374qG5u46GoyPedPp
         6VhHgVJn2QjWpcORN9BovpOLb6IZaxApUryk2L75kH/h3A4NZB2VlqhfqunVAZzYZeIv
         0Qlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694762464; x=1695367264;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Yz+a3+Hs1UEV0kLM4A4/qmBfCV6+T8xxpBGh+tYU6M=;
        b=VWwXSQwolXn7l3NZPANOvwIlqm9H6ny2whPl6RGUh+XtRQuL6Re25zgMrXZwN2YlsT
         hR+cGbd8VPydU37muZadfMFQVi69LdVlVGAjeCHpuUnA6vGo7phhdENeCjLEDK4xMAkl
         1bO/qQzcETKXP6ps9ieloKoeaw/lMyr4CBSayRxfidar3Q63dhlCvJYRHuFsTauvJLFJ
         K6o7acOCcCoWcIkdAQg8o+aXtw2ocXSCqdq/gGtygzMqM6Z50+ZdbvKg1OPLtjdT1bW/
         OOJnR9B53fL6QxF8LtaeEsNGsj/fhpju0DXVEjrF1rx9NjqvJ55jywvfRJZFqdRsVw5F
         +XxA==
X-Gm-Message-State: AOJu0YwPlYJCO+xRwNQSNE9+SaXOAKqIaca0Fv22gI6BUewJ6hLHEkzT
        TuyfONHoA9tZdb21HfgrSYyJyCtQTkcp1TTkDyc=
X-Google-Smtp-Source: AGHT+IG3xeyHmoWhXnZJajvsHWaNZEbohqXPnyuURyz14JTdWdU8mJjcvpKsVBg3kUXVXufRM5BiCg==
X-Received: by 2002:adf:dd8d:0:b0:314:1313:c3d6 with SMTP id x13-20020adfdd8d000000b003141313c3d6mr651755wrl.33.1694762463903;
        Fri, 15 Sep 2023 00:21:03 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r10-20020adfdc8a000000b0031aeca90e1fsm3695239wrj.70.2023.09.15.00.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 00:21:03 -0700 (PDT)
Date:   Fri, 15 Sep 2023 10:21:00 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     tianjia.zhang@linux.alibaba.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] lib/mpi: Extend the MPI library
Message-ID: <800d9813-af24-4b4a-ba0f-45a37515902c@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Tianjia Zhang,

The patch a8ea8bdd9df9: "lib/mpi: Extend the MPI library" from Sep
21, 2020 (linux-next), leads to the following Smatch static checker
warning:

lib/crypto/mpi/mpiutil.c:202 mpi_copy() error: potential null dereference 'b'.  (mpi_alloc returns null)
lib/crypto/mpi/mpiutil.c:224 mpi_alloc_like() error: potential null dereference 'b'.  (mpi_alloc returns null)
lib/crypto/mpi/mpiutil.c:258 mpi_set() error: potential null dereference 'w'.  (<unknown> returns null)
lib/crypto/mpi/mpiutil.c:277 mpi_set_ui() error: potential null dereference 'w'.  (<unknown> returns null)
lib/crypto/mpi/mpiutil.c:289 mpi_alloc_set_ui() error: potential null dereference 'w'.  (mpi_alloc returns null)

lib/crypto/mpi/mpiutil.c
    195 MPI mpi_copy(MPI a)
    196 {
    197         int i;
    198         MPI b;
    199 
    200         if (a) {
    201                 b = mpi_alloc(a->nlimbs);

Allocations can fail.

--> 202                 b->nlimbs = a->nlimbs;
    203                 b->sign = a->sign;
    204                 b->flags = a->flags;
    205                 b->flags &= ~(16|32); /* Reset the immutable and constant flags. */
    206                 for (i = 0; i < b->nlimbs; i++)
    207                         b->d[i] = a->d[i];
    208         } else
    209                 b = NULL;
    210         return b;
    211 }

regards,
dan carpenter
