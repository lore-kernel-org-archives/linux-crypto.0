From: George Cherian <gcherianv@gmail.com>
Subject: Re: [PATCH v2 0/3] Add more algorithms and some misc cleanups
Date: Sun, 11 Jun 2017 07:57:30 +0530
Message-ID: <CABYS091MS4tjV-U1A37Uy4+petP5R4YkpASVqrORNdjoXOCPNQ@mail.gmail.com>
References: <1493897686-12330-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34262 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdFKC1b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 22:27:31 -0400
In-Reply-To: <1493897686-12330-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Ping on this series....

Regards,
-George Cherian

On Thu, May 4, 2017 at 5:04 PM, George Cherian
<george.cherian@cavium.com> wrote:
> This series adds more algorithm support for CPT.
> Add support for
>         -ecb(aes)
>         -cfb(aes)
>         -ecb(des3_ede)
>
> Some cleanups too.
>
> George Cherian (3):
>   crypto: cavium: Downgrade the annoying misc interrupt print from
>     dev_err to dev_dbg
>   crypto: cavium: Remove the individual encrypt/decrypt function for
>     each algorithm
>   crypto: cavium: Add more algorithms
>
>  drivers/crypto/cavium/cpt/cptvf_algs.c | 234 ++++++++++++++++++++++-----------
>  drivers/crypto/cavium/cpt/cptvf_algs.h |   7 +
>  drivers/crypto/cavium/cpt/cptvf_main.c |   2 +-
>  3 files changed, 165 insertions(+), 78 deletions(-)
>
> --
> 2.1.4
>
