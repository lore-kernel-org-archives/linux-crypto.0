From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: testmgr - add aead cbc aes hmac sha384 test vectors
Date: Wed, 27 Feb 2013 18:08:46 +0200
Message-ID: <512E2F8E.6040706@freescale.com>
References: <1357620546-25192-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:16013
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab3B0QIy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2013 11:08:54 -0500
Received: from mail23-am1 (localhost [127.0.0.1])	by mail23-am1-R.bigfish.com
 (Postfix) with ESMTP id E2B9E320062	for <linux-crypto@vger.kernel.org>; Wed,
 27 Feb 2013 16:08:52 +0000 (UTC)
Received: from AM1EHSMHS016.bigfish.com (unknown [10.3.201.244])	by
 mail23-am1.bigfish.com (Postfix) with ESMTP id 2DC8A3E057D	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:08:51 +0000 (UTC)
In-Reply-To: <1357620546-25192-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/8/2013 6:49 AM, Vakul Garg wrote:
> Test vectors were generated starting from existing CBC(AES) test vectors
> (RFC3602, NIST SP800-38A) and adding HMAC(SHA384) computed with Crypto++ and
> double-checked with HashCalc.
>
> Signed-off-by: Vakul Garg <vakul@freescale.com>

Acked-by: Horia Geanta <horia.geanta@freescale.com>
