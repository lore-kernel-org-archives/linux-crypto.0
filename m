Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78D4C48BE9
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B162089F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GuNoLYkQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfFXHih (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:38:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42301 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfFXHih (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:38:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so12691657wrl.9
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aJ2frxtItoOdASfDgurNaEGo6zzAMYWog88kS6QDgiQ=;
        b=GuNoLYkQKEU73mu3/7iHpGXtDE+J0Nd0TNcCdU6ENNEMDknqTRlPJkhNiJtN6X8LOk
         UJaYxKKUmwWaaGE0+q4Hy1X4+x28ia8GCF14Fnv5YTOeitJncZab/Lg/AO5KIXUYuw7K
         xQ+JwqjXBnXhPv/L0Ewmc+JpHT/UxLuXuhn4EQdVS2Eyp/TyZWyzvfVrlcd1FM/xKvpd
         SJH/lmMK6E2ngO5gcfqOOlKMOEBQv0Z8KIQyF1IUfGs2ianTBsljWsydcgGn8PDE0ijk
         woY+ekqMzRGdtoFlBhhF6BktgLzmeBS93UsYTqkN7OFvOB3DMv9fdWmUAQjFfQCMFU0h
         g22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aJ2frxtItoOdASfDgurNaEGo6zzAMYWog88kS6QDgiQ=;
        b=YiX6etqFXo5OW7nM8sm028aDN3kwRpSdEVKDpikWmy6bAvqQQq75hZmc7O/1QUEFr7
         luEYsMEd3g4dLhEb3hQLelJuVY77qpeazqW187vH6DKQsMIktS68tTkyosdVsMfHajbB
         9HvIIVM3OoycDkEkXltAeCwb7KR098KpBp7yVQ+unLgjJCdGSGMN0QyjjIMszDeCo6sU
         JAdVtN9BnNQT1JYdB0KHeANCXy4/eXGSJqBcmcaB/MmAXQshxHOsbw6zkF3C+8b9n2dq
         b5GzA7Nbm6M9J1HugdYawpo3ENMnwC06e+LWuyJjdtqFVXNBLkZdkGwEQ+vNceBit+un
         IpnA==
X-Gm-Message-State: APjAAAWBuo0MAqQHt3WgYxXgs7aib9Sv8fjgqrnlbLUchLKrOwkyoJ0g
        /NmuuDTiCxgMCGIigyYgZBAiBX4yFy691Q==
X-Google-Smtp-Source: APXvYqwTCNM4G7LjMyIADZGbLdD98jvNvZCoT4STmxytYs5x9ZEd9raiToSMzhIk9cfrM5w9PaqhYA==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr92777173wrp.293.1561361915452;
        Mon, 24 Jun 2019 00:38:35 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id 203sm7419280wmc.30.2019.06.24.00.38.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:38:34 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Subject: [PATCH 6/6] crypto: tcrypt - add a speed test for AEGIS128
Date:   Mon, 24 Jun 2019 09:38:18 +0200
Message-Id: <20190624073818.29296-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/tcrypt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ad78ab5b93cb..c578ccd92c57 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2327,6 +2327,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
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
2.20.1

