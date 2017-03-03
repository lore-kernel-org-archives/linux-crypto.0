From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Fri, 3 Mar 2017 17:33:44 +0800
Message-ID: <20170303093344.GA26003@gondor.apana.org.au>
References: <CALaQ_hoZ6wh-H_NNoT80r6kthvFpL05zNWr7upVqispknXMEvg@mail.gmail.com>
 <20170303040210.GA24737@gondor.apana.org.au>
 <CALaQ_hruPpfO0ggwcQZ_j+WB9=ONDatLbe3sERviVd=w1iNhSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751468AbdCCJ56 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2017 04:57:58 -0500
Content-Disposition: inline
In-Reply-To: <CALaQ_hruPpfO0ggwcQZ_j+WB9=ONDatLbe3sERviVd=w1iNhSw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 03, 2017 at 03:00:26AM -0600, Nathan Royce wrote:
> OK, I went ahead and enabled self tests
> "CRYPTO_MANAGER_DISABLE_TESTS=n", and my system was able to boot,
> albeit with failures:
> *****
> Mar 02 23:14:38 server kernel: ---[ end trace 1c8a91f28cbcebf3 ]---
> Mar 02 23:14:38 server kernel: alg: skcipher: encryption failed on
> test 1 for xts(ecb-aes-s5p): ret=35
> Mar 02 23:14:38 server kernel: device-mapper: table: 254:0: crypt:
> Error allocating crypto tfm
> Mar 02 23:14:38 server kernel: device-mapper: ioctl: error adding
> target to table
> Mar 02 23:14:39 server systemd-cryptsetup[234]: Failed to activate
> with key file '/dev/urandom': Invalid argument
> *****
> (weird that it asked for the passphrase)
> 
> But I do question whether the root issue is related to s5p... Maybe
> there is a correlation in the warning, but to me it looks like the
> issue is something else.

I see.  Do you have ECB enabled in your config? The new XTS requires
ECB to be present so that could be your problem.

There is already a patch on its way to stable to add the Kconfig
select on ECB.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
