Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F334FC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiGYQCI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiGYQCI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:02:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EC113F98
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FA41CE12E8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A4CC341CD
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:02:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=linaro.org header.i=@linaro.org header.b="pftI++pi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=20210105;
        t=1658764922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQ1TuRAqAB9FQ9er/Dx0aITtQ81Ea93wYVpkDOTZzNs=;
        b=pftI++pijUaz3/9YWuGkgwpYYOeteHlRB346U+zG71uBYambApj6yzZJRhpuU89mJczqlV
        OR1kisX2aR0AF8M5Yeg3YVeWJB/mvOnsTIXB8M8VM5LSM3V5/8sQmY536Tle2Iezcq2Yns
        mC0sR5utEwTMN2S+YiO8OVCxHvEzzW8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ad1e6947 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 16:02:02 +0000 (UTC)
Message-ID: <b33914f7-660a-e5c9-f77b-2f6227ea8ab8@linaro.org>
Date:   Mon, 25 Jul 2022 12:59:39 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.0.3
Subject: Re: arc4random - are you sure we want these?
Content-Language: en-US
To:     Rich Felker <dalias@libc.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, Paul Eggert <eggert@cs.ucla.edu>,
        linux-crypto@vger.kernel.org
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
 <20220725153303.GF7074@brightrain.aerifal.cx>
From:   Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Organization: Linaro
In-Reply-To: <20220725153303.GF7074@brightrain.aerifal.cx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 25/07/22 12:33, Rich Felker wrote:
> 
> If this is just a case of trying to be "cautious" about overpromising
> things, the documentation needs fixed to specify that this is a
> CSPRNG. I'm particularly worried about the wording "these still use a
> Pseudo-Random generator and should not be used in cryptographic
> contexts". *All* CSPRNGs are PRNGs. Being pseudo-random does not make
> it not cryptographically safe. The safety depends on the original
> source of the entropy and the practical irreversibility and other
> cryptographic properties of the extension function. The fact that this
> has been stated so poorly in the documentation really has me worried
> that someone does not understand the issues. I haven't dug into the
> list mails or actual code to determine to what extent that's the case,
> but it's really, *really* worrying.

That's the main drive to avoid calling CSPRNGs, since nor me or Florian
is secure enough to certify current scheme can actually follow all the
requirements.  It does follow OpenBSD strategy of a fast-key-erasure 
random-number generators, although all strategies of key reseeding are
basically heuristics.

If I understand Jason argument correctly, unless we have a kernel API
which it actually handles the buffer (so it can reseed or clear when it
seems fit), there is no point is proving a CSPRNGs in userspace, use
getrandom instead.


