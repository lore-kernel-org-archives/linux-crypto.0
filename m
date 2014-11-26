From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] arm64: crypto: Add ARM64 CRC32 hw accelerated module
Date: Wed, 26 Nov 2014 20:00:03 +0800
Message-ID: <20141126120003.GA16236@gondor.apana.org.au>
References: <1416417577-27495-1-git-send-email-yazen.ghannam@linaro.org>
 <CA+dbMptnfYf0QgKqXWkv4N7_YzJvnoKcvOUY5asPX4x9yEApLg@mail.gmail.com>
 <CAKv+Gu9-ZqkNxEMcdbna4jYDvNmtwEr0Yf57Wv=usURZBvC3BQ@mail.gmail.com>
 <CA+dbMpt=xV2fBxb75JZUuDnpub4LCLZfHBLSkQX55t9Ov+6j_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Yazen Ghannam <yazen.ghannam@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33848 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaKZMAN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Nov 2014 07:00:13 -0500
Content-Disposition: inline
In-Reply-To: <CA+dbMpt=xV2fBxb75JZUuDnpub4LCLZfHBLSkQX55t9Ov+6j_g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 25, 2014 at 10:50:12AM -0600, Yazen Ghannam wrote:
> Herbert,
> 
> I have a couple of questions.
> 
> 1) To which release has the patch been applied? We're just curious for
> tracking purposes.

3.19

> 2) I'd like to apply Ard's suggestion. Do you prefer a second version
> of this patch or a separate fixup patch?

Please make your patches against the cryptodev tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
