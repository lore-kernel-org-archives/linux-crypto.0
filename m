Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F215C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Nov 2021 09:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E854611AD
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Nov 2021 09:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhKCJuC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Nov 2021 05:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhKCJuB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Nov 2021 05:50:01 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8AEC061714;
        Wed,  3 Nov 2021 02:47:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t30so2580706wra.10;
        Wed, 03 Nov 2021 02:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Owuxu/u/a2bHMDCGZQeGYLoaD+hfbfqkKmW4rV72EDg=;
        b=OHlMo4AEB3El1xuPYSeoUEOZ8QkjsQ/eUYqmmv/EZCjaM+yZQV4XNLGiayYmXQJ7dY
         U0QThqegFN7ujzo5fqAxGE/k/fogrx2nWD1LNZL+RAMrvmeHC/0bHWuSYbtRkMhIjaMa
         QvgD7ra+DMDY0qSLZr4MrQO6/S6YGWKK4TJWjhyxKvqvr56YQ2R1rHTXiVzhvgg/VGri
         gE4nooMYMvUK5LbJJrD96RCVg0gXEgpZaBkHzcCnLdLlHad2/889nZHp6FlmY+59OZde
         BSqOYVJ7o6jnbBctnRO7pFdjQobsu6XaCk07uVuh2FlmFjCrwPbriIlft+rmz2CJY2lV
         +qDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Owuxu/u/a2bHMDCGZQeGYLoaD+hfbfqkKmW4rV72EDg=;
        b=HphlRgUQ5viFhfDvOtNnt2kFjwBOSHG/DDZev5Wa1cL0egGN2DPWhkHMFWCXg+MBcc
         evKRUZEavyB+3P2sebPtZoW45GrCiJgb3QAuCUiZVgokelGKohIrtZZFyujEDeyz7vp0
         dPqZ++VQEaaF8CUKi0R5lHcynAwC2nXZlYR7SrP8P8nORwDTn+0uAxxGa10GkaRsBOaJ
         m5EdCUC1O5/YgNGLdep7M2UFGrnxvlr++FbnqIGGhCPf3JQYSnI+myrAUYgZgfqNNd9Q
         5MSLfNsqaWa3iKEuXM+6Ym3tLQYWi+1Q4Da90Ppfed+jhOD0PT0JwDD7YOLj6VWr1p11
         b/Qg==
X-Gm-Message-State: AOAM532bR27jeKBhiD6fpL6XmLwwIAlwARcDzRWPECeIbHABkqokDOBi
        /O1Hc5nXfYj00uzutRM6YGc=
X-Google-Smtp-Source: ABdhPJw6J4+VCHWxT1GPXHqXpGNOOBk0+iT4tUFqkeGI1hU7hTG0Xt73bJZaS6mBMLuFHyr5y1ED4Q==
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr25960360wrs.81.1635932843964;
        Wed, 03 Nov 2021 02:47:23 -0700 (PDT)
Received: from localhost.elektrobit.com (eth1-fw1-nbg6.eb.noris.de. [213.95.148.172])
        by smtp.gmail.com with ESMTPSA id l7sm1779889wry.86.2021.11.03.02.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 02:47:23 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Declan Murphy <declan.murphy@intel.com>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rectify entry for INTEL KEEM BAY OCS ECC CRYPTO DRIVER
Date:   Wed,  3 Nov 2021 10:47:11 +0100
Message-Id: <20211103094711.8844-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit c9f608c38009 ("crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC
Driver") only adds drivers/crypto/keembay/keembay-ocs-ecc.c, but adds a
file entry drivers/crypto/keembay/ocs-ecc-curve-defs.h in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns warns:

  warning: no file matches  F:  drivers/crypto/keembay/ocs-ecc-curve-defs.h

Assuming that this header is obsolete and will not be included in the
repository, remove the unneeded file entry from MAINTAINERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ba9f6537abc3..1fb254aa12d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9671,7 +9671,6 @@ F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
 F:	drivers/crypto/keembay/Kconfig
 F:	drivers/crypto/keembay/Makefile
 F:	drivers/crypto/keembay/keembay-ocs-ecc.c
-F:	drivers/crypto/keembay/ocs-ecc-curve-defs.h
 
 INTEL KEEM BAY OCS HCU CRYPTO DRIVER
 M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
-- 
2.26.2

