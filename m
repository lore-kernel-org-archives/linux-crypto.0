Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED323C4646B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 07:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB4382086D
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 07:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5Vo4Xvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfFZHjd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 03:39:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36977 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfFZHjd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 03:39:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so1469114wrr.4
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2019 00:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PtXpvYN9mCa8w0iR1BV1It8OBzidBqxfzs4wNKcWYOM=;
        b=L5Vo4Xvg+xc0hoBBMBCJ0nYhYx0CFVY6gMUyGbjUpWO5hzvnuBN7fwrLpdmW4u8oYM
         6d7Z4y4N1b6Rpzs4PaJgSamu24kxwr3srIhWcVQQEq2LNnPu9xJxMN/XY0HgiEGpurJf
         PxCLphYnGfyvfrW7To0nrrdD+oTRLDbMAAKQ0gxEeY5wvnuT3rBtmwkzd5pjlVozY+Dw
         iot7axiuaLqgKR3lZM5dxEEvUCbqL1JZKDaFQskEhVOyQp/xeda5ddvntbHGU/PoAUJ6
         /caIsyAbA7nwKckB3a7HHpkiKFqAkNW70j+FKnEG2RqZnyv9cbMVQVBx/WABnqyc3MHv
         H7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PtXpvYN9mCa8w0iR1BV1It8OBzidBqxfzs4wNKcWYOM=;
        b=EcVRQiWeblYurT7z9lEzQHmHY80WzvXqF8sz4kLpP3EghcwkGnaywMsYgIUINpfc3i
         lp2zrvuQQ+jWZVMIh8NKA5mZtMzhhnAconW0eMYI8nw9y99WPsVooOBnYauL/yolUVQ+
         4zBIecX6iNrltlDsONa5UC7HDZvJbagN/r3RynRlfANOGseYMSv66mXekeYKNX84aVEN
         C/GP6O559zMGfn2aUidbV0VugdJk7NdrPkPKEz5sXi9ZNAuf1fMBIoKsAtkSCgrEAogM
         mbEuYbjZnDnrWcfd7yF38pZmbiKmv7CLPAiCYhxTIOyliT2ze4+AqEz1TfIQoNxQ8RIP
         p4AQ==
X-Gm-Message-State: APjAAAVDCx24AJx2Ww1ZMVEEEkWrOSlBloWgniZ0v4C35nJciz/irCVU
        hcwNwJ1hL58d4Oo/oBI1A8U=
X-Google-Smtp-Source: APXvYqyeU2K/3I/+7yDdgNVTVngHpYhZC8BPQj9kv/pLZYqUwi7ShYq2o8ZeWZNYArP+fZA8qXLVjA==
X-Received: by 2002:adf:f28a:: with SMTP id k10mr2411895wro.343.1561534771303;
        Wed, 26 Jun 2019 00:39:31 -0700 (PDT)
Received: from [10.43.17.24] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z6sm15941593wrw.2.2019.06.26.00.39.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 00:39:30 -0700 (PDT)
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Milan Broz <gmazyland@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <20190625171234.GB81914@gmail.com>
 <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
 <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com>
 <CAKv+Gu9jAqGAYg8f_rBVbve=L3AQb_xKnpmnsqrZ3m7VLnaz1g@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e9d045c6-f6e2-a0d2-b1f2-bebee5d027f4@gmail.com>
Date:   Wed, 26 Jun 2019 09:39:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9jAqGAYg8f_rBVbve=L3AQb_xKnpmnsqrZ3m7VLnaz1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/06/2019 09:15, Ard Biesheuvel wrote:

> Thanks for the insight. So I guess we have consensus that MORUS should
> be removed. How about aegis128l and aegis256, which have been
> disregarded in favor of aegis128 by CAESAR (note that I sent an
> accelerated ARM/arm64 version of aegis128 based on the ARMv8 crypto
> instructions, in case you missed it)

Well, there are similar cases, see that Serpent supports many keysizes, even 0-length key (!),
despite the AES finalists were proposed only for 128/192/256 bit keys.
(It happened to us several times during tests that apparent mistype in Serpent key length
was accepted by the kernel...)

(Maybe the cleanup should continue? :-)

Dunno, for me, I think the generic implementation could stay there.

Milan
