From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Thu, 9 Feb 2017 10:29:14 -0800
Message-ID: <20170209182914.GB92711@gmail.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209002436.GA103792@gmail.com>
 <20170209110211.GB3575@bierbaron.springfield.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33450 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdBISbe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 13:31:34 -0500
Content-Disposition: inline
In-Reply-To: <20170209110211.GB3575@bierbaron.springfield.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 09, 2017 at 12:02:11PM +0100, Sven Schmidt wrote:
> > 
> > [Also, for some reason linux-crypto is apparently still not receiving patch 1/5
> > in the series.  It's missing from the linux-crypto archive at
> > http://www.spinics.net/lists/linux-crypto/, so it's not just me.]
> > 
> 
> I don't really know what to do about this. I think the matter is the size of the E-Mail.
> Are there filters or something like that? Since in linux-kernel the patch seems to get delivered.
> I could otherwise CC you if you wish.
> 

If I'm not mistaken, David Miller is the admin of the mail server on
vger.kernel.org, and he already happens to be Cc'ed on this thread, so maybe he
can answer as to why linux-crypto may be configured differently?

Anyway, since the patch did make it to linux-kernel anyone can still download it
from patchwork if they know where to look:
https://patchwork.kernel.org/patch/9556271/

Eric
