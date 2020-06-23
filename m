Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2093FC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 06:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1853206E2
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 06:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BIdVinkt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgFWGX5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 02:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbgFWGX4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 02:23:56 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804CCC061573
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2020 23:23:56 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s1so22092843ljo.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2020 23:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPmL4ji10DM23gXnHiUP2NWgp6rzRT93lGyytV/WtJM=;
        b=BIdVinktvLNiMk2nDRyH/DIePkv0Y76ENlOPbiD73uhrPmAMWpcQr0GXrq31J7UWKy
         nx8cSiBDNUNtKhgqbuWTj5/yrtE899FP1q+Kbv9b1V1z5MhHcAfoTPmKUBPRNv4O93xb
         8ErCN2zCByMbG4NDklpkORi7nxFQvRFTmI7j6WCrrT6j3vugRvMD4MvqbAJez/VIbSj4
         F0L1wnWSrbrCCkBdJrgEi6penn3FCPOtrKz5WHjQOZua3SlwQcChthsVjDiMoQ/6X8iE
         H9FMLmhcj3Z+bPDhmvjDT6yMPl5j3w0NhSrNdNuLf8wDntXMPLPLJ4sFqphnVX3TlWyV
         A/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPmL4ji10DM23gXnHiUP2NWgp6rzRT93lGyytV/WtJM=;
        b=BPkQUFThp72I5Fhspafx5Fw0vERqv/hDB5eorisdjLfB/lcrj2y5lXe0wsN++giOXW
         nYfbzKUQh18bSTdzaEdhICYmdoYr3WbjqCJozAU7nO/YyMNTKtbs3wGR1xbwt3cAvReB
         1Lhs0BVLy3N9gUycl5woVk8A8yBM8wFhqzW9M4dO054JYQEhvyBBpthOjIEZ8LjK1RrR
         +xwSIhkTWK4XBF+5YtHCxa6VgMpQHE1k1Qf8YfpBRjYdhxwGqECt19QxhZkokBme217T
         LRgAPSpl/oFTSSvZ8VolbkPv+tKGClhWbEY/C6rU2kyL7efRm7H5/F+q33l49owE54Z6
         5L+w==
X-Gm-Message-State: AOAM532MarQ98o5cMXjFbpK5QK2JK/fMjcKcEUPBoQgjem1XvJLupi/o
        0fTQsHP451Ukhrqu+ycMR3gciiqI4rJ41ldJvPmftw==
X-Google-Smtp-Source: ABdhPJwyfBDDErbrS4GjTK/D+t1eKZ96j9X/dUhypMGUwehTdQFYmoz856g75PfnLqD8QeqGESPEHLqWG864TNrkBCI=
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr10241919ljp.266.1592893434808;
 Mon, 22 Jun 2020 23:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvHFs5Yx8TnT6VavtfjMN8QLPuXg6us-dXVJqUUt68adA@mail.gmail.com>
 <20200622224920.GA4332@42.do-not-panic.com>
In-Reply-To: <20200622224920.GA4332@42.do-not-panic.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Jun 2020 11:53:43 +0530
Message-ID: <CA+G9fYsXDZUspc5OyfqrGZn=k=2uRiGzWY_aPePK2C_kZ+dYGQ@mail.gmail.com>
Subject: Re: LTP: crypto: af_alg02 regression on linux-next 20200621 tag
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        lkft-triage@lists.linaro.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jan Stancek <jstancek@redhat.com>, chrubis <chrubis@suse.cz>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 23 Jun 2020 at 04:19, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Jun 23, 2020 at 12:04:06AM +0530, Naresh Kamboju wrote:
> > LTP crypto regressions noticed on linux next 20200621.
> >
> > The common case for all tests is timeout after 15 minutes which
> > means tests got hung and LTP timers killed those test runs after
> > timeout.
> > The root cause of the failure is under investigation.
> >
> >   ltp-crypto-tests:
> >     * af_alg02 - failed
> >     * af_alg05 - failed
> >   ltp-syscalls-tests:
> >     * keyctl07 - failed
> >     * request_key03 - failed
<trim>
>
> Can you try reverting:
>
> d13ef8e10756873b0a8b7cc8f230a2d1026710ea
>
> The patch is titled "umh: fix processed error when UMH_WAIT_PROC is used"

Thanks for the investigation.
After reverting, two test cases got PASS out of four reported failure cases.
 ltp-crypto-tests:
     * af_alg02 - still failing - Hung and time out
     * af_alg05 - still failing - Hung and time out
  ltp-syscalls-tests:
     * keyctl07 - PASS
     * request_key03 - PASS

Please suggest the way to debug / fix the af_alg02 and af_alg05 failures.

- Naresh
