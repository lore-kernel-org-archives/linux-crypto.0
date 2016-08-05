From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] KEYS: add SP800-56A KDF support for DH
Date: Fri, 05 Aug 2016 09:10:35 +0200
Message-ID: <7993056.4BOhkDi2U3@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <alpine.OSX.2.20.1608041258050.55029@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34024 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030361AbcHEHKt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 03:10:49 -0400
In-Reply-To: <alpine.OSX.2.20.1608041258050.55029@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 4. August 2016, 13:41:58 CEST schrieb Mat Martineau:

Hi Mat,

> > +
> > +long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> > +		       char __user *buffer, size_t buflen,
> > +		       struct keyctl_kdf_params __user *kdf)
> > +{
> > +	struct keyctl_kdf_params kdfcopy;
> > +
> > +	if (!kdf)
> > +		return __keyctl_dh_compute(params, buffer, buflen, NULL);
> > +
> > +	if (copy_from_user(&kdfcopy, kdf, sizeof(kdfcopy)) != 0)
> > +		return -EFAULT;
> > +
> > +	return __keyctl_dh_compute(params, buffer, buflen, &kdfcopy);
> 
> I'd find this more readable if there was one call to __keyctl_dh_compute.

When trying to implement it, I think that it would even be more confusing, 
because we need a conditional in any case. Do you like

return __keyctl_dh_compute(params, buffer, buflen, (kdf) ? &kdfcopy : NULL);

better than the already presented code? Besides, this would now imply that we 
have two conditionals instead of one.

Ciao
Stephan
