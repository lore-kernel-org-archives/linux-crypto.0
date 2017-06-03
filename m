From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Staging: ccree: cc_crypto_ctx.h: Fixed a comment coding
 style issue.
Date: Sat, 3 Jun 2017 17:36:50 +0900
Message-ID: <20170603083650.GA29531@kroah.com>
References: <1496235295-2696-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: srishti sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdFCOHk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2017 10:07:40 -0400
Content-Disposition: inline
In-Reply-To: <1496235295-2696-1-git-send-email-srishtishar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 31, 2017 at 06:24:55PM +0530, srishti sharma wrote:
> Fixed a comment coding style issue that generated a warning stating that block comments should align the * on each line.
> 

Please properly line-wrap your changelog comments :(

You also sent 2 different patches, that did different things, yet they
had the same subject line.  That's not ok, and also, I have no idea
which one to apply first.

I'm dropping both, please fix and resend them properly as a patch
series.

thanks,

greg k-h
