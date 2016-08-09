From: Stephan Mueller <smueller@chronox.de>
Subject: Re: FIPS mode: modprobe: ERROR: could not insert 'drbg'
Date: Tue, 09 Aug 2016 19:05:50 +0200
Message-ID: <1699099.iu8Xr4xQ6X@tauon.atsec.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34414 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbcHIRFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 13:05:53 -0400
In-Reply-To: <D3CF7065.28F3%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 16:34:59 CEST schrieb Tapas Sarangi:

Hi Tapas,

> Hi Stephan,
> 
> Following up from the other thread:
> 
> While trying to boot in FIPS mode, kernel panics with the following
> message. So far, I don¹t have success to get more information about which
> module or symbol is causing this. I haven¹t found any errors or warnings
> in kernel compilation. It boots fine in a non-fips mode.
> 
> I am also pasting the CRYPTO related configs that I have enabled (See
> below).

I do not see the issue immediately. Could you boot without fips=1 and do a 
modprobe drbg ?

I am also testing fips=1 now.

Ciao
Stephan
