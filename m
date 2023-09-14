Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F63EDE990
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbjINI2n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbjINI2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818791FC2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:29 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2747b49cac4so124578a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680109; x=1695284909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=vNYD+fBOqLIjCnYaCF24bvaAM7+rA3DL+RIob1Ylwrs=;
        b=Ue9ulvsFcvx0Ss+kGIb/7ncVhJI2alaEOwrBvyP6pIEzuCfyVdKHxsz22nkn8sFnaU
         FtMsjRU+GrKcm2Nx1/dBe40nJi81icbQRpCChx5adUNR4N4PJ4OQXi6Q50zK2wTIENfJ
         MBFKiJRdXwd3HBAbW2ITal0c8LfSY6tCW5lhIh1CiaX5Py/7IvN1yeAEsRR0vJgbJJUn
         D8R4MrSbyADUFH6QclGM+VfCc4nXVUzhUfdUwRhzBvZML5uQW1e9e/p0mLuCdKksWB9x
         eetcuMvxqHWnRUeAyy8oZYKR/B8kvDZWZsuHJ6WH/Yo8v0FdyWGkbYtAGZxOt+8Hap2o
         3pAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680109; x=1695284909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNYD+fBOqLIjCnYaCF24bvaAM7+rA3DL+RIob1Ylwrs=;
        b=NnWV3n+qFfPKcH830k6qIIu5kA/QqUAIQwVJ32utFe983uEvi0fIyxAkSx11k8xe3J
         TBzW09lvovJRtogGgxw8Kl1JXxymFhv5nnjH3x2DT8OMuzqw7h7LZLDF28mmK6IFcX/B
         JnezoL5qRkS9R9nc5Tq2VgKUDk1yDcewC/SP+JfLiJkZuMW08DS2+Ws3O/jXdSZkzSpi
         jfP2jYy3/sAS1G2wWilP80e8piwmBGYJcROX+BMYLuu1hkeBwrwuUozYfVIHessw+hRD
         XOFu/29kjNiqSsFEznO5apFJg9fIhvurDW6ryRtgHWGGdlQ2Z/boT/JQIR7vU0kcpJBK
         q29g==
X-Gm-Message-State: AOJu0Yz80/aHtuhLtzi9BuNjDTgZWM0T7Cjh+0S3Fuq+EJh29psT31Z+
        x2IYmevq00IGyvcWELApkOuXW+MZnHw=
X-Google-Smtp-Source: AGHT+IEtExITCsFWtlUsxFi17bgXOhtn60h513OB7c/7RwFAzCVVu+UaqFuNfG8B9a6d0jWFsQLeGA==
X-Received: by 2002:a17:90a:df15:b0:26d:20b8:445d with SMTP id gp21-20020a17090adf1500b0026d20b8445dmr4463777pjb.9.1694680108723;
        Thu, 14 Sep 2023 01:28:28 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:28 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/8] crypto: Add lskcipher API type
Date:   Thu, 14 Sep 2023 16:28:20 +0800
Message-Id: <20230914082828.895403-1-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series introduces the lskcipher API type.  Its relationship
to skcipher is the same as that between shash and ahash.

This series only converts ecb and cbc to the new algorithm type.
Once all templates have been moved over, we can then convert the
cipher implementations such as aes-generic.

Ard, if you have some spare cycles you can help with either the
templates or the cipher algorithm conversions.  The latter will
be applied once the templates have been completely moved over.

Just let me know which ones you'd like to do so I won't touch
them.

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
