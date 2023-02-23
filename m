Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91128C64ED6
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 22:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjBWWlz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 17:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBWWly (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 17:41:54 -0500
X-Greylist: delayed 1879 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 14:41:41 PST
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354705DCD4;
        Thu, 23 Feb 2023 14:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:
        Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
        :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=CslzAJiIp7r58RKv96q1x1gc0Bf7YcbpzDSzziIZkhc=; b=Q
        kGA+Somztr9qy6v8Jgb8XuuJEMWjE7kfwks7O1Y18KNURgMnzCjZjwRM4l8lvdI6sWHszxpfyu1QN
        c4jlsjwBjO66azqrKVu8msEZGbCFd5z7tNFkl5NV8P/u8p2FhvDKk258iMI7rV9/UL2Yu342hPvRn
        A5Z2rNo2f3nXSZmfqVVNRBn7WcSOuEuLMwFNRBPr2yFVLWAg3oyy/tGBwkMuLSs8UMIDm2lR16+Nh
        X+bTj+pQcdDQeZfb1HLshjI74WpGwTWz53YSuO8Ce159jT7ZvVr21zPfRsW+5Ext4rvmBIEt0fl5S
        EBm1+trDYu2cYbhjs+FFgkKrklHXAqgpg==;
Received: from [2001:4d48:ad59:1403::17ca] (helo=sevai.o362.us)
        by the.earth.li with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1pVJmu-0047nl-G5; Thu, 23 Feb 2023 22:10:04 +0000
Date:   Thu, 23 Feb 2023 22:10:00 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     Antoine Tenart <atenart@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: inside-secure: Handle load errors better
Message-ID: <Y/fkOF31BTQVocSe@sevai.o362.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

2 minor patches to improve the error handling of the safexcel driver
when it fails to load.

Firstly, make it clear when the reason for a load failure is because the
firmware is not available.

Secondly, ensure we clean up the ring workqueues / IRQ affinity settings
to avoid a kernel warning when the driver fails to load.

Jonathan McDowell (2):
  crypto: inside-secure: Raise firmware load failure message to error
  crypto: inside-secure: Cleanup ring IRQ workqueues on load failure

 drivers/crypto/inside-secure/safexcel.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
2.39.1

