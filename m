Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CC9E9370C
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Oct 2023 13:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjJENyR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Oct 2023 09:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbjJENsE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2023 09:48:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037EB25727
        for <linux-crypto@vger.kernel.org>; Thu,  5 Oct 2023 04:55:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3231d6504e1so849883f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Oct 2023 04:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696506916; x=1697111716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwO6Ki+5EpybdSIGbdkuxTHSu7uLfu1Vp4xVkRO0nX8=;
        b=xxr/5SMDtw4SxP3bh5Jg/52g+fiBFWQpsKenqLYIPo7K4xO51jwsYcV5eqpB9ztdH4
         AR3aLeTRlxg2XqbrmevdoghFNYfppAr6DskcT5x3cO2SSeM/j4rZmDMDotEmqAgiO6FW
         3+VdG2NNPVcPRzT58QuL3lghwEAI0dH9Oq126nfvtOGh6pDhlnKXaaOpMPbawLWUlPex
         sBfZRW3pAJQ23QrnkyBJnzpzW0W+45iey7pYPWBpc7GClUxDdaj+dz8A3AeU9JTJUKvc
         lkBzLOA8dyGqvSKWVlubzBqmiv//0+p/lgLMcSFRITEgEjAsM2QnQAgeW1TfWG5iq7RB
         4g+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696506916; x=1697111716;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DwO6Ki+5EpybdSIGbdkuxTHSu7uLfu1Vp4xVkRO0nX8=;
        b=ShBoQ77mbe5NaD+QBptPJ0kCwRtmaEmRuV0k2z10EQt0NIzwWFdDsRDNhNuC9ZOmuG
         jtfVVmwzsDEJZFDOIZJiLzaNM7VXiVNmM0DFmusLgbea6xXuHlH/nnNm2573U4qXyqo0
         BUDMAmMYn2VNiZK7l0/TFKQjFm4JyrKq2VZnGXgBLccjdE7rriI3/IM0h8Z2SdmY/0wz
         zdelv3J9D7kUfrF1maabcRTl8JfR/R2Wg4O02zcaAu/8IBU2xhh1ZC35QLGnJrNpPAMZ
         mVKchC68CPzYIpWDvJUDYg0Y1E8YEGfaZoG5DrrsMPQERMbsS1fmdbYJEuYK1zpwBgXd
         zjRw==
X-Gm-Message-State: AOJu0Ywa7ME3lM8aVl0zAzgNE+mhY8x7oXcpb6F02JsQ4GLcAMnS0noY
        cP4vaGHBf5zcCakkm98Miab7OnygwbeB+W4Gmno=
X-Google-Smtp-Source: AGHT+IE6gikIk7V7xjRWnBzcsbAAOyul6lA7rACnTXDyQtKqBijrIo6HND/+JmQ3DZeeRxt4XtPNZQ==
X-Received: by 2002:a5d:5502:0:b0:317:5182:7b55 with SMTP id b2-20020a5d5502000000b0031751827b55mr4482480wrv.42.1696506916209;
        Thu, 05 Oct 2023 04:55:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o17-20020a5d6851000000b0031fe0576460sm1639989wrw.11.2023.10.05.04.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 04:55:15 -0700 (PDT)
Date:   Thu, 5 Oct 2023 14:55:11 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     smueller@chronox.de
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: jitter - add RCT/APT support for different OSRs
Message-ID: <9a6fbd96-53a3-48d4-978d-b21510f655a8@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Stephan Müller,

The patch 04597c8dd6c4: "crypto: jitter - add RCT/APT support for
different OSRs" from Sep 21, 2023 (linux-next), leads to the
following Smatch static checker warning:

	crypto/jitterentropy.c:615 jent_read_entropy()
	warn: sleeping in atomic context

crypto/jitterentropy.c
    601                 if (jent_permanent_health_failure(ec)) {
    602                         /*
    603                          * At this point, the Jitter RNG instance is considered
    604                          * as a failed instance. There is no rerun of the
    605                          * startup test any more, because the caller
    606                          * is assumed to not further use this instance.
    607                          */
    608                         return -3;
    609                 } else if (jent_health_failure(ec)) {
    610                         /*
    611                          * Perform startup health tests and return permanent
    612                          * error if it fails.
    613                          */
    614                         if (jent_entropy_init(ec->osr, ec->flags,
--> 615                                               ec->hash_state))

jent_entropy_init() does a sleeping allocation.  The caller,
jent_kcapi_random(), is holding spin_lock(&rng->jent_lock); and so
we're not allowed to sleep.

    616                                 return -3;
    617 
    618                         return -2;
    619                 }
    620 
    621                 if ((DATA_SIZE_BITS / 8) < len)
    622                         tocopy = (DATA_SIZE_BITS / 8);
    623                 else
    624                         tocopy = len;
    625                 if (jent_read_random_block(ec->hash_state, p, tocopy))
    626                         return -1;
    627 
    628                 len -= tocopy;
    629                 p += tocopy;
    630         }
    631 
    632         return 0;
    633 }

regards,
dan carpenter
