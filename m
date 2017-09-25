From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: cryptoloop - Fix build warning
Date: Mon, 25 Sep 2017 13:24:22 -0600
Message-ID: <d9bed3f0-637d-8003-de09-c382f00f9e1e@kernel.dk>
References: <20170925171007.4660-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:55653 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965777AbdIYTYY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 15:24:24 -0400
Received: by mail-io0-f181.google.com with SMTP id z187so10696809ioz.12
        for <linux-crypto@vger.kernel.org>; Mon, 25 Sep 2017 12:24:24 -0700 (PDT)
In-Reply-To: <20170925171007.4660-1-clabbe.montjoie@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/25/2017 11:10 AM, Corentin Labbe wrote:
> This patch fix the following build warning:
> drivers/block/cryptoloop.c:46:8: warning: variable 'cipher' set but not used [-Wunused-but-set-variable]

Thanks, added for 4.15.

-- 
Jens Axboe
