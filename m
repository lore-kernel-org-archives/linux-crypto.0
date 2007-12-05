From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: Problems encountered with latest cryptodev-2.6 under UML
Date: Thu, 6 Dec 2007 00:59:27 +0800
Message-ID: <fd3e431c0712050859x2e6c2d7bqc7c3e39cf243637@mail.gmail.com>
References: <fd3e431c0712020759tbc41c91o39c0c3e56be66734@mail.gmail.com>
	 <20071202212841.GA7343@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Linux Crypto" <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:31494 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751963AbXLEQ72 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Dec 2007 11:59:28 -0500
Received: by rn-out-0102.google.com with SMTP id i6so2745194rng
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2007 08:59:27 -0800 (PST)
In-Reply-To: <20071202212841.GA7343@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Dec 3, 2007 5:28 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Yes as I said earlier geniv was broken.  I've since removed it from my
> tree.
Sorry for the lousy bug report. I misinterpreted git-pull's "Already
up-to-date" to mean that it matches your tree exactly. Apparently that
is not the case. I just git-clone and the current tree works fine.
Thanks!

Swee Heng
