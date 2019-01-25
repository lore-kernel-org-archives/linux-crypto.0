Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC53EC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 701A62084C
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="GHNXs9Sy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfAYHqI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:46:08 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:39240 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfAYHqH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 02:46:07 -0500
Received: by mail-it1-f194.google.com with SMTP id a6so8449695itl.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 23:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=frViEAZ6rhdURbIOPIcE2U4G9xv0tHAxMx5jBGgTrrU=;
        b=GHNXs9Syx9YwgJnNEoyscKiIADLnU9r3YffUxSEEBVPRQv0qGXLWsnPLN5XnHZKv2+
         2aZ+XvJwE3OFy4Mb7HqmFUrhp5rXLorlCI/1EuM1RstgsQ2Ca368aueNAxM/6pZpHXXJ
         I+6JX5QwZssA9zokActsO1386jC2lyI8UMAh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=frViEAZ6rhdURbIOPIcE2U4G9xv0tHAxMx5jBGgTrrU=;
        b=VjnixovFOJLBTHXWeJ8+ryAWFOSxn23UWOOfIQgddlJjnru9RiRaUbaQP/V8w9CE0U
         RnHbdmprBL8H6THbouHQVfh0MIVy8R3DGMjn0tR/8YDNNGB9KiVkeOJszp8n+jNOEhos
         569Kh3aMYZS9Sa/yLJwEfqFsQtCr0Qrdsq4Dun9nkcax+1CCEdyg2SV8qhU/h6XThac9
         VdecoNSNE2hwSSy4moWvtff/Ty4/2d2W3j2W2fcBiDJE4d7MjalJrgWIL+TYPnISQJu8
         Zai9HL2fCzG2yn9VyKreR1q77JOnYaM+Anz2issubMSungQg78XVN1Pb/TfARtrlAF2T
         f8Qw==
X-Gm-Message-State: AJcUukdrF5jLWiXT8/7I/iM7GnK1/4aCIkdTW85XBFTwSq4aDkeyVdwD
        jY13EWV7cPi7xTUBFeAtQ6CUy9wk6M80VKajV5f5tohL1vk=
X-Google-Smtp-Source: ALg8bN50nVvnRCF0Dj7wTr82Y/DfooK9OVhmbZxuVp+ByC6rEHC9zzj/PhLw2wRicOxUg9AhQ0tPdTe3OoGLXtlMt5Y=
X-Received: by 2002:a24:edc4:: with SMTP id r187mr3870892ith.158.1548402366967;
 Thu, 24 Jan 2019 23:46:06 -0800 (PST)
MIME-Version: 1.0
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
 <20190125064217.GA700@sol.localdomain> <20190125064710.juyju7rcz4j6iip6@gondor.apana.org.au>
In-Reply-To: <20190125064710.juyju7rcz4j6iip6@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Jan 2019 08:45:56 +0100
Message-ID: <CAKv+Gu9rhECQO_jqjfDYkaTt8SjXMUQ7tR0xEcVr-n_fnj1PLg@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: arm64/aes-ccm - various bug fixes
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Jan 2019 at 07:47, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jan 24, 2019 at 10:42:18PM -0800, Eric Biggers wrote:
> >
> > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> >
> > However, can you add Cc stable to the first two?
>
> I will add them when I apply the patches.
>

Thanks. Also, Greg and Sasha tend to pick anything with a fixes tag these days.
