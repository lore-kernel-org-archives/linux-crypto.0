From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: linux-next: Tree for Oct 26 (crypto/acompress.ko)
Date: Thu, 27 Oct 2016 06:17:54 +0100
Message-ID: <20161027051754.GA3715@SILVIXA00369791-F22-1>
References: <20161026135133.65edfd22@canb.auug.org.au>
 <052d917e-0442-0bbf-5b22-6506f832e30e@infradead.org>
 <CAP=VYLq=Zgaf5uhWVG68Hyha=gJ923ZkW+v7UsfsOJE53YxR0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18659 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750855AbcJ0FSD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 01:18:03 -0400
Content-Disposition: inline
In-Reply-To: <CAP=VYLq=Zgaf5uhWVG68Hyha=gJ923ZkW+v7UsfsOJE53YxR0w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, Oct 26, 2016 at 07:54:00PM -0400, Paul Gortmaker wrote:
> So, no EXPORT_SYMBOL, and any .config which has ACOMP2=m will fail.
I sent a patch for this:
https://patchwork.kernel.org/patch/9396503/

Regards,

--
Giovanni
