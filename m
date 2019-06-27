Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D43FC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 07:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5127B205C9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 07:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p53tJzIK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfF0HnA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 03:43:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46558 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfF0HnA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 03:43:00 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so2587719iol.13
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 00:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3fBAKQwI2PJSj30Ng8shpFsxQD/XkP/I50yquaAKmYY=;
        b=p53tJzIK8exdP2U56hWQMXucOC3azqeklOBdkBLPnkIStncMupi3aUOpC3sKMW/PKo
         Gx9RK3T4fHTLTqETsUNqTkZi+r3F+fj/K8MrTluQOYzRylGNTWl//APYId727jRDmG9i
         XZG6s47T/gv39J/HukK7qiDhPQZ1MPCIe83Jv1DSEDqTd2rld//P1FZga+LkDVPpRshn
         lGfA8RTs7+B/82ahbvjT4XGObdPplLdMhXImVmwoseYfP5djAolBQdYaukuSmb66RRrc
         MVXXlJu6CoIrLbba1nr/byaHPALwaNDLVCESJKGzc07SZwfS7bPhLHknDMY81auAIQnO
         nt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fBAKQwI2PJSj30Ng8shpFsxQD/XkP/I50yquaAKmYY=;
        b=uHjgdqdeZiNmHXc1eNNo+U9pCjiFa0AGjupaa45JYAav/zy0v7CJKkgXPT0qnhINw4
         VJzgboUMRxoTBLSmKlhFlAE1PN4gZRMDsPHaUuivRFflIi1QXLhPT3KCeuIgOBKQ6PhX
         F0FPwXUsREVh4gOWArCT1U1SeQBafTkdL0UrU2CcsGkIX8YbDYNyOLIrt2/WbZycAyGQ
         J8OmgLRew+d95I7/GwbNOeKSGdV9c6piQqTNXSpFpx0wqYK0bvOLUBn5SPBokDkvEJ46
         ueW5fPovdN7t6C2aUA86Mp4B+JD1uUfF+r++rK1apSl7zbYMFPFXQUOx6ac3y1NaKR/W
         il7g==
X-Gm-Message-State: APjAAAWYCNrcT6sTzo52HeoScVF0rURZMIQJ6n2L5i8EtDRFsfkpl769
        fy5BYSM6P81FxIvfyoFG6SGsJ+ZKVaniFAqcpHBRaw==
X-Google-Smtp-Source: APXvYqwKJVzYNKdt23YtpyHGo6kNeu11tFZRr79WQUXWysp350VQoNLhUqw3kYEvFUOTPFAvp7rls0hGOuqia6DbmZ8=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr3022644iob.49.1561621379461;
 Thu, 27 Jun 2019 00:42:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <20190625171234.GB81914@gmail.com> <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
 <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com> <CAKv+Gu9jAqGAYg8f_rBVbve=L3AQb_xKnpmnsqrZ3m7VLnaz1g@mail.gmail.com>
 <e9d045c6-f6e2-a0d2-b1f2-bebee5d027f4@gmail.com> <CAEX_ruEDA9ZG+6aA_jTBSq-MM=pOrdxoJA2x0LPF3dkYk76kCQ@mail.gmail.com>
In-Reply-To: <CAEX_ruEDA9ZG+6aA_jTBSq-MM=pOrdxoJA2x0LPF3dkYk76kCQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 09:42:45 +0200
Message-ID: <CAKv+Gu_W9sMrSyqBQv0pZZwgJzCgpSv7CAR6mdH-sJTdMExbHA@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Samuel Neves <samuel.c.p.neves@gmail.com>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 26 Jun 2019 at 23:11, Samuel Neves <samuel.c.p.neves@gmail.com> wrote:
>
> , On Wed, Jun 26, 2019 at 8:40 AM Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 26/06/2019 09:15, Ard Biesheuvel wrote:
> >
> > > Thanks for the insight. So I guess we have consensus that MORUS should
> > > be removed. How about aegis128l and aegis256, which have been
> > > disregarded in favor of aegis128 by CAESAR (note that I sent an
> > > accelerated ARM/arm64 version of aegis128 based on the ARMv8 crypto
> > > instructions, in case you missed it)
> >
> > Well, there are similar cases, see that Serpent supports many keysizes, even 0-length key (!),
> > despite the AES finalists were proposed only for 128/192/256 bit keys.
> > (It happened to us several times during tests that apparent mistype in Serpent key length
> > was accepted by the kernel...)
>
> I'm not sure the Serpent case is comparable. In Serpent, the key can
> be any size below 256 bits, but internally the key is simply padded to
> 256 bits and the algorithm is fundamentally the same. There are no
> speed differences between different keys sizes.
>
> On the other hand, AEGIS128, AEGIS256, and AEGIS128L are different
> algorithms, with different state sizes and state update functions. The
> existing cryptanalysis of AEGIS consists solely of [1] (which is the
> paper that directly inspired the MORUS cryptanalysis), which does not
> look at AEGIS128L at all. In effect, to my knowledge there are no
> known cryptanalytic results on AEGIS128L, which I imagine to be one of
> the main reasons why it did not end up in the CAESAR portfolio. But
> AEGIS128L is by far the fastest option, and a user is probably going
> to be naturally tempted to use it instead of the other variants.
>

Indeed. So that would actually argue for removing the optimized x86
implementation, but tbh, I'd rather remove aegis128l and aegis256
entirely, given that no recommendations exist for its use in any
particular context, and given the CAESAR outcome, that is unlikely to
change in the future.
