From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/4] lib: Update LZ4 compressor module based on LZ4
 v1.7.2.
Date: Tue, 10 Jan 2017 10:59:26 +0100
Message-ID: <20170110095926.GB32419@kroah.com>
References: <20170108112223.GA12798@kroah.com>
 <1484040737-5400-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdAJJ7G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2017 04:59:06 -0500
Content-Disposition: inline
In-Reply-To: <1484040737-5400-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 10, 2017 at 10:32:17AM +0100, Sven Schmidt wrote:
> On 01/08/2017 12:23 PM, Greg KH wrote:
> > And follow the proper kernel coding style rules, putting your patches
> > through scripts/checkpatch.pl should help you out here.
> 
> Sorry, I didn't know about that particular script. I already put
> Patches 2, 3 and 4 through checkpatch.pl; patch 1 is a little more to
> rework but I will, of course, do that.

You do know about Documentation/SubmittingPatches, right?  If not, take
a look at that as well :)

thanks,

greg k-h
