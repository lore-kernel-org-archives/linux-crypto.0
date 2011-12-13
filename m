From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag.
Date: Tue, 13 Dec 2011 09:54:45 +0100
Message-ID: <4EE712D5.9060200@gnutls.org>
References: <4EE4A172.9010308@gnutls.org> <20111212144309.5c1db15ae58ad5167cddb6ec@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34778 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1LMIvx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 03:51:53 -0500
Received: by eekc4 with SMTP id c4so2001776eek.19
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2011 00:51:52 -0800 (PST)
In-Reply-To: <20111212144309.5c1db15ae58ad5167cddb6ec@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/12/2011 09:43 PM, Kim Phillips wrote:


> This appears to be based on an older version of the current master
> of Herbert's cryptodev tree on github [1] - it's missing the hmac
> algorithms introduced in commit 79b3a41 "crypto: talitos - add hmac
> algorithms", and a caam entry is missing (it's an offload engine,
> just like talitos). Something like:


Thanks, I've resubmitted with your patch included.

regards,
Nikos
