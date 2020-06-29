Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFF2C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 18:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4A5204EC
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 18:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgF2Sur (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:50:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:64953 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgF2Sun (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:50:43 -0400
IronPort-SDR: CFxEYzUkIsoBPxzdsuvs811fhSwNNLa9MEYduw6iqsyIOKMlO+/SqjjqodwXIT6sfAowcWaAB9
 0lv9522/WMRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="207516131"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="207516131"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:04:58 -0700
IronPort-SDR: PSh9N3OOgk5Ln16DxKMg1w0XnsqVf7kVnK+ig5FbcTBfFoCFsIx4VngYEZk+mug0y6+6IJ0MJJ
 h4rwNEPgLHww==
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="303138586"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:04:56 -0700
Date:   Mon, 29 Jun 2020 18:04:50 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux@intel.com
Subject: Re: [PATCH v2 4/4] crypto: qat - fallback for xts with 192 bit keys
Message-ID: <20200629170353.GA2750@silpixa00400314>
References: <20200626080429.155450-1-giovanni.cabiddu@intel.com>
 <20200626080429.155450-5-giovanni.cabiddu@intel.com>
 <CAMj1kXGu4_Fp=0i9FUJuRUknsUrf0Ci=r9gMb5+Zf+hVXN4-rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGu4_Fp=0i9FUJuRUknsUrf0Ci=r9gMb5+Zf+hVXN4-rw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for your feedback Ard.

On Fri, Jun 26, 2020 at 08:15:16PM +0200, Ard Biesheuvel wrote:
> On Fri, 26 Jun 2020 at 10:04, Giovanni Cabiddu
> <giovanni.cabiddu@intel.com> wrote:
> >
> > +static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
> > +{
> > +       struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +       int reqsize;
> > +
> > +       ctx->ftfm = crypto_alloc_skcipher("xts(aes)", 0, CRYPTO_ALG_ASYNC);
> 
> Why are you only permitting synchronous fallbacks? If the logic above
> is sound, and copies the base.complete and base.data fields as well,
> the fallback can complete asynchronously without problems.
> Note that SIMD s/w implementations of XTS(AES) are asynchronous as
> well, as they use the crypto_simd helper which queues requests for
> asynchronous completion if the context from which the request was
> issued does not permit access to the SIMD register file (e.g., softirq
> context on some architectures, if the interrupted context is also
> using SIMD)
I did it this way since I though I didn't have a way to test it with an
asynchronous sw implementation.
I changed this line to avoid masking the asynchronous implementations
and test it by forcing simd.c to use always cryptd (don't know if there
is a simpler way to do it).

Also, I added to the mask CRYPTO_ALG_NEED_FALLBACK so I don't get another
implementation that requires a fallback.

I'm going to send a v3.

Regards,

-- 
Giovanni
