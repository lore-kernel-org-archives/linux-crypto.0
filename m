Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76BF0C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 09:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjJ3JDJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjJ3JDI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 05:03:08 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FF0A7
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:03:06 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-507cee17b00so6047454e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698656584; x=1699261384; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SRyapUQYnfbbBHiYxr7bXEhk97MYCElvMWksTuUpiBI=;
        b=wZpWhut9utHVScFz/2KXaGxrA3XNOs9Qf5RZgAX2Rn03OVYaYlNvuUvz/wab1szK+r
         w2PxM9812INZI7RV3kQiuCU9gxYdcIUkxrppT3xvwt4F4FL0mDGWwNvHOliYKeWzQOd9
         NN/9gyTb69pP4Dr58hHrXUCZ3j+GbSxUWwQdWUfmckd2JzTWdQbQtK/tdJB400+ypX6F
         +yPt7dK4IauGe9E43jz1puvLIREpChgIeGlyoTJ1sK4T4Vyi5/w2TNPf5X9fxXcfqOhq
         bFQV9c25kEf71kBsC4QKDQ2WuXXbG4oWtzO4AMeeHYCj0sqgKst652HYXQJ0Wph1Lba0
         YIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698656584; x=1699261384;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRyapUQYnfbbBHiYxr7bXEhk97MYCElvMWksTuUpiBI=;
        b=nJiK4ltBbTWg6uObfzfT8AuiMHeCW3o8mKmq8WVeiiFb725UpJkTVW8hV0C99a33lM
         JCnDggQk8DXe81QfU4pejdDZooG2m8WELQB3qte4rXZ826vMflezj9BTD/bUDVwsa3Qp
         4DMjbbYPGihA0Hsh0QOrt2mW/KwqUPF1t18CpXPEFoVVdRp4cNrF8GDkNyEUqqkNVj4V
         xqsVxE4M2Xkl29pbdiPlNLQmaHP4OtTre+1z1MZ9meS7mDHqTPH7L0V/jmXAUEiDHvOu
         GIzhNTl2jLs3kU/5+SZK0ukkiGDrY8AuFJK2zapA7OU+BIKIQTBoKerkkcykNUE0ypv6
         qDHg==
X-Gm-Message-State: AOJu0YxQ6IU/IVt/n7s/sPRPm7MbcHp6lRtMAhzLCpwKKLB03zq9JkwN
        sQ3o8Qq5QJ1HgviYwusi8/b/zg==
X-Google-Smtp-Source: AGHT+IGE99OWNt/zT9E56xEJH4FurSF3jhY8kWnknrKbKIipicriA4DVeO6VjLRCYnBV4zz2JQX+Fg==
X-Received: by 2002:ac2:43c9:0:b0:508:e4b1:a785 with SMTP id u9-20020ac243c9000000b00508e4b1a785mr4581566lfl.62.1698656583893;
        Mon, 30 Oct 2023 02:03:03 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l12-20020adfe9cc000000b003232380ffd7sm7758694wrn.102.2023.10.30.02.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 02:03:03 -0700 (PDT)
Date:   Mon, 30 Oct 2023 12:02:59 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Mahmoud Adam <mngyadam@amazon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: rsa - add a check for allocation failure
Message-ID: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Static checkers insist that the mpi_alloc() allocation can fail so add
a check to prevent a NULL dereference.  Small allocations like this
can't actually fail in current kernels, but adding a check is very
simple and makes the static checkers happy.

Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 crypto/rsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index c79613cdce6e..b9cd11fb7d36 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -220,6 +220,8 @@ static int rsa_check_exponent_fips(MPI e)
 	}
 
 	e_max = mpi_alloc(0);
+	if (!e_max)
+		return -ENOMEM;
 	mpi_set_bit(e_max, 256);
 
 	if (mpi_cmp(e, e_max) >= 0) {
-- 
2.42.0

