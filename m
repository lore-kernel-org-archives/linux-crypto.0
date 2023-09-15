Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7691EE6425
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 07:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjIOHTA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 03:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjIOHS7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 03:18:59 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADABA1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 00:18:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4018af103bcso11966215e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 00:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694762333; x=1695367133; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wTqEOKPFAjUAIZczKpSgF0/qf4MhKz6ZaQTFknczT7Q=;
        b=WAQLMNDWAehF2KckG3OfsrJT/gjMnvJWtaFONDAh2wUnLL0F4nobgqQgl2N2oLUZ3u
         2XQJZhTDqeo0VLBcHScdXDwzyopDJgRgvKOzFizZNUCXNLPas0K0Z6EiiDcABtJiSGMr
         DMYe4l3TeSAWtRSJjxw8mYpO+EVHcN2WdfKnkjpZwUOf3UOD9Yd8XIT5ijt6MQOqtJk7
         7nXlTgrQ5Z13sfWDJMV4QhDdz5Vm+L6fV4U1jj6F8W1BBTf6TcA0jMFsHu7ffd5lQnU7
         11/6dzKf7I+UBiSlIyy75sSgrRYufoO4qOMn+VbmjNckRhfNuAk/r1M1MHVwxoR38zwg
         MEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694762333; x=1695367133;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTqEOKPFAjUAIZczKpSgF0/qf4MhKz6ZaQTFknczT7Q=;
        b=Ly4xaLYLYGwkIimP5N9FgpwIhusURfCy4Xic2PbHaC+b4VkazbNxrFatxX1DCCDs4g
         YVLzOyIg0ew5N3sUdghWH4aITMtkA8PQcBGuQKjPqqjRqaDrVYvhrqX0FCoNiCrQ140m
         HZnE0tsnDfAKSz+FVWDwkD0zPn96+PJL89YxTjAf46GiCPI4RAiMytdvQSuH1W0Q2mnS
         puOxmdo1B/N1BB0Hbp9MysGBfyJaLroLKy3MJQI045zhVIeEOlq5BSopVvhFOpMlaHbN
         Ctb2PFWn4nAyc0x0IxuwnjmRHyf6NGQborEkT/lLQ6slj+IA1S0hWVIzkJ1bucse6mq4
         UKAw==
X-Gm-Message-State: AOJu0YwV1mQUot9zoZorAlq1XagZ6E4zgfoUgeBv8/KB1pTyZY3sZz8p
        o+HJxAvZxhNtoaZg03VNvspifCToStNp6ig6mvU=
X-Google-Smtp-Source: AGHT+IEXlMPKVuUrxHl7PdjbQZSI4Gm3U3C3LRM7ljfc0PyY38aWWVOk7zwb7ChD4HyDX2ADGjb8ig==
X-Received: by 2002:a1c:720c:0:b0:3fe:1fd9:bedf with SMTP id n12-20020a1c720c000000b003fe1fd9bedfmr543945wmc.11.1694762333216;
        Fri, 15 Sep 2023 00:18:53 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 18-20020a05600c235200b003fe61c33df5sm6763511wmq.3.2023.09.15.00.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 00:18:52 -0700 (PDT)
Date:   Fri, 15 Sep 2023 10:18:49 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     tianjia.zhang@linux.alibaba.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] lib/mpi: Extend the MPI library
Message-ID: <da19f62a-7b7c-4d8f-b768-5789f9597bb1@moroto.mountain>
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

	lib/crypto/mpi/mpi-mul.c:75 mpi_mul()
	error: uninitialized symbol 'cy'.

lib/crypto/mpi/mpi-mul.c
    65                         vp = tmp_limb = mpi_alloc_limb_space(vsize);
    66                         /* Copy to the temporary space.  */
    67                         MPN_COPY(vp, wp, vsize);
    68                 }
    69         }
    70 
    71         if (!vsize)
    72                 wsize = 0;
    73         else {
    74                 mpihelp_mul(wp, up, usize, vp, vsize, &cy);

Herbert moved files around so we're re-visiting old warnings today.
The mpihelp_mul() function can fail with -ENOMEM.  Should we check for
that?

--> 75                 wsize -= cy ? 0:1;
    76         }
    77 
    78         if (assign_wp)
    79                 mpi_assign_limb_space(w, wp, wsize);
    80         w->nlimbs = wsize;
    81         w->sign = sign_product;
    82         if (tmp_limb)
    83                 mpi_free_limb_space(tmp_limb);
    84 }

regards,
dan carpenter
