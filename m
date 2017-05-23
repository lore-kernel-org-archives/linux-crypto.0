From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] crypto: engine - replace pr_xxx by dev_xxx
Date: Tue, 23 May 2017 07:52:06 -0700
Message-ID: <1495551126.2093.60.camel@perches.com>
References: <20170523120903.31637-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:36374 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967075AbdEWOwM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 10:52:12 -0400
In-Reply-To: <20170523120903.31637-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-05-23 at 14:09 +0200, Corentin Labbe wrote:
> By adding a struct device *dev to struct engine, we could store the
> device used at register time and so use all dev_xxx functions instead of
> pr_xxx.

trivia:

> diff --git a/include/crypto/engine.h b/include/crypto/engine.h
[]
> @@ -58,6 +58,7 @@ struct crypto_engine {
>  	struct list_head	list;
>  	spinlock_t		queue_lock;
>  	struct crypto_queue	queue;
> +	struct device *dev;

Probably nicer to align to column for consistency

	struct device		*dev;
