Return-Path: <SRS0=UIra=5S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AFAC43331
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 10:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F1420658
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 10:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="gA+0yFMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbgDBKy5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Apr 2020 06:54:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37587 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgDBKy5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Apr 2020 06:54:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48tKhb4hmdz9sRN;
        Thu,  2 Apr 2020 21:54:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1585824895;
        bh=k1eckHiRYcUlA+oiJEV2L/x/tm7pSdUROFgylzAgvQU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gA+0yFMo3UD0GnfCfq46uR33SrXx1FsexzcNqB3CXDFCYHE59cFy2VnnS1bQIvdrf
         0zTKrYmKBFNayJsUsasr49Wfm552UUbCi4XJ9KdDCiLJUwbK0RW278t4WMtymrG+Vn
         Nfs/6qtq/kygTgiloASV3SuZ+WnMMzJ+xQEPe1w/NG86zeJcjx/BHdkUXB8KR4GJJW
         sc5yYICTiIakePYPx29WodTJNujWgSSjUsfuXU9DHZgsHRbCLGSti6FJPgwOKU6JFb
         M9+pDGIV/lU7gjeGLdJKOyDPuJtRubxCVidHxuru4HV/ga173tPOXo/lZxkGEWrtxw
         t7QeDuLD7nYcw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Axtens <dja@axtens.net>,
        Raphael Moreira Zinsly <rzinsly@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, haren@linux.ibm.com, abali@us.ibm.com,
        Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
Subject: Re: [PATCH V2 3/5] selftests/powerpc: Add NX-GZIP engine compress testcase
In-Reply-To: <87369mwgwy.fsf@dja-thinkpad.axtens.net>
References: <20200327181610.13762-1-rzinsly@linux.ibm.com> <20200327181610.13762-4-rzinsly@linux.ibm.com> <87369mwgwy.fsf@dja-thinkpad.axtens.net>
Date:   Thu, 02 Apr 2020 21:55:03 +1100
Message-ID: <875zeitawo.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Daniel Axtens <dja@axtens.net> writes:
> Raphael Moreira Zinsly <rzinsly@linux.ibm.com> writes:
>
>> Add a compression testcase for the powerpc NX-GZIP engine.
>>
>> Signed-off-by: Bulent Abali <abali@us.ibm.com>
>> Signed-off-by: Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
...
>> diff --git a/tools/testing/selftests/powerpc/nx-gzip/gzip_vas.c b/tools/testing/selftests/powerpc/nx-gzip/gzip_vas.c
>> new file mode 100644
>> index 000000000000..d28e1efb527b
>> --- /dev/null
>> +++ b/tools/testing/selftests/powerpc/nx-gzip/gzip_vas.c
>> @@ -0,0 +1,259 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +/* Copyright 2020 IBM Corp.
>> + *
>> + * Author: Bulent Abali <abali@us.ibm.com>
>> + *
>> + */
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <stdint.h>
>> +#include <sys/types.h>
>> +#include <sys/stat.h>
>> +#include <sys/time.h>
>> +#include <sys/fcntl.h>
>> +#include <sys/mman.h>
>> +#include <endian.h>
>> +#include <bits/endian.h>
>> +#include <sys/ioctl.h>
>> +#include <assert.h>
>> +#include <errno.h>
>> +#include <signal.h>
>> +#include "nx-gzip.h"
>> +#include "nx.h"
>> +#include "copy-paste.h"
>> +#include "nxu.h"
>> +#include "nx_dbg.h"
>> +#include <sys/platform/ppc.h>
>> +
>> +#define barrier()
>> +#define hwsync()    ({ asm volatile("hwsync" ::: "memory"); })
>
> This doesn't compile on the clang version I tried as it doesn't
> recognise 'hwsync'.

What assembler are you using? I guess the LLVM one?

Can you try with -fno-integrated-as ?

> Does asm volatile("sync" ::: "memory");
> do the same thing? That is recognised by clang, but I don't know if
> dropping the hw prefix matters!

It shouldn't matter.

But you can just try it and look at the generated code to be sure, you
should get 0x7c0004ac.

cheers
