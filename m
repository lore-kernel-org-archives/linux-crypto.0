Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A451C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 13:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5644A21848
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 13:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfnkjBA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKIN3B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 08:29:01 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:34912 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKIN3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 08:29:01 -0500
Received: by mail-pf1-f180.google.com with SMTP id d13so7062847pfq.2
        for <linux-crypto@vger.kernel.org>; Sat, 09 Nov 2019 05:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=V0dcfjSsClF9Vvn2QG0lFTvRyH4w1Rt9rORwYtF7hsg=;
        b=PfnkjBA6dB62KLBpuTBR/rBX5fTbuE0njk0prFq62ukCHULmsh02gpZVvwFa+bfq0h
         ok/v/PYheYnhih4wlkP/MY5YQFVmzj7g+SINZsiO/DAnlhcjonDcHHuGpeEWP1JJKrAe
         2pssqN7XBsZQdblZ20cEZj7qztj82zrBjv7YjYtQ01b0+kM/7aYz52IaCfuoOc6kaT0g
         oZqkvMN756xHy39jQkCBqR7CQ+oS+QrZNXr78rZBIdCJ97LBJUR3mr4wbSDy7PVI+i+g
         98Q5tQqIEvEKpOJUorwQpdh2T+IjGZYWk4b1kZccmNAtD7C/hndsV5q6i+/8p/oyVFoU
         MCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=V0dcfjSsClF9Vvn2QG0lFTvRyH4w1Rt9rORwYtF7hsg=;
        b=YkPOwqTZoJOLF56lRG9Kdqynd/wZ3dxxhCdv1xNoo3rnLkdy+xw5izcqw2T5odCbqU
         vOcxPJ/5Cw8plgfLU5VRt0PxLjpfcK/+d/FLk81nyqwZjpKPslnWOh8UNc1A3USzmTDr
         NU+OnC665QbLKeIr5MCAgTLJM7VG6rGljJfXcV0bRMl70JDke6rLaS7uZzyqQzG+Gd2k
         PoKWFuj4OsguUKB0mY3tkVarSaxbkCzlcLQL6aZevaBwi9buKmEb7VAlA9vHKGnk1oih
         5+qS0sEOnMPyHV99pKgc4JH93ciwpBT/hqigfCKakkBMR3NmtepJuK71cAm82U681jhX
         RTgw==
X-Gm-Message-State: APjAAAXR5tQkJkf6YDDBcnyjyNcPTXuAf4TytXq+Le/65S9BKYM6zxiC
        p7zMq5vAwhUn3ne3kWwF/A8A+DJ+4ipWq2VLpA55fg==
X-Google-Smtp-Source: APXvYqw6pGPC3sFRpLalCPFQx6RZ1pKa1V01s5kiRF4Sq+Rqb6PtzjWia9Fo6pW6zEh7d6XhK5UqY+wUTlZFrYc6bE8=
X-Received: by 2002:a63:6286:: with SMTP id w128mr5617853pgb.290.1573306139750;
 Sat, 09 Nov 2019 05:28:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:23ab:0:0:0:0 with HTTP; Sat, 9 Nov 2019 05:28:59
 -0800 (PST)
From:   "Thomas P. K. Healy" <thomas.healy1987@gmail.com>
Date:   Sat, 9 Nov 2019 13:28:59 +0000
Message-ID: <CABXf8vbSXTZh2P+CkTiJXpaKDd08OjMP-82AScxf_kGr=CXRpQ@mail.gmail.com>
Subject: Re: Remove PRNG from Linux Kernel
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I've done performance testing, and I can generate 50 kilobytes of
random data in 6.9 seconds using the TMP2 hardware. This is adequate.

The boot-up state of my embedded device is very predictable, and so I
don't want any mathematical algorithms for psudeo-randomness present
on my device. I am cutting them all out.

I don't want to use the TPM2 to feed entropy into the Linux kernel's
PRNG. Instead I wish to remove the PRNG from the kernel and replace it
with a direct call to the TPM2 chip. Performance is not an issue here.
