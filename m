From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: XTS - remove test that will fail in FIPS mode
Date: Fri, 12 Aug 2016 10:43:35 +0200
Message-ID: <43267171.xBbHY8HyGv@tauon.atsec.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com> <D3D10E85.2F74%tsarangi@trustwave.com> <D3D23ED9.2F9C%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35118 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbcHLIni (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Aug 2016 04:43:38 -0400
In-Reply-To: <D3D23ED9.2F9C%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. August 2016, 19:42:54 CEST schrieb Tapas Sarangi:

Hi Tapas,

> Hi Stephan,
> 
> Any other ideas about this problem ? Since XTS is not amongst the
> self-tests as you observed, is it safe to disable .fips_allowed for
> xts(aes) in testmgr.c ?

If you do that, none of your XTS implementations will be allowed and work in 
FIPS mode. The thing is that I cannot reproduce the issue (yet). I am still 
looking.

Ciao
Stephan
