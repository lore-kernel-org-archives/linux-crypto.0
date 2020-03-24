Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A95FC4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A43206F9
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YH+7nYPt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgCXAWj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:22:39 -0400
Received: from terminus.zytor.com ([198.137.202.136]:32779 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgCXAWj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:22:39 -0400
Received: from hanvin-mobl2.amr.corp.intel.com (jfdmzpr05-ext.jf.intel.com [134.134.139.74])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 02O0MGjT2855350
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 23 Mar 2020 17:22:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 02O0MGjT2855350
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020022001; t=1585009340;
        bh=6ozD22oNmLz3Eyc6szHUH/qbiZMeaSJjOryDYbDBROQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YH+7nYPt7tPJkMOnFeE1w2qg3kxk+wLUW1H4sj2UxJ0ND9QdKXu6Cc/QTBdPpuZkV
         fCu1dUPtFuB9k2XOo4HQcF8VDk8XBtONfFAXwugcx1jQUIGMZg2miJKZ1p66PdgW0L
         PXP44TvuJ2sVVWL3RbKAvh8T1QmsDAaKrjfv3NK36p18mTqjFuhWs49AVg1gW0Pgiq
         1iyFs2Rff45bUJ2B7V1KzXjPIiDXOP04KbaXZnp5WEBtG2XWFfXKrupmF5WmktQP+s
         WtSsVb7RLeJ64WNNQFPpIgWuEi/kiqge9/iB29Dm6RX5tW8zh4yTzWY2x7/MniOCTd
         R6aRAu1H5JvBg==
Subject: Re: [PATCH v2 1/9] lib/raid6/test: fix build on distros whose /bin/sh
 is not bash
To:     Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
References: <20200324001358.4520-1-masahiroy@kernel.org>
 <20200324001358.4520-2-masahiroy@kernel.org>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <56f56703-9771-8d64-3820-0ffbbe8dd3bc@zytor.com>
Date:   Mon, 23 Mar 2020 17:22:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324001358.4520-2-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-03-23 17:13, Masahiro Yamada wrote:
> You can test raid6 library code from user-space, like this:
> 
>   $ cd lib/raid6/test
>   $ make
> 
> The command in $(shell ...) function is evaluated by /bin/sh by default.
> (or, you can change the default shell by setting 'SHELL' in Makefile)
> 
> Currently '>&/dev/null' is used to sink both stdout and stderr. Because
> this code is bash-ism, it only works when /bin/sh is a symbolic link to
> bash (this is the case on RHEL etc.)
> 
> This does not work on Ubuntu where /bin/sh is a symbolic link to dash.
> 
> I see lots of
> 
>   /bin/sh: 1: Syntax error: Bad fd number
> 
> and
> 
>   warning "your version of binutils lacks ... support"
> 
> Replace it with portable '>/dev/null 2>&1'.
> 
> Fixes: 4f8c55c5ad49 ("lib/raid6: build proper files on corresponding arch")
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>

> ---
> 
> Changes in v2:
>   - New patch
> 
>  lib/raid6/test/Makefile | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> index 3ab8720aa2f8..b9e6c3648be1 100644
> --- a/lib/raid6/test/Makefile
> +++ b/lib/raid6/test/Makefile
> @@ -35,13 +35,13 @@ endif
>  ifeq ($(IS_X86),yes)
>          OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
>          CFLAGS += $(shell echo "pshufb %xmm0, %xmm0" |		\
> -                    gcc -c -x assembler - >&/dev/null &&	\
> +                    gcc -c -x assembler - >/dev/null 2>&1 &&	\
>                      rm ./-.o && echo -DCONFIG_AS_SSSE3=1)
>          CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1" |	\
> -                    gcc -c -x assembler - >&/dev/null &&	\
> +                    gcc -c -x assembler - >/dev/null 2>&1 &&	\
>                      rm ./-.o && echo -DCONFIG_AS_AVX2=1)
>  	CFLAGS += $(shell echo "vpmovm2b %k1, %zmm5" |          \
> -		    gcc -c -x assembler - >&/dev/null &&        \
> +		    gcc -c -x assembler - >/dev/null 2>&1 &&	\
>  		    rm ./-.o && echo -DCONFIG_AS_AVX512=1)
>  else ifeq ($(HAS_NEON),yes)
>          OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
> 

