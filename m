From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Date: Wed, 15 Aug 2012 16:03:31 +0200
Message-ID: <20120815140331.GB4103@x1.osrc.amd.com>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
 <20120815140016.76673zs818g2hagw@www.81.fi>
 <20120815125220.GB4409@x1.osrc.amd.com>
 <20120815164854.11913imktb2fg90k@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?=
	<tilo.mueller@informatik.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:33567 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab2HOODf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Aug 2012 10:03:35 -0400
Content-Disposition: inline
In-Reply-To: <20120815164854.11913imktb2fg90k@www.81.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 15, 2012 at 04:48:54PM +0300, Jussi Kivilinna wrote:
> I posted patch that optimize twofish-avx few weeks ago:
> http://marc.info/?l=linux-crypto-vger&m=134364845024825&w=2
>
> I'd be interested to know, if this is patch helps on Bulldozer.

Sure, can you inline it here too please. The "Download message RAW" link
on marc.info gives me a diff but patch says:

patching file arch/x86/crypto/twofish-avx-x86_64-asm_64.S
patch unexpectedly ends in middle of line

Thanks.

-- 
Regards/Gruss,
Boris.
