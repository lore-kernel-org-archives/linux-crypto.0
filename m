From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Wed, 27 Feb 2008 18:59:03 +0300
Message-ID: <20080227155901.GA30642@2ka.mipt.ru>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi> <20080226185240.GA2521@2ka.mipt.ru> <20080226160439.5941cc31.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Bunk <bunk@kernel.org>, Martin Michlmayr <tbm@cyrius.com>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux-crypto@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37191 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYB0QAH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2008 11:00:07 -0500
Content-Disposition: inline
In-Reply-To: <20080226160439.5941cc31.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2008 at 04:04:39PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> udelay() might be exposed to the same problem.  It would be better to fix
> ndelay() and udelay() rather than callers.  It is reasonable to pass a u64
> into ndelay() and to expect the build to not explode.

Well, if you think it is resonable to pass u64 into function, which is 
supposed to sleep no more than several cpu cycles. I do not want to
start any kind of flame about it, but this looks like an overkill.

> (Geeze macros suck)

Absolutely.

-- 
	Evgeniy Polyakov
