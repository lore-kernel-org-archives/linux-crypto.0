Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213F5C32771
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 01:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B652465A
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 01:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aj.id.au header.i=@aj.id.au header.b="qsshw+6M";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DN6OGW/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAWBxx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 20:53:53 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36509 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgAWBxw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 20:53:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D8A6A6D87;
        Wed, 22 Jan 2020 20:53:51 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Wed, 22 Jan 2020 20:53:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=ujZkvtF9majEmku/Gxs4rZoUakuhfzp
        hD8ol/URHilo=; b=qsshw+6MxBNBzlpsVfUQJvzPlg1mYf034IOSuoePEBVtHNN
        ehE++KC/RbpuXEATKpEmSmmnCDp1WFqj7zSqqmQaLd1P/XsqZQpuulLziDntGcEi
        Zl24Kqe7K5broi96LBy5wFhNHIwNwXyEvvLMp9EqS/6nsF/A1gBvZHTJSR+ZCTq8
        jWvOnveizc8TEi4FFYrl6/b6ptzaBi4KjnepiyPNrzEAfiFHFKqfnudBBcXcd+Vl
        1Q6FBERhKPJL2nFTyOkGQPs5b8QvcnoAzkZn2Br4y2nAbo2Du0g3lZgqPa6+xHCl
        fQ1vp8LM4m3v8l5So9ZZ5kwWz2cHB6+LstSxB/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ujZkvt
        F9majEmku/Gxs4rZoUakuhfzphD8ol/URHilo=; b=DN6OGW/SMqdXSI8jjtOzO2
        pGGVbrE9JRzGYsU3PcIOiobOZj1lO91DbwO31coNzfzM79yWYDsfaH1z/FrE4pOw
        K1cSpis2xl8x04ImWo4vZfPpa6T2R2jbu6OXfyod2Hi9b39uZVhOzKR8R0hG5A/N
        pUc9U3pDRSgmijNImgE+OK81Ohewqo/E9GWP5dUvTYMhLzWSWl9uJyv9P6EMFbBA
        g9nO1fp1IBXJUNrvbSrHxWw/xir2jOWs+Mub7vIioYbyUbYPRtBaAkBrcb7BhOTB
        fSY/RMQ+yIIyPB8wd9BHAvboR+hwUPsKTXljq72DPmDKDp0NAzJYOwmNdvlrtwAA
        ==
X-ME-Sender: <xms:rvwoXnPmSRFRoFSuOm7H2Q4DecD6HAwCBDdiFFGSAvJj6zxaqmvceQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvddugdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvfiesrghj
    rdhiugdrrghu
X-ME-Proxy: <xmx:rvwoXvx-psYu7LL5r4lFE6gYjRtdJY7jDu8sCdwsxIUqEXwemxeeCg>
    <xmx:rvwoXguvi3BjUj3AREX18fnbuZnb3eAzM5mUb7BWgebWP_w_zFRS2A>
    <xmx:rvwoXo63d6GAWwmGVoM4TP7Mnn-5xB2vKVnbwUhGjRvT8NIoJVAvjw>
    <xmx:r_woXnavh1Sem4tw8dB6XhIxw3Uv0cmbKNPj4_UAE9VF6956A8QC-w>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7543AE00A2; Wed, 22 Jan 2020 20:53:50 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-754-g09d1619-fmstable-20200113v1
Mime-Version: 1.0
Message-Id: <575811fd-24ca-409c-8d33-c2152ee401d7@www.fastmail.com>
In-Reply-To: <4446ffb694c7742ca9492c7360856789@neuralgames.com>
References: <20200120150113.2565-1-linux@neuralgames.com>
 <CACPK8XfuVN3Q=npEoOP-amQS0-wemxcx6LKaHHZEsBAHzq1wzA@mail.gmail.com>
 <4446ffb694c7742ca9492c7360856789@neuralgames.com>
Date:   Thu, 23 Jan 2020 12:23:29 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Oscar A Perez" <linux@neuralgames.com>,
        "Joel Stanley" <joel@jms.id.au>
Cc:     "Matt Mackall" <mpm@selenic.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwrng: Add support for ASPEED RNG
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Thanks for reviewing the patch.
> 
> The RNG on Aspeed hardware allows eight different modes for combining 
> its four internal Ring Oscillators that together generate a stream of 
> random bits. However, the timeriomem-rng driver does not allow for mode 
> selection so, the Aspeed RNG with this generic driver runs always on 
> mode 'seven' (The default value for mode according to the AspeedTech 
> datasheets).
> 
> I've performed some testings on this Aspeed RNG using the NIST 
> Statistical Test Suite (NIST 800-22r1a) and, the results I got show that 
> the default mode 'seven' isn't producing the best entropy and linear 
> rank when compared against the other modes available on these SOCs.  On 
> the other hand, the driver that I'm proposing here allows for mode 
> selection which would help improve the random output for those looking 
> to get the best out of this Aspeed RNG.

Have you published the data and results of this study somewhere? This
really should be mentioned in the commit message as justification for
not using timeriomem-rng.

Andrew
