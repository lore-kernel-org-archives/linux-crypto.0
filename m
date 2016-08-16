From: Stephan Mueller <smueller@chronox.de>
Subject: Re: RSA key size not allowed in FIPS
Date: Tue, 16 Aug 2016 11:33:14 +0200
Message-ID: <2453784.ib1sbOJlK4@tauon.atsec.com>
References: <D3CF4E8C.2883%tsarangi@trustwave.com> <D3CF5455.2887%tsarangi@trustwave.com> <21317106.O9C0GvNNQc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: dhowells@redhat.com,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36466 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbcHPJdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:33:17 -0400
In-Reply-To: <21317106.O9C0GvNNQc@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 16:55:52 CEST schrieb Stephan Mueller:

Hi Tapas, David,
> 
> David, the x509.genkey file seems to generate a 4k RSA key per default. This
> will cause a panic with fips=1 as only 2k and 3k keys are allowed.

Just yesterday, a new ruling came out from NIST allowing any key size >= 2048 
provided that at least either 2048 or 3072 is a usable key size to allow CAVS 
testing.

I will send a patch that changes this in the code.

Thanks
Stephan
