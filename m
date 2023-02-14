Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CB6C6379F
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 06:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjBNGMc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 01:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBNGMb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 01:12:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F246A5F;
        Mon, 13 Feb 2023 22:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G0/WVB6qNrAaN5ACJglpC0Dt5fwi5uc2iQpoJ82fBxQ=; b=oP9c+fi5tr9naLFnem3+coI9f4
        OFNgd0dF7kJlU6WdkDQIiQTFssKMjrZItC5mDiWGFY/zIAJGfooluGQx+RBB6zzfCvsh87zEotcLM
        hMt6sozsh9sOU6wbnWwMD9pc37iFa8gARB9z7c0ml1fSSXkLrvJHyNesk4EzDrjemFLhHJZY3c7NQ
        GaPKY6gOGbMbqIKdoTfDu2lapFQwPwyH7JU1RmTpYosC9un5YVjBUvQ1OEkxuydserb9DgONMUsO8
        V4mq2OfSN67MFno9a5pleSh9cuuHp1LofAtIHWHZ/dZ2jxuu+IxrCQ5Fbid3ZfctlAP1BwFYMkZQt
        sN5ZU5zQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRoXw-0001HL-Qo; Tue, 14 Feb 2023 06:12:08 +0000
Date:   Mon, 13 Feb 2023 22:12:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     JiaJie Ho <jiajie.ho@starfivetech.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] crypto: starfive - Add hash and HMAC support
Message-ID: <Y+smOBZ9CkEGY8Ua@infradead.org>
References: <20230130154242.112613-1-jiajie.ho@starfivetech.com>
 <20230130154242.112613-5-jiajie.ho@starfivetech.com>
 <Y+S5fBjZQZli9nBg@gondor.apana.org.au>
 <88a62a7a11814d629e2198583a0349b6@EXMBX168.cuchost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88a62a7a11814d629e2198583a0349b6@EXMBX168.cuchost.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 09, 2023 at 09:33:06AM +0000, JiaJie Ho wrote:
> > Why do you copy everything before you feed it to the hardware?
> > If the issue is alignment then surely you should only to copy a small amount
> > of header (and perhaps trailer) for that?
> > 
> 
> The DMA can only support 32-bit addressing.
> So, I am copying everything in case kernel allocated memory region >32-bit for a user app.

The DMA API takes care of that.
