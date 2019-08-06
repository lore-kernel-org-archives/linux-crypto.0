Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0766C433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83D7F2054F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RlE497f7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732045AbfHFICn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 04:02:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39266 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfHFICn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 04:02:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so33716277wrt.6
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 01:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LPxrPr3q5T9XtnaxYFQ5MHNB86Gds1XCyjunFknCBCg=;
        b=RlE497f7kLUSLf4mV597Si4ml7zHS2egprS8akgckGS4RA1YP4GqcmZHvmPQk4Tgm5
         2/pKmkGJlCek74lO5Rd9WHtWeMvI1M7DQtLGH9T+avk/4v4wf6qMZmwcG0FDyFnbFx38
         VzDWvZoYnNYcbKmTfDWOA9b3Oh1/uwmQ3O7Yz6n02JvPj04C/PFG1TULau4EJwIPzUTx
         dJE/FiJqvcV2nwup9SZYXA45CIuLbnp9YMVhTErIKmk5udQ90LKxRf3WBwKTLtS0qrjH
         4pqwrkEgAyPtkuC2OR99Vt+MfTYQpgdwcWoz0a12nxUBU9JN1SCpZfBZl93fOtZoGI9s
         Oq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LPxrPr3q5T9XtnaxYFQ5MHNB86Gds1XCyjunFknCBCg=;
        b=m/g4+C7S0kR4ZPFGYU2ivmN096QfjBXeHT5sR5y3muAqEZAIXj068/eCzXQ4ljjGYA
         4U0Im7Ou5i+pOh9a5xuh0FPeu1IZ9rNX6pERF3U5CP3B7c102BM2nouoHqxOqOWmyjdd
         FO/HBp64KzxMDDYf0Y6HDdq2fdojaMesP8J8k0v2srRI2VSYEc5fvvPiIQGwR+Yjs0op
         rNLyG2ptCrnpIOM4xU6lXtwm3j+KXddaj0oDpKPUnrz5jSYnQLeJQQUYaMSnR5RVSBEi
         n1zkzbrz0pzIwa1yQqHLTU8Ehr29l4J6uZ11WpoHAlR2G5XEP4xgzv6HkH7jWovl6lkX
         souQ==
X-Gm-Message-State: APjAAAW55g0vE6a6wBdXxUColJu1hkIwZF1IHVnosRFGiFvw3Lg6W7Bn
        yQl0BE64qqeemBrvgH5UohGfzy0M53M+cA==
X-Google-Smtp-Source: APXvYqzSjUHqVv3p94bbd0GUC+Orah/QZCx7GT1jK2qKN7lBk5fYqPKu7RuMoW3+YbpduUpR/VMPnw==
X-Received: by 2002:adf:de10:: with SMTP id b16mr2946471wrm.296.1565078561540;
        Tue, 06 Aug 2019 01:02:41 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id g12sm123785475wrv.9.2019.08.06.01.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 01:02:40 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com, gmazyland@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/2] dm-crypt: get rid of cipher API for EBOIV
Date:   Tue,  6 Aug 2019 11:02:32 +0300
Message-Id: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a follow-up to the discussion [0] started by regarding adding
new uses of the cipher API to dm-crypt. In particular, the discussion
was about EBOIV, which is used by BitLocker to generate IVs from byte
offsets, to be used for AES encryption in CBC mode.

The way EBOIV support is currently integrated does not restrict it at
all, which means we may paint ourselves into a corner where we are
forced to support unexpected and novel ways users have decided to
wire up EBOIV. This may become a maintenance burden going forward,
and given that EBOIV uses the same key for generating the IV via
AES encryption as the one used for the data, it may produce configurations
that are not entirely safe.

So let's restrict EBOIV to cbc(aes) (patch #1), to prevent it from
being used in arbitrary cipher cocktails, and avoid ending up with
a disproportionate maintenance burden on the crypto API side.

Patch #2 switches the IV generation to the AES library, which avoids
potential key leaks due to the use of aes-generic as the cipher used
for IV generation.

[0] https://www.redhat.com/archives/dm-devel/2019-July/msg00041.html

Ard Biesheuvel (2):
  md/dm-crypt - restrict EBOIV to cbc(aes)
  md/dm-crypt - switch to AES library for EBOIV

 drivers/md/dm-crypt.c | 34 ++++++++------------
 1 file changed, 13 insertions(+), 21 deletions(-)

-- 
2.17.1

