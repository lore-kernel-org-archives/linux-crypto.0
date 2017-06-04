From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] Staging: ccree: cc_crypto_ctx.h: Added * on
 subsequent lines of a comment block.
Date: Sun, 4 Jun 2017 10:19:57 +0200
Message-ID: <20170604081957.GA28749@kroah.com>
References: <cover.1496531673.git.srishtishar@gmail.com>
 <e1974f1fece258f422e8f90ca820170a2b982933.1496531673.git.srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: srishti sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbdFDIUC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:20:02 -0400
Content-Disposition: inline
In-Reply-To: <e1974f1fece258f422e8f90ca820170a2b982933.1496531673.git.srishtishar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 04, 2017 at 05:02:08AM +0530, srishti sharma wrote:
> Added * on subsequent lines of a comment block.
> 
> Signed-off-by: srishti sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/ccree/cc_crypto_ctx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This whole series also does not apply.  Note, this driver is under
active development, you are probably running into the problem that lots
of people are working on it at the same time.

sorry,

greg k-h
