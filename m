From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v2 1/4] lib: Update LZ4 compressor module based on LZ4
 v1.7.2.
Date: Tue, 10 Jan 2017 11:50:25 +0100
Message-ID: <20170110105025.GA4733@1wt.eu>
References: <20170108112542.GC12798@kroah.com>
 <1484040076-5004-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170110100032.GC32419@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>,
        akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110100032.GC32419@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 11:00:32AM +0100, Greg KH wrote:
> On Tue, Jan 10, 2017 at 10:21:16AM +0100, Sven Schmidt wrote:
> > On 01/08/2017 12:25 PM, Greg KH wrote:
> > >On Sat, Jan 07, 2017 at 05:55:42PM +0100, Sven Schmidt wrote:
> > >> This patch updates LZ4 kernel module to LZ4 v1.7.2 by Yann Collet.
> > >> The kernel module is inspired by the previous work by Chanho Min.
> > >> The updated LZ4 module will not break existing code since there were alias
> > >> methods added to ensure backwards compatibility.
> > >
> > > Meta-comment.  Does this update include all of the security fixes that
> > > we have made over the past few years to the lz4 code?  I don't want to
> > > be adding back insecure functions that will cause us problems.
> > >
> > > Specifically look at the changes I made in 2014 in this directory for an
> > > example of what I am talking about here.
> > >
> > 
> > Hi Greg,
> > 
> > it doesn't. I didn't have that in mind until now.
> 
> Ick, those changes never got made "upstream"?  Not good, but makes sense
> as we couldn't really find an "upstream" when we made them :(

I *seem* to remember that some of these changes were specific to our
implementation, and were discovered during a review after we worked on
the the LZO implementation bugs, though I could be wrong.

If this is the case, it is one more reason for being extra careful.

> As you took this code from somewhere, you might want to also push your
> changes for these issues there as well, so that others don't run into
> them in the future.

Agreed!

Willy
