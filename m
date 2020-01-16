Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B594C33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 13:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A0BD20663
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 13:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QctqX+SA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgAPNQJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 08:16:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55271 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAPNQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 08:16:09 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so3703424wmj.4;
        Thu, 16 Jan 2020 05:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2fUXK8SpQFeNUTHHjq17WKEa2HX3RjBEp1dlf1605d8=;
        b=QctqX+SABPym4k6LOX1hzx5gGwkEvbayU2AwkCvhTMCpEs7ix0z3Y9lzgR8BIzExGs
         7Nmlqo7vmRyMi5++i7LRdKtmyQT8h2AfO8p5VVGLeEuuRSByY4ji0ucCpYlyiAntiLhu
         VsZz2FGp/upKFVJQvg0CGbvNSY1KlWk+pFvE8a8aihQPntSsMDotWqDTQIiPgwfSrpeP
         kj7Hfcr35pFToHNz5/Ub5rPit4WdGxYOcZuxPMdDsVrPknOEcggUKzQu2umL1Fkw76g8
         oiToDbmSTMNxl31Lfusng0BIhaz9f+r7aGAksBjS7megI67hE+Gmn+5o41tNxzsfXU5V
         +X6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2fUXK8SpQFeNUTHHjq17WKEa2HX3RjBEp1dlf1605d8=;
        b=tUbi2p5WjbBfzZgznHVeJQjjPG2ckZs4lZQoDSjzjT0v0bB8R6u11fV9ua1pALlYHV
         JSp2mny091jnf/dSh4H32lloq1GKltqrT3Aq5uC4G5/rV3kXDPvdTELBH/gZmwweWlkC
         Dm+uyXa2CQh0NzOgZ+MmAuHF72Vj0sSQEmY33FIvZFGQLxIZKxzs97Iiz9EibUdTx9ac
         RvUDAMccjnnoYHygwaWMQ5sokQl7jYj95cM8DvdHgdeb69vNX22sstGJHy1GbGyfcgiU
         Y9OAKJSlk7/EamVeRILdZqJbLy5TkX5R1vHEFLD3tObpKwdfguLwST6BwdJcBvqbGHGd
         tAaw==
X-Gm-Message-State: APjAAAWNLBmLqKWcKgvf3yyJFAqmf4dxYYlq4GorHgYSOiOcJ0I6CBOf
        pOH4qqz672EecdB761EfXr4=
X-Google-Smtp-Source: APXvYqy+KZj1RE5Da5UJUk8yDqkXjQ9G20krvYN+N07Q3VSfPwOBls/Wn9bvazOAR6xdN4I5BNBNVg==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr6139437wmm.70.1579180566478;
        Thu, 16 Jan 2020 05:16:06 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y139sm3415692wmd.24.2020.01.16.05.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:16:05 -0800 (PST)
Date:   Thu, 16 Jan 2020 14:16:03 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH RFC 00/10] crypto: engine: permit to batch requests
Message-ID: <20200116131603.GA26487@Red>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
 <VI1PR04MB444530675D82743E8AFFD8FE8C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB444530675D82743E8AFFD8FE8C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 16, 2020 at 11:33:24AM +0000, Iuliana Prodan wrote:
> On 1/14/2020 3:59 PM, Corentin Labbe wrote:
> > Hello
> > 
> > The sun8i-ce hardware can work on multiple requests in one batch.
> > For this it use a task descriptor, and chain them.
> > For the moment, the driver does not use this mechanism and do requests
> > one at a time and issue an irq for each.
> > 
> > Using the chaning will permit to issue less interrupts, and increase
> > thoughput.
> > 
> > But the crypto/engine can enqueue lots of requests but can ran them only
> > one by one.
> > 
> > This serie introduce a way to batch requests in crypto/engine by
> > - setting a batch limit (1 by default)
> > - refactor the prepare/unprepare code to permit to have x requests
> >    prepared/unprepared at the same time.
> > 
> > For testing the serie, the selftest are not enough, since it issue
> > request one at a time.
> > I have used LUKS for testing it.
> > 
> > Please give me what you think about this serie, specially maintainers
> > which have hardware with the same kind of capability.
> > 
> Hi,
> 
> I'm working on CAAM, on adding support for crypto-engine.
> These modifications are not working on CAAM.
> They seem to be specific to requests that are linked. CAAM can work on 
> multiple request, at the same time, but they are processed independently.
> So, I believe the parallelization is a good idea, but the requests still 
> need to be independent.
> I'll follow up with comments on each patch.

Hello

Thanks for the review.
Yes my serie is for doing "linked" request.
For the CAAM, if you can do multiple request independently, why not having x crypto engine ? (like sun8i-ce/sun8i-ss/amlogic)

> 
> Also, IMO you should send the patches for crypto-engine improvements in 
> a separate series from the one for allwinner driver.

For this RFC serie, I tried to do real atomic patch, for let people see the whole process.

Regards
