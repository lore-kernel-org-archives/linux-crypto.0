Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EBFCDB47E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 14:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbjJLOTs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Oct 2023 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjJLOTr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2023 10:19:47 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EBBB8
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 07:19:45 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6c64a3c4912so668361a34.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 07:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697120384; x=1697725184; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sU6bicL5JnS2kQdhCmJB+79gZQVrmzKQwo4HsfXQMOk=;
        b=m8RHVEnVrLGBXxeB1Y9KuW1mCt9quwxLANqm8APx8ulWFVq5aRcQ+aa6GRF0h8xLPa
         w2oUWsK9PLmS/LbzG9vHjteBLi9uxd9gitVFOiOqnmqVUquVJnXixTIGkmIx4iQVpyWt
         EymchHvDT3gPt/LUOFz796iLrCQuIBZiAksR8oExk8VAXwLZMGNj4RDaMNqvuNPs4NXg
         +lHcqXF4mhdiOMMXoMoLKOJ8i/12vBHca74G8MHqvSl3ykV6MVOXLAt/tZb+uFHw7PIL
         mGwj5wTGh0uqMFCxyR9cW3l0tsNjrZPxvBM8YxChBLFzQQNat7jjXFrZSyDp3mOQ9A15
         1xWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697120384; x=1697725184;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sU6bicL5JnS2kQdhCmJB+79gZQVrmzKQwo4HsfXQMOk=;
        b=YNYZI1FAyDm2SADFYaktxH3Te0jpcNImLLohm3JI/HGGoynL6hOT2dusFi5lHo5bcK
         iyAq7nlgUpilWtkLzQoSk+bbsGgxvOoqQsZ3aH0vWoSBKlgCDkOIYqVfzlIQA/qAm2BZ
         SA7kq72ZjzutXKC+1SyGmdouf/rNJKjrB9evfe7wnOEDQnLxCHqTGC+Tga54wU830OB3
         Stm73QWaa9zN25EqZE3yc0nJcw5kttpdDvNDpiZokoWDbY12lyMh8Mq96DfDEnQRU2dD
         8tVYia6BVnMy4csnwbWXKbibYkXYd+d+BEmcF3K8zYq+GJa4nqFKZV4Jmu6j5WwuI+Vt
         HbzA==
X-Gm-Message-State: AOJu0Yx2ytSYpuUqqznZtWjpuzxol0Xg2ONuHf+pEdPj6/eKHWchL2mw
        7IVcoZehP3Tsdy59qxWTcQ+URBzJZ2Q=
X-Google-Smtp-Source: AGHT+IF7O1rQCtYSPwCUb6j/esW/cVz20ISAnBMXOdv263RKFp3qGgGrJxsezvG38Jcjlt9e2G+hdg==
X-Received: by 2002:a05:6830:99:b0:6bf:1e78:cc52 with SMTP id a25-20020a056830009900b006bf1e78cc52mr25861437oto.25.1697120384008;
        Thu, 12 Oct 2023 07:19:44 -0700 (PDT)
Received: from [172.16.49.130] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id j7-20020a9d7687000000b006c61c098d38sm313078otl.21.2023.10.12.07.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 07:19:43 -0700 (PDT)
Message-ID: <1d22cd18-bc2a-4273-8087-e74030fbf373@gmail.com>
Date:   Thu, 12 Oct 2023 09:19:42 -0500
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
From:   Denis Kenzior <denkenz@gmail.com>
In-Reply-To: <ZSdn29PDrs6hzjV9@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 10/11/23 22:28, Herbert Xu wrote:
> On Wed, Oct 11, 2023 at 10:09:02PM -0500, Denis Kenzior wrote:
> .
>> [denkenz@archdev linux]$ git checkout 63ba4d67594ad05b2c899b5a3a8cc7581052dd13
>> HEAD is now at 63ba4d67594a KEYS: asymmetric: Use new crypto interface
>> without scatterlists
> 
> No wonder I can't reproduce this.  This is already fixed by
> 
> commit 3867caee497edf6ce6b6117aac1c0b87c0a2cb5f
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sat Jun 24 13:19:56 2023 +0800
> 
>      crypto: sm2 - Provide sm2_compute_z_digest when sm2 is disabled
> 
> It's just a bisection artifact, you need to skip the broken commit
> when bisecting.
> 

Unfortunately that commit causes the unit test to crash the kernel.
bash-5.1# uname -a
Linux (none) 6.4.0-rc1-00082-g3867caee497e #37 Thu Oct 12 09:11:21 CDT 2023 
x86_64 GNU/Linux
bash-5.1# unit/test-key
TEST: unsupported
TEST: user key
TEST: Diffie-Hellman 1
TEST: Diffie-Hellman 2
TEST: Diffie-Hellman 3
TEST: simple keyring
TEST: trusted keyring
Kernel panic - not syncing: Kernel mode fault at addr 0x18, ip 0x601fac3a
CPU: 0 PID: 28 Comm: test-key Not tainted 6.4.0-rc1-00082-g3867caee497e #37
Stack:
  6232a840 6232d400 00000000 2000000100
  62345e00 00000000 718b7aa0 718b7aa0
  00000000 712851d8 10000000400 00000000
Call Trace:
  [<602115cd>] public_key_verify_signature+0x272/0x2ed
  [<60210503>] ? asymmetric_key_id_same+0x0/0x3b
  [<602131d9>] x509_check_for_self_signed+0x65/0xe3
  [<600bd2ca>] ? kfree+0x0/0x4a
  [<6021242f>] x509_cert_parse+0x205/0x245
  [<60212de2>] x509_key_preparse+0x28/0x237
  [<6006820d>] ? __down_read_common+0x92/0xc4
  [<602102f1>] asymmetric_key_preparse+0x50/0x7f
  [<601eaa68>] __key_create_or_update+0x1c1/0x4d4
  [<601ec7a1>] ? key_ref_put+0x0/0x16
  [<601ead90>] key_create_or_update+0x15/0x17
  [<601eccc2>] sys_add_key+0x183/0x1d8
  [<60025c4d>] handle_syscall+0x99/0xc7
  [<60038646>] userspace+0x4d3/0x60f
  [<60021ac2>] fork_handler+0x92/0x94
Aborted (core dumped)

I managed to narrow things down a bit further:

[denkenz@archdev linux]$ git bisect good
There are only 'skip'ped commits left to test.
The first bad commit could be any of:
501e197a02d4aef157f53ba3a0b9049c3e52fedc
afa9d00ee0fda2387ad598d0b106e96a7ed360ae
b335f258e8ddafec0e8ae2201ca78d29ed8f85eb
3867caee497edf6ce6b6117aac1c0b87c0a2cb5f
d744ae7477190967a3ddc289e2cd4ae59e8b1237
63ba4d67594ad05b2c899b5a3a8cc7581052dd13
767cfee8368f43c6d6c58cdf8c2d143a027fa55f
891ebfdfa3d08bf55ebec523c99bb68ac9c34cf7
e5221fa6a355112ddcc29dc82a94f7c3a1aacc0b
486bfb05913ac9969a3a71a4dc48f17f31cb162d
We cannot bisect more!

Four of the above are hwrng related, so not the culprits.

Maybe?

891ebfdfa3d08bf55ebec523c99bb68ac9c34cf7
crypto: sig - Fix verify call

Regards,
-Denis
