Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B4FC47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 07:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA3F2206B9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 07:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgEEH7V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 03:59:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36432 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEH7V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 03:59:21 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jVsOw-00069M-Tw; Tue, 05 May 2020 17:54:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2020 17:58:35 +1000
Date:   Tue, 5 May 2020 17:58:35 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Sahana Prasad <saprasad@redhat.com>,
        Tomas Mraz <tmraz@redhat.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: libkcapi tests are failing on kernels 5.5+
Message-ID: <20200505075834.GA1190@gondor.apana.org.au>
References: <CAAUqJDvZt7_j+eor1sXRg+QmrdXTjMiymFnji86PoatsYPUugA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAUqJDvZt7_j+eor1sXRg+QmrdXTjMiymFnji86PoatsYPUugA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 21, 2020 at 10:08:14AM +0200, Ondrej Mosnáček wrote:
> Hi all,
> 
> the libkcapi [1] tests are failing on kernels 5.5-rc1 and above [2].
> All encryption/decryption tests that use 'ctr(aes)' and a message size
> that is not a multiple of 16 fail due to kcapi-enc returning different
> output than expected.
> 
> It seems that it started with:
> commit 5b0fe9552336338acb52756daf65dd7a4eeca73f
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Sep 10 11:42:05 2019 +1000
> 
>     crypto: algif_skcipher - Use chunksize instead of blocksize
> 
> Reverting the above commit makes the tests pass again.
> 
> Here is a one-line reproducer:
> head -c 257 /dev/zero | kcapi-enc -vvv --pbkdfiter 1 -p "passwd" -s
> "123" -e -c "ctr(aes)" --iv "0123456789abcdef0123456789abcdef"
> >/dev/null
> 
> Output without revert:
> [...]
> libkcapi - Debug: AF_ALG: recvmsg syscall returned 256
> kcapi-enc - Verbose: Removal of padding disabled
> kcapi-enc - Verbose: 256 bytes of ciphertext created

OK, I tried it here and the problem is that kcapi-enc is setting
the flag SPLICE_F_MORE:

splice(4, NULL, 6, NULL, 257, SPLICE_F_MORE) = 257
write(2, "libkcapi - Debug: AF_ALG: splice"..., 54libkcapi - Debug: AF_ALG: splice syscall returned 257
) = 54
write(2, "kcapi-enc - Debug: Data size exp"..., 59kcapi-enc - Debug: Data size expected to be generated: 257
) = 59
recvmsg(6, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\363\212\340S\r\231\371+\234\320\"\360}%\244\242.\365iJ\304\257\210\f\366\20\257'F\5EP"..., iov_len=257}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 256

That flag means that the request is not finished and because of
the way CTR works we must wait for more input before returning
the next block (or partial block).

So kcapi-enc needs to unset the SPLICE_F_MORE to finish a request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
