Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB4FC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Dec 2022 14:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiLLOqA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Dec 2022 09:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiLLOpl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2022 09:45:41 -0500
X-Greylist: delayed 471 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Dec 2022 06:45:36 PST
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDF713CD6
        for <linux-crypto@vger.kernel.org>; Mon, 12 Dec 2022 06:45:36 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id B96E9220002;
        Mon, 12 Dec 2022 15:37:42 +0100 (CET)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UvXraO4sfpgr; Mon, 12 Dec 2022 15:37:41 +0100 (CET)
Received: from [10.6.32.204] (unknown [185.12.128.224])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 602B6220001;
        Mon, 12 Dec 2022 15:37:41 +0100 (CET)
Message-ID: <60937acc8b143e552aa41a689c03febb1fd3729a.camel@strongswan.org>
Subject: Re: [PATCH v2 0/2] ARM: allow kernel mode NEON in softirq context
From:   Martin Willi <martin@strongswan.org>
To:     Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc:     linux-crypto@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 12 Dec 2022 15:37:41 +0100
In-Reply-To: <20221207103936.2198407-1-ardb@kernel.org>
References: <20221207103936.2198407-1-ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

> Currently on ARM, we only permit kernel mode NEON in task context [...]
> For IPsec packet encryption involving highly performant crypto
> implementations, this results in a substantial performance hit [...]

Thanks for your continued work on this.

> Without these changes, an IPsec tunnel from a 32-bit VM to the 64-bit
> host can achieve a throughput of 9.5 MB/s TX and 11.9 MB/s RX.
> 
> When the crypto algorithm is permitted to execute in softirq context,
> the throughput increases to 16.5 MB/s TX and 41 MB/s RX.

In my tests on an Armada 385, I could increase IPsec throughput with
ChaCha20/Poly1305 on RX from ~230 to ~260 MBit/s when using the NEON
code path. So you may add my:

Tested-by: Martin Willi <martin@strongswan.org>

Thanks,
Martin
