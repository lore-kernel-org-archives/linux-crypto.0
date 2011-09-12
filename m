From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Mon, 12 Sep 2011 18:06:57 +0100
Message-ID: <20110912170657.GA10452@sirena.org.uk>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <1315417137-12093-1-git-send-email-jarod@redhat.com>
 <1315419179.3576.6.camel@lappy>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <4E6E1103.2000408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40989 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1ILRHH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Sep 2011 13:07:07 -0400
Content-Disposition: inline
In-Reply-To: <4E6E1103.2000408@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 12, 2011 at 10:02:43AM -0400, Jarod Wilson wrote:
> Ted Ts'o wrote:

> >Yeah, but there are userspace programs that depend on urandom not
> >blocking... so your proposed change would break them.

> I'm already consigned to the fact this isn't going to fly, but I'm
> still curious to know examples of programs that are going to break
> here, for my own education. Its already possible for urandom reads
> to fail as the code is now (-ERESTARTSYS and -EFAULT are possible),
> so a sane program ought to already be handling error cases, though
> not -EAGAIN, which this would add.

It's not just a question of error handling existing, it's also about the
expectations the system has for the behaviour of the file - if urandom
is expected to always be able to return data an application is likely to
rely on the fact that it's effectively non-blocking anyway and not bother
setting non-blocking mode at all and so have no graceful handling for
this.
