From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 8 Sep 2011 04:44:20 -0400
Message-ID: <20110908084420.GC4032@infradead.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <201109071602.24519.sgrubb@redhat.com>
 <20110907211858.GE20571@thunk.org>
 <4E67E1B0.2040309@atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Steve Grubb <sgrubb@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Stephan Mueller <stephan.mueller@atsec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40301
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932418Ab1IHIoY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Sep 2011 04:44:24 -0400
Content-Disposition: inline
In-Reply-To: <4E67E1B0.2040309@atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 07, 2011 at 11:27:12PM +0200, Stephan Mueller wrote:
> And exactly that is the concern from organizations like BSI. Their
> cryptographer's concern is that due to the volume of data that you can
> extract from /dev/urandom, you may find cycles or patterns that increase
> the probability to guess the next random value compared to brute force
> attack. Note, it is all about probabilities.

So don't use /dev/urandom if you don't like the behaviour.  Breaking all
existing application because of a certification is simply not an option.
