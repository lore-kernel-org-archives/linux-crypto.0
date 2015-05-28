From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Thu, 28 May 2015 20:27:15 +0200
Message-ID: <201505282027.15827.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <201505080220.56630.marex@denx.de> <55673BF4.3040108@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	herbert@gondor.apana.org.au
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:53111 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbbE1S1T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 14:27:19 -0400
In-Reply-To: <55673BF4.3040108@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, May 28, 2015 at 06:01:56 PM, Jay Monkman wrote:
> Marek,

Hi,

note that this discussion should really happen on the linux-crypto ML.
Moving the discussion to ML.

> I have a question about the proper way to implement a feature. The DCP
> has the ability to read a key for encryption/decryption from on chip
> fuses. The current driver doesn't support this and as far as I can tell,
> there's no clean way to do that within the Linux crypto API.
> 
> Do you have any suggestions on how to handle that?
> 
> My best idea so far is to modify the driver so that if setkey is passed
> a key with a length of 1 byte, the driver uses the on chip key. I'm not
> sure if that would make it into the official kernel.

What about defining CRYPTO_TFM_REQ_CPU_KEY and then notifying the MXS DCP
code to pick the key from CPU by doing something like this in your code:

crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_CPU_KEY);

I _think_ this might be the way to go. Do a git grep on CRYPTO_TFM_REQ to
get some usecases on the TFM flags.

Best regards,
Marek Vasut
