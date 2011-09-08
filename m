From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 8 Sep 2011 07:48:27 -0400
Message-ID: <201109080748.27750.sgrubb@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67E1B0.2040309@atsec.com> <20110908084420.GC4032@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <stephan.mueller@atsec.com>,
	"Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324Ab1IHLtL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Sep 2011 07:49:11 -0400
In-Reply-To: <20110908084420.GC4032@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, September 08, 2011 04:44:20 AM Christoph Hellwig wrote:
> On Wed, Sep 07, 2011 at 11:27:12PM +0200, Stephan Mueller wrote:
> > And exactly that is the concern from organizations like BSI. Their
> > cryptographer's concern is that due to the volume of data that you can
> > extract from /dev/urandom, you may find cycles or patterns that increase
> > the probability to guess the next random value compared to brute force
> > attack. Note, it is all about probabilities.
> 
> So don't use /dev/urandom if you don't like the behaviour.  Breaking all
> existing application because of a certification is simply not an option.

This patch does not _break_ all existing applications. If a system were under attack, 
they might pause momentarily, but they do not break. Please, try the patch and use a 
nice large number like 2000000 and see for yourself. Right now, everyone arguing about 
this breaking things have not tried it to see if in fact things do break and how they 
break if they do.

-Steve
