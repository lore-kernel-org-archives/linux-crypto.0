From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] nx-842: Ignore bit 3 of condition register returned by
 icswx
Date: Tue, 17 Nov 2015 11:06:29 -0800
Message-ID: <20151117190629.GB6795@ram.oc3035372033.ibm.com>
References: <20151030224301.GA22549@ram.oc3035372033.ibm.com>
 <20151117140020.GA9546@gondor.apana.org.au>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	ddstreet@ieee.org, hbabu@us.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:40991 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbKQTGk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 14:06:40 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <linuxram@us.ibm.com>;
	Tue, 17 Nov 2015 14:06:39 -0500
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 26F7B38C803B
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2015 14:06:37 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAHJ6aHT58851540
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2015 19:06:36 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAHJ6Zag025768
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2015 14:06:36 -0500
Content-Disposition: inline
In-Reply-To: <20151117140020.GA9546@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 17, 2015 at 10:00:20PM +0800, Herbert Xu wrote:
> On Fri, Oct 30, 2015 at 03:43:01PM -0700, Ram Pai wrote:
> > icswx occasionally under heavy load sets bit 3 of condition register 0.
> > It has no software implication.
> > 
> > Currently that bit is interpreted by the driver as a failure, when
> > it should have calmly ignored it.
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> 
> Your patch is corrupted:
> 
> $ patch -s -p1 < .git/rebase-apply/patch 
> patch: **** malformed patch at line 21: To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> $

Herbert, There were some comments about the patch on the ppc mailing
list.  

There are times this bit could be set and could be used by its
consumers; depending on how the RFC is implemented by the hardware. The
RFC does allow the hardware to assign meaning to that bit; though no
hardware currently exploits that feature. However from a software point
of view, we probably should not ignore the bit entirely. So please
ignore this patch till we come with a better solution.

RP

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Ram Pai
