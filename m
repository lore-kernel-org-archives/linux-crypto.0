From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr problem
Date: Fri, 6 Aug 2010 15:13:39 +0400
Message-ID: <20100806111339.GA8259@ioremap.net>
References: <20100806080642.GA4642@dspnet.fr> <20100806083900.GA25385@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olivier Galibert <galibert@pobox.com>, kyle@moffetthome.net,
	torvalds@linux-foundation.org, herbert@gondor.hengli.com.au,
	dhowells@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from netgear.net.ru ([195.178.208.66]:37291 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab0HFLNp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Aug 2010 07:13:45 -0400
Content-Disposition: inline
In-Reply-To: <20100806083900.GA25385@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 06, 2010 at 04:39:00PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> So you'd rather have a box that doesn't boot rather than one
> that automatically falls back to software crypto allowing you
> to diagnose and report the problem.

What about kernel boot parameter to test hardware accelerators or not?

-- 
	Evgeniy Polyakov
