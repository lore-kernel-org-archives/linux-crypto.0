From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/12] staging: ccree: correct coding style violations
Date: Mon, 29 May 2017 09:57:10 -0700
Message-ID: <1496077030.18529.1.camel@perches.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
         <1495982440-10047-2-git-send-email-gilad@benyossef.com>
         <20170529143728.GA12428@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:36621 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750947AbdE2Q52 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 12:57:28 -0400
In-Reply-To: <20170529143728.GA12428@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-05-29 at 16:37 +0200, Greg Kroah-Hartman wrote:
> On Sun, May 28, 2017 at 05:40:26PM +0300, Gilad Ben-Yossef wrote:
> > cc_crypto_ctx.h had multiple coding style violations reported by
> > checkpatch. Fix them all.
> 
> Sorry, no.  You need to do only one-thing-per-patch, and "fix all coding
> style issues is not "one thing".  I wouldn't take this kind of patch
> from anyone else, so why should I take it from you?  :)

Because he's the named MAINTAINER of the subsystem
and you are acting as an upstream conduit.
