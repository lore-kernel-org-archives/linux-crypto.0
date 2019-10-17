Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1B8ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C26921835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rKm7YSOK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503405AbfJQTKl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50316 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503396AbfJQTKl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so3686272wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/bMk1MmOJGGPQtbtRGKAUAFBf6gzwzxY0aFl7AK9OOk=;
        b=rKm7YSOK6uv6vM5zZKCkn+XVLYdVQZxyfpGcnTLUK1SeRlUIb24voPhhom/j7U1mnV
         tuiMl2w7YcEgWltoT0XDngTC+khnrhXdXZmxc5IfU3xfXw4uKISJdP3/LJBmGyROizrQ
         nmf7f7Dbm5CUIFqplM9D3xY3ushe2wDrysX7n3wYPVZNZeehoA94IDR/i6O3lgv0ev2a
         iul+5Mx+q7hjcAI52HacWnAxbjXSdSPKYWNYly9Yqm1i4VqH5/zIhLL8EsMD9Tbw32Zb
         kZwQ3ATL8We63hOdtOJKPHYTQakllZBGw/u5Esolk5zqijoCEmkvhrMlqOVqBRteKf5N
         ueMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/bMk1MmOJGGPQtbtRGKAUAFBf6gzwzxY0aFl7AK9OOk=;
        b=TLtFMtuNEHneD0iYUjVRVVwQO/NLH3Jvpf2pty0+EuyMBCLxwqqLkpLb7Sir2zzJL/
         F+1O/U5ZaYyDqcDO4NxKNWofzvRNS3aW2TW3vMLqM4CwCu7b4H81nsZSnwgzH0raDnej
         6vp7U+HXactg/27qR4MScpYEGGqUYS+ORwUvCoo4ckJBl7RNCG3L/svpgavIeDHyZCAJ
         1c1CAx3lBXzw/vmDViNUVE/6qps0Kcxao25fynp/BOY+xN46s3dJRciHxFFVE0r2W5Td
         2JDJjuBnINRN2VzcWPBfP+p74NdnEy6qDWFjaDK64flciIZ4fR+TlKD54ht2kZs2PtfI
         AFTg==
X-Gm-Message-State: APjAAAVlrWeNC/R1Vx7eNEJI71VAc1qVVkMBNUIk+bkDGEoVoo7h5oZX
        mfHND5ch+yUOUYG1vnkHhG0DCZRevBJ/aXbN
X-Google-Smtp-Source: APXvYqzIHiakTACIjnhcoQQUM7tweko9/xdl10d7CYp19FLXgGFIUAwygCda2zWnZHPIpVFv6D22Nw==
X-Received: by 2002:a1c:5587:: with SMTP id j129mr4175379wmb.15.1571339439262;
        Thu, 17 Oct 2019 12:10:39 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:38 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 27/35] crypto: testmgr - implement testing for KPP failures
Date:   Thu, 17 Oct 2019 21:09:24 +0200
Message-Id: <20191017190932.1947-28-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Curve25519 drivers we will be implementing will perform validation
of the inputs, and in order to ensure that these checks work as expected,
we need to be able to test for expected errors. So implement this in the
KPP test routines in the testmgr framework.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.c | 14 ++++++++++----
 crypto/testmgr.h |  2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 767fc5444771..4548559b2f0b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3499,8 +3499,11 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 	/* Compute party A's public key */
 	err = crypto_wait_req(crypto_kpp_generate_public_key(req), &wait);
 	if (err) {
-		pr_err("alg: %s: Party A: generate public key test failed. err %d\n",
-		       alg, err);
+		if (err != vec->gen_pubkey_error)
+			pr_err("alg: %s: Party A: generate public key test failed. err %d (expected %d)\n",
+			       alg, err, vec->gen_pubkey_error);
+		else
+			err = 0;
 		goto free_output;
 	}
 
@@ -3537,8 +3540,11 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 				 crypto_req_done, &wait);
 	err = crypto_wait_req(crypto_kpp_compute_shared_secret(req), &wait);
 	if (err) {
-		pr_err("alg: %s: Party A: compute shared secret test failed. err %d\n",
-		       alg, err);
+		if (err != vec->comp_ss_error)
+			pr_err("alg: %s: Party A: compute shared secret test failed. err %d (expected %d)\n",
+			       alg, err, vec->comp_ss_error);
+		else
+			err = 0;
 		goto free_all;
 	}
 
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index b717afc0926e..c39be00a8125 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -166,6 +166,8 @@ struct kpp_testvec {
 	unsigned short expected_a_public_size;
 	unsigned short expected_ss_size;
 	bool genkey;
+	int gen_pubkey_error;
+	int comp_ss_error;
 };
 
 static const char zeroed_string[48];
-- 
2.20.1

