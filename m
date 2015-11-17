From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] nx-842: Ignore bit 3 of condition register returned by
 icswx
Date: Tue, 17 Nov 2015 22:00:20 +0800
Message-ID: <20151117140020.GA9546@gondor.apana.org.au>
References: <20151030224301.GA22549@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	ddstreet@ieee.org, hbabu@us.ibm.com
To: Ram Pai <linuxram@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33739 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbbKQOA0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 09:00:26 -0500
Content-Disposition: inline
In-Reply-To: <20151030224301.GA22549@ram.oc3035372033.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2015 at 03:43:01PM -0700, Ram Pai wrote:
> icswx occasionally under heavy load sets bit 3 of condition register 0.
> It has no software implication.
> 
> Currently that bit is interpreted by the driver as a failure, when
> it should have calmly ignored it.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>

Your patch is corrupted:

$ patch -s -p1 < .git/rebase-apply/patch 
patch: **** malformed patch at line 21: To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
$
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
