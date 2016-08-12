From: Stephan Mueller <smueller@chronox.de>
Subject: Re: FIPS self test failures (kernel panic) in kernel-4.7
Date: Fri, 12 Aug 2016 15:11:46 +0200
Message-ID: <14147393.J4OEbelQUo@tauon.atsec.com>
References: <D3D25E68.3066%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35202 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbcHLNLz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Aug 2016 09:11:55 -0400
In-Reply-To: <D3D25E68.3066%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. August 2016, 21:55:05 CEST schrieb Tapas Sarangi:

Hi Tapas,

> Hello,
> 
> A few algorithms are failing Œalg self tests' during kernel boot into FIPS
> mode (fips=1), causing a kernel panic (see below). I am using vanilla
> kernel-4.7 source for these tests.
> 
> These messages were from individual boots into FIPS mode, where algorithms
> are taken out from ".fips_allowed=1² and compiled.
> 
> Following (see below) is a patch to disable tests for some of these
> algorithms work and kernel could boot into FIPS mode (fips=1)
> successfully. Please Let me know if there is a deeper/lower-level fix to
> this.

Can you please send me (not the list) your .config file? I am not really sure 
what is going on as I cannot reproduce it. I use the fips mode during my tests 
and I use cmac or XTS and yet they do not cause an issue.

Thanks.

Ciao
Stephan
