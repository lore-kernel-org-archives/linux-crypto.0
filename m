Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63698ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370EC218AC
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570462817;
	bh=0SqrmEI3jPveA0in6PcRhu6ezfY2kUTsmIlF2EiiGK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=WQMMqCSpDDnMloCiM0lAesf44lwGH+EiUeZmFEklMMG7fosVuqtDUzAmJ1a2M4LHt
	 UUfUO3WzuGlEDIPp+3YqeKNNr1zpZF5aXaGFQJjR6W75UsWrbY1pTa14IP+iGvmFR9
	 lCKWZfFqEAwVBvSRHbSte3OZDwGYeU6IgG34eqf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfJGPkM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 11:40:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38223 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbfJGPkL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 11:40:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so12870348wmi.3;
        Mon, 07 Oct 2019 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YvxpVFdJOEZrkQChM8Lq11d9YvLJbKpxKj8YQXF8h+c=;
        b=b4aG6tjLd5D2QbgnsraRnITHGMxPIlNYBw3yvdWYP1HXbsqS/SraQh9s6vsAGE01d6
         MQIslDbt1wE18zCEStz+X9q7Y+jV6jLPKAjDeWSBoivuHmzk3dLr7uDU52DvuXSd1BTw
         ksD0DFhHtZ6gDqB3thMNT0kkZ388AIzXzMAVXxcOm6Weie/MQZPRYbHYdHbLwMvkG1hn
         mjV1Am8WsTi4xlAwdj5P4xVuX+Nj+pqwa5aM3dlPsSATUFr3NrmlTOJkFh9pgTFrn1BQ
         HpKoFh/IQSXAeHRrbbdvggubAAPtBj1XdU+YV1/fExBF7JZnI6PCKZ+M/CUlgGKP0Iag
         D0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=YvxpVFdJOEZrkQChM8Lq11d9YvLJbKpxKj8YQXF8h+c=;
        b=iNuJLxNTvo7RGem/89WvjeG8DdkG5Q7hCpYpNpkWGGyw6ap19R+XErQBbT5zQuwIUU
         WqetegjJ+EJa0Ta9eMhaWPfvGr+XlMpeng+jJVCVc2gHFguUBYPkOMX5avh1jrVVm4v4
         6qg7Yux6934RBBInf9bq80FdpdWc8R4m1/4fqKEfAkIXDEdiDip8CnfbEyW14CPKFVTM
         dB0BgvOFUReuAyKQhG7wYqNMGi1YUv/OcYH/mLXGTzHDCcEWX1BKyYwScM0HOwW7V+Vr
         pR5V8EuvDtvlwosxYVZFkE+3xSATzM3z/NMWw9J8Hr+D0Y3eMKuxqwzxybHpQik3fRGd
         86kg==
X-Gm-Message-State: APjAAAX10vbkuKDJ62W8jsPPnpOnANCRqKsszQDRFGuJx7vdsYXhla3O
        F+bbTQKf9Jm7MwAfj5lIpgo=
X-Google-Smtp-Source: APXvYqw1sh7drpFUzZ8Rb52Hl6MrStf7eBimtSUGhMBrc0RLPFo88/Tu+eXgo9P3OGErTSCHgYbQDA==
X-Received: by 2002:a1c:7ec4:: with SMTP id z187mr20333322wmc.94.1570462809964;
        Mon, 07 Oct 2019 08:40:09 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id y5sm18605709wma.14.2019.10.07.08.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 08:40:09 -0700 (PDT)
Date:   Mon, 7 Oct 2019 17:40:07 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007154007.GA96929@gmail.com>
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
 <20191007142230.GA117630@gmail.com>
 <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
 <20191007144600.GB59713@gmail.com>
 <20191007152049.GA384920@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007152049.GA384920@rani.riverdale.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


* Arvind Sankar <nivedita@alum.mit.edu> wrote:

> With the barrier in there, is there any reason to *not* inline the
> function? barrier_data() is an asm statement that tells the compiler
> that the asm uses the memory that was set to zero, thus preventing it
> from removing the memset even if nothing else uses that memory later. A
> more detailed comment is there in compiler-gcc.h. I can't see why it
> wouldn't work even if it were inlined.
> 
> If the function can indeed be inlined, we could just make the common
> implementation a macro and avoid duplicating it? As mentioned in another
> mail, we otherwise will likely need another duplicate implementation for
> arch/s390/purgatory as well.

I suspect macro would be justified in this case. Mind sending a v3 patch 
to demonstrate how it would all look like?

I'll zap v2 if the macro solution looks better.

Thanks,

	Ingo
