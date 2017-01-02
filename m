From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: picoxcell - Fix module autoload for non-OF registration
Date: Mon, 02 Jan 2017 17:05:32 +0100
Message-ID: <2761495.aqgObxUbGB@wuerfel>
References: <1483371482-4956-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:50289 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755641AbdABQGW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2017 11:06:22 -0500
In-Reply-To: <1483371482-4956-1-git-send-email-javier@osg.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, January 2, 2017 12:38:02 PM CET Javier Martinez Canillas wrote:
> If the driver is built as a module, autoload won't work because the module
> alias information is not filled. So user-space can't match the registered
> device with the corresponding module if the device isn't registered via OF.
> 
> Export the module alias information using the MODULE_DEVICE_TABLE() macro.

I think we can just remove the table, as the platform only supports
booting through DT anyway.

	Arnd
