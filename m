Return-Path: <SRS0=31iC=U5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F07C5B57E
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD58D20665
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QF+fb7tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfF3Quw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jun 2019 12:50:52 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32881 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfF3Quv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jun 2019 12:50:51 -0400
Received: by mail-lf1-f68.google.com with SMTP id y17so7149304lfe.0
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jun 2019 09:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IbJk8yGtVibJ3jA8F/L0xfrbsqoU6XoewNPY2ugJCBA=;
        b=QF+fb7trOvbjVq88KkcG2JWbeyUjCx5AtXyv1/BUbp/DH9VTjzns/hGeZUDLKLibnZ
         1FvFAvbFGGyclYgSZSWg3GI1X223PwJHMXyvS3L6yDylJf9ytZ2kdV19xpCJd6xtFN/i
         Gb+s0752ff+klGixdQDmu3BY5buISnJjUngYVeb2dy6EuSfp+BN8dSp4OVGto3f8buKA
         nk/1JP++zpFsRXBXSskYx6dxKgBltrVugLvk4yobiBB19zZJrvHtgWfYBYuzfKusLMwQ
         u53gO2UOMJjGCFXSJ0wiBYzo5oQ8TY4LZ5L5gwnPeT1uWXbZVXHHxo29AdlSoxNcTb7w
         YHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IbJk8yGtVibJ3jA8F/L0xfrbsqoU6XoewNPY2ugJCBA=;
        b=mHhR1jfMBkqM8R1G4ur/jQn5Q7GniBKPp9fty7MF8HPNFkMlDN6/nyKptTOtchmYhN
         dQPyNR0fwueVrDp1ypZimDe+TpV5YBq4XXcfHwt0Rl3IF4BQu3+xg4WIwxhFmpdbVECz
         An9v6QpJhgPs/CUopYASKrPqjJtKOCdH6Y8Y4EAZH6xos9GWlfuoaAiz0V52katFhA58
         JmlYw1HxPEDZRU0XqIPCvTsRFaN+r37r9TXzesx10PEleb428RADd+wzKjMKoTxU8G2y
         ZYGhoM4dIrsRi0OwZ6jk2G38AhftMDY05ujv4k07gI9JEhK3dMM/pKfhBKu//tmPsLti
         6aXw==
X-Gm-Message-State: APjAAAWS3lhvixWfJJdlHQKutYvaRw4C++71TmDJdoAF8eYDHoosn+7Z
        ZkG/cjBKh/LVWswpFsaGJ6+vWO4AV1TLYg==
X-Google-Smtp-Source: APXvYqw0MPHu81T4weFfjyVPg6OJbH6zgCQU5h04i76ILW9zBAuSGSAPPX9C+05Cnf4+QhbGmer29A==
X-Received: by 2002:a19:ccc6:: with SMTP id c189mr9527080lfg.160.1561913449522;
        Sun, 30 Jun 2019 09:50:49 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id t15sm2097367lff.94.2019.06.30.09.50.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 09:50:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 7/7] crypto: tcrypt - add a speed test for AEGIS128
Date:   Sun, 30 Jun 2019 18:50:31 +0200
Message-Id: <20190630165031.26365-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
References: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/tcrypt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 798253f05203..72dc84e1c647 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2332,6 +2332,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				  0, speed_template_32);
 		break;
 
+	case 221:
+		test_aead_speed("aegis128", ENCRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		test_aead_speed("aegis128", DECRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
-- 
2.17.1

