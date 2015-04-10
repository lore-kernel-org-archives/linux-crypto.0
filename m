From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:33:17 +0200
Message-ID: <1611407.vmKOV6O1rC@tauon>
References: <20150318095345.GA12923@zoho.com> <1697288.aUGCRhyl06@tauon> <20150410142208.GA16910@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Daniel Borkmann <daniel@iogearbox.net>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: mancha security <mancha1@zoho.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34095 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbbDJOdV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 10:33:21 -0400
In-Reply-To: <20150410142208.GA16910@zoho.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 10. April 2015, 14:22:08 schrieb mancha security:

Hi mancha,

>__asm__ __volatile__("": :"r"(p) :"memory")

gcc -O2/3: mov present

clang -O2/3: mov present

==> approach would be good too.

Note, the assembly code does not seem to change whether to use this approach 
or the one I initially tested.


Ciao
Stephan
