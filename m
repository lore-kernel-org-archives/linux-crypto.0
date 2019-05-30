Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB178C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 07:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAC4A25610
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 07:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQIA4q9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfE3HjT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 03:39:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37455 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfE3HjT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 03:39:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id h1so3461164wro.4;
        Thu, 30 May 2019 00:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f6gpiwLUuJ7oLJMeN7jt3+ObOTih2yoMnDqiwdziYpw=;
        b=XQIA4q9YQFOAj4GTuvXQ9HeR4rgx0QV1DVeptVcA/ipU3+6ZW84MaQ3kTGgy0Z369e
         sLjrNZ9N1ffMye4GBtbtn4RAa0FMI6P0A3dEN3mo6hClWjjJ6rS3+Xo4+mDaURbqwlx8
         jxMUvnegCIyDhKHRjIX9zhW24hAfxeR1Yp3yhLcyLrq5JT3/L3RpEiS3KKPbLvn5hNgV
         BzZwIAg43q1INgo2/sNQpdCWZjdYYc+f0n5FF2Rs/esRXTHrD0CbuyMHdy0vg9hEw0U8
         aNs+rbl9k/czm5Nj+0wiF6tU4Vkga6Z5EKU4zwrdrS8VJTojp4GAA+4g1Mp+sPwJY6Lj
         MtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f6gpiwLUuJ7oLJMeN7jt3+ObOTih2yoMnDqiwdziYpw=;
        b=F9XBS4l0fh6LGm+LXPYyg0NASdao6L01MBYaFkzDDtVgS5WBQnGe5IiusPY6W7fWLy
         kh+4Git9r0uoauA/P3uNCda8tfBvy0ZRTH8J7RIx9ZqvKAkBmv6mN9152++/6gQAv53B
         MBaHpgpFt18xi2qrRZGx904sM5puPt9v9bUFTPFWrxuCHRJoPqA9aCAGj7/F7pVmJic0
         el9LpIrczKZdi+x6o6Ub6i6XjGI2JhEIGZQa9PvEHgbEJLgzUgb47YcAjAy8vnPWt7OA
         2uFvDmpjCg2lbn7ZslMWUoM41bFyIMN93LYLMITA3RiZ0wF6nqIpfp2a/tQoSa9EFPA7
         ftqQ==
X-Gm-Message-State: APjAAAVQMOc/toaAeHooiipHgkEplfRnBcLQ1EeVJf63ZACOBUvH1xsE
        3mBdeVFvbPbPNXo3rZc/adGRBgrmHVmSVw==
X-Google-Smtp-Source: APXvYqwwfKirnrLfA9EPuN6PGTnkLM6dJG5tBhfYIzKRH7jZcyVu8fuMRmTRuwE9HS8SLu4i/08kxg==
X-Received: by 2002:adf:e7c5:: with SMTP id e5mr1489911wrn.107.1559201957520;
        Thu, 30 May 2019 00:39:17 -0700 (PDT)
Received: from [10.43.17.75] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d9sm2316251wro.26.2019.05.30.00.39.16
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 00:39:16 -0700 (PDT)
Subject: Re: [PATCH] crypto: af_alg - implement keyring support
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Ondrej Kozina <okozina@redhat.com>,
        Daniel Zatovic <dzatovic@redhat.com>
References: <20190521100034.9651-1-omosnace@redhat.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e492858e-a93b-cee9-b50a-e61e23ce9f90@gmail.com>
Date:   Thu, 30 May 2019 09:39:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190521100034.9651-1-omosnace@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 21/05/2019 12:00, Ondrej Mosnacek wrote:
> This patch adds new socket options to AF_ALG that allow setting key from
> kernel keyring. For simplicity, each keyring key type (logon, user,
> trusted, encrypted) has its own socket option name and the value is just
> the key description string that identifies the key to be used. The key
> description doesn't need to be NULL-terminated, but bytes after the
> first zero byte are ignored.

There is one nasty problem with this approach (we hit the same in dmcrypt now).

These lines cause hard module dependence on trusted.ko and encrypted.ko
modules (key_type_* are exported symbols):

 +static const struct alg_keyring_type alg_keyring_type_trusted = {
 +	.key_type = &key_type_trusted,...
...
 +	.key_type = &key_type_encrypted,

I do not think this is what we actually want - the dependence should be dynamic,
the modules should be loaded per-request...

I asked David Howells, and seems kernel keyring does not have such
interface yet. (There is an internal lookup function already though.)

So until such a lookup interface is present, and the patch is ported to it,
I think this patch adds module dependency that should not be there.

Milan
