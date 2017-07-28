From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/4] staging: ccree: coding style clean ups
Date: Thu, 27 Jul 2017 21:55:09 -0700
Message-ID: <20170728045509.GA24659@kroah.com>
References: <1501152199-7671-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37030 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbdG1EzP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 00:55:15 -0400
Content-Disposition: inline
In-Reply-To: <1501152199-7671-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 27, 2017 at 01:43:14PM +0300, Gilad Ben-Yossef wrote:
> Misc. coding style fixes for ccree driver.
> 
> These are the missing patches that failed to apply two weeks ago,
> rebased onto latest staging-next.
> 
> By the way, I still do not understand why they failed to apply,
> as they applied just fine being cherry picked on top of latest
> staging-next apart for fixes for later changes. I hope these will
> be good.

Only one applied here :(

I did just take some more coding style fixes from someone else who sent
them before you did as they looked correct, maybe that's why?  Can you
rebase and resend?

thanks,

greg k-h
