From: Uri Simchoni <uri@jdland.co.il>
Subject: Re: Bug#552270: Marvell CESA driver and Kirkwood
Date: Thu, 22 Apr 2010 06:23:12 +0300
Message-ID: <4BCFC120.5010306@jdland.co.il>
References: <4B12F9E7.1020207@gmail.com> <20091130211531.GK18101@deprecation.cyrius.com> <4B144627.7060901@gmail.com> <20091204212847.GC28480@deprecation.cyrius.com> <4BCB4009.70707@gmail.com> <20100418191719.GA2508@Chamillionaire.breakpoint.cc> <4BCE125F.30200@gmail.com> <20100421081302.GB31506@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "L.C." <lucorsel@gmail.com>, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:58929 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0DVDXU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Apr 2010 23:23:20 -0400
In-Reply-To: <20100421081302.GB31506@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I have some IPSec background but am not familiar with the Linux implementation (I'm using the mv_cesa for SSL acceleration through a usermode interface I'm working on). Can you point me to the nearest howto? I suppose I could have a look.
Thanks,
Uri.

On 4/21/2010 11:13 AM, Sebastian Andrzej Siewior wrote:
> * L.C. | 2010-04-20 22:45:19 [+0200]:
> 
>> Sebastian, here is the OOPS from the latest cryptodev git tree
>> (2.6.33), more clue than I thought, it looks?:
> 
> No I don't. I look at it this weekend. I need just to setup IPsec in
> order to reproduce this, right?
> 
>> ------------------------------------cut
>> flip> ping 10.10.10.230
>> PING 10.10.10.23[51252.081262] Unable to handle kernel NULL pointer
>> dereference at virtual address 00000034
>> 0 (10.10.10.230)[51252.090530] pgd = c0004000
>> 56(84) bytes of[51252.094632] [00000034] *pgd=00000000 data.
>>
<snip>
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

