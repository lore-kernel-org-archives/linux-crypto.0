From: Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Wed, 25 Feb 2009 10:07:35 +0100
Message-ID: <20090225090735.GA6283@elara.bln.innominate.local>
References: <49A2E421.5050806@hiramoto.org> <49A3F3FA.1000801@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, chohnstaedt@innominate.com,
	LKML <linux-kernel@vger.kernel.org>
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:51829 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760519AbZBYJHj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 04:07:39 -0500
Content-Disposition: inline
In-Reply-To: <49A3F3FA.1000801@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 24, 2009 at 02:19:54PM +0100, Karl Hiramoto wrote:
> The latest thing i found is  kernel BUG at lib/scatterlist.c:26!
> 
> ping -s 1800  host in a IPSec tunnel.  Setup is   802.1Q VLAN  --> 
> ixp4xx_eth  --> IPSec Tunnel
> 
> trace with   some   debug printk's  i added.    printk("%s:%d  
> values",__func__, __LINE__);
> 
> 
> [42949542.170000] esp_output:142 skb->len=1828 data_len=328 clen=1832 alen=0 blksize=8  skb=c7a5cb40 data=c79ba054
> [42949542.180000] esp_output:168 skb=c7a5cb40 data=c79ba054 clone=0
> [42949542.180000] __skb_to_sgvec:2430 skb=c7a5cb40 data=c79ba030 sg=c78a0324 off=36 len=1832
> [42949542.190000] __skb_to_sgvec:2477 list=c795a0c0 start=1536  end=1868 list->len=332 offset=1536
> [42949542.200000] __skb_to_sgvec:2430 skb=c795a0c0 data=c6d8f048 sg=c78a0338 off=0 len=332
> [42949542.210000] __skb_to_sgvec:2484 len==0 elt=2
> [42949542.210000] esp_output:218 skb=c7a5cb40 data=c79ba030
> [42949542.220000] esp_output:228 skb=c7a5cb40 data=c79ba030
> [42949542.230000] ablk_perform:897 ivsize=8 nbytes=1840
> [42949542.230000] ablk_perform:919 dst=NULL src=c78a0278
> [42949542.240000] count_sg:757 i=0 nbytes=1840 sg=c78a0278  sg_next(sg)=c78a028c
> [42949542.240000] count_sg:758 len=1508 sg_is_last(sg)=0
> [42949542.250000] count_sg:757 i=1 nbytes=332 sg=c78a028c  sg_next(sg)=c78a02a0
> [42949542.250000] count_sg:758 len=0 sg_is_last(sg)=0
> [42949542.260000] kernel BUG at lib/scatterlist.c:26!
> [42949542.260000] Unable to handle kernel NULL pointer dereference at virtual address 00000000

This differs from the issue you mentioned first.
The first one was in "dma_cache_maint".

Are you sure, your printk()s don't have any side effect ?

Christian

-- 
The decline of the Roman Empire can be traced to the fact that, lacking
zero, they were unable to return from their C programs.
