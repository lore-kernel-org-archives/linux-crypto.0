Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8C7C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 09:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBB621D90
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592473837;
	bh=F0mHrmIfDX6Kuk9+3Hgh9PYce9TZgz8bGDX3F2Xq7yg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=bjrrg60mvY3VPWAljVbhSIxjWpcezGYlHXV+JNG4UkCk3uaSdJNakuLrIgMgF2IUH
	 XgXgEIAgqDoT23tte4+3j9RRQcCCOK7EtwIjG5FIL5N6fkJxmW18ioXKBpLZDjSA/n
	 GhLYI6YUkhJdW7NdjQAa56CL5SmkBYMVJK9/b7wY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgFRJuh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 05:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbgFRJuf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 05:50:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD63204EA;
        Thu, 18 Jun 2020 09:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592473834;
        bh=F0mHrmIfDX6Kuk9+3Hgh9PYce9TZgz8bGDX3F2Xq7yg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yi/kPSWjPKq7vjvVPdM8ROse+MVAcIlqSfhz+akzk8JbIpIvCPW1iGgMM+7NoXyPa
         8fwS2TTiUIvUqGdjM06a5kgBR1T3PtM2KV2csFREIvvqP7w2ouLbekxclP/58tOMbD
         +YCsgdxEu5hx97TeLGI6/mPjfdZ8dgOfY6wBXmoY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jlrBp-0047dq-3G; Thu, 18 Jun 2020 10:50:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Jun 2020 10:50:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Julius Werner <jwerner@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        linux-mediatek@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Crystal_Guo_=28=E9=83=AD?= =?UTF-8?Q?=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jose.Marinho@arm.com
Subject: Re: Security Random Number Generator support
In-Reply-To: <1591170857.19414.5.camel@mtkswgap22>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
 <1591169342.4878.9.camel@mtkswgap22>
 <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
 <1591170857.19414.5.camel@mtkswgap22>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <c3d5d4a79c7fe158cae117ff79ab332b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: neal.liu@mediatek.com, jwerner@google.com, ardb@kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, arnd@arndb.de, gregkh@linuxfoundation.org, sean.wang@kernel.org, linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, wsd_upstream@mediatek.com, robh+dt@kernel.org, linux-crypto@vger.kernel.org, mpm@selenic.com, matthias.bgg@gmail.com, Crystal.Guo@mediatek.com, linux-arm-kernel@lists.infradead.org, Jose.Marinho@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-06-03 08:54, Neal Liu wrote:

Hi Neal,

> Do you know which ARM expert could edict this standard?
> Or is there any chance that we can make one? And be reviewed by
> maintainers?

It appears that ARM just released a beta version of the spec at [1].

I'd encourage you (and anyone else) to have a look at it and provide 
feedback to ARM.

Thanks,

         M.

[1] 
https://developer.arm.com/-/media/Files/pdf/DEN0098-True_Random_Number_Generator_Firmware_Interface-1.0BET2.pdf
-- 
Jazz is not dead. It just smells funny...
