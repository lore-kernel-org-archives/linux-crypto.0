From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: ssi_aead: fixed all coding style
 warnings.
Date: Thu, 7 Dec 2017 07:15:20 +0100
Message-ID: <20171207061520.GB7545@kroah.com>
References: <1512598089-15699-1-git-send-email-kallur.sunil@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: SUNIL KALLUR RAMEGOWDA <kallur.sunil@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdLGGPQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 01:15:16 -0500
Content-Disposition: inline
In-Reply-To: <1512598089-15699-1-git-send-email-kallur.sunil@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 06, 2017 at 11:08:09PM +0100, SUNIL KALLUR RAMEGOWDA wrote:
> My first kernel patch, fixed warnings.
> 
> Signed-off-by: SUNIL KALLUR RAMEGOWDA <kallur.sunil@gmail.com>
> ---
>  drivers/staging/ccree/ssi_aead.c | 179 +++++++++++++++++++++++++++------------
>  1 file changed, 123 insertions(+), 56 deletions(-)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch did many different things all at once, making it difficult
  to review.  All Linux kernel patches need to only do one thing at a
  time.  If you need to do multiple things (such as clean up all coding
  style issues in a file/driver), do it in a sequence of patches, each
  one doing only one thing.  This will make it easier to review the
  patches to ensure that they are correct, and to help alleviate any
  merge issues that larger patches can cause.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
