Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71A5C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 14:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7982121D6C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 14:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cbrHpAea"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfIZO7g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:59:36 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:37654 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfIZO7g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 10:59:36 -0400
Received: by mail-wr1-f48.google.com with SMTP id i1so3161998wro.4
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 07:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JyVaqaZ193HlGyEuM1IPz/iYFAXNi/CM2xxL+aWnNWs=;
        b=cbrHpAeanzc0/KwZKxx6xOp2/hXya7Uy2dKk4WdD1cnlxe3B9WOVYy2tYSRDsK7SCW
         Tr+61trJ0bVhDdahZdNfSFP5Wx9SJWK2ai7xVwUo1Hm74fuWl9S+k7X6cqGebgR1s/2Z
         pFU3uodgfOc491EruFKE7PCv/rn4ZpcbRrxnyDNHRv7wmm1UZ5xfuf2OWnurD1YPX36s
         kNfQ1UdNB2YVYJpfzJDFdYVq/A7YCMqcvNxojbMoMNfwFNr86Vny7lzfDB6bNlY+t9VH
         f1b6a+kwLagX7WBbpzYgUbgZLznuTuFJGEMFLwJCHUzeaCCMUrhNLA8DM1iAIP1P/Xqf
         R0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JyVaqaZ193HlGyEuM1IPz/iYFAXNi/CM2xxL+aWnNWs=;
        b=FKxNYMQHkrq71b2/RoU7UQZ8y2JrS9nLKoAtHJ2pmYLLsvijA6sPEt7ZjIkwNTrqfS
         xiP4dtgMHcYob2yBzIaJjem3VUqkN5GoF3vuhiUik2Bry0o6LKo9zKgO3xJfy6fdqJE1
         z7Bynk7jNXLvhKaowODtL5l4PH1uG32PLqfqAUmFlUYoVME8EvjPgX9T9HcyY4h3n2JZ
         pU5z2TMGyJvm78Yd/Fme1YSaN5x0qrkgWeP3YNtVgeAjEJoO/6ACO4jHyx2qd0zao5IO
         0tfV8O63pD9HEL81PUuUqNBkFnztRaXSqUUqb2f2LIIjNs/EpVkUm8VOjkAHmEjs7Ldd
         /8xw==
X-Gm-Message-State: APjAAAXmipIBgR2ud/U9F5UQbJVsf7Wdbuin/VXKX43BWUgy51ynKZh0
        mhBQhMWiHphl07nujoCzHIYbR5dFkrazqZMLyt6x3A==
X-Google-Smtp-Source: APXvYqzttLBXo7S0jNa10/nHp9vRJuiAiEremvYaFCsACYEpriZ3z1uPNXy/4NmOPkmAfWcBTDEQvAtdhoQhMYAYdsI=
X-Received: by 2002:adf:fe88:: with SMTP id l8mr3193714wrr.32.1569509973246;
 Thu, 26 Sep 2019 07:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB2973C550AC7337ED85B874D8CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973C550AC7337ED85B874D8CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 26 Sep 2019 16:59:22 +0200
Message-ID: <CAKv+Gu86tW4hw7b3iMDt6U6HnUcf1BWRAcGK8O3xtSj_hdmdQQ@mail.gmail.com>
Subject: Re: Chacha-Poly performance on ARM64
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Sep 2019 at 16:55, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> Hi,
>
> I'm currently doing some performance benchmarking on a quad core Cortex
> A72 (Macchiatobin dev board) for rfc7539esp (ChachaPoly) and the
> relatively low performance kind of took me by surprise, considering how
> everyone  keeps shouting how efficient Chacha-Poly is in software on
> modern CPU's.
>
> Then I noticed that it was using chacha20-generic for the encrypt
> direction, while a chacha20-neon implementation exists (it actually
> DOES use that one for decryption). Why would that be?
>
> Also, it also uses poly1305-generic in both cases. Is that the best
> possible on ARM64? I did a quick search in the codebase but couldn't
> find any ARM64 optimized version ...
>

The Poly1305 implementation is part of the 18 piece WireGuard series I
just sent out yesterday (which I know you have seen :-))

The Chacha20 code should be used in preference to the generic code, so
if you end up with the wrong version, there's a bug somewhere we need
to fix.

Also, how do you know which direction uses which transform? What are
the refcounts for the transforms in /proc/crypto?
