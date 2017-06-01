From: Ryder Lee <ryder.lee@mediatek.com>
Subject: Re: [PATCH 2/2] crypto: mediatek - update DT binding documentation
Date: Thu, 1 Jun 2017 09:04:38 +0800
Message-ID: <1496279078.31264.2.camel@mtkswgap22>
References: <1495791789-19230-1-git-send-email-ryder.lee@mediatek.com>
         <1495791789-19230-2-git-send-email-ryder.lee@mediatek.com>
         <20170531184620.io3nohu3f4hhkpwz@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <devicetree@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
To: Rob Herring <robh@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:3610 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751327AbdFABEp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2017 21:04:45 -0400
In-Reply-To: <20170531184620.io3nohu3f4hhkpwz@rob-hp-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2017-05-31 at 13:46 -0500, Rob Herring wrote:
> On Fri, May 26, 2017 at 05:43:09PM +0800, Ryder Lee wrote:
> > This patch removes unnecessary clock in binding file.
> 
> Why is the clock unnecessary? A h/w block either has a clock or doesn't.
> 
> The subject needs some work. Perhaps "dt-bindings: crypto: remove 
> mediatek ethif clock".
> 
> Rob

I'll write more clearly, thanks.

Ryder.
