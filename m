From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: memset() in crypto code?
Date: Mon, 6 Oct 2014 14:23:45 -0400
Message-ID: <20141006182345.GC14468@titan.lakedaemon.net>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
 <20141006174403.GB14468@titan.lakedaemon.net>
 <CACXcFmmv2hKaVNS3hok6V=7VmrqTMF1_Pn2z0e31dd_YywBfKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16200 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753036AbaJFSXr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 14:23:47 -0400
Content-Disposition: inline
In-Reply-To: <CACXcFmmv2hKaVNS3hok6V=7VmrqTMF1_Pn2z0e31dd_YywBfKQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 06, 2014 at 01:59:06PM -0400, Sandy Harris wrote:
> On Mon, Oct 6, 2014 at 1:44 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > On Sat, Oct 04, 2014 at 11:09:40PM -0400, Sandy Harris wrote:
> >> There was recently a patch to the random driver to replace memset()
> >> because, according to the submitter, gcc sometimes optimises memset()
> >> away which might leave data unnecessarily exposed. The solution
> >> suggested was a function called memzero_explicit(). There was a fair
> >> bit of discussion and the patch was accepted.
> >
> > Do you have a pointer?
> 
> https://lkml.org/lkml/2014/8/25/497

Ok, that was the same thread I found.  I was looking for the 'fair bit
of discussion' part. ;-)

thx,

Jason.
