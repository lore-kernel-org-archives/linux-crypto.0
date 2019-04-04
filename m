Return-Path: <SRS0=rTfc=SG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7808C4360F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Apr 2019 17:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7192075E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Apr 2019 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554397929;
	bh=aXS/er4HBQNFf3E7MTT4ZdaWtvRrMiEkXol7ICiOn0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lClVyUIcxDf+xOLBYt0euvzyakPd1o8TO3I6era/GZQX1cvxpxHyw1aaNQaIvwflu
	 DXGndF2AHZTT546Xo5gY9iz1ryv7hlScakinXr/iKmLSogNtLvb/qVMTqTwX3MJ5YR
	 XqkZaEzf111k0256dnFHn780AWoEp3N3z4mBlzKc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfDDRMI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Apr 2019 13:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfDDRMI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Apr 2019 13:12:08 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E987D206BA;
        Thu,  4 Apr 2019 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554397927;
        bh=aXS/er4HBQNFf3E7MTT4ZdaWtvRrMiEkXol7ICiOn0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l15YJtid7VbR0t6Rh/c0DNOrL0+xMvIlmSbUVaq04pDH2MbSqqKjostr+5rLzpT9V
         Xb6xJNGxIqEq6dwaEbRGegiE5uS2T7B6OpSejTjkcPr1KYOV0K5Gc34mlCW6fZeJ5I
         SJqDvJnWhioUPm7LBWZBeLcAzlfwsgUT6hvHjnJc=
Date:   Thu, 4 Apr 2019 10:12:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "ezequiel@collabora.com" <ezequiel@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Message-ID: <20190404171204.GA121392@gmail.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 04, 2019 at 01:41:50PM +0000, Pascal Van Leeuwen wrote:
> > The issue is that the self-tests now verify that CBC implementations update the
> > IV buffer to contain the next IV, aka the last ciphertext block.  But the Rockchip
> > crypto driver doesn't do that, so it needs to be fixed.
> >
> > This has always been a requirement for CBC implementations so that users can
> > chain CBC requests.  Unfortunately it was just never tested for...
> >
> This did not immediately trigger me when it came flying past a couple of weeks
> ago, but I ran into the same issue today with the inside_secure driver I'm playing
> with: it does NOT return correct IV outputs for CBC modes.
> 
> However ... I'd like to question that very requirement ... if I may :-)
> 
> My reasoning is that this IV output *is* available as the last block of either the
> output (for encrypt) or input (for decrypt) datastream. So requiring it to be
> updated in the IV buffer as well seems redundant to me. It burdens the driver
> with an extra data copy operation, while in the majority of practicle use cases
> you would not even *need* this output IV. (chaining IV's would not work on
> a hardware accelerator anyway, because you would need to serialize the
> datastream, meaning you run at the speed of the round-trip latency instead
> of the throughput, which is typically one to two orders of a magnitude slower)
> 
> And in the odd case you do need it, you can just grab it from the data buffer
> yourself.
> 
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines
> 

Herbert, can you explain what users actually rely on the next IV being returned?
I don't know all the historical context behind this.

- Eric
