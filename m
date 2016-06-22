From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 15:20:51 +0200
Message-ID: <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
References: <20160622101432.GA30454@gondor.apana.org.au> <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35566 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbcFVNUw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:20:52 -0400
Received: by mail-vk0-f67.google.com with SMTP id t7so7747881vkf.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2016 06:20:52 -0700 (PDT)
In-Reply-To: <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 22 June 2016 at 12:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> The only user of rsa-pkcs1pad always uses the hash so there is
> no reason to support the case of not having a hash.

We use pkcs1pad with AF_ALG to implement lightweight TLS.  TLS
versions < 1.2 use a non-standard hash so we'd have to move the PKCS#1
padding back to userspace if this is changed.

The remaining patches make sense, I think there was some reason there
were those PAGE_SIZE checks in every operation but it's probably no
longer valid.

Best regards
