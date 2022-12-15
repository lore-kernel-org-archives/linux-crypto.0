Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615BAC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Dec 2022 10:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLOKvw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Dec 2022 05:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiLOKvs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2022 05:51:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33565F66
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k8z9NPwjR/1WjDLafqFssLJg9DyvbaDVrEj71me8s10=; b=FqN/U+FpVhHgwuSC0KHPwZ7IOl
        AP1BieXhX0Fq2O01OJNw6WTgryTAF1ZXW+l2yug8M6gafkp1whJgQcUW6XdOPWtTnDmOn4MsCAy3G
        x6Xkhl+gUH1E37i5LhfMKOBY+iae1t+dGijFsP47jRrDxTYu+aMm7hrWdYwr//01fPLBAa157/2W1
        OvCJ7StosCbcLfDes7Y/TZSyrVNgY+RECLJmTyOkk4w8z753UWZgxHEjC//1VJP20CHsEFxibN/9G
        pgmcE3YxDyVtfMRXGTg0y7iGqUDTT8cmk3LDzJS/g06///Rmpe5iexuOzI44kRl+UuvI+PHzGd4Wm
        YRTAXDnA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35714)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p5lq0-0002kH-CX; Thu, 15 Dec 2022 10:51:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p5lpy-0008II-Qi; Thu, 15 Dec 2022 10:51:38 +0000
Date:   Thu, 15 Dec 2022 10:51:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/2] ARM: permit non-nested kernel mode NEON in
 softirq context
Message-ID: <Y5r8OrCrjfil0LWs@shell.armlinux.org.uk>
References: <20221207103936.2198407-1-ardb@kernel.org>
 <20221207103936.2198407-3-ardb@kernel.org>
 <CACRpkdYiHQQtw2=iPKos3sXEkeErTNxR7T0FPBrCqhQxtxhCkA@mail.gmail.com>
 <CAMj1kXFPDXp4OfjKYzM0namfbAijbuCfiEaDC9+jAhd1GFY6FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFPDXp4OfjKYzM0namfbAijbuCfiEaDC9+jAhd1GFY6FA@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 15, 2022 at 11:43:22AM +0100, Ard Biesheuvel wrote:
> On Thu, 15 Dec 2022 at 11:27, Linus Walleij <linus.walleij@linaro.org> wrote:
> >
> > On Wed, Dec 7, 2022 at 11:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > > We currently only permit kernel mode NEON in process context, to avoid
> > > the need to preserve/restore the NEON register file when taking an
> > > exception while running in the kernel.
> > >
> > > Like we did on arm64, we can relax this restriction substantially, by
> > > permitting kernel mode NEON from softirq context, while ensuring that
> > > softirq processing is disabled when the NEON is being used in task
> > > context. This guarantees that only NEON context belonging to user space
> > > needs to be preserved and restored, which is already taken care of.
> > >
> > > This is especially relevant for network encryption, where incoming
> > > frames are typically handled in softirq context, and deferring software
> > > decryption to a kernel thread or falling back to C code are both
> > > undesirable from a performance PoV.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > So boosting WireGuard as primary SW network encryption user?
> 
> Essentially, although the use case that inspired this work is related
> to IPsec not WireGuard, and the crypto algorithm in that case (GCM) is
> ~3x faster than WG's chacha20poly1305, which makes the performance
> overhead of asynchronous completion even more significant. (Note that
> GCM needs the AES and PMULL instructions which are usually only
> available when running the 32-bit kernel on a 64-bit core, whereas
> chacha20poly1305 uses ordinary NEON instructions.)
> 
> But Martin responded with a Tested-by regarding chacha20poly1305 on
> IPsec (not WG) where there is also a noticeable speedup, so WG on
> ARM32 should definitely benefit from this as well.

It'll be interesting to see whether there is any noticable difference
with my WG VPN.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
