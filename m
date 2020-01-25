Return-Path: <SRS0=mAFZ=3O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D044DC35242
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jan 2020 01:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D0B2075E
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jan 2020 01:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=neuralgames.com header.i=@neuralgames.com header.b="g1w1f5kv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgAYBKG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jan 2020 20:10:06 -0500
Received: from kross.rwserver.com ([69.13.37.146]:43868 "EHLO
        kross2019.rwserver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387564AbgAYBKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jan 2020 20:10:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by kross2019.rwserver.com (Postfix) with ESMTP id ADA55B3DC2;
        Fri, 24 Jan 2020 19:10:05 -0600 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuralgames.com;
         h=user-agent:message-id:references:in-reply-to:subject:subject
        :from:from:date:date:content-transfer-encoding:content-type
        :content-type:mime-version; s=default; t=1579914605; x=
        1581729006; bh=oobQmrNrtMrH5ic0QlZWtjmXlS2bin04onbQAnRpyJI=; b=g
        1w1f5kv5ixK4UfVj48ni8bD3RCw1DXYJy8+YnATBfjEGqB7+wMPBm5d3kIcsaOBS
        MEeRZDujLnNQIP/QVcKRCPUD1fIf260MmOsEJUlzojaejtbETzjCLfHYU/ISy84P
        KyvzeG7ldpFXIES2zkKUcV/P7FgNrAGQnQH+zEr3es=
X-Virus-Scanned: Debian amavisd-new at kross2019.rwserver.com
Received: from kross2019.rwserver.com ([127.0.0.1])
        by localhost (kross2019.rwserver.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yE5rXoj6bgXT; Fri, 24 Jan 2020 19:10:05 -0600 (CST)
Received: from rwserver.com (localhost [IPv6:::1])
        (Authenticated sender: linux@neuralgames.com)
        by kross2019.rwserver.com (Postfix) with ESMTPA id 30E46B3DC1;
        Fri, 24 Jan 2020 19:10:05 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 24 Jan 2020 19:10:05 -0600
From:   linux@neuralgames.com
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     Joel Stanley <joel@jms.id.au>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwrng: Add support for ASPEED RNG
In-Reply-To: <575811fd-24ca-409c-8d33-c2152ee401d7@www.fastmail.com>
References: <20200120150113.2565-1-linux@neuralgames.com>
 <CACPK8XfuVN3Q=npEoOP-amQS0-wemxcx6LKaHHZEsBAHzq1wzA@mail.gmail.com>
 <4446ffb694c7742ca9492c7360856789@neuralgames.com>
 <575811fd-24ca-409c-8d33-c2152ee401d7@www.fastmail.com>
Message-ID: <136bbab84d13d8d56a5ac297e415975e@neuralgames.com>
X-Sender: linux@neuralgames.com
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-01-22 19:53, Andrew Jeffery wrote:
>> Thanks for reviewing the patch.
>> 
>> The RNG on Aspeed hardware allows eight different modes for combining
>> its four internal Ring Oscillators that together generate a stream of
>> random bits. However, the timeriomem-rng driver does not allow for 
>> mode
>> selection so, the Aspeed RNG with this generic driver runs always on
>> mode 'seven' (The default value for mode according to the AspeedTech
>> datasheets).
>> 
>> I've performed some testings on this Aspeed RNG using the NIST
>> Statistical Test Suite (NIST 800-22r1a) and, the results I got show 
>> that
>> the default mode 'seven' isn't producing the best entropy and linear
>> rank when compared against the other modes available on these SOCs.  
>> On
>> the other hand, the driver that I'm proposing here allows for mode
>> selection which would help improve the random output for those looking
>> to get the best out of this Aspeed RNG.
> 
> Have you published the data and results of this study somewhere? This
> really should be mentioned in the commit message as justification for
> not using timeriomem-rng.
> 
> Andrew

Hi Andrew,

I have uploaded the results of my tests to my GitHub, along with all the 
binaries
containing the random bits that I collected from this Aspeed RNG using 
all 8 modes.
You can also find in this repository a patch for the hw_random core 
driver that
I've been using to collect this data. Here is the link:
   https://github.com/operezmuena/aspeed-rng-testing

You can see in the reports that when using large enough samples (40Mb in 
size)
this Aspeed RNG consistently fails the linear rank and entropy tests, no 
matter
what RNG mode is selected. However, modes 2, 4 and 6 produce better 
entropy than
the rest.
I'm now collecting rng data from 2 other AST2520 SOCs that I have in 
order to
compare results.

Regards,
Oscar



