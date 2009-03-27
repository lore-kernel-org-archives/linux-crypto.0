From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] shash: fix unaligned calculation with short length
Date: Fri, 27 Mar 2009 13:04:25 +0800
Message-ID: <20090327050424.GB26198@gondor.apana.org.au>
References: <1238101941-12859-1-git-send-email-yehuda@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Yehuda Sadeh <yehuda@hq.newdream.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48213 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751702AbZC0FE2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 01:04:28 -0400
Content-Disposition: inline
In-Reply-To: <1238101941-12859-1-git-send-email-yehuda@hq.newdream.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 26, 2009 at 02:12:21PM -0700, Yehuda Sadeh wrote:
> When the total length is shorter than the calculated number of unaligned bytes, the call to shash->update breaks. For example, calling crc32c on unaligned buffer with length of 1 can result in a system crash.
> 
> Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>

Ouch! Thanks for fixing this!  Applied to crpyto-2.6.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
