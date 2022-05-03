Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E37C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 May 2022 14:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiECOgk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 May 2022 10:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237091AbiECOgj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 May 2022 10:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 888103134F
        for <linux-crypto@vger.kernel.org>; Tue,  3 May 2022 07:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651588384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=83wy3D5dt5Ummd3Bx/sB0t7+Cs+0z1iy7in3UM+60Qw=;
        b=ZS4k5EZZx8vQCeUNiZqAtX/v6HTgaL/d8sf/ZfR1Y/mt3TaAOdPOpg9X+/zFCp4a81s14v
        Nz6O+FhjEowoZY2pinUn/93RiaTeyFD/wHs0LHLeMZ+wADgO4Z0xZKjNO5VdOmQOgGV6fR
        LhsIpvxQHX1B7iBEoIuNgwWAlMYhxrc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-30D7OOKuM2qn4_jpxjVVlg-1; Tue, 03 May 2022 10:32:38 -0400
X-MC-Unique: 30D7OOKuM2qn4_jpxjVVlg-1
Received: by mail-wm1-f70.google.com with SMTP id n26-20020a1c721a000000b003941ea1ced7so834338wmc.7
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2022 07:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83wy3D5dt5Ummd3Bx/sB0t7+Cs+0z1iy7in3UM+60Qw=;
        b=stdjpaM84ONNwNPa5Qv/ywFq/RXA0zV1g/+YXzSzadOw+7eXRO+uj9xn8tWYJt7PCm
         qn/oRI2aSPQHzeoKGdhaF57uVnhP5ixTLBbxPHDeFbyGK0aMJeI2PB6GZ1zbiIuOXKZK
         jIQDAzcZWHtzEFEUHEf2DSAIdKwhGRMMiUI+hXykQyXcJA/ydGQs+ANGxzPBa7hkDx8c
         5yVH6CP5alvafLeUWZqmg/NvLD7cfxjLt0C34W6XFj1wec8cofb0NCco5OS+BHHo3H1v
         TzMedGWu0PID0bA/snVYhvBHr/UHCmc51ihGh0+/d7iOpL8Lq2nA4iE3PoRaTYlMH2nC
         mpWw==
X-Gm-Message-State: AOAM532yEsuUmkgn1TGMopnxINIid4oJ1hlwuX7R/zRugydDgcZse5/9
        9FKy0G0pCVQdnLcGj4CKeIKQTJ4Fzk2jhIBtuXPIXR3P6/A8DmVS5F+oEDPOcpztYUT+scqU0nN
        CIUaRbJJvyX0mOpny/f1UIezX
X-Received: by 2002:a17:907:1623:b0:6e8:8678:640d with SMTP id hb35-20020a170907162300b006e88678640dmr15141680ejc.189.1651578613927;
        Tue, 03 May 2022 04:50:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgDSCmimGS4eep27PTOqrwdW6NzkICeJYxvlFa/x2oEMAH8qT4xJYqw/QzH9kG9LMxlrJyzA==
X-Received: by 2002:a17:907:1623:b0:6e8:8678:640d with SMTP id hb35-20020a170907162300b006e88678640dmr15141658ejc.189.1651578613740;
        Tue, 03 May 2022 04:50:13 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b106:e300:32b0:6ebb:8ca4:d4d3])
        by smtp.gmail.com with ESMTPSA id m21-20020aa7c2d5000000b0042617ba6395sm7740445edp.31.2022.05.03.04.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 04:50:12 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Masney <bmasney@redhat.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ
Date:   Tue,  3 May 2022 13:50:10 +0200
Message-Id: <20220503115010.1750296-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The commit referenced in the Fixes tag removed the 'break' from the else
branch in qcom_rng_read(), causing an infinite loop whenever 'max' is
not a multiple of WORD_SZ. This can be reproduced e.g. by running:

    kcapi-rng -b 67 >/dev/null

There are many ways to fix this without adding back the 'break', but
they all seem more awkward than simply adding it back, so do just that.

Tested on a machine with Qualcomm Amberwing processor.

Fixes: a680b1832ced ("crypto: qcom-rng - ensure buffer for generate is completely filled")
Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 drivers/crypto/qcom-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 11f30fd48c141..031b5f701a0a3 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -65,6 +65,7 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
 		} else {
 			/* copy only remaining bytes */
 			memcpy(data, &val, max - currsize);
+			break;
 		}
 	} while (currsize < max);
 
-- 
2.35.1

