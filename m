From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH] lz4: fix performance regressions
Date: Sun, 12 Feb 2017 16:20:00 +0100
Message-ID: <20170212152000.GA24704@bierbaron.springfield.local>
References: <20170210001311.GA25078@bbox>
 <1486898178-17125-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486898178-17125-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170212130508.GA27710@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: minchan@kernel.org, ebiggers3@gmail.com, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: Willy Tarreau <w@1wt.eu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47682 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751206AbdBLPUH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2017 10:20:07 -0500
Content-Disposition: inline
In-Reply-To: <20170212130508.GA27710@1wt.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 12, 2017 at 02:05:08PM +0100, Willy Tarreau wrote:
> Hi Sven,
> 
> On Sun, Feb 12, 2017 at 12:16:18PM +0100, Sven Schmidt wrote:
> > Fix performance regressions compared to current kernel LZ4
> 
> Your patch contains mostly style cleanups which certainly are welcome
> but make the whole patch hard to review. These cleanups would have been
> better into a separate, preliminary patch IMHO.
> 
> Regards,
> Willy

Hi Willy,

the problem was, I wanted to compare my version to the upstream LZ4 to find bugs (as with my last patch version: wrong indentation in LZ4HC 
in two for loops). But since the LZ4 code is a pain to read, I made additional style cleanups "on the way".
Hope you can manage to review the patch though, because it is difficult to separate the cleanups now.
Please feel free to ask if you stumble upon something.

Greetings,

Sven 
