From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [patch 0/3] crypto: padlock-aes: enable on VIA Nano
Date: Tue, 9 Jun 2009 20:42:03 +0200
Message-ID: <20090609184203.GA22084@Chamillionaire.breakpoint.cc>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Harald Welte <HaraldWelte@viatech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51967 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbZFISmW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2009 14:42:22 -0400
Content-Disposition: inline
In-Reply-To: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Chuck Ebbert | 2009-06-09 10:35:33 [-0400]:

>The VIA Nano has a bug that makes the padlock unit fetch extra data
>during encryption operations. Add workarounds for that, and enable
>the driver on x86_64.
Nice. The X86_64 padlock will make it mainline in next merge window so
I'm asking you kindly to rebase it against Herbert's cryptodev tree [0].

I guess the bug can trigger on 32bit if you boot the affected 64bit CPU
in 32bit mode? I'm not sure if it is better to send this patches via
stable tree _or_ deactivate the padlock on affected CPUs.

[0]
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

Sebastian
