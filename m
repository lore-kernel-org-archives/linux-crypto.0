From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 13:58:25 -0400
Message-ID: <20150318175825.GE5663@thunk.org>
References: <20150318095345.GA12923@zoho.com>
 <1712478.ujdQuuIYol@tauon>
 <1426681147.2164835.241982149.0C3DD661@webmail.messagingengine.com>
 <1867652.j97RWRfxn1@tauon>
 <550972A7.9030100@iogearbox.net>
 <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
 <20150318174136.GD5663@thunk.org>
 <1426701379.2258085.242143049.7A720D00@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Stephan Mueller <smueller@chronox.de>,
	mancha <mancha1@zoho.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47542 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbbCRR6z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 13:58:55 -0400
Content-Disposition: inline
In-Reply-To: <1426701379.2258085.242143049.7A720D00@webmail.messagingengine.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 18, 2015 at 06:56:19PM +0100, Hannes Frederic Sowa wrote:
> 
> Maybe a BUILD_BUGON: ;)

Even better!  :-)

				- Ted

> 
> __label__ l1, l2;
> char buffer[1024];
> l1:
>     memset(buffer, 0, 1024);
> l2:
>   BUILD_BUGON(&&l1 == &&l2);
> 
