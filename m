From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Tue, 26 Feb 2008 18:20:24 +0100
Message-ID: <20080226172024.GO2655@deprecation.cyrius.com>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux-crypto@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763438AbYBZRVT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080226153421.GB10717@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Adrian Bunk <bunk@kernel.org> [2008-02-26 17:34]:
> >   MODPOST 759 modules
> > ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> 
> Fix below.

Tested-by: Martin Michlmayr <tbm@cyrius.com>

-- 
Martin Michlmayr
http://www.cyrius.com/
