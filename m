Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280DDC3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EAE206C1
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfHPHGH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 03:06:07 -0400
Received: from mail.someserver.de ([31.15.66.35]:54022 "EHLO
        mail.someserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPHGH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 03:06:07 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 03:06:06 EDT
Received: from localhost (87-231-101-12.rev.numericable.fr [87.231.101.12])
        by mail.someserver.de (Postfix) with ESMTPSA id 66533121546;
        Fri, 16 Aug 2019 09:00:20 +0200 (CEST)
From:   Christina Quast <contact@christina-quast.de>
To:     ard.biesheuvel@linaro.org
Cc:     Christina Quast <contact@christina-quast.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Payal Kshirsagar <payal.s.kshirsagar.98@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anushka Shukla <anushkacharu9@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Zach Turner <turnerzdp@gmail.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] Use ccm(aes) aead transform in staging drivers
Date:   Fri, 16 Aug 2019 08:59:34 +0200
Message-Id: <20190816065936.12214-1-contact@christina-quast.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use ccm(aes) aead transform instead of invoking the AES block cipher
block by block.

Christina Quast (2):
  staging: rtl8192u: ieee80211: ieee80211_crypt_ccmp.c: Use crypto API
    ccm(aes)
  staging: rtl8192e: rtllib_crypt_ccmp.c: Use crypto API ccm(aes)

 drivers/staging/rtl8192e/Kconfig              |   1 +
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c  | 187 ++++++++----------
 drivers/staging/rtl8192u/Kconfig              |   2 +
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c | 187 ++++++++----------
 4 files changed, 159 insertions(+), 218 deletions(-)

-- 
2.20.1

