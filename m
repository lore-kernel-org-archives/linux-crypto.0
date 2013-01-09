From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - Fix missing init of '.type' in AEAD
 algos.
Date: Wed, 9 Jan 2013 15:46:48 -0600
Message-ID: <20130109154648.a2a56a61d32e1506d7b8782c@freescale.com>
References: <1357558099-4603-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:56634
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894Ab3AIVty (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jan 2013 16:49:54 -0500
Received: from mail13-db3 (localhost [127.0.0.1])	by mail13-db3-R.bigfish.com
 (Postfix) with ESMTP id D45893003F6	for <linux-crypto@vger.kernel.org>; Wed,
  9 Jan 2013 21:49:52 +0000 (UTC)
Received: from DB3EHSMHS006.bigfish.com (unknown [10.3.81.232])	by
 mail13-db3.bigfish.com (Postfix) with ESMTP id 405E026021A	for
 <linux-crypto@vger.kernel.org>; Wed,  9 Jan 2013 21:49:21 +0000 (UTC)
In-Reply-To: <1357558099-4603-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 7 Jan 2013 16:58:19 +0530
Vakul Garg <vakul@freescale.com> wrote:

> Following AEAD algo templates are updated for '.type' initialization.
> 	(a) authenc(hmac(sha224),cbc(aes))
> 	(b) authenc(hmac(sha384),cbc(aes))
> 	(c) authenc(hmac(sha224),cbc(des3_ede))
> 	(d) authenc(hmac(sha384),cbc(des3_ede))
> 	(e) authenc(hmac(sha224),cbc(des))
> 	(f) authenc(hmac(sha384),cbc(des))
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Kim
