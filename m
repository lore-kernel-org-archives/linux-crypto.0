From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] hw_random: bcm63xx-rng: misc cleanups and reorg
Date: Sun, 1 Mar 2015 23:03:57 +1300
Message-ID: <20150301100357.GA16444@gondor.apana.org.au>
References: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mips@linux-mips.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, mpm@selenic.com, wsa@the-dreams.de,
	cernekee@gmail.com
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52873 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbCAKFT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 05:05:19 -0500
Content-Disposition: inline
In-Reply-To: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 16, 2015 at 06:09:12PM -0800, Florian Fainelli wrote:
> Hi,
> 
> This patchset prepares the driver to be built on non-MIPS bcm63xx architectures
> such as the ARM bcm63xx variants, thanks!
> 
> Although patch 3 touches a MIPS header file, there should be little to no
> conflicts there if all patches went through the hw_random tree (is there one?)

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
