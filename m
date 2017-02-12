From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] lz4: fix performance regressions
Date: Sun, 12 Feb 2017 14:05:08 +0100
Message-ID: <20170212130508.GA27710@1wt.eu>
References: <20170210001311.GA25078@bbox>
 <1486898178-17125-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486898178-17125-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: minchan@kernel.org, ebiggers3@gmail.com, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:37480 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbdBLNIy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2017 08:08:54 -0500
Content-Disposition: inline
In-Reply-To: <1486898178-17125-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sven,

On Sun, Feb 12, 2017 at 12:16:18PM +0100, Sven Schmidt wrote:
> Fix performance regressions compared to current kernel LZ4

Your patch contains mostly style cleanups which certainly are welcome
but make the whole patch hard to review. These cleanups would have been
better into a separate, preliminary patch IMHO.

Regards,
Willy
