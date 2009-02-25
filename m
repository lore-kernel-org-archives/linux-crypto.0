From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Wed, 25 Feb 2009 10:36:11 +0100
Message-ID: <49A5110B.2050803@hiramoto.org>
References: <49A2E421.5050806@hiramoto.org> <49A3F3FA.1000801@hiramoto.org> <20090225090735.GA6283@elara.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Christian Hohnstaedt <chohnstaedt@innominate.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:59095 "EHLO
	spunkymail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752336AbZBYJgc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 04:36:32 -0500
In-Reply-To: <20090225090735.GA6283@elara.bln.innominate.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Hohnstaedt wrote:
> On Tue, Feb 24, 2009 at 02:19:54PM +0100, Karl Hiramoto wrote:
>   
>> The latest thing i found is  kernel BUG at lib/scatterlist.c:26!
>>
>> ping -s 1800  host in a IPSec tunnel.  Setup is   802.1Q VLAN  --> 
>> ixp4xx_eth  --> IPSec Tunnel
>>
>> trace with   some   debug printk's  i added.    printk("%s:%d  
>> values",__func__, __LINE__);
>>
>>
>> [42949542.170000] esp_output:142 skb->len=1828 data_len=328 clen=1832 alen=0 blksize=8  skb=c7a5cb40 data=c79ba054
>> [42949542.180000] esp_output:168 skb=c7a5cb40 data=c79ba054 clone=0
>> [42949542.180000] __skb_to_sgvec:2430 skb=c7a5cb40 data=c79ba030 sg=c78a0324 off=36 len=1832
>> [42949542.190000] __skb_to_sgvec:2477 list=c795a0c0 start=1536  end=1868 list->len=332 offset=1536
>> [42949542.200000] __skb_to_sgvec:2430 skb=c795a0c0 data=c6d8f048 sg=c78a0338 off=0 len=332
>> [42949542.210000] __skb_to_sgvec:2484 len==0 elt=2
>> [42949542.210000] esp_output:218 skb=c7a5cb40 data=c79ba030
>> [42949542.220000] esp_output:228 skb=c7a5cb40 data=c79ba030
>> [42949542.230000] ablk_perform:897 ivsize=8 nbytes=1840
>> [42949542.230000] ablk_perform:919 dst=NULL src=c78a0278
>> [42949542.240000] count_sg:757 i=0 nbytes=1840 sg=c78a0278  sg_next(sg)=c78a028c
>> [42949542.240000] count_sg:758 len=1508 sg_is_last(sg)=0
>> [42949542.250000] count_sg:757 i=1 nbytes=332 sg=c78a028c  sg_next(sg)=c78a02a0
>> [42949542.250000] count_sg:758 len=0 sg_is_last(sg)=0
>> [42949542.260000] kernel BUG at lib/scatterlist.c:26!
>> [42949542.260000] Unable to handle kernel NULL pointer dereference at virtual address 00000000
>>     
>
> This differs from the issue you mentioned first.
> The first one was in "dma_cache_maint".
>
>   
When i turned on CONFIG_DEBUG_SG    i hit the BUG()      call in the
scatterlist, instead of the dma_cache_maint..


One thing i've found, is with fragmented packets    in crypto/eseqiv.c 
eseqiv_chain()     scatterwalk_sg_chain(head, 2, sg);  is called  and 
the BUG() occurs.


> Are you sure, your printk()s don't have any side effect ?
>
>   
Don't think so, i tried taking them out  and had the same issue.  I'm
using pr_debug so undefine debug and take them out..

I've also reproduced the same issue.. in IPSec   transport and tunnel
modes, with and without vlans, using  3des-cbc  or aes-cbc


A simple config like below, and a ping -s 2000  will  create a IP
fragment and cause the BUG()


#!/usr/sbin/setkey -f

flush;
spdflush;

add 192.168.10.51 192.168.10.54 esp 0x101 -E aes-cbc
0x000102030405060708090a0b0c0d0e0f;
add 192.168.10.54 192.168.10.51 esp 0x201 -E aes-cbc
0x000102030405060708090a0b0c0d0e0f;

spdadd 192.168.10.51 192.168.10.54 any -P out ipsec
   esp/transport//require;






Thanks,

  Karl

