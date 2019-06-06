Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92431C04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB1820673
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbfFFGvm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:51:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38754 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGvl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:51:41 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmFM-0006tu-Hl; Thu, 06 Jun 2019 14:51:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmFK-0006hT-CO; Thu, 06 Jun 2019 14:51:34 +0800
Date:   Thu, 6 Jun 2019 14:51:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     davem@davemloft.net, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH v4] crypto: xxhash - Implement xxhash support
Message-ID: <20190606065134.jjq4upsfve4hq755@gondor.apana.org.au>
References: <20190530065257.13174-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530065257.13174-1-nborisov@suse.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 30, 2019 at 09:52:57AM +0300, Nikolay Borisov wrote:
> xxhash is currently implemented as a self-contained module in /lib.
> This patch enables that module to be used as part of the generic kernel
> crypto framework. It adds a simple wrapper to the 64bit version.
> 
> I've also added test vectors (with help from Nick Terrell). The upstream
> xxhash code is tested by running hashing operation on random 222 byte
> data with seed values of 0 and a prime number. The upstream test
> suite can be found at https://github.com/Cyan4973/xxHash/blob/cf46e0c/xxhsum.c#L664
> 
> Essentially hashing is run on data of length 0,1,14,222 with the
> aforementioned seed values 0 and prime 2654435761. The particular random
> 222 byte string was provided to me by Nick Terrell by reading
> /dev/random and the checksums were calculated by the upstream xxsum
> utility with the following bash script:
> 
> dd if=/dev/random of=TEST_VECTOR bs=1 count=222
> 
> for a in 0 1; do
> 	for l in 0 1 14 222; do
> 		for s in 0 2654435761; do
> 			echo algo $a length $l seed $s;
> 			head -c $l TEST_VECTOR | ~/projects/kernel/xxHash/xxhsum -H$a -s$s
> 		done
> 	done
> done
> 
> This produces output as follows:
> 
> algo 0 length 0 seed 0
> 02cc5d05  stdin
> algo 0 length 0 seed 2654435761
> 02cc5d05  stdin
> algo 0 length 1 seed 0
> 25201171  stdin
> algo 0 length 1 seed 2654435761
> 25201171  stdin
> algo 0 length 14 seed 0
> c1d95975  stdin
> algo 0 length 14 seed 2654435761
> c1d95975  stdin
> algo 0 length 222 seed 0
> b38662a6  stdin
> algo 0 length 222 seed 2654435761
> b38662a6  stdin
> algo 1 length 0 seed 0
> ef46db3751d8e999  stdin
> algo 1 length 0 seed 2654435761
> ac75fda2929b17ef  stdin
> algo 1 length 1 seed 0
> 27c3f04c2881203a  stdin
> algo 1 length 1 seed 2654435761
> 4a15ed26415dfe4d  stdin
> algo 1 length 14 seed 0
> 3d33dc700231dfad  stdin
> algo 1 length 14 seed 2654435761
> ea5f7ddef9a64f80  stdin
> algo 1 length 222 seed 0
> 5f3d3c08ec2bef34  stdin
> algo 1 length 222 seed 2654435761
> 6a9df59664c7ed62  stdin
> 
> algo 1 is xx64 variant, algo 0 is the 32 bit variant which is currently
> not hooked up.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V4: 
>  * Renamed couple more shash_desc_ctx variable to "dctx" (Eric Biggers)
>  * Removed _finup method  (Eric Biggers)
>  * Implemented _digest method by directly calling xxh64() (Eric Biggers)
> 
>  crypto/Kconfig          |   8 +++
>  crypto/Makefile         |   1 +
>  crypto/testmgr.c        |   7 +++
>  crypto/testmgr.h        | 106 +++++++++++++++++++++++++++++++++++++++
>  crypto/xxhash_generic.c | 108 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 230 insertions(+)
>  create mode 100644 crypto/xxhash_generic.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
