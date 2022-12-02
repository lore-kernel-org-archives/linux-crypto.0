Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3111BC47088
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 18:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiLBS6P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 13:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLBS6N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 13:58:13 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BFE92A14
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 10:58:13 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v3so5103412pgh.4
        for <linux-crypto@vger.kernel.org>; Fri, 02 Dec 2022 10:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hPdGcOCEsG7lUmArEzStFj43mzNWvKg2+Ebw16M3TCY=;
        b=PU3gDK3JBsY8Izq24LkRkMa24eKn0Mu0dmVHTCV4yTEpqX6bxxHxWKaBIDHx0HnqeJ
         jhExXB/Ex03vAiF69WJEpsCl4UWQ9Tovfwyo9wxw+NkZDdH0KfetQa679Ugg8duke325
         KxFZeqdCU9j9zaf0rQ4JEC0LZDDu0WcfjaHss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPdGcOCEsG7lUmArEzStFj43mzNWvKg2+Ebw16M3TCY=;
        b=hErljYberRG6lpMZG1tfZOjKZ/DJoZgwAFWcN6hIWcg+p3u8QgNacPkr4DM0durdQT
         jVi9koOwzC5E4xc8unZQuSigTzjGfhXGxyIEI2g7vzCRosjfGaWbUXxnxWs2q5Cg5MTH
         esczqWdGfj7MIwy2zJRxPOit/DR/z6RlXadibrTY4sN0jbBx+T75wq0RgNhpeokhOFdA
         3F9lu5SHEHkq9gWo9FCNjTt/mmPwRONDEQa4/QfY4IZmOPTM2REApiBkO/7VQfk2Ij0s
         abl7NWcJIMuXfxbkUR4c+cvwlKNqkcqHEQYeCAyrXIpZWQtv5jDNnhwXilzgdxGSBQFS
         7h1w==
X-Gm-Message-State: ANoB5pnph4oMkp4SG1z9xrj+9LCEKCfd1f4xbEr+TxD6wUxGH6esuxgU
        qQLu35p4LYdeBkpWtnE6cUuJIQ==
X-Google-Smtp-Source: AA0mqf48V3uHLmY0yySTaOoB/FYAXZPXo2e4ikb3ZgTnAR9y+ke4PQBq1FnMqulyBpKVV19bLfFIbA==
X-Received: by 2002:a62:65c3:0:b0:562:ce80:1417 with SMTP id z186-20020a6265c3000000b00562ce801417mr53353551pfb.19.1670007492560;
        Fri, 02 Dec 2022 10:58:12 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0016c9e5f291bsm5948660plh.111.2022.12.02.10.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 10:58:11 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:58:11 -0800
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Anders Roxell' <anders.roxell@linaro.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] crypto/caam: Avoid GCC constprop bug warning
Message-ID: <202212021057.B1B1BDE380@keescook>
References: <20221028210527.never.934-kees@kernel.org>
 <20221202005814.GD69385@mutt>
 <4f7ffdd948a84013a0e84876b3e3944b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f7ffdd948a84013a0e84876b3e3944b@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 02, 2022 at 10:01:50AM +0000, David Laight wrote:
> From: Anders Roxell
> > Sent: 02 December 2022 00:58
> > 
> > On 2022-10-28 14:05, Kees Cook wrote:
> > > GCC 12 appears to perform constant propagation incompletely(?) and can
> > > no longer notice that "len" is always 0 when "data" is NULL. Expand the
> > > check to avoid warnings about memcpy() having a NULL argument:
> > >
> > >    ...
> > >                     from drivers/crypto/caam/key_gen.c:8:
> > >    drivers/crypto/caam/desc_constr.h: In function 'append_data.constprop':
> > >    include/linux/fortify-string.h:48:33: warning: argument 2 null where non-null expected [-
> > Wnonnull]
> > >       48 | #define __underlying_memcpy     __builtin_memcpy
> > >          |                                 ^
> > >    include/linux/fortify-string.h:438:9: note: in expansion of macro '__underlying_memcpy'
> > >      438 |         __underlying_##op(p, q, __fortify_size);                        \
> > >          |         ^~~~~~~~~~~~~
> ...
> 
> Is this really a bug in the fortify-string wrappers?
> IIRC the call is memcpy(NULL, ptr, 0) (or maybe memcpy(ptr, NULL, 0).
> In either case call can be removed at compile time.
> 
> I'd bet that the constant propagation of 'len' fails because
> of all the intermediate variables that get used in order to
> avoid multiple evaluation.
> 
> The some 'tricks' that are used in min() (see minmax.h) to
> generate a constant output for constant input could be
> use to detect a compile-time zero length.
> 
> Something like:
> #define memcpy(dst, src, len) \
> 	(__is_constzero(len) ? (dst) : memcpy_check(dst, src, len))
> 
> With:
> #define __is_constzero(x) sizeof(*(1 ? (void *)(x) : (int *)0) != 1)
> Which could go into const.h and used in the definition of __is_constexpr().

While it could be possible to strip the nonnull attribute, I think it's
not an unreasonable check to have. This is literally the only case in
the entire kernel that is tripped, for example.

-- 
Kees Cook
