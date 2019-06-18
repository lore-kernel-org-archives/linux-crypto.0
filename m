Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88C8C31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE1F206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eUkJi2E1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfFRJcW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:32:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36298 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfFRJcV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:32:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so2437101wmm.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIJtJFYthGUMX8rdgQmg7yAqt6VRngy7cSWmscVewUM=;
        b=eUkJi2E1vjoyNXX3PV3H7C8LZYQJbd3nR64Y5MWfpCwUbeZxpsHB8edKWBz6M9dp7M
         ic8Ujhx0Hu77yCpuw51OZ81spve5EWDVc9SsPnch0rrCbHAXybZlZb+8R2p9SMG+yzFU
         s7KsVCJz6r+c8ly9X334WNq9MTFVCgpFiBrluTQfl9xpdWapX0CQW1y6zmnWYkhGYIRB
         IMKzhWHe/HVJpxUegqx/+JK4Lk1B6f3eQJKsHmpMJnLbkeRxELn/GqitT8l5rW0PsVSz
         WGRXj0xvInRC7SAuNnhWcUY6Xndy2F/VAxQ79dekzHfGy4uqUQlzdbUGnvTJAtOcssUB
         4Cwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIJtJFYthGUMX8rdgQmg7yAqt6VRngy7cSWmscVewUM=;
        b=VbmrieiF+0V6Xbt/HTBTOzrYCvWI0O/VY2gIsascZuyJ+5FN2nd5Za5EAEirVpIgyn
         ASvDkCh+PDO6fjwxXDVZdBOHNtn3sVesgoj23GhIV0uDfAJKkJnv7Tjh9vRRVJNwH0Ux
         0aQgb2TOF6eqs56KzwbEf9gZqJTC162iF4rHMUJReorYF1c3bIImRvE0ZsN8LV3dIMHk
         68fVw3aofc+fpT53Pe+5TZlFXAMqx9R40M7PtUrihGkwjeN94MVSQCVI5jWHSEB4gyRO
         YRANGf90vj9iS/OcPvrbMPsQM0h12Ux+fshm1RQoMaun975P2L/V70Yr3piC75ApFlzt
         cuwQ==
X-Gm-Message-State: APjAAAWbyLoha2nMWhBT6gd6ePgEyooruGvQN+62pAWyWn2NOkddqdn1
        n0fgYUgyTwP0/KcCLyrZJpxBNg==
X-Google-Smtp-Source: APXvYqyjfHsP8G1Dzg+lMlP+QxjKf+wh4Cki/PQLQJ1Gj87vB26caxOwEXAIDwPHPDNVp6UkEBQM0Q==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr2574538wmf.124.1560850339781;
        Tue, 18 Jun 2019 02:32:19 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:c97b:2293:609c:ae03])
        by smtp.gmail.com with ESMTPSA id y1sm1517104wma.32.2019.06.18.02.32.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:32:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH 0/2] net: fastopen: follow-up tweaks for SipHash switch
Date:   Tue, 18 Jun 2019 11:32:05 +0200
Message-Id: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A pair of tweaks for issues spotted by Eric Biggers. Patch #1 is
mostly cosmetic, since the error check it adds is unreachable in
practice, and the other changes are syntactic cleanups. Patch #2
adds endian swabbing of the SipHash output for big endian systems
so that the in-memory representation is the same as on little
endian systems.

cc: Eric Biggers <ebiggers@kernel.org>
cc: linux-crypto@vger.kernel.org
cc: herbert@gondor.apana.org.au
cc: edumazet@google.com
cc: davem@davemloft.net
cc: kuznet@ms2.inr.ac.ru
cc: yoshfuji@linux-ipv6.org
cc: jbaron@akamai.com
cc: cpaasch@apple.com
cc: David.Laight@aculab.com
cc: ycheng@google.com

Ard Biesheuvel (2):
  net: fastopen: make key handling more robust against future changes
  net: fastopen: use endianness agnostic representation of the cookie

 include/linux/tcp.h     |  2 +-
 include/net/tcp.h       |  5 +--
 net/ipv4/tcp_fastopen.c | 34 +++++++++++---------
 3 files changed, 23 insertions(+), 18 deletions(-)

-- 
2.17.1

