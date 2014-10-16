From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Thu, 16 Oct 2014 11:06:05 -0400
Message-ID: <20141016150604.GK17447@titan.lakedaemon.net>
References: <7502136.9BkWHTZ0th@myon.chronox.de>
 <20141015175800.GH17447@titan.lakedaemon.net>
 <3251314.QkilbvNUO7@myon.chronox.de>
 <20141016132501.GI17447@titan.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141016132501.GI17447@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 16, 2014 at 09:25:01AM -0400, Jason Cooper wrote:
> + Grant, Geert,
> 
> Stephan has created some great example code for both the kernel crypto
> API and the userspace crypto API.  As examples tend to bitrot, I was
> wondering if the code could serve as test code.  Then it would have a
> triple role: API regression testing, crypto test suite, and reference
> implementation.
> 
> Original patch is here:
> 
>   https://lkml.kernel.org/r/7502136.9BkWHTZ0th@myon.chronox.de
> 
> On Thu, Oct 16, 2014 at 09:19:08AM +0200, Stephan Mueller wrote:
> > Am Mittwoch, 15. Oktober 2014, 13:58:00 schrieb Jason Cooper:
> > > On Tue, Oct 14, 2014 at 09:46:50PM +0200, Stephan Mueller wrote:
...
> > > Perhaps the userspace API example should be a separate file with this
> > > text at the top?  Seems odd having it at the end.  Also, if you copied
> > > it from cryptsetup, is the copyright info correct?
> > 
> > I did not copy it from cryptsetup. I only used it as a basis, especially with 
> > the data structure handling in _kcapi_cipher_crypt. But you are right, I 
> > changed the license for the user space by taking the cryptsetup license.
> 
> Ok.  It looks like Geert and Grant took part in the kernel test
> unconference, so I'm adding them to the Cc.  I hope they can give us
> some pointers as to where we could hook in this code.  Then we can
> simply refer to it from the userspace API document.

tools/testing/selftests/crypto would be a good location for the example
code in the next version of this patch.  Make sure to take a look at
tools/testing/selftests/README.txt.

thx,

Jason.
