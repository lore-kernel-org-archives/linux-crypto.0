Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A965C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C2F161051
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhJ2O0X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:26:23 -0400
Received: from phobos.denx.de ([85.214.62.61]:50100 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhJ2O0X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:26:23 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5D71F835BF;
        Fri, 29 Oct 2021 16:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1635517433;
        bh=ZWEwn6xxH9thjtW69prVFZ20jiDIdEX/mAl5N86y5gs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zQ6qmJoFsbPLo4fNjIbKsn7lCU5pFd4Y+8R5ranowo4Nxmas9/BVTJiCfFUc9Vyh3
         hyAYHqJu5yndLGFMzAldklvksqkCdo4lAuL8oqscb8d/0+j8BQ/EtyaYROLCSOXkU4
         zmZeeAm8fxHrLRtp8QxPEa1tp2roO99pUmRUBIxpOO6camEULH5Q+SMQASl9l2jB0g
         gRAnVQ32ftQYow2aLiU4szUBz9eX1n2b4oiau9TeOlvmvRUQ3PIZ+Jp+IxpF8PK7Ev
         BEyy+eT/r0COf5T/gWGoWQHV0YZu00+3FS6PYaY5XkpUk5JeZUBQkuH9c+CaLuPX36
         sv5H18B800xYg==
Subject: Re: [PATCH 4/8] crypto: stm32/cryp - fix race condition
To:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
 <20211029135454.4383-5-nicolas.toromanoff@foss.st.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <1ec60d9c-1ab4-8a92-1c6d-8093232ca039@denx.de>
Date:   Fri, 29 Oct 2021 16:23:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211029135454.4383-5-nicolas.toromanoff@foss.st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/29/21 3:54 PM, Nicolas Toromanoff wrote:
> Erase key before finalizing request.
> Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")

Can you be a bit more specific in your commit messages ? That applies to 
the entire patchset. It is absolutely impossible to tell what race is 
fixed here or why it is fixed by exactly this change. This applies to 
the entire series.

And while I am at it, does the CRYP finally pass at least the most basic 
kernel boot time crypto tests or does running those still overwrite 
kernel memory and/or completely crash or lock up the machine ?
