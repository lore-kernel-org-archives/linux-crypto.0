Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC3DCDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 02:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjJLCSJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 22:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbjJLCSI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 22:18:08 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CD4C0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 19:18:06 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-57b68556d6dso240801eaf.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 19:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697077086; x=1697681886; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jrqP6Xob8zgQLbzmdJIc5MMa2E7i5HONr7VvT9m0DA8=;
        b=j+zLeDxSZbP01HejGOEed5Gmm6A/CbVg27BFY/5iA2l/HqacTy+eN7RWg5SfB0OqRA
         ml33yDNScy6wDXJve5YS+icJB4rSsKCfK5z8pYvGpv2K0LAoaWBeeTT4pZu174g5bp7x
         8hMbAum+cQSpRbeR7xct+esPtqUAc7/nPsB6BVShpTg4e+e+eUb0Kpo5T0wNPUc2ikQ0
         zaPbPNOGox1/tZhOV5f0WLZ2BEav3RhXBWHNeYRhdcOTLuBdt4s2koTJZL/5NK80rw1g
         uw6liNyNErLVMAeruy/vISOpIulqQ805DaiG4iCK7sU3iu0Ltv77/OpcACONcDadBNJ4
         0atg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697077086; x=1697681886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrqP6Xob8zgQLbzmdJIc5MMa2E7i5HONr7VvT9m0DA8=;
        b=t28bmPqQ0E/JmYUBYPu+jCKFzO+auKoX+OfQJKTne+9o16SBR/Y2wLkNwsFOoGlsil
         t/+ZbZyaNhuG4oDkFN29+ZLblcT9uW/SztSeNDDiIIF8TqyiQ2vcY2VIH7Micr0SxcQh
         zVPVyoteHYhZflWw+pGIm6r3ilrLXbr6D5zEQrejTF2VubTAS6CMflzeZw1OsqeILk0g
         GrId6Jo3YECyzPI6v+JCUSgBQRUNA1M6G9/oWBwgyE3czt1iUZrS4hKXkCiv+XvD0Y4/
         ib50XkXlTPXP5Hf+TgGP/dTlS2+EPaD02oVZ8hn5r08dM1au3zJ6QeKXvkqqri/nU5r7
         wegA==
X-Gm-Message-State: AOJu0YxKQqLZYczhrD8VuAOrJfSMp02xYQhQicMApYDCMKxrpDhOs6xv
        7DTpgzPkI9S/oA4hxW0zliSxAzr4Td8=
X-Google-Smtp-Source: AGHT+IEKmSpenxWM3CFTcLXZ2cQrFLNRU0AxELTyMBRok/Mu4PButryb1gjN+T1eOwhSLgdtEIsyqA==
X-Received: by 2002:a4a:3016:0:b0:57d:e76d:c206 with SMTP id q22-20020a4a3016000000b0057de76dc206mr23125465oof.1.1697077085847;
        Wed, 11 Oct 2023 19:18:05 -0700 (PDT)
Received: from [172.16.49.130] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id o12-20020a4a2c0c000000b0057e66fa004dsm2556206ooo.47.2023.10.11.19.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 19:18:05 -0700 (PDT)
Message-ID: <4f5f4d52-a1c4-4726-80c2-dcc8b3e86e5c@gmail.com>
Date:   Wed, 11 Oct 2023 21:18:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.5 broke iwd
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Prestwood <prestwoj@gmail.com>
References: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
 <ZSc/9nUuF/d24iO6@gondor.apana.org.au>
From:   Denis Kenzior <denkenz@gmail.com>
In-Reply-To: <ZSc/9nUuF/d24iO6@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

> 
> This looks like a Kconfig issue.  Please send me your .config file.

Possible.  I performed the bisect using a kernel configuration from the 
following instructions:

https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/doc/test-runner.txt#n55

In my case, I was using the User Mode Linux arch and testing locally using iwd's 
test runner.

# make ARCH=um olddefconfig
# make ARCH=um -j8

from iwd-git:
# tools/test-runner --kernel=<path to linux> --start=/bin/bash
<run the failing ell unit test.  Namely ell/unit/test-key and ell/unit/test-tls>

Here's my bisect log:
[denkenz@archdev linux]$ git bisect log
git bisect start
# status: waiting for both good and bad commits
# good: [6995e2de6891c724bfeb2db33d7b87775f913ad1] Linux 6.4
git bisect good 6995e2de6891c724bfeb2db33d7b87775f913ad1
# status: waiting for bad commit, 1 good commit known
# bad: [2dde18cd1d8fac735875f2e4987f11817cc0bc2c] Linux 6.5
git bisect bad 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
# good: [b775d6c5859affe00527cbe74263de05cfe6b9f9] Merge tag 'mips_6.5' of 
git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux
git bisect good b775d6c5859affe00527cbe74263de05cfe6b9f9
# bad: [56cbceab928d7ac3702de172ff8dcc1da2a6aaeb] Merge tag 'usb-6.5-rc1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect bad 56cbceab928d7ac3702de172ff8dcc1da2a6aaeb
# good: [b30d7a77c53ec04a6d94683d7680ec406b7f3ac8] Merge tag 
'perf-tools-for-v6.5-1-2023-06-28' of 
git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next
git bisect good b30d7a77c53ec04a6d94683d7680ec406b7f3ac8
# bad: [dfab92f27c600fea3cadc6e2cb39f092024e1fef] Merge tag 'nfs-for-6.5-1' of 
git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect bad dfab92f27c600fea3cadc6e2cb39f092024e1fef
# good: [28968f384be3c064d66954aac4c534a5e76bf973] Merge tag 'pinctrl-v6.5-1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good 28968f384be3c064d66954aac4c534a5e76bf973
# bad: [5d95ff84e62be914b4a4dabfa814e4096b05b1b0] Merge tag 'v6.5-p1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect bad 5d95ff84e62be914b4a4dabfa814e4096b05b1b0
# good: [d8c226ac1f748d0eac54ef869a4f41b26bc4f825] Merge branch 
'pci/controller/endpoint'
git bisect good d8c226ac1f748d0eac54ef869a4f41b26bc4f825
# good: [ef492d080302913e85122a2d92efa2ca174930f8] crypto: caam - adjust RNG 
timing to support more devices
git bisect good ef492d080302913e85122a2d92efa2ca174930f8
# good: [b25f62ccb490680a8cee755ac4528909395e0711] Merge tag 'vfio-v6.5-rc1' of 
https://github.com/awilliam/linux-vfio
git bisect good b25f62ccb490680a8cee755ac4528909395e0711
# good: [6cb8815f41a966b217c0d9826c592254d72dcc31] crypto: sig - Add interface 
for sign/verify

Regards,
-Denis
