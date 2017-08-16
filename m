From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: mediatek - Add empty messages check in GCM mode
Date: Wed, 16 Aug 2017 14:18:02 +0200
Message-ID: <3037420.ZP13UAVzzO@tauon.chronox.de>
References: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Ryder Lee <ryder.lee@mediatek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58914 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdHPMSE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 08:18:04 -0400
In-Reply-To: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 16. August 2017, 13:19:48 CEST schrieb Ryder Lee:

Hi Ryder,

> Currently, empty messages are not supported in GCM mode, hence add
> a check to prevent producing incorrect results.

In case the caller would provide empty messages, would there be just wrong 
data or a real problem? Note, unprivileged user space can make such requests.

If there would be a real problem (like crash), this should also go to stable.

Ciao
Stephan
