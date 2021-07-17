Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13123C636CA
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 14:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE1C611BE
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 14:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbhGQOXu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 10:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhGQOXu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 10:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27913613C4;
        Sat, 17 Jul 2021 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626531653;
        bh=wSCwVuuSnJ3NHowIjdatyUb2d30WxXzTltY3f8AipVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rxuhin9VHzrkiynQVLE/oSC9N/P4q1XmBS+mIzFysTyr1Ytfcq2t1wqtjw7rtwWK1
         1LrEhEqRiWHgroZSStVvKHAc766HKyzUFjtvOSoje9CngpjYOx+olsKeVpS5DoOnYs
         gDOdwt2qgGOFcROCRdRi2tOlvy4yTJyRq44RcgYLJ8Gaee3BBUXJDqB4FkxoX+0ggy
         FyPL4oAeRMZvp7A3ReSNLLFRz5zW2i1rd2oxaHFsLpD7H2BELAQXUaF9yI6PHIjfgM
         F0rr9zfs5T4uqV1g/zuQ5YKEAJ1jqZPHhMUQFfxDW/zuA04cPOJKFdC9tVs58nWjay
         p9lIAmrMfJyYw==
Date:   Sat, 17 Jul 2021 09:20:51 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 04/11] lib/base64: RFC4648-compliant base64 encoding
Message-ID: <YPLnQ1iyCQaEcnCq@quark.localdomain>
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716110428.9727-5-hare@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 16, 2021 at 01:04:21PM +0200, Hannes Reinecke wrote:
> +/**
> + * base64_decode() - base64-decode some bytes
> + * @src: the base64-encoded string to decode
> + * @len: number of bytes to decode
> + * @dst: (output) the decoded bytes.
> + *
> + * Decodes the base64-encoded bytes @src according to RFC 4648.
> + *
> + * Return: number of decoded bytes
> + */
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
> +                        if (src[i] == lookup_table[c]) {
> +                                p = c;
> +                                break;
> +                        }
> +                }
> +                if (p < 0)
> +                        break;
> +                ac = (ac << 6) | p;
> +                bits += 6;
> +                if (bits < 24)
> +                        continue;
> +                while (bits) {
> +                        bits -= 8;
> +                        dst[dst_len++] = (ac >> bits) & 0xff;
> +                }
> +                ac = 0;
> +        }
> +        dst_len -= pad;
> +        return dst_len;
> +}
> +EXPORT_SYMBOL_GPL(base64_decode);

This should return an error if the input isn't valid base64.

- Eric
