From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: Fix Kernel coding style issues
Date: Fri, 22 Sep 2017 10:59:44 +0200
Message-ID: <20170922085944.GA9529@kroah.com>
References: <1506069934-28571-1-git-send-email-karthik@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        sunil.m@techveda.org
To: karthik@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdIVI7e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 04:59:34 -0400
Content-Disposition: inline
In-Reply-To: <1506069934-28571-1-git-send-email-karthik@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 22, 2017 at 02:15:34PM +0530, karthik@techveda.org wrote:
> From: Karthik Tummala <karthik@techveda.org>
> 
> Fixed following checkpatch warnings & checks:
> CHECK: Unnecessary parentheses
> WARNING: suspect code indent for conditional statements
> WARNING: Missing a blank line after declarations

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

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
