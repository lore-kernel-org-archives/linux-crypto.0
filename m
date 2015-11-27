From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: mxs-dcp - Initialize .statesize fields
Date: Fri, 27 Nov 2015 15:25:22 +0100
Message-ID: <5269835.Et7mvBlT7h@tauon.atsec.com>
References: <1448552861-17410-1-git-send-email-fabio.estevam@freescale.com> <20151127125239.GA29303@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Fabio Estevam <fabio.estevam@freescale.com>, marex@denx.de,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35878 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbK0OZZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 09:25:25 -0500
In-Reply-To: <20151127125239.GA29303@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 27. November 2015, 20:52:39 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Nov 26, 2015 at 01:47:41PM -0200, Fabio Estevam wrote:
>> Initialize .statesize fields in order to avoid the following error
>> on probe:
>> 
>> mxs-dcp 80028000.dcp: Failed to register sha1 hash!
>> mxs-dcp: probe of 80028000.dcp failed with error -22
>> 
>> Cc: <stable@vger.kernel.org> # 4.1+
>> Suggested-by: Stephan Mueller <smueller@chronox.de>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
>It's not as simple as that.  You must implement import and export
>for it before we can turn it back on.

May I ask you for a brief reference on how that should be covered so that we 
can fix all other problematic implementations?

Thanks
Stephan
