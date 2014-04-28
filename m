From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: user - Allow CRYPTO_MSG_GETALG without CAP_NET_ADMIN
Date: Mon, 28 Apr 2014 23:37:34 +0200
Message-ID: <201404282337.34142.marex@denx.de>
References: <534016A0.6020702@mirix.org> <5359955A.4070903@mirix.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Matthias-Christian Ott" <ott@mirix.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:47435 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaD1VwM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Apr 2014 17:52:12 -0400
In-Reply-To: <5359955A.4070903@mirix.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, April 25, 2014 at 12:51:06 AM, Matthias-Christian Ott wrote:
> CRYPTO_USER requires CAP_NET_ADMIN for all operations. Most information
> provided by CRYPTO_MSG_GETALG is also accessible through /proc/modules
> and AF_ALG. CRYPTO_MSG_GETALG should not require CAP_NET_ADMIN so that
> processes without CAP_NET_ADMIN can use CRYPTO_MSG_GETALG to get cipher
> details, such as cipher priorities, for AF_ALG.
> 
> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
> ---
>  crypto/crypto_user.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Can you please submit the patch using git send-email so we can properly review 
it?

Thank you !

Best regards,
Marek Vasut
