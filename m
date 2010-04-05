From: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 5/7] net/wireless: switch lib80211_crypt_wep from arc4
	to arc4blk
Date: Mon, 5 Apr 2010 13:13:36 -0400
Message-ID: <20100405171336.GB29596@tuxdriver.com>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-6-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45727 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab0DERPJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Apr 2010 13:15:09 -0400
Content-Disposition: inline
In-Reply-To: <1270280969-11357-6-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 03, 2010 at 09:49:27AM +0200, Sebastian Andrzej Siewior wrote:
> ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself. The
> required selects are now pulled in by LIB80211_CRYPT_WEP instead of
> selecting it by every driver. Since there is no dependency on ecb and arc4
> therr are removed from the idividual driver.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Fine by me...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
