From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 41/47] ERROR: "crypto_acomp_scomp_free_ctx"
 [crypto/acompress.ko] undefined!
Date: Tue, 1 Nov 2016 08:44:35 +0800
Message-ID: <20161101004435.GD7375@gondor.apana.org.au>
References: <201610260803.GIBxWXo3%fengguang.wu@intel.com>
 <20161026095645.GA27004@SILVIXA00369791-F22-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56235 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948288AbcKAAoo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:44:44 -0400
Content-Disposition: inline
In-Reply-To: <20161026095645.GA27004@SILVIXA00369791-F22-1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 26, 2016 at 10:56:45AM +0100, Giovanni Cabiddu wrote:
> Hi,
> 
> On Wed, Oct 26, 2016 at 08:47:16AM +0800, kbuild test robot wrote:
> > >> ERROR: "crypto_acomp_scomp_free_ctx" [crypto/acompress.ko] undefined!
> > >> ERROR: "crypto_acomp_scomp_alloc_ctx" [crypto/acompress.ko] undefined!
> > >> ERROR: "crypto_init_scomp_ops_async" [crypto/acompress.ko] undefined!
> 
> Thanks for the report. There is a problem with a dependency between
> acomp and scomp. This patch should fix the issue.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
