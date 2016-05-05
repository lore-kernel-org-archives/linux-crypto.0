From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 21:10:07 -0400
Message-ID: <20160505011007.GB10776@thunk.org>
References: <1462389951-29439-1-git-send-email-tytso@mit.edu>
 <1462389951-29439-2-git-send-email-tytso@mit.edu>
 <2563613.fjdkC65vSW@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, cryptography@lakedaemon.net, jsd@av8n.com,
	hpa@zytor.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48036 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbcEEBKR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 21:10:17 -0400
Content-Disposition: inline
In-Reply-To: <2563613.fjdkC65vSW@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 10:28:24PM +0200, Stephan Mueller wrote:
> > +out:
> > +	spin_unlock_irqrestore(&primary_crng.lock, flags);
> > +	return ret;
> 
> Where did you add the memzero_explict of tmp?

Oops, sorry, somehow that change got lost in the patch updates.  Fixed now.

      	     	     	  	     - Ted
