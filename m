From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] hwrng: bcm2835: Handle deferred clock properly
Date: Mon, 12 Feb 2018 12:22:21 -0800
Message-ID: <d3f5b375-d2e8-2e7c-526d-aa5d49751ed4@gmail.com>
References: <1518466296-30161-1-git-send-email-stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Anholt <eric@anholt.net>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-crypto@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38655 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbeBLUWe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 15:22:34 -0500
Received: by mail-qk0-f195.google.com with SMTP id s198so3783104qke.5
        for <linux-crypto@vger.kernel.org>; Mon, 12 Feb 2018 12:22:33 -0800 (PST)
In-Reply-To: <1518466296-30161-1-git-send-email-stefan.wahren@i2se.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/12/2018 12:11 PM, Stefan Wahren wrote:
> In case the probe of the clock is deferred, we would assume it is
> optional. This is wrong, so defer the probe of this driver until
> the clock is available.
> 
> Fixes: 791af4f4907a ("hwrng: bcm2835 - Manage an optional clock")
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Stephan!
-- 
Florian
