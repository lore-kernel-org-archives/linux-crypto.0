From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] drivers/crypto:caam:Map src buffer before access in CAAM
 driver
Date: Wed, 11 Sep 2013 15:54:28 +0300
Message-ID: <52306804.1070602@freescale.com>
References: <1378879346-24500-1-git-send-email-Yashpal.Dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: <Yashpal.Dutta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:13012
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab3IKMyo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Sep 2013 08:54:44 -0400
Received: from mail32-va3 (localhost [127.0.0.1])	by mail32-va3-R.bigfish.com
 (Postfix) with ESMTP id CECC5380122	for <linux-crypto@vger.kernel.org>; Wed,
 11 Sep 2013 12:54:42 +0000 (UTC)
Received: from VA3EHSMHS033.bigfish.com (unknown [10.7.14.239])	by
 mail32-va3.bigfish.com (Postfix) with ESMTP id A4E47180064	for
 <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2013 12:54:41 +0000 (UTC)
In-Reply-To: <1378879346-24500-1-git-send-email-Yashpal.Dutta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/11/2013 9:02 AM, Yashpal.Dutta@freescale.com wrote:
> From: Yashpal Dutta <yashpal.dutta@freescale.com>
>
> KMap the buffers before copying trailing bytes during hmac in CAAM driver into a
> session temporary buffer. This is required if pinned buffer from user-space
> is send to CAAM driver during hmac and is safe even if hmac request is generated
> from within kernel.
>
> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
> ---

Subject not consistent with previous caam driver commits. Prefix should 
be "crypto: caam - ".
I would drop the "in CAAM driver" since it's redundant - the prefix 
already mentions this.

> @@ -124,15 +139,15 @@ static inline void sg_copy(u8 *dest, struct scatterlist *sg, unsigned int len)
>   	int cpy_index = 0, next_cpy_index = current_sg->length;
>   
>   	while (next_cpy_index < len) {
> -		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
> -		       current_sg->length);
> +		sg_map_copy(dest + cpy_index, current_sg, current_sg->length,
> +				current_sg->offset);

CHECK: Alignment should match open parenthesis
#49: FILE: drivers/crypto/caam/sg_sw_sec4.h:143:
+               sg_map_copy(dest + cpy_index, current_sg, 
current_sg->length,
+                               current_sg->offset);

>   		current_sg = scatterwalk_sg_next(current_sg);
>   		cpy_index = next_cpy_index;
>   		next_cpy_index += current_sg->length;
>   	}
>   	if (cpy_index < len)
> -		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
> -		       len - cpy_index);
> +		sg_map_copy(dest + cpy_index, current_sg, len-cpy_index,
> +				current_sg->offset);

CHECK: Alignment should match open parenthesis
#58: FILE: drivers/crypto/caam/sg_sw_sec4.h:150:
+               sg_map_copy(dest + cpy_index, current_sg, len-cpy_index,
+                               current_sg->offset);
