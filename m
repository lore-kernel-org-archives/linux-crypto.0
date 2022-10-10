Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F64C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Oct 2022 08:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiJJIou (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Oct 2022 04:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJJIot (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2022 04:44:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FA8630A
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 01:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E566CE111C
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 08:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A9C433D6
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 08:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665391481;
        bh=U+VesL5rKH0WdIVQgPmf1JjjeAqqTvnxJT8QtaNJZKQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hZbMJ5kRhgF13oQrYJb+wqTSpUOxijZ1HgmE+umbk7qkgCtGeEbLhQE/dXuNswj/r
         HxvxkxN2tLZH+eQDfeySA+HSGWpQkjo7PIjWp58OWofdH+lGK7f1owu0QzLnehJ8gp
         gWo779JJPlxo7nB65umKd0ksPgFC9q1M99CXzCgofJMzYv8zc6a45mNDFldUzz1oH1
         GUQL/N0Zn0X1QZbyMZVh2r5OKiPSIprYlGeV/dGfnhvHJcwc3skJ68AbMloX0GpxEh
         bwY864r7xgEhyseeBoGrEuUYrHWwxjRxmw+9RE/fx3XSl8DPSq2VcGve1AtHhWGuMr
         TOhzj8dFIhe9Q==
Received: by mail-lj1-f178.google.com with SMTP id f9so12425747ljk.12
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 01:44:41 -0700 (PDT)
X-Gm-Message-State: ACrzQf0kxG0WT0wOdqe2l/RczgE+or8z974bJ+IOPnFPCLwMRefSCm/q
        0l2qBm9Fv5mJdXZ3rWbkAvCVPN+bYtcovzqI7kk=
X-Google-Smtp-Source: AMsMyM5vqRvzZ+BnbpOTyzOLlqcgg+2J+M/n4zPqG/ITNtSM2rJ4fz2ULWML7N468LA/0NV7m3EyNv73CBI6YvKSMAA=
X-Received: by 2002:a2e:9a81:0:b0:26c:5b63:7a83 with SMTP id
 p1-20020a2e9a81000000b0026c5b637a83mr6780544lji.291.1665391479521; Mon, 10
 Oct 2022 01:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221007152105.3057788-1-ardb@kernel.org> <3e395ad2-48f6-87f6-9042-a3ca21c0baba@amd.com>
 <CAMj1kXGNXYvS9_-RwzzO-VeZN8+ZErhxGiCbfbBA5thJ84RxYA@mail.gmail.com> <ecc2207e-4845-f467-1926-e675f78c6b2e@amd.com>
In-Reply-To: <ecc2207e-4845-f467-1926-e675f78c6b2e@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 10 Oct 2022 10:44:28 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF5+i9SJ3zuua8TCQVRutVt80v85dgjde3sb3+J+=pKHg@mail.gmail.com>
Message-ID: <CAMj1kXF5+i9SJ3zuua8TCQVRutVt80v85dgjde3sb3+J+=pKHg@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - Provide minimal library implementation
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, keescook@chromium.org, jason@zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 10 Oct 2022 at 10:25, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
>
>
> On 10/10/22 13:45, Ard Biesheuvel wrote:
> > On Mon, 10 Oct 2022 at 09:27, Nikunj A. Dadhania <nikunj@amd.com> wrote:
> >>
> >> Hi Ard,
> >>
> >> On 07/10/22 20:51, Ard Biesheuvel wrote:
> >>> Implement a minimal library version of GCM based on the existing library
> >>> implementations of AES and multiplication in GF(2^128). Using these
> >>> primitives, GCM can be implemented in a straight-forward manner.
> >>>
> >>> GCM has a couple of sharp edges, i.e., the amount of input data
> >>> processed with the same initialization vector (IV) should be capped to
> >>> protect the counter from 32-bit rollover (or carry), and the size of the
> >>> authentication tag should be fixed for a given key. [0]
> >>>
> >>> The former concern is addressed trivially, given that the function call
> >>> API uses 32-bit signed types for the input lengths. It is still up to
> >>> the caller to avoid IV reuse in general, but this is not something we
> >>> can police at the implementation level.
> >>>
> >>> As for the latter concern, let's make the authentication tag size part
> >>> of the key schedule, and only permit it to be configured as part of the
> >>> key expansion routine.
> >>>
> >>> Note that table based AES implementations are susceptible to known
> >>> plaintext timing attacks on the encryption key. The AES library already
> >>> attempts to mitigate this to some extent, but given that the counter
> >>> mode encryption used by GCM operates exclusively on known plaintext by
> >>> construction (the IV and therefore the initial counter value are known
> >>> to an attacker), let's take some extra care to mitigate this, by calling
> >>> the AES library with interrupts disabled.
> >>>
> >>>
> >>> Cc: "Nikunj A. Dadhania" <nikunj@amd.com>
> >>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >>> ---
...
> >> The gcm_mac computation seems to be broken in this version. When I receive the encrypted
> >> packet back from the security processor the authtag does not match. Will debug further
> >> and report back.
> >>
> >
> > Sorry to hear that. If you find out what's wrong, can you please
> > provide a test vector that reproduces it so we can add it to the list?
>
> My bad, it was wrong crypt_len that I was sending. Working fine now.
>
> Tested-by: Nikunj A Dadhania <nikunj@amd.com>

OK, good to know - thanks.
