From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Tue, 15 Mar 2016 13:28:01 +0100
Message-ID: <20160315122801.GB3347@gauss.secunet.com>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
 <56CE22A3.7030702@alliedtelesis.co.nz>
 <20160304070525.GA3347@gauss.secunet.com>
 <56E73285.5000702@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:52116 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934666AbcCOM2H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2016 08:28:07 -0400
Content-Disposition: inline
In-Reply-To: <56E73285.5000702@alliedtelesis.co.nz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 14, 2016 at 09:52:05PM +0000, Mark McKinstry wrote:
> Your patch adds a dst_release() call to my suggested fix, but this is 
> problematic because the kfree_skb() call at tx_error already takes care 
> of releasing dst - via kfree_skb() > __kfree_skb() > skb_release_all() > 
> skb_release_head_state() > skb_dst_drop()
>  > refdst_drop() > dst_release(). In our scenario your patch results in 
> a negative refcount kernel warning being generated in dst_release() for 
> every packet that is too big to go over the vti.

Hm. I've just noticed that my pmtu test does not trigger this
codepath, so I did not see the warning.

Seems like we do the pmtu handling too late, it should happen before
we do skb_dst_set(). Also skb_scrub_packet() resets skb->ignore_df,
so checking ignore_df after skb_scrub_packet() does not make much sense.

I'll send an updated version after some more testing.
