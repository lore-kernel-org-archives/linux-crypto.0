From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix leak on error path
Date: Wed, 17 Feb 2016 07:46:38 +0000
Message-ID: <20160217074638.GA16041@gondor.apana.org.au>
References: <1455145184-5610-1-git-send-email-tadeusz.struk@intel.com>
 <20160216202046.GD11908@gondor.apana.org.au>
 <56C38537.109@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52918 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbcBQHqr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Feb 2016 02:46:47 -0500
Content-Disposition: inline
In-Reply-To: <56C38537.109@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2016 at 12:23:19PM -0800, Tadeusz Struk wrote:
> On 02/16/2016 12:20 PM, Herbert Xu wrote:
> > On Wed, Feb 10, 2016 at 02:59:44PM -0800, Tadeusz Struk wrote:
> >> > Fix a leak on error path in qat asym
> >> > 
> >> > Reported-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> >> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> > Appiled.
> 
> Thanks Herbert, should we also push it to stable?

I don't think it is serious enough to warrant going in immediately.
We can push it once the next merge window opens up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
