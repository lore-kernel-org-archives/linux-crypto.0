From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/4] lib: Update LZ4 compressor module based on LZ4
 v1.7.2.
Date: Sun, 8 Jan 2017 12:25:42 +0100
Message-ID: <20170108112542.GC12798@kroah.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483808145-18417-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jan 07, 2017 at 05:55:42PM +0100, Sven Schmidt wrote:
> This patch updates LZ4 kernel module to LZ4 v1.7.2 by Yann Collet.
> The kernel module is inspired by the previous work by Chanho Min.
> The updated LZ4 module will not break existing code since there were alias
> methods added to ensure backwards compatibility.

Meta-comment.  Does this update include all of the security fixes that
we have made over the past few years to the lz4 code?  I don't want to
be adding back insecure functions that will cause us problems.

Specifically look at the changes I made in 2014 in this directory for an
example of what I am talking about here.

thanks,

greg k-h
