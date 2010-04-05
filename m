From: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 6/7] net/mac80211: convert wep from arc4 to arc4blk
Date: Mon, 5 Apr 2010 13:15:06 -0400
Message-ID: <20100405171506.GC29596@tuxdriver.com>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-7-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43965 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0DERaJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Apr 2010 13:30:09 -0400
Content-Disposition: inline
In-Reply-To: <1270280969-11357-7-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 03, 2010 at 09:49:28AM +0200, Sebastian Andrzej Siewior wrote:
> ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Seems ok to me...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
