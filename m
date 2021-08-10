Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF9AC4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 19:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5308661052
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 19:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhHJTOE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Aug 2021 15:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhHJTOE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Aug 2021 15:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7F261019;
        Tue, 10 Aug 2021 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628622822;
        bh=3rE5qc+iJNNSvC4ekgPf62m2QsbfzCpL6SJxL+syab8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQC0NEk0Him79x8hhE3+Sr+z7EPYmUxL8PTeYH/CjZGvf4FrabhG8oPj/dhV15wp9
         bM0E6Zb3ZtrKA/55nDzFReeOSLZs2MDcZ5Jx6FlungZ+C+lrN9hH7gY9VyNACyRvS+
         jU/O6+Wzzt8CtrpVTelrqQvpOLxSLPaKxbPMGZp3q0xK72zRV+qU8YkdRUpkWHoF+G
         uHv8MCo6c3pHEq90IVKsjmQcSvf4Ctu3fECrFTuNySU3qLZSvlgGv3Lx2tqqUtYtH/
         gyHADC9n6cHisQamSGltETg5lyyE9Ap1yi8YmBiGU5swo57pTX4Cc8RJn0N0JNCqPO
         0TB1Iqe4arR8A==
Date:   Tue, 10 Aug 2021 12:13:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 04/13] lib/base64: RFC4648-compliant base64 encoding
Message-ID: <YRLP5JuQrF/SJPBt@gmail.com>
References: <20210810124230.12161-1-hare@suse.de>
 <20210810124230.12161-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810124230.12161-5-hare@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 10, 2021 at 02:42:21PM +0200, Hannes Reinecke wrote:
> Add RFC4648-compliant base64 encoding and decoding routines.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  include/linux/base64.h |  16 ++++++
>  lib/Makefile           |   2 +-
>  lib/base64.c           | 115 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 132 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/base64.h
>  create mode 100644 lib/base64.c
> 
> diff --git a/include/linux/base64.h b/include/linux/base64.h
> new file mode 100644
> index 000000000000..660d4cb1ef31
> --- /dev/null
> +++ b/include/linux/base64.h
> @@ -0,0 +1,16 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * base64 encoding, lifted from fs/crypto/fname.c.
> + */

As I mentioned previously, please make it very clear which variant of Base64 it
is (including whether padding is included and required or not), and update all
the comments accordingly.  I've done so in fs/crypto/fname.c with
https://lkml.kernel.org/r/20210718000125.59701-1-ebiggers@kernel.org.  It would
probably be best to start over with a copy of that and modify it accordingly to
implement the desired variant of Base64.

> +/**
> + * base64_decode() - base64-decode some bytes
> + * @src: the base64-encoded string to decode
> + * @len: number of bytes to decode
> + * @dst: (output) the decoded bytes.

"@len: number of bytes to decode" is ambiguous as it could refer to either @src
or @dst.  I've fixed this in the fs/crypto/fname.c version.

> + *
> + * Decodes the base64-encoded bytes @src according to RFC 4648.
> + *
> + * Return: number of decoded bytes
> + */

Shouldn't this return an error if the string is invalid?  Again, see the latest
fs/crypto/fname.c version.

> +int base64_decode(const char *src, int len, u8 *dst)
> +{
> +        int i, bits = 0, pad = 0;
> +        u32 ac = 0;
> +        size_t dst_len = 0;
> +
> +        for (i = 0; i < len; i++) {
> +                int c, p = -1;
> +
> +                if (src[i] == '=') {
> +                        pad++;
> +                        if (i + 1 < len && src[i + 1] == '=')
> +                                pad++;
> +                        break;
> +                }
> +                for (c = 0; c < strlen(lookup_table); c++) {

strlen() shouldn't be used in a loop condition like this.

- Eric
