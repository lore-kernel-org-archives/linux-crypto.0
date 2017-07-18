From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 18 Jul 2017 15:18:49 +0800
Message-ID: <20170718071849.GA5536@gondor.apana.org.au>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170718052556.GA4532@gondor.apana.org.au>
 <CAKv+Gu_6Gw5dD7rnmL-AUUSFFC8W077F8FqDK7m_wYYUizmZFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Eric Biggers <ebiggers3@gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53114 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdGRHTQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 03:19:16 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_6Gw5dD7rnmL-AUUSFFC8W077F8FqDK7m_wYYUizmZFg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 07:32:41AM +0100, Ard Biesheuvel wrote:
>
> Because it is slower, and how much slower is architecture dependent
> (if your arch has slow multiplication, aes-ti decryption will be dog
> slow compared to aes-generic)

Right, but does anybody actually care? My guess is that on such a
platform aes-generic is going to be dog-slow anyway.

> Also, quite a few architectures have table based implementations that
> reuse crypto_ft_tab/crypto_fl_tab etc so we'd need to factor out those
> into a separate module if we were to remove aes-generic.

You mean x86 and arm, right? Isn't the idea of your patch-set to allow
aes-generic to be disabled on x86/arm, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
