Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C2BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 18:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 934836121F
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 18:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbhJOSIA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Oct 2021 14:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhJOSH7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Oct 2021 14:07:59 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299D1C061762
        for <linux-crypto@vger.kernel.org>; Fri, 15 Oct 2021 11:05:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q5so9257293pgr.7
        for <linux-crypto@vger.kernel.org>; Fri, 15 Oct 2021 11:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6aKaUBfmZ/RDXszMaOimAv4KMW/OyS3sPGtjs8O2E34=;
        b=GVmzuU15JAJiFkhxCvlybvv8JQ/weN1u6H5X2ykdGO0SbPC2oh+6v6cVgvlO570SQt
         3GkvfNVzAqWl8zPNWSHbY7njqG6CewmKP4h1XOj6yKnHOyQYUzyjQPvU2OuC15dfq4Hi
         VN3x/O+P0ilrNaIVGJ68Ygk351wgrsLm7ndELutEZZrw8z+cY1yzXMgBMy/pBci3EOyl
         ulcHWdF/9vBkEsUgkf7h44ja1u6SEY2tkk+eSi5LWgBg9XB/icMRuY+GRaP+xW3MrzGB
         XuNyraHQEXo08aqdnameuEFfd5qdBGYdt1wmlmW6lyc7tCbSiQ7jQ3umV9arDxtAw+lt
         E+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6aKaUBfmZ/RDXszMaOimAv4KMW/OyS3sPGtjs8O2E34=;
        b=e1pAb/0VvDKk3lvgYzcuqx11D6++QjWXGCUC2fqdxo08iGkFU5G1IJPzHHSRKUdufL
         KLEIqFOyqpL5iGIRnv9aT+KqHspR87FYruAT0Cz5pQVcRfZevJsELLUX7NNRNWDYYINN
         7w1/98NKCBTwGnDPZ85MFjRhnVA7jqRQUkhu9I0OJdjdBxEhG/o9iladwHHD64vgLdzN
         P7DtASas1LP6DgO5L2dw8WV9wH6yrkjS6lMC8Wr3xA8sTQRENVQPYPiR3QSRaUdEQ0d8
         DB/WIT4UxaBnfH4CXkhHr/43Kd+V9xAkQOa715/S8TjOoMrP/Jw4Z977x3kI0uKCkfuB
         z5lA==
X-Gm-Message-State: AOAM530SKL80XOgieEOjk4p7S2OfHDW8nLHxsH5za8+l+R6N/OLAGqJh
        ZzQOMz1wo4Twfys/04o453bfrC8ZBvrXMw==
X-Google-Smtp-Source: ABdhPJzz3Nh77XlAC6fmajJ34SeI4VWlWS8ZkGOVsmolRrMLTNk0lzHHckKjtlG+93CIt4Ywfy5cfA==
X-Received: by 2002:a63:6a49:: with SMTP id f70mr7399062pgc.199.1634321152413;
        Fri, 15 Oct 2021 11:05:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w15sm5543737pfc.220.2021.10.15.11.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 11:05:51 -0700 (PDT)
Date:   Fri, 15 Oct 2021 18:05:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YWnC++azH3xXrMm6@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-6-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index f383d2a89263..8627c49666c9 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2419,3 +2419,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>  	return !!rmpentry_assigned(e);
>  }
>  EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> +
> +int psmash(u64 pfn)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;

Probably better to use __pfn_to_phys()?

> +	int ret;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))

Shouldn't this be a WARN_ON_ONCE()?

> +		return -ENXIO;
> +
> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */
> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +		      : "=a"(ret)
> +		      : "a"(paddr)
> +		      : "memory", "cc");
> +
> +	return ret;

I don't like returning the raw result from hardware; it's mostly works because
hardware also uses '0' for success, but it will cause confusion should hardware
ever set bit 31.  There are also failures that likely should never happen unless
there's a kernel bug, e.g. I suspect we can do:

	if (WARN_ON_ONCE(ret == FAIL_INPUT))
		return -EINVAL;
	if (WARN_ON_ONCE(ret == FAIL_PERMISSION))
		return -EPERM;
	
	....

or if all errors are "impossible"

	if (WARN_ON_ONCE(ret))
		return snp_error_code_to_errno(ret);

FAIL_INUSE and FAIL_OVERLAP also need further discussion.  It's not clear to me
that two well-behaved callers can't encounter collisions due to the 2mb <=> 4kb
interactions.  If collisions between well-behaved callers are possible, then this
helper likely needs some form of serialization.  Either, the concurrency rules
for RMP access need explicit and lengthy documentation.
