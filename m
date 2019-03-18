Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20512C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 09:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9F220811
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 09:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bKm6PagN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfCRJNv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 05:13:51 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:56283 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfCRJNv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 05:13:51 -0400
Received: by mail-it1-f195.google.com with SMTP id z126so16515376itd.5
        for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2019 02:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uE2320ZkGegzn6C2nz3VmLnLyOznFffq4WgiPNHhKg=;
        b=bKm6PagNd6AosOHCCgPW2wXZrQ8BiO3G9j2acIddrVIegcMk9CkyWKvoDqwdsUpcnA
         4/0+a1p6SfovX7GaexVFgTAOTV0mXiiSfWQ2T42MeUN14uNbJ6SYsVGU4RVdhce8zj7o
         GKiExM/X9ULYMAz8zSKgto/jznFsQkOI7gQ9MSj7p9EepCnXDel063yh3ilkDKQTfJFa
         GPSfJzP0A+QLIAZN3JWgTxsPPvps9t0HpaxBeEdf6BWMYY1d9Y4gjqDOiGb8Ff/S1x3W
         8jqW7KTrlxonVaavSeYvSNOeyMCC+kTWvx7GvhJd7YeRHUgF2dNQ9Wxilragd+ZFAn7x
         iDmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uE2320ZkGegzn6C2nz3VmLnLyOznFffq4WgiPNHhKg=;
        b=mZggd8jERCe5z2x07pBhX8SFYUhXM/X9x5s0WmrgUTYXmEfJsjjs4Y28Fv2DZ181fU
         /eIY1s77zA1787ZNOcimRc7B9c5O5rva3Yw1eOI/WeC/jXJY9jRKDmGPKXQVpjrO9a6H
         KwbZwaNYAP9+MWvhtw6rb4g9Ikai6ptoYMG8wfcpf1z1XT81AHcrHkGM5qkLJKpHV2an
         ke+mClTPK4l0B6QjKeJMR9jvDDsZPVpudO/FvP2abp9cnL0YI+iHE76sGp8grUEYNlT+
         tXwIXtxwEI58oUWh7OI95gnXZKppKZD8Vm3TVJ1duj80Ne2D4CsnFgFIt6s4IFPGqrjF
         mYLA==
X-Gm-Message-State: APjAAAVmqk89O8jtFDzdaHjxHI52X3PspuJ/3u6FG4nCfKGnOnmgzQiq
        QaFjYv7AcDeIsrsI4VKUp2y07IBt+ahUhboCLyoJIA==
X-Google-Smtp-Source: APXvYqyN0p2A1jJRUW5/NfS5vOSEU8kd82YZzNZrq5nGnaSLkgKcrNgzdrRSmsJxzGRS03+WgjEhIxIfWK0oLp98XUU=
X-Received: by 2002:a05:660c:a54:: with SMTP id j20mr550217itl.158.1552900430151;
 Mon, 18 Mar 2019 02:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain>
 <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain>
 <87pnqo7ewp.fsf@concordia.ellerman.id.au>
In-Reply-To: <87pnqo7ewp.fsf@concordia.ellerman.id.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 18 Mar 2019 10:13:39 +0100
Message-ID: <CAKv+Gu_w_d5AbkYu=fdK1ver97G4O_rqu9o9tNy_-zNaAOnkkA@mail.gmail.com>
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, Daniel Axtens <dja@axtens.net>,
        leo.barbosa@canonical.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, marcelo.cerri@canonical.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 18 Mar 2019 at 09:41, Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Eric Biggers <ebiggers@kernel.org> writes:
> > On Fri, Mar 15, 2019 at 03:24:35PM +1100, Daniel Axtens wrote:
> ...
> >> >> This leads to corruption of the IV, which leads to subsequent blocks
> >> >> being corrupted.
> >> >>
> >> >> This can be detected with libkcapi test suite, which is available at
> >> >> https://github.com/smuellerDD/libkcapi
> >> >
> >> > Is this also detected by the kernel's crypto self-tests, and if not why not?
> >> > What about with the new option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
> >>
> >> It seems the self-tests do not catch it. To catch it, there has to be a
> >> test where the blkcipher_walk creates a walk.nbytes such that
> >> [(the number of AES blocks) mod 8] is either 2 or 3. This happens with
> >> AF_ALG pretty frequently, but when I booted with self-tests it only hit
> >> 1, 4, 5, 6 and 7 - it missed 0, 2 and 3.
> >>
> >> I don't have the EXTRA_TESTS option - I'm testing with 5.0-rc6. Is it in
> >> -next?
> >
> > The improvements I recently made to the self-tests are intended to catch exactly
> > this sort of bug.  They were just merged for v5.1, so try the latest mainline.
> > This almost certainly would be caught by EXTRA_TESTS (and if not I'd want to
> > know), but it may be caught by the regular self-tests now too.
>
> Enabling the crypto tests (CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n)
> actually hides the bug for me.
>
> By which I mean I can't trigger the bug via kcapi-enc-tests.sh, because
> the VMX code is never called.
>
> ie:
>   # zgrep -e CRYPTO_MANAGER -e VMX /proc/config.gz
>   CONFIG_CRYPTO_MANAGER=y
>   CONFIG_CRYPTO_MANAGER2=y
>   # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>   # CONFIG_CRYPTO_MANAGER_EXTRA_TESTS is not set
>   CONFIG_CRYPTO_DEV_VMX=y
>   CONFIG_CRYPTO_DEV_VMX_ENCRYPT=y
>
>   # echo "p:p8_aes_ctr_crypt p8_aes_ctr_crypt" > /sys/kernel/debug/tracing/kprobe_events
>   # echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
>   # ./kcapi-enc-test.sh
>   ...
>   Number of failures: 0
>   # grep -c p8_aes_ctr_crypt  /sys/kernel/debug/tracing/trace
>   0
>
>
> I don't understand how the crypto core chooses which crypto_alg to use,
> but I didn't expect enabling the tests to change it?
>

This is not entirely unexpected. Based on the tests, algos that are
found to be broken are disregarded for further use, and you should see
a warning in the kernel log about this.
