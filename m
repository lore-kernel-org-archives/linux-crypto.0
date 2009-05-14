From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Thu, 14 May 2009 08:48:39 -0400
Message-ID: <200905140848.40553.jarod@redhat.com>
References: <200905111006.32675.jarod@redhat.com> <200905131253.16977.jarod@redhat.com> <20090513234550.GA24792@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55418 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZENMt2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 May 2009 08:49:28 -0400
In-Reply-To: <20090513234550.GA24792@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 13 May 2009 19:45:50 Herbert Xu wrote:
> On Wed, May 13, 2009 at 12:53:16PM -0400, Jarod Wilson wrote:
> > 
> > It would likely need a LOT of polish, and I'm not sure if its at all
> > close to what we have (Herbert has?) in mind.... At the moment, it
> > consists of:
> 
> The interface I had in mind can be found in the recent discussions
> in the linux-crypto archives.

Ah, sorry, I found it. So pretty much absolutely nothing like the
netlink-based stuff I've done. :) I'll go further familiarize
myself with the proposed patch...

-- 
Jarod Wilson
jarod@redhat.com
