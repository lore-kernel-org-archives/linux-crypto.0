From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [patch 3/3] crypto: padlock-aes: enable on 64-bit kernels
Date: Tue, 9 Jun 2009 20:47:20 +0200
Message-ID: <20090609184720.GB22084@Chamillionaire.breakpoint.cc>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com> <20090609103907.1903878c@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Harald Welte <HaraldWelte@viatech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49964 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbZFISrY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2009 14:47:24 -0400
Content-Disposition: inline
In-Reply-To: <20090609103907.1903878c@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Chuck Ebbert | 2009-06-09 10:39:07 [-0400]:

>From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>crypto: padlock-aes: enable on 64-bit kernels
>
>The only required change now is using the right push/pop instruction
>on x86-64. Taken from the original patch by Sebastian Andrzej Siewior.
>(Added a dependency on X86.)
My original patch is allready in cryptodev followed by another patch for
the correct dependency.

Sebastian
