From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Date: Sat, 05 Jul 2014 02:03:42 +0200
Message-ID: <3976289.yTN4qK0lsl@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <1616464.nTZ4WdyPoM@myon.chronox.de> <20140704141541.GB27229@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33573 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbaGEAEp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Jul 2014 20:04:45 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S241> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sat, 5 Jul 2014 02:03:44 +0200
In-Reply-To: <20140704141541.GB27229@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 4. Juli 2014, 22:15:41 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Jun 29, 2014 at 01:37:05PM +0200, Stephan Mueller wrote:
> > When looking into the documentation and trying it I found:
> > 
> > - bool choices allow me to only select one option, and only one
> > 
> > - tristate choices allow me to only select one option, if the initial
> > tristate is set to yes. If the initial tristate is set to module, it
> > allows zero to all options to be set.
> > 
> > That said, neither covers my requirement here: require that at least one
> > option is set, but allow more options.
> 
> I have added the following patch to solve this problem.

Thank you very much for the help. I will test it once it is present on the 
server.
> 
> Please respin your patch against this.

All patches that have been sent so far and not applied will be respun around 
the new code level once the updated code appears on the server.

-- 
Ciao
Stephan
