From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: testmgr - add aead cbc des, des3_ede tests.
Date: Wed, 27 Feb 2013 18:08:02 +0200
Message-ID: <512E2F62.8090609@freescale.com>
References: <1357715865-10357-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:25157
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981Ab3B0QIM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2013 11:08:12 -0500
Received: from mail234-va3 (localhost [127.0.0.1])	by
 mail234-va3-R.bigfish.com (Postfix) with ESMTP id 2E0337C04EA	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:08:11 +0000 (UTC)
Received: from VA3EHSMHS030.bigfish.com (unknown [10.7.14.236])	by
 mail234-va3.bigfish.com (Postfix) with ESMTP id EB7B438008E	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:08:06 +0000 (UTC)
In-Reply-To: <1357715865-10357-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/9/2013 9:17 AM, Vakul Garg wrote:
> Test vectors were taken from existing test for CBC(DES3_EDE).
> Associated data has been added to test vectors.
> HMAC computed with Crypto++ has been used.
> Following algos have been covered.
>
> 	(a) "authenc(hmac(sha1),cbc(des))"
> 	(b) "authenc(hmac(sha1),cbc(des3_ede))"
> 	(c) "authenc(hmac(sha224),cbc(des))"
> 	(d) "authenc(hmac(sha224),cbc(des3_ede))"
> 	(e) "authenc(hmac(sha256),cbc(des))"
> 	(f) "authenc(hmac(sha256),cbc(des3_ede))"
> 	(g) "authenc(hmac(sha384),cbc(des))"
> 	(h) "authenc(hmac(sha384),cbc(des3_ede))"
> 	(i) "authenc(hmac(sha512),cbc(des))"
> 	(j) "authenc(hmac(sha512),cbc(des3_ede))"
>
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
>   crypto/testmgr.c |  120 ++++++++++
>   crypto/testmgr.h |  647 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 767 insertions(+), 0 deletions(-)

A good idea would be to cross-check by verifying that both caam and 
talitos pass these builtin tests, if you haven't done so already.
If you have other platforms at hand, the more the better.

Some time ago I wanted to add support for cbc(des), but Kim argued it 
ain't worth the effort due to low interest in des algo. But since you 
already did the work and submitted the patch, I guess it's fine.

Regards,
Horia
