Return-Path: <SRS0=wTi7=QX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BACC43381
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Feb 2019 13:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4267121924
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Feb 2019 13:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="whdM0tjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfBPNve (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Feb 2019 08:51:34 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53710 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfBPNve (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Feb 2019 08:51:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id d15so12770606wmb.3
        for <linux-crypto@vger.kernel.org>; Sat, 16 Feb 2019 05:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZORToI5nt6PNzFypx/0DHWLVrDRL44b6utu7PDdTvuw=;
        b=whdM0tjclRD1wScJxqOwNYxB99LYPFcBvQ4gFrsnqwlw3WAJSlEp7zHIX8L9EiRUp3
         pAciCkaMh0GlFvPtdfKS9dEvnL2bCpZPfBwlg91Wp5ID8dn3Bvf92KuYSXeF6LmMT0M6
         mJ9s/G9pLVtqgav+KnOgw6hQxxkIL9IB/dB835nuJnc5rVA3F36Ao5qKX6qo88zqvMjM
         CVFXMCbjf3cD13MMPT91N+Z90/QLi1xPY5WVe90c4aNt9NfFqXUuqCS+5R+51x27M7kN
         vWtyqn6yi1ePJyMSae7WEeJNzFcihL9IHYxCdiScW3OWIDO8BBMT31BulfrvhLAObRvU
         NTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZORToI5nt6PNzFypx/0DHWLVrDRL44b6utu7PDdTvuw=;
        b=CRN6qwq3idEWQ8q6Gr5apkxXfR0FH+wKelzc/SlWeK2Eb/FKe5V0xd/NMMP2jgIIb+
         50B/fSqibwYYuD7Yjxj3UIENuzZI1wmWmNTvMqTW1GpSU3LRLDT/EkjTVDek6/oBF8Ml
         dT5canC5wbSYAPuc7feYbW1+TH0s3EVKAvaA6AWE6NpV/nSAFfs7a1geywlfwQtTnsoY
         nvP7iYkjlUqar9FfBMHLC8T3Wzwyol9ZN/aqNovQBXwDhpr6gWZ7Gjh4bYOd3Chr5Q4q
         27xYQNQORhm7hD/Am4i37fhUxIBKjMZ8ckBNLk9ecXj8wgTOuGuBS5jEwbu2tlPqS2Mw
         zozw==
X-Gm-Message-State: AHQUAub9ZZVY+3tNVsFTJblmd+ECPNp6DcjiJpC0w59QLgC3uCMczbDr
        JCfs8OJ1TtwwPePtRgPo8FiZqAYqAQA=
X-Google-Smtp-Source: AHgI3IY1QI40TA/SFs722MYzKKB0uUt7YxmakGQVJNbaZsOmuHEPRtFbqKqxzekR9vjs5U3+71UQdQ==
X-Received: by 2002:a1c:e344:: with SMTP id a65mr1495617wmh.117.1550325092088;
        Sat, 16 Feb 2019 05:51:32 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:8ee:778e:6c2d:d201])
        by smtp.gmail.com with ESMTPSA id z17sm7452339wrs.75.2019.02.16.05.51.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 05:51:30 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] SHA fixes for 32-bit ARM
Date:   Sat, 16 Feb 2019 14:51:24 +0100
Message-Id: <20190216135126.17290-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A couple of fixes for a crash bugs in the scalar SHA code for ARM,
taken from the OpenSSL project. This is triggered by a binutils
change, and so they should probably be tagged for all stable (v4.4+) 

Ard Biesheuvel (2):
  crypto: sha256/arm - fix crash bug in Thumb2 build
  crypto: sha512/arm - fix crash bug in Thumb2 build

 arch/arm/crypto/sha256-armv4.pl       | 3 ++-
 arch/arm/crypto/sha256-core.S_shipped | 3 ++-
 arch/arm/crypto/sha512-armv4.pl       | 3 ++-
 arch/arm/crypto/sha512-core.S_shipped | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.20.1

