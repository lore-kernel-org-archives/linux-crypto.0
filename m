Return-Path: <SRS0=rw2L=VZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18752C433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 18:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E19F12085A
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 18:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564339688;
	bh=4DYiX1iZmDAb/6QIy02mrj5YucN4V4gh5wPN40oeVcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=VeHljq0+im3qUo7HG2rCb74bENjc3pgBi6sno18rcuCJV612dZV3BXAXnA8ast+3l
	 W9oZ6x5K83TcnXPVE1JCxLPl0ICsMm4Dp24ws+LvOKJkFSf1IKstdpkj+utUqcISpN
	 pJBsgE54XCFltfgPVOnz6pH4XP9H1QkVxvpkwIIs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfG1SsG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jul 2019 14:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfG1SsG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jul 2019 14:48:06 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4F9206A2;
        Sun, 28 Jul 2019 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564339685;
        bh=4DYiX1iZmDAb/6QIy02mrj5YucN4V4gh5wPN40oeVcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1x6CdvMFhhJpAqMrHpTg8s1dw/3onqj82ebkAM634Qi9JtPrLS2d41BDRyleQF8rc
         z8ez9kt631w8KhvzEa8NB2GGiD7L2QdgmE8nUQeZdO0Bm2BPRmjruLsOjQh4v3nMJC
         lBf5+MClR7Io/D3CHcsbKBpNz5sfw37TOm+n1UPI=
Date:   Sun, 28 Jul 2019 11:48:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, baylibre-upstreaming@groups.io
Subject: Re: [PATCH 0/4] crypto: add amlogic crypto offloader driver
Message-ID: <20190728184803.GA14920@sol.localdomain>
Mail-Followup-To: Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, khilman@baylibre.com,
        mark.rutland@arm.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, baylibre-upstreaming@groups.io
References: <1564083776-20540-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564083776-20540-1-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Corentin,

On Thu, Jul 25, 2019 at 07:42:52PM +0000, Corentin Labbe wrote:
> Hello
> 
> This serie adds support for the crypto offloader present on amlogic GXL
> SoCs.
> 
> Tested on meson-gxl-s905x-khadas-vim and meson-gxl-s905x-libretech-cc
> 
> Regards
> 

Does this new driver pass all the crypto self-tests?
Including with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

- Eric
