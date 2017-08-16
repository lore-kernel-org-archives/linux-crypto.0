From: Ryder Lee <ryder.lee@mediatek.com>
Subject: Re: [PATCH] crypto: mediatek - Add empty messages check in GCM mode
Date: Wed, 16 Aug 2017 20:50:17 +0800
Message-ID: <1502887817.30384.16.camel@mtkswgap22>
References: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
         <3037420.ZP13UAVzzO@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:14083 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751287AbdHPMuX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 08:50:23 -0400
In-Reply-To: <3037420.ZP13UAVzzO@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, 2017-08-16 at 14:18 +0200, Stephan Mueller wrote:
> Am Mittwoch, 16. August 2017, 13:19:48 CEST schrieb Ryder Lee:
> 
> Hi Ryder,
> 
> > Currently, empty messages are not supported in GCM mode, hence add
> > a check to prevent producing incorrect results.
> 
> In case the caller would provide empty messages, would there be just wrong 
> data or a real problem? Note, unprivileged user space can make such requests.
> 
> If there would be a real problem (like crash), this should also go to stable.
> 
> Ciao
> Stephan

This does not cause any problem and it just returns a wrong result. 

Ryder
