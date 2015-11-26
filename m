From: Stephan Mueller <smueller@chronox.de>
Subject: Re: ghash-clmulni: does not load
Date: Thu, 26 Nov 2015 15:18:44 +0100
Message-ID: <1504432.E8Z6Cz7sm5@tauon.atsec.com>
References: <4267678.SA4Iv35LnJ@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34592 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbbKZOSw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 09:18:52 -0500
In-Reply-To: <4267678.SA4Iv35LnJ@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. November 2015, 13:45:26 schrieb Stephan Mueller:

Hi,

>Hi Tadeusz,
>
>testing the current cryptodev-2.6 tree, ghash-clmulni does not load. In the
>init function
>
>	err = crypto_register_ahash(&ghash_async_alg);
>
>returns EINVAL.

It looks like the halg.statesize is missing. When I add that field, the insmod 
works. But I do not know which statesize is needed to provide a full patch.


Ciao
Stephan
