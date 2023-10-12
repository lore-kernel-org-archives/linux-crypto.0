Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAEBCDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 03:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjJLDJL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 23:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbjJLDJK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 23:09:10 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B028394
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 20:09:04 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6c4b9e09528so340950a34.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 20:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697080144; x=1697684944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7tqM+00K8kKUMJM7ZhaBJxyhA89t88m9MxRvAL5Lmh8=;
        b=g/Qrtywr5mCYZeGRQbldV5RXE7kqCXGjvSRHkkwRVHEKcPlJRuOxCv06kN3x+L9HT4
         uW4OkR3sGAofTiYxLY0mOMqBTzl6L/QA+vnWIL+PAsXMoj79Db3wRoHE5tjaoyW/Y6zZ
         nEPmF/UuS40AIHDVNVQN8cuKVHGCbPG9cIwaFFVPdbGK9blK3ECFNGHgDQTX9IGzezeB
         Yb8zC3MkY63da4QGHvrL+ve61JnMmZVVOOfcCWFE8hN8nvflJpSj+wH3YnCRJubOFHoo
         Z/fASTxFSsjknxx8hE7Ggd9yiZ3mbT5e/+qii+Jk5Y30x1ZG5EAHkzqre0w2qgc4S5X4
         7c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697080144; x=1697684944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7tqM+00K8kKUMJM7ZhaBJxyhA89t88m9MxRvAL5Lmh8=;
        b=cztcw+wgSrf97iV5EIhPtvucUGMR+3txXxNwLDzMmzILrCNSYtZtuYf//OWbzjIEUH
         XNqcVFXkKf4TTqRpWHT94iUoT4J+ctAOkwuL/NUQgQlUHqppuki4bz0ps1zNadZoPh7K
         wF5+CZUWknh6pJ3AAsAwa0wIj9lWFNOmFTUhsKLqohsho9iv9LbNNJhkGao1k2s4UeAo
         4aPYTbh2BAuDIHaKwKt9vDlvLSKVE1f2FatFy+pB8ygcwYw5WK0vyOFxB8VsIhFVR7vo
         AgKAwxAFAhRNkS38sJXlk+PEJe5ZhTz4gI8/NzqDwejO88phnOAXr19eWfcWNAxugSI2
         X9XA==
X-Gm-Message-State: AOJu0YzT16I7T7NxH3GKFhCZj2WddMUdv5LFIfhNLAoqP5h9FC6pb1pL
        VVazDSvnbBDb8RvIxYu0KP10LMVsjRo=
X-Google-Smtp-Source: AGHT+IFZE2FUsdfD4OgkhndMQIMwlb8Wc03Yc8QUCHW2CsQHBUFpXxLWSp554rXqjhNRgcQvNsjcxg==
X-Received: by 2002:a9d:6a14:0:b0:6bc:86f1:f24e with SMTP id g20-20020a9d6a14000000b006bc86f1f24emr23672874otn.12.1697080143895;
        Wed, 11 Oct 2023 20:09:03 -0700 (PDT)
Received: from [172.16.49.130] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id h2-20020a4a5e02000000b005760ec1708esm2584693oob.38.2023.10.11.20.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 20:09:03 -0700 (PDT)
Message-ID: <be96d2e7-592e-467e-9ad2-3f69a69cf844@gmail.com>
Date:   Wed, 11 Oct 2023 22:09:02 -0500
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
From:   Denis Kenzior <denkenz@gmail.com>
In-Reply-To: <ZSda3l7asdCr06kA@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

> 
> I wonder if this is a bug in the bisection process.  The reference
> to sm2_compute_z_digest is protected by an IS_REACHABLE test on
> SM2 which is presumably disabled in your configuration.

So I just tried this again, here are the exact steps.  I believe the sha1 below 
was next in the bisect process.

[denkenz@archdev linux]$ git checkout 63ba4d67594ad05b2c899b5a3a8cc7581052dd13
HEAD is now at 63ba4d67594a KEYS: asymmetric: Use new crypto interface without 
scatterlists
[denkenz@archdev linux]$ make ARCH=um x86_64_defconfig
#
# configuration written to .config
#
[denkenz@archdev linux]$ ARCH=um sh ~/iwd-master/tools/test_runner_kernel_config
[denkenz@archdev linux]$ make ARCH=um olddefconfig
#
# configuration written to .config
#
[denkenz@archdev linux]$ make clean
   CLEAN   crypto/asymmetric_keys
   CLEAN   drivers/base/firmware_loader/builtin
   CLEAN   init
   CLEAN   kernel
   CLEAN   lib
   CLEAN   .
   CLEAN   modules.builtin modules.builtin.modinfo .vmlinux.export.c
[denkenz@archdev linux]$ make ARCH=um -j16

...

/usr/bin/ld: crypto/asymmetric_keys/x509_public_key.o: in function 
`x509_get_sig_params':
/home/denkenz/devel/linux/crypto/asymmetric_keys/x509_public_key.c:70:(.text+0x390): 
undefined reference to `sm2_compute_z_digest'

Regards,
-Denis
