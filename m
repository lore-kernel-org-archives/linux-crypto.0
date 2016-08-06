From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] KEYS: add SP800-56A KDF support for DH
Date: Sat, 06 Aug 2016 08:33:54 +0200
Message-ID: <1674739.yHBNX4Wynu@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <7993056.4BOhkDi2U3@positron.chronox.de> <alpine.OSX.2.20.1608050858270.69454@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34180 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbcHFUm7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Aug 2016 16:42:59 -0400
In-Reply-To: <alpine.OSX.2.20.1608050858270.69454@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 5. August 2016, 09:08:59 CEST schrieb Mat Martineau:

Hi Mat,

> > 
> > When trying to implement it, I think that it would even be more confusing,
> > because we need a conditional in any case. Do you like
> > 
> > return __keyctl_dh_compute(params, buffer, buflen, (kdf) ? &kdfcopy :
> > NULL);
> > 
> > better than the already presented code? Besides, this would now imply that
> > we have two conditionals instead of one.
> 
> Another approach that uses one conditional is to add a struct
> keyctl_kdf_params* variable and assign it in the conditional block. Maybe
> that's not much of a win, it's up to you.

To be honest, I like the code as is, because although you have two 
invocations, it is yet just a few lines in size and thus readable and second 
either my suggestion or yours with the additional variable implies one or more 
additional instructions (yes, I know, this should not matter too much, but 
still ... ).

Ciao
Stephan
