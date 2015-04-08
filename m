From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Wed, 8 Apr 2015 22:22:08 +0800
Message-ID: <20150408142208.GA30510@gondor.apana.org.au>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
 <1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
 <20150408131916.GA29646@gondor.apana.org.au>
 <CAKv+Gu9gQqQEEXgJ=JhVf=7SURx9BfRiaJkakhGv1S9FsqujaQ@mail.gmail.com>
 <20150408133050.GB29646@gondor.apana.org.au>
 <CAKv+Gu-=obTKmviwH9B2wBi==LQa_-aAXVU9QPh1gUeYyopmVw@mail.gmail.com>
 <20150408140633.GA30047@gondor.apana.org.au>
 <CAKv+Gu8_GQuYakxGkqcxh1hX3Ly0gKEqheuh0dgs3SGU-z9Ofw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Markus Stockhausen <stockhausen@collogia.de>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55430 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbbDHOWQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:22:16 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8_GQuYakxGkqcxh1hX3Ly0gKEqheuh0dgs3SGU-z9Ofw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 08, 2015 at 04:18:56PM +0200, Ard Biesheuvel wrote:
>
> So what about
> 
> > +typedef void (sha1_block_fn)(int blocks, u8 const *src, u32 *state,
> > +                          bool final);
> 
> ?

Looks good to me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
