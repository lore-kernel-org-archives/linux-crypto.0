Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9E0C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 07:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 227C922D6D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 07:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfHUHVq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 03:21:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58114 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbfHUHVq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 03:21:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0Kvm-0002hO-Tc; Wed, 21 Aug 2019 17:21:19 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0Kvd-0005uA-Ax; Wed, 21 Aug 2019 17:21:09 +1000
Date:   Wed, 21 Aug 2019 17:21:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "boojin.kim" <boojin.kim@samsung.com>,
        'Alasdair Kergon' <agk@redhat.com>,
        'Mike Snitzer' <snitzer@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org,
        "'David S. Miller'" <davem@davemloft.net>,
        'Eric Biggers' <ebiggers@kernel.org>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>, 'Chao Yu' <chao@kernel.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Andreas Dilger' <adilger.kernel@dilger.ca>,
        'Jens Axboe' <axboe@kernel.dk>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Kukjin Kim' <kgene@kernel.org>,
        'Jaehoon Chung' <jh80.chung@samsung.com>,
        'Ulf Hansson' <ulf.hansson@linaro.org>,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 6/9] dm crypt: support diskcipher
Message-ID: <20190821072109.GA22686@gondor.apana.org.au>
References: <CGME20190821064230epcas2p1ad7301f2b1331bcab3126e6e37c0e272@epcas2p1.samsung.com>
 <004201d557eb$9b0a4410$d11ecc30$@samsung.com>
 <cc484ef6-aacc-7864-0e6d-313b2e1c5d92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc484ef6-aacc-7864-0e6d-313b2e1c5d92@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 21, 2019 at 09:13:36AM +0200, Milan Broz wrote:
>
> NACK.
> 
> The whole principle of dm-crypt target is that it NEVER EVER submits
> plaintext data down the stack in bio.
> 
> If you want to do some lower/higher layer encryption, use key management
> on a different layer.
> So here, just setup encryption for fs, do not stack it with dm-crypt.
> 
> Also, dm-crypt is software-independent solution
> (software-based full disk encryption), it must not depend on
> any underlying hardware.
> Hardware can be of course used used for acceleration, but then
> just implement proper crypto API module that accelerates particular cipher.

I agree.  Please take a look at the recent ESSIV patches on
linux-crypto and build multi-block operations on top of them
which can then be implemented by the hardware.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
