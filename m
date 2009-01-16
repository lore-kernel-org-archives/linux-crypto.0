From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Fri, 16 Jan 2009 14:31:05 +1100
Message-ID: <20090116033105.GB10390@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58984 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751699AbZAPDbJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 22:31:09 -0500
Content-Disposition: inline
In-Reply-To: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 16, 2009 at 11:10:36AM +0800, Huang Ying wrote:
> 
> The scalability of current cryptd implementation is not good. So a
> per-CPU cryptd kthread implementation is necessary. The per-CPU kthread
> pool implementation need to consider many issues such as CPU hotplug, so
> I suggest to base cryptd kthread implementation on workqueue, that is,
> create a dedicate workqueue for crypto subsystem. This way, chainiv can
> use this crypto workqueue too.

Yes that sounds like a great idea.

> I will implement it if you have no plan to do it yourself.

Please do.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
