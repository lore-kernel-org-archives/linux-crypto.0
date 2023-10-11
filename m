Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A648CDB46B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 17:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjJKRME (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjJKRMD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 13:12:03 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AF98F
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 10:12:01 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-57b67c84999so33046eaf.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 10:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697044320; x=1697649120; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea6VJT7qFM6GLWDHvaRUXCL18fEBuC90j1bsNiAF8Ts=;
        b=JgWQi5Kuku09bk6OZj/e4CRyfGgjSm91CzVBrdA29nIS+QGSSm6EU7j213fzDEZVvs
         nZrlWdyd65a66R1XSnOo1/wH1pMteDelEQUTQa6A8lHOY5//gFRXMj4BPJDAuOpwz1/x
         5pjn6Unsh3G9fsO5jksiBC5/dHmfk1/NmSWCkKUxBkenRE7Sj2pgE6UPQqgf9ao6LwYL
         Vsy7bWECcEQ6A2vQk67r+q6BYK5SA4ZjBEg18OioDt7AGA+jj5FaUQRNwpKs5ZHu1v7/
         4xGhA7QhujHoql23NIFszmlRGiEtfRkXUtTNXCMP/5f1nvmXuaoWCihunWslb6Xmy0Pz
         AuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697044320; x=1697649120;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ea6VJT7qFM6GLWDHvaRUXCL18fEBuC90j1bsNiAF8Ts=;
        b=mpoAxgYVJwsr7X5dvlmG6faeKeRNHKijhj3iANF/cHIYefjOZQlszw2ThcSNlxlJW5
         mVmlRpppJ8KrMFuAm0pKsNBZIZyspWrMgXZJLVQqHAtzF0L6+62EM7E8HZfiqUC83DoD
         cuWJfd7K+qaYAdZPiu9gMLTeqbrD6s8qEB3powIoBgV4gS82+YV1MXomOhsd7vxuGKoF
         +/2DX9Gmpcx05ArOmtZgm9fi5Yj4hv/QuHGEa+Cd1aaGviWptwW/IcTnfZWTzZgX+x9A
         VQhO+legLy21bS1so4by28G4G3prNnAOlnDzrTrU4q1kxrYAAvrewjvktOqZwaxEWt15
         E02Q==
X-Gm-Message-State: AOJu0YwAkfDT2m7pqDLRDV8CtobUXCGXeKZr+KfkHv+r2NQvTFrcWzjJ
        A8FSt7tsex7NU4OaoiHUZikuGd3k8f8=
X-Google-Smtp-Source: AGHT+IHO5/yROlaIE2MeFrY0Re0Q3NtJtfqPRICfl02qt1SMeZ24yO+58oJg8XUjqYfxXjnSW+8jyg==
X-Received: by 2002:a4a:d213:0:b0:57b:3a07:181c with SMTP id c19-20020a4ad213000000b0057b3a07181cmr20998188oos.9.1697044320721;
        Wed, 11 Oct 2023 10:12:00 -0700 (PDT)
Received: from [172.16.49.130] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id 63-20020a4a1742000000b0057327cecdd8sm2411864ooe.10.2023.10.11.10.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 10:12:00 -0700 (PDT)
Message-ID: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
Date:   Wed, 11 Oct 2023 12:11:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Prestwood <prestwoj@gmail.com>
From:   Denis Kenzior <denkenz@gmail.com>
Subject: Linux 6.5 broke iwd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Looks like something in Linux 6.5 broke ell TLS unit tests (and thus likely 
WPA-Enterprise support).  I tried a git bisect and could narrow it down to a 
general area.  The last good commit was:

commit 6cb8815f41a966b217c0d9826c592254d72dcc31
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Jun 15 18:28:48 2023 +0800

     crypto: sig - Add interface for sign/verify

     Split out the sign/verify functionality from the existing akcipher
     interface.  Most algorithms in akcipher either support encryption
     and decryption, or signing and verify.  Only one supports both.

     As a signature algorithm may not support encryption at all, these
     two should be spearated.

     For now sig is simply a wrapper around akcipher as all algorithms
     remain unchanged.  This is a first step and allows users to start
     allocating sig instead of akcipher.

     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Narrowing down further didn't work due to:
/usr/bin/ld: crypto/asymmetric_keys/x509_public_key.o: in function 
`x509_get_sig_params':
x509_public_key.c:(.text+0x363): undefined reference to `sm2_compute_z_digest'
collect2: error: ld returned 1 exit status

Regards,
-Denis
