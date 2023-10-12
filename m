Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF75CDB47E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 15:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjJLPIw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343837AbjJLPIv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2023 11:08:51 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631B6BE
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 08:08:49 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6c4c594c0eeso680128a34.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 08:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697123328; x=1697728128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nhlvftp0Eau1YECdWUl7w/Gsq1ga8TMsCPoziQqIGXE=;
        b=H6bMbyJh2L07s3Diu87rgDUCafghipta7SZpKMhrBGkNGQ1GaOxa5NuKAQGrs0jQWw
         1f3c2w/fFQJ13moJvEFr49ym3pxRsiQStisUR3mGr/pQnVPS3arTLFO/ix5eR7rALrtV
         jk8HD9gHK4P+zorYYkSYE559XVEshdFaIZq9du9DqbjEQWjDfT5hmauQTWsqUofuv9iT
         Q+Fi4+kRQhVPyikabPKrgNclB1hCfMKzjKWS4klDzjzsvy/hJcbPgK6fbD96DSUZegMz
         DDbhVKix2qpo45U+XFIz4ygGPsuDIijdIijLjOO5u1tHiOTP3tgPyfv2KYJGXw/jfIWD
         +BTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697123328; x=1697728128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhlvftp0Eau1YECdWUl7w/Gsq1ga8TMsCPoziQqIGXE=;
        b=oMqs5cjmGd2N5VQihcYtcrPY6/y9oY/9B1rpz8RkvcxronpxYCFl1mZRu1phmIvTun
         1au+wbvw2HnPdLjBp05WAiK9WralI0teC4lja0K9jETMTd7hhXctes4mVWvDOSMibjTQ
         YcVfBzBJJWL4fQmiUvfwCw895BrsMwtOZTJf5KjWKvJ55v3EF6BBREdkt91zwKFep2Nq
         cagHmpqpyg+ZrGQyghFRaSaXm7JpEswnj738N6GitrepZe2uVe0RkkQUITc5BP8J/nbd
         r3D6pOiXNK3LoJo+pV6kXBMKlcsmkbWTJn/U9A8hkzDg8u3zpJlNRz792XTUL83dhlkE
         kGGQ==
X-Gm-Message-State: AOJu0YxbBykJvy+F9fEh1bGU6TtARK0FbDF4cx444ssAJUCadh8I0Gy2
        0yuvpzIp4TilmdLPUE9DngU=
X-Google-Smtp-Source: AGHT+IEk5cwYFBt4bB2R7DiehtAuPsNbgCjCkt2iwNbyWEw3o0mo3Ck9fNpODw8QNGXlQ1oyMJgeRQ==
X-Received: by 2002:a05:6830:118f:b0:6bc:cd0d:427e with SMTP id u15-20020a056830118f00b006bccd0d427emr22136498otq.38.1697123328619;
        Thu, 12 Oct 2023 08:08:48 -0700 (PDT)
Received: from [172.16.49.130] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id f9-20020a9d5e89000000b006c4ecbbcfa7sm330146otl.34.2023.10.12.08.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 08:08:48 -0700 (PDT)
Message-ID: <c917020d-0cb0-4289-a2e3-d9a0fa28151a@gmail.com>
Date:   Thu, 12 Oct 2023 10:08:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.5 broke iwd
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Prestwood <prestwoj@gmail.com>
References: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
 <ZSc/9nUuF/d24iO6@gondor.apana.org.au> <ZSda3l7asdCr06kA@gondor.apana.org.au>
 <be96d2e7-592e-467e-9ad2-3f69a69cf844@gmail.com>
 <ZSdn29PDrs6hzjV9@gondor.apana.org.au>
 <1d22cd18-bc2a-4273-8087-e74030fbf373@gmail.com>
 <ZSgChGwi1r9CILPI@gondor.apana.org.au>
From:   Denis Kenzior <denkenz@gmail.com>
In-Reply-To: <ZSgChGwi1r9CILPI@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

> OK, we need to take a step back.  The commits that you're testing
> are all known to be buggy.
> 
> So please tell me what exactly is the problem with the latest kernel
> and then we can work it back from there.

Looks like something took out the ability to run sign/verify without a hash on 
asymmetric keys.

> 
> If you have a reproducer that works on the latest kernel that would
> be great.
> 

Easiest is to run the ell unit test:

[denkenz@archdev tmp]$ git clone git://git.kernel.org/pub/scm/libs/ell/ell.git
[denkenz@archdev tmp]$ cd ell
[denkenz@archdev ell]$ ./bootstrap-configure
[denkenz@archdev ell]$ make -j16
[denkenz@archdev ell]$ unit/test-key
TEST: unsupported
TEST: user key
TEST: Diffie-Hellman 1
TEST: Diffie-Hellman 2
TEST: Diffie-Hellman 3
TEST: simple keyring
TEST: trusted keyring
TEST: trust chain
TEST: key crypto
test-key: unit/test-key.c:624: test_key_crypto: Assertion `len == 
sizeof(ciphertext)' failed.

Regards,
-Denis
