Return-Path: <SRS0=RoO8=UG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F42DC468BC
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 14:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39397208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 14:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yR0habUD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfFGOud (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jun 2019 10:50:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39807 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfFGOud (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jun 2019 10:50:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so2458404wrt.6
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jun 2019 07:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyIPK0uGfVvmF4vYYnPSL82M9o5wEbDTCrjl6r/aHXI=;
        b=yR0habUDsptvaNtxi8t7Zb+xCxIU3fB55eZXPPy/tPwfoLPuXh14x02PlI/YMjVm/f
         Yn8pI2IAfCnWCJRaA9QZajb9cDny131ZDPqebR3CPLTvDFx7+MzJfCGQXnAGqcqQQHt+
         hhBp2mM7KC/fnOzsUvAGiVrjbPgdFfHIzVr71mtRH6ozzZ41klqN798QPbdNsHr0qBcR
         gtaeZixmzDPAOLfFqJ2ck/v7nc952YY4Qj6TCpHmH+updMSr1mSq1P8oCARmh1/QMEtJ
         vipItAXhpO+CRBzZryrIBb1AL16VqEfAc6Qy/+XZbmWtW/i6kbxSVhOzKBzOhsZZXqWV
         pRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyIPK0uGfVvmF4vYYnPSL82M9o5wEbDTCrjl6r/aHXI=;
        b=PjU0cf+B+Q8ohX+0qZFLYD6nps8lbRCdf8ykQQqZo+D3Pl2jNlKQjWeLBiB3u8EUtR
         aXbba/2tGZtCKjzlLKtjPVHFdrGWnaAlSc4PuWVPY9Whb27YHuuo05H6hFMLU/LDqjUB
         zOZLaM2RcXpXlFfbFnQfuqiXgFMoIHNVu4GdHgajg5vpJxYWrvercfiNaOOFrVzm3gMe
         u0kIYpOCpOgedNXyr0kEZCEdfQXCkw70UuNJGM5s0ZDcSwVMzz0HFltqEU4OZg52VZZJ
         hEs92fID/czLTSkA/3EgoIYvCoLFWsNH7vgew3Dfv+1xLOYZO4p/WUQvAqCBxZrUJXoC
         XStA==
X-Gm-Message-State: APjAAAWytVX3MraZfydOuJx7ovN2NnwWO4YLjkobjvq8DQu8lDqNXgav
        M7HOu/ptACffaCaY+aRyBLsRN/uTJMr0Og==
X-Google-Smtp-Source: APXvYqxUBW3msIX4EhYmbwjgUhDr4jBHmDzriq7zWS+2FwJB4snr/s+c6QALwCt62jyT0Pj9Wuh28w==
X-Received: by 2002:adf:b689:: with SMTP id j9mr12793509wre.76.1559919031531;
        Fri, 07 Jun 2019 07:50:31 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-188.w90-88.abo.wanadoo.fr. [90.88.7.188])
        by smtp.gmail.com with ESMTPSA id t13sm4129354wra.81.2019.06.07.07.50.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 07:50:30 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        davem@davemloft.net, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/3] move WEP implementation to skcipher interface
Date:   Fri,  7 Jun 2019 16:49:41 +0200
Message-Id: <20190607144944.13485-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

One of the issues that I would like to see addressed in the crypto API
is they way the cipher abstraction is used. In general, a cipher should
never be used directly, and so it would be much better to clean up the
existing uses of ciphers outside of the crypto subsystem itself, so that
we can make the cipher abstraction part of the internal API, only to
be used by templates or crypto drivers that require them as a callback.

As a first step, this series moves all users of the 'arc4' cipher to
the ecb(arc4) skcipher, which happens to be implemented by the same
driver, and is already a stream cipher, given that ARC4_BLOCK_SIZE
actually evaluates to 1.

Next step would be to switch the users of the 'des' and 'aes' ciphers
to other interfaces that are more appropriate, either ecb(...) or a
library interface, which may be more appropriate in some cases. In any
case, the end result should be that ciphers are no longer used outside
of crypto/ and drivers/crypto/

This series is presented as an RFC, since I am mostly interested in
discussing the above, but I prefer to do so in the context of actual
patches rather than an abstract discussion.

Ard Biesheuvel (3):
  net/mac80211: switch to skcipher interface for arc4
  lib80211/tkip: switch to skcipher interface for arc4
  lib80211/wep: switch to skcipher interface for arc4

 net/mac80211/ieee80211_i.h         |  6 +-
 net/mac80211/key.h                 |  1 +
 net/mac80211/tkip.c                |  8 +-
 net/mac80211/tkip.h                |  4 +-
 net/mac80211/wep.c                 | 81 +++++++++++++++-----
 net/mac80211/wep.h                 |  4 +-
 net/mac80211/wpa.c                 |  4 +-
 net/wireless/lib80211_crypt_tkip.c | 61 ++++++++++-----
 net/wireless/lib80211_crypt_wep.c  | 52 +++++++++----
 9 files changed, 153 insertions(+), 68 deletions(-)

-- 
2.20.1

