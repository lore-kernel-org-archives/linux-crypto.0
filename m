From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v5] IV Generation algorithms for dm-crypt
Date: Mon, 10 Apr 2017 16:00:39 +0200
Message-ID: <774a9713-05ef-0162-0203-461254a04f6e@gmail.com>
References: <1491562064-23591-1-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Milan Broz <gmazyland@gmail.com>, Gilad <gilad@benyossef.com>
To: Binoy Jayan <binoy.jayan@linaro.org>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33048 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbdDJOAn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 10:00:43 -0400
In-Reply-To: <1491562064-23591-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/07/2017 12:47 PM, Binoy Jayan wrote:
> ===============================================================================
> dm-crypt optimization for larger block sizes
> ===============================================================================
...
> Tests with dd [direct i/o]
> 
> Sequential read            -0.134 %
> Sequential Write           +0.091 %
> 
> Tests with fio [Aggregate bandwidth - aggrb]
> 
> Random Read                +0.358 %
> Random Write               +0.010 %
> 
> Tests with bonnie++ [768 MiB File, 384 MiB Ram]
> after mounting dm-crypt target as ext4
> 
> Sequential o/p [per-char]  -2.876 %
> Sequential o/p [per-blk]   +0.992 %
> Sequential o/p [re-write]  +4.465 %
> 
> Sequential i/p [per-char] -0.453 %
> Sequential i/p [per-blk]  -0.740 %
> 
> Sequential create         -0.255 %
> Sequential delete         +0.042 %
> Random create             -0.007 %
> Random delete             +0.454 %
> 
> NB: The '+' sign shows improvement and '-' shows degradation.
>     The tests were performed with minimal cpu load.
>     Tests with higher cpu load to be done

Well, it is good that there is no performance degradation but it
would be nice to have some user of it that proves it is really
working for your hw.

FYI - with patch that increases dmcrypt sector size to 4k
I can see improvement in speed usually in 5-15% with sync AES-NI
(depends on access pattern), with dmcrypt mapped to memory
it is even close to 20% speed up (but such a configuration is
completely artificial).

I wonder why increased dmcrypt sector size does not work for your hw,
it should help as well (and can be combiuned later with this IV approach).
(For native 4k drives this should be used in future anyway...)

Milan
