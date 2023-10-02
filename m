Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762A4E7849A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Oct 2023 08:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjJBIdI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 04:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbjJBIdH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 04:33:07 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4184AC6
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 01:33:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnEMK-002dTQ-Nh; Mon, 02 Oct 2023 16:32:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 02 Oct 2023 16:33:00 +0800
Date:   Mon, 2 Oct 2023 16:33:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [bug report] dm-crypt setup failure with next-20230929 kernel
Message-ID: <ZRqAPN5j4RxH9QW1@gondor.apana.org.au>
References: <4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxdsu3g4uughh6go@6owks5linnxi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxdsu3g4uughh6go@6owks5linnxi>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 02, 2023 at 08:08:23AM +0000, Shinichiro Kawasaki wrote:
> Hello there,
> 
> I ran the command below on top of linux-next kernel with the tag next-20230929,
> and observed dm-crypt setup failed.
> 
>   $ sudo cryptsetup open --type=plain --key-file=/dev/zero /dev/nullb0 test
>   device-mapper: reload ioctl on test (253:0) failed: No such file or directory
> 
> Kernel reported an error related to crypto.
> 
>   device-mapper: table: 253:0: crypt: Error allocating crypto tfm (-ENOENT)
>   device-mapper: ioctl: error adding target to table
> 
> The failure was observed with null_blk and SATA HDD. It looks independent of
> block device type.
> 
> I bisected and found that the commit 31865c4c4db2 ("crypto: skcipher - Add
> lskcipher") is the trigger. I reverted the commit from next-20230929 together
> with other four dependent commits below, and observed the failure disappears.
> 
>   705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher")
>   32a8dc4afcfb ("crypto: ecb - Convert from skcipher to lskcipher")
>   3dfe8786b11a ("crypto: testmgr - Add support for lskcipher algorithms")
>   8aee5d4ebd11 ("crypto: lskcipher - Add compatibility wrapper around ECB")
> 
> Is this a known issue?

Thanks for the report.  I'll look into this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
