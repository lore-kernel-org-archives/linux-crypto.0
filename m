From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: tcrypt - removed unused variable.
Date: Wed, 27 Feb 2013 18:07:43 +0200
Message-ID: <512E2F4F.6030109@freescale.com>
References: <1358315331-29465-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:51529
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab3B0QHw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2013 11:07:52 -0500
Received: from mail69-am1 (localhost [127.0.0.1])	by mail69-am1-R.bigfish.com
 (Postfix) with ESMTP id E61B62A0079	for <linux-crypto@vger.kernel.org>; Wed,
 27 Feb 2013 16:07:50 +0000 (UTC)
Received: from AM1EHSMHS009.bigfish.com (unknown [10.3.201.234])	by
 mail69-am1.bigfish.com (Postfix) with ESMTP id 83D3E3C00B5	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:07:48 +0000 (UTC)
In-Reply-To: <1358315331-29465-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/16/2013 7:48 AM, Vakul Garg wrote:
> Removed unused variable for storing output string from:
>
> 	(a) test_ahash_jiffies_digest()
> 	(b) test_ahash_jiffies()
> 	(c) test_ahash_cycles_digest()
> 	(d) test_ahash_cycles()
>
> This variable is not needed in above functions since the caller function
> test_ahash_speed() already sets output buffer in the ahash transform using
> ahash_request_set_crypt().
>
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---

> @@ -519,14 +519,14 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
>   }
>
>   static int test_ahash_jiffies(struct ahash_request *req, int blen,
> -			      int plen, char *out, int sec)
> +			      int plen, int sec)
>   {
>   	unsigned long start, end;
>   	int bcount, pcount;
>   	int ret;
>
>   	if (plen == blen)
> -		return test_ahash_jiffies_digest(req, blen, out, sec);
> +		return test_ahash_jiffies_digest(req, blen, sec);
>
>   	for (start = jiffies, end = start + sec * HZ, bcount = 0;
>   	     time_before(jiffies, end); bcount++) {

You should also remove the deprecated comment in test_ahash_jiffies:
/* we assume there is enough space in 'out' for the result */

Regards,
Horia
