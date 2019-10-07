Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FB8C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC0A21655
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570456828;
	bh=5DKDGeTFgWgrnLxNSIQxh5fo19stg4UcbImx3z4ru/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KnBNd+/tOrVNHsn8Wy0LrL9DDJMl+hCG70KQMrt60da6uQU9Zpk2HZWwgHgILqQD8
	 ZpNF+V9qdraKEMMZn8HifLAX3VUTDUhpyuOJlfCmITKARm91sdT75JX/EjI+2qNig0
	 IgWa5QuYCknmm+mKSbQrTtu0NstLKdJRZNLPPLCw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfJGOA2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:00:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33441 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOA1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 10:00:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so106161wme.0;
        Mon, 07 Oct 2019 07:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LTQi6AkTTCXGOyTWZNioMhV3bvTHe5T1ruIzA19ASxM=;
        b=Ec5eQrQETPS4fmIBKOLkJ++AcnN6gM5l5/ss/GzPFzM4k/tPOxRjtlxVfT1sTjhyY/
         GnyJUpjY7ekRLAKB+uyJaFgwUReOVX9x55IXQlzzBEDiGnfgwydrBbEblPgFKWHHxJFW
         N4ZDVDehirClb2LDqMjWWrQZkfcn+gqMPw5R1BZ4NpHeaBuGSGSkUUnFK2wbY1K4hMIq
         ttRFGExAhQuGdpYLmX0ZlxozPCZBrd/R6uKEqRDmr+J3Ty3xlX5Mkj1it3sgn5WtxDbw
         BBuPVcS8Uvp+AZhEMwsBPU5cl0wPi6iBMoqgF2MRWjzVmPZRPYsrSZ8QLkvR5qvyQ6QX
         rocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LTQi6AkTTCXGOyTWZNioMhV3bvTHe5T1ruIzA19ASxM=;
        b=bDSYxmXsBY01hm5YHYs1vJ2glVnK8LkXf0RKo+D43nEcOr+5J87259VYRvXgu954mX
         dyHvA9kP7wxuGUTAhAq29K09BheFUHlINZwsDcvP8T+otSTgddsCop6bACZ70YO1iFzv
         R3wCAhwmoljqrujRaEmPNzHq5BYOO77puG9XzY5Z6c+/tnICzmfjCDzscBCRnDu1vPxq
         bEhT2tXsrGnAQ5Co44boDJK1TfmladM/cJ/D5f9RtokxkM/MLSu/HEM9in8ksyZMD1vB
         lZxN7fU7pf0Y2OYvI6ZEdrjlwHEYlvilMno4hRLLVJcIUmVdmenZf7GkTvcl8fEoOWEF
         gCrw==
X-Gm-Message-State: APjAAAXNZlPo372ejbqSuMk1EuTzkNnz82xDHHNKrNihGkwFVP+ZjLBP
        YrGbW2bxXHjNojTDwdStWsk=
X-Google-Smtp-Source: APXvYqyefKR8OR7QDZDd+jzxQ9ozWeYPJG85KFqiuWil8Kw+KFm7XmK5bGe1uF+tFvXVMghLhjntSw==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr20538894wmf.80.1570456825315;
        Mon, 07 Oct 2019 07:00:25 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id y19sm34357804wmi.13.2019.10.07.07.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 07:00:24 -0700 (PDT)
Date:   Mon, 7 Oct 2019 16:00:22 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007140022.GA29008@gmail.com>
References: <20191007134724.4019-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007134724.4019-1-hdegoede@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


* Hans de Goede <hdegoede@redhat.com> wrote:

> The purgatory code now uses the shared lib/crypto/sha256.c sha256
> implementation. This needs memzero_explicit, implement this.
> 
> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Add barrier_data() call after the memset, making the function really
>   explicit. Using barrier_data() works fine in the purgatory (build)
>   environment.
> ---
>  arch/x86/boot/compressed/string.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
> index 81fc1eaa3229..654a7164a702 100644
> --- a/arch/x86/boot/compressed/string.c
> +++ b/arch/x86/boot/compressed/string.c
> @@ -50,6 +50,12 @@ void *memset(void *s, int c, size_t n)
>  	return s;
>  }
>  
> +void memzero_explicit(void *s, size_t count)
> +{
> +	memset(s, 0, count);
> +	barrier_data(s);
> +}

So the barrier_data() is only there to keep LTO from optimizing out the 
seemingly unused function?

Is there no canonical way to do that, instead of a seemingly obscure 
barrier_data() call - which would require a comment at minimum.

We do have $(DISABLE_LTO), not sure whether it's applicable here though.

Thanks,

	Ingo
