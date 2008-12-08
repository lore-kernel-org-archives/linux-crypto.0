From: James Hsiao <jhsiao@amcc.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v4]
Date: Mon, 08 Dec 2008 13:55:07 -0800
Message-ID: <1228773307.4906.14.camel@jhsiao-usb>
References: <1228256232.4770.47.camel@jhsiao-usb>
	 <20081204193256.12dbc306.kim.phillips@freescale.com>
Reply-To: jhsiao@amcc.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:14470 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYLHVys (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 16:54:48 -0500
In-Reply-To: <20081204193256.12dbc306.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim,


>> +     /* figure how many gd is needed */
>> +     if (aad_len) {
>> +             num_gd = get_sg_count(assoc, aad_len) +
>> +                     get_sg_count(src, datalen);

> this is dead code - aad_len is never non-zero - is there some code
> missing from crypto4xx_alg.c?  Also, IIRC, assoc is a superset of src,
> so I believe something like num_gd = get_sg_count(assoc, aad_len +
> datalen) would work better - this should also permit removal of the
> nbytes reached check in [1] in get_sg_count.

For the get num_gd, assoc and src are two different scatter_lists. One
for the packet and one for the aad, so, it makes more sense to me to
count them seperately. Yes?

The way to driver pass aad and aad_len is from crypto4xx_build_pd. 
This aad support will be used in the future. Do you want me to remover
from the current release?  The reason I have it in, is to avoid too much
code change for the future release.


Thanks

James

