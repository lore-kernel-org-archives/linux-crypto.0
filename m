Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719C7C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 447DA21734
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgBMJ0R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:26:17 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42556 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729619AbgBMJ0R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 04:26:17 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2AlE-0004C3-40; Thu, 13 Feb 2020 17:26:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2AlD-0006s1-66; Thu, 13 Feb 2020 17:26:15 +0800
Date:   Thu, 13 Feb 2020 17:26:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 0/3] crypto: qce driver fixes for gcm
Message-ID: <20200213092615.l7cd3qe6etp55mjc@gondor.apana.org.au>
References: <20200207150227.31014-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207150227.31014-1-cotequeiroz@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 07, 2020 at 12:02:24PM -0300, Eneas U de Queiroz wrote:
> I've made enough mistakes in this series, I'll just start over.  It's
> been hard for me not to be able to run test this in master, and have to
> go back and forth between it and 4.19; that's why I have messed up so
> many times.  I apologize for the noise again.
> 
> If you've read the cover letter from v1 and v2, there's not anything too
> relevant that I'm changing here.
> 
> ---
> 
> I've finally managed to get gcm(aes) working with the qce crypto engine.
> 
> These first patch fixes a bug where the gcm authentication tag was being
> overwritten during gcm decryption, because it was passed in the same sgl
> buffer as the crypto payload.  The qce driver appends some private state
> buffer to the request destination sgl, but it was not checking the
> length of the sgl being passed.
> 
> The second patch works around a problem, which I frankly can't pinpoint
> what exactly is the cause, but after some help from Ard Biesheuvel, I
> think it is related to DMA.  When gcm sends a request in
> crypto_gcm_setkey, it stores the hash (the crypto payload) and the iv in
> the same data struct.  When the driver updates the IV, then the payload
> gets overwritten with the unencrypted data, or all zeroes, it may be a
> coincidence.
> 
> However, it works if I pass the request down to the fallback driver--it
> is used by the driver to accept 192-bit-key requests.  All I had to do
> was setup the fallback regardless of key size, and then check the
> payload length along with the keysize to pass the request to the
> fallback.  This turns out to enhance performance, because of the
> avoided latency that comes with using the hardware.
> 
> I've started with checking for a single 16-byte AES block, and that is
> enough to make gcm work.  Next thing I've done was to tune the request
> size for performance.  What got me started into looking at the qce
> driver was reports of it being detrimental to VPN speed, by the way.
> I've tested this win an Asus RT-AC58U, but the slow VPN reports[1] have
> more devices affected.  Access to the device was kindly provided by
> @simsasss.
> 
> I've added a 768-byte block size to tcrypt to get some measurements to
> come up with an optimal threshold to transition from software to
> hardware, and encountered another bug in the qce driver: it apparently
> cannot handle aes-xts requests that are greater than 512 bytes, but not
> a multiple of it.  It failed with 768, 1280; XTS is usually used with a
> 512-byte sector (or a multiple of it), so I'm concluding that is the
> cause of failure.
> 
> With that fixed, I added a module parameter to set the maximum request
> size that will be handled by the software fallback cipher and made some
> speed measurements using tcrypt to come up with an optimum value.
> 
> I've documented this briefly in the parameter description, pointing out
> that gcm will not work if you set it to 0, and in better detail in the
> Kconfig help.
> 
> TLDR: In the worst (where the hardware is slowest) case, hardware and
> software speed match at around 768 bytes, but I lowered the threshold to
> 512 to benefit the CPU offload.
> 
> Here's a sample comparing three runs, using the proposed driver, varying
> the aes_sw_max_len parameter: 1st run will always use fallback, second
> run will use the default fallback for len <= 512, and third run will
> never use the fallback.
> 
> testing speed of async cbc(aes) (cbc-aes-qce) encryption
> ------------------      ----------   ----------    ----------
> aes_sw_max_len              32,768          512             0
> ------------------      ----------   ----------    ----------
> 128 bit   16 bytes       8,081,136    5,614,448       430,416
> 128 bit   64 bytes      13,152,768   13,205,952     1,745,088
> 128 bit  256 bytes      16,094,464   16,101,120     6,969,600
> 128 bit  512 bytes      16,701,440   16,705,024    12,866,048
> 128 bit  768 bytes      16,883,712   13,192,704    15,186,432
> 128 bit 1024 bytes      17,036,288   17,149,952    19,716,096
> 128 bit 2048 bytes      17,108,992   30,842,880    32,868,352
> 128 bit 4096 bytes      17,203,200   44,929,024    49,655,808
> 128 bit 8192 bytes      17,219,584   58,966,016    74,186,752
> 256 bit   16 bytes       6,962,432    1,943,616       419,088
> 256 bit   64 bytes      10,485,568   10,421,952     1,681,536
> 256 bit  256 bytes      12,211,712   12,160,000     6,701,312
> 256 bit  512 bytes      12,499,456   12,584,448     9,882,112
> 256 bit  768 bytes      12,622,080   12,550,656    14,701,824
> 256 bit 1024 bytes      12,750,848   16,079,872    19,585,024
> 256 bit 2048 bytes      12,812,288   28,293,120    27,693,056
> 256 bit 4096 bytes      12,939,264   34,234,368    44,142,592
> 256 bit 8192 bytes      12,845,056   50,274,304    63,520,768
> 
> The numbers vary from run to run, sometimes greatly.
> 
> I've tried running the same tests with the arm-neon drivers, but the
> results don't change with any cipher mode, so I'm assuming the fallback
> is always aes-generic.
> 
> I've made the measurements using an Asus RT-AC58U only, so I don't know
> how other hardware performs, but the user can always override the
> parameter, or even its default value.
> 
> [1] https://forum.openwrt.org/t/ipsec-performance-issue/39690
> 
> Eneas U de Queiroz (3):
>   crypto: qce - use cryptlen when adding extra sgl
>   crypto: qce - use AES fallback for small requests
>   crypto: qce - handle AES-XTS cases that qce fails
> 
>  drivers/crypto/Kconfig        | 23 +++++++++++++++++++++++
>  drivers/crypto/qce/common.c   |  2 --
>  drivers/crypto/qce/common.h   |  3 +++
>  drivers/crypto/qce/dma.c      | 11 ++++++-----
>  drivers/crypto/qce/dma.h      |  2 +-
>  drivers/crypto/qce/skcipher.c | 30 ++++++++++++++++++++----------
>  6 files changed, 53 insertions(+), 18 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
