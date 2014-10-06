From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: memset() in crypto code?
Date: Mon, 6 Oct 2014 13:44:03 -0400
Message-ID: <20141006174403.GB14468@titan.lakedaemon.net>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41893 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJFRoF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 13:44:05 -0400
Content-Disposition: inline
In-Reply-To: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 04, 2014 at 11:09:40PM -0400, Sandy Harris wrote:
> There was recently a patch to the random driver to replace memset()
> because, according to the submitter, gcc sometimes optimises memset()
> away which might leave data unnecessarily exposed. The solution
> suggested was a function called memzero_explicit(). There was a fair
> bit of discussion and the patch was accepted.

Do you have a pointer?

> In the crypto directory of the kernel source I have:
> 
> $ grep memset *.c | wc -l
> 133
> $
> 
> I strongly suspect some of these should be fixed.

It seems this is a common topic:

  http://www.daemonology.net/blog/2014-09-04-how-to-zero-a-buffer.html

and part 2:

  http://www.daemonology.net/blog/2014-09-06-zeroing-buffers-is-insufficient.html

Summary:  It's not just the memory we should be concerned about, there's also
the stack and the registers.

memzero_explicit() is a good start, but I think the articles raise two
important points.  a) register data temporarily stored on the stack via
compiler optimizations, and b) aesni register contents left behind after
use.

I suspect (a) is an unquantified problem on embedded systems, and (b)
may extend to embedded hardware crypto implementations.

thx,

Jason.
