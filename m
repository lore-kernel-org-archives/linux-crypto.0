Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA82C54FD0
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 16:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CF420767
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 16:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mrzi5atR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgDWQgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 12:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729407AbgDWQgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 12:36:05 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37561C09B041;
        Thu, 23 Apr 2020 09:36:05 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id j26so7157433ots.0;
        Thu, 23 Apr 2020 09:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZD5R6FmUjPmeYL4MRpYo2rDAvGPliTwTgGLA+RltUqk=;
        b=mrzi5atRRI2q3lMqAA6n6OfEcnerfPoNonIqtPU1b5IDS8I6RB9CnvWYjRv1+FNgQ+
         1hQAvaydH0SIwTKWkrXj0QXhUfIK7hJCMjAWxzcrsLndr1hHEojvwqlL9RE+KQf41Ohw
         C54/gWvcQ7WhARr0DpWrTGZf+WKCLWpHAtHfJYQtCSO90ZL8EyJHMWx/MXBKVpftxaos
         cwYgQwfkrRlpKd9+NJJoijx7ki+uV2tKrs1W3OBSTKJwxyzxREaiRBOWIiV2NdB25J7n
         FR1p6b7X6MfsupFfkyZngdbfHyxhf9Q9zT22p4VrdGFWefKKNostT25EZM/L95tn/vFa
         NFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZD5R6FmUjPmeYL4MRpYo2rDAvGPliTwTgGLA+RltUqk=;
        b=XWwVU5kDNLDOp5b4AZ3iJHQNUquw168w/IhIE2Zltryw7yVceTCHYgbAhFFhdGcLNp
         iabTr4mokGM0Z4WfpoQlpjijHi0JfYJP806TTKte7WC4jQKOIUVFIsi8YUkTkq/m2bjR
         l68i9wzKZP9HAVZXaucerXQSfiDLbtbWxcXbvMafoUAIUpzUSnePAEZT/y2m+HWZp7AA
         yHpXsvjnqkdzePDfJf7rWuK/ZSzPfcLL5yVmUwUjFkEcQxElIqgZvNgzQFa+TdDm9IKy
         qoo/2Moy6lSpkTmTSdxgK7MxU09eGHJywxt/H8vMUMkWJTgkCTD5SkCSeBMdmj3Rdumm
         5DlQ==
X-Gm-Message-State: AGi0PuamYAD8UsUEQYf88ljQuStzjxj/awg81XXc5NKZ0eC57U7HIdab
        wzbQUSXuKApcGrERL/4R2H7bSNktixQ=
X-Google-Smtp-Source: APiQypJHtf6Ck2oO+M4egmth4Lj3DPdzF5M8EvzupgTfw7XGpdJcG37znh+DX6bhvgIOm+iyOdEuew==
X-Received: by 2002:aca:f254:: with SMTP id q81mr3723853oih.12.1587659764320;
        Thu, 23 Apr 2020 09:36:04 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id b19sm791382oii.1.2020.04.23.09.36.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 09:36:03 -0700 (PDT)
Date:   Thu, 23 Apr 2020 09:36:02 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] lib/mpi: Fix building for powerpc with clang
Message-ID: <20200423163602.GA18872@ubuntu-s3-xlarge-x86>
References: <20200413195041.24064-1-natechancellor@gmail.com>
 <20200414135731.GA8766@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414135731.GA8766@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 14, 2020 at 11:57:31PM +1000, Herbert Xu wrote:
> On Mon, Apr 13, 2020 at 12:50:42PM -0700, Nathan Chancellor wrote:
> > 0day reports over and over on an powerpc randconfig with clang:
> > 
> > lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
> > inline asm context requiring an l-value: remove the cast or build with
> > -fheinous-gnu-extensions
> > 
> > Remove the superfluous casts, which have been done previously for x86
> > and arm32 in commit dea632cadd12 ("lib/mpi: fix build with clang") and
> > commit 7b7c1df2883d ("lib/mpi/longlong.h: fix building with 32-bit
> > x86").
> > 
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/991
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Might be better for you to take this instead. 0day just tripped over
this again.

Cheers,
Nathan
