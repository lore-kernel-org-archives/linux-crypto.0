Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF386C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 11:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAEB63210
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 11:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKOLUm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 06:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhKOLUZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 06:20:25 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D65DC061746;
        Mon, 15 Nov 2021 03:17:27 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 43A8022221;
        Mon, 15 Nov 2021 12:17:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636975046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/iWpLyoa1gNZiyBDxuUPBO05cWoG2tLuiKiWw/oH/0=;
        b=agijY97sqc3+pHSLv4oLGgRmgzivxSkJnuGG9xuwYFuSs8BlVx4ccdf7f7qmsz7pIHVToJ
        cB/nGsDz5wApvdNmP1mHsW3gYs5C5yc1P81YBxKStoVfYsM95R0TWoj4lsus8vd5avWKWz
        WVGqg1TUWRbQrwYNPv9cgfhrfjtCDYc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Nov 2021 12:17:23 +0100
From:   Michael Walle <michael@walle.cc>
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
In-Reply-To: <AM6PR06MB46914ECA12815ABFCE8C1A59A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
 <e8456cc0bb9e4fc306e8188c5bd666d0@walle.cc>
 <AM6PR06MB46914ECA12815ABFCE8C1A59A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <2070c2062606821fbf6ed052e6864255@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>> > +EXPORT_SYMBOL(caam_ctrl_check_jr_perm);
>> 
>> no need for exporting this, no?
> 
> Unfortunately, both CONFIG_CRYPTO_DEV_FSL_CAAM and
> CONFIG_CRYPTO_DEV_FSL_CAAM_JR are tristate. Setting both
> config options to "=m" fails to resolve caam_ctrl_check_jr_perm,
> therefore I had to export it.
> 
> It strikes me odd however that CAAM can be compiled as module
> without CAAM_JR module at all. This would imply that DECO is used
> directly, which according to SRM is used for pure descriptor debug
> purposes and should never be used in production.
> 
> I guess CRYPTO_DEV_FSL_CAAM _JR should be merged into
> CRYPTO_DEV_FSL_CAAM, so they at least comes together. In that
> case the export would not be necessary at all.
> 
> I must admit I didn't find this a good solution, therefore any advise
> on a better solution here is highly appreciated.

I see, and I'm too lazy at the moment to figure that out ;) but afaik
new exports should be only EXPORT_SYMBOL_GPL().

>> >       if ((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) !=
>> >           JRINT_ERR_HALT_COMPLETE || timeout == 0) {
>> > -             dev_err(dev, "failed to flush job ring %d\n", jrp->ridx);
>> > +             dev_err(dev, "failed to flush job ring %x\n",
>> > + jrp->ridx);
>> 
>> mh? why changing this?
> 
> After the change, jrp->ridx would contain JR hex address instead of 
> index,
> therefore I had to replace the debug output.

ahh then, ridx should renamed accordingly, I suppose.

-michael
