From: Stephan Mueller <smueller@chronox.de>
Subject: Re: linux-next: Tree for Aug 26 (drbg)
Date: Tue, 26 Aug 2014 22:19:11 +0200
Message-ID: <2143681.nIInT2cPxl@myon.chronox.de>
References: <20140826173452.7cc5445c@canb.auug.org.au> <53FCDA03.3050504@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46953 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbaHZUTP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Aug 2014 16:19:15 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S333> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 26 Aug 2014 22:19:12 +0200
In-Reply-To: <53FCDA03.3050504@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 26. August 2014, 12:03:31 schrieb Randy Dunlap:

Hi Randy,

> On 08/26/14 00:34, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20140825:
> > 
> > The net tree gained a build failure for which I reverted a commit.
> > 
> > The mfd tree still had its build failure so I used the version from
> > next-20140822.
> 
> on i386:
> 
> ../include/crypto/drbg.h:157:2: warning: left shift count >= width of type
> [enabled by default] ../include/crypto/drbg.h:163:2: warning: left shift
> count >= width of type [enabled by default]
> 
> I guess that someone has already seen this but I haven't noticed any reports
> of it.

Thank you for reporting the issue. The patch and fix is provided with [1]. Did 
you test with this patch?

[1] 
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=b9347aff91ce4789619168539f08202d8d6a1177

-- 
Ciao
Stephan
