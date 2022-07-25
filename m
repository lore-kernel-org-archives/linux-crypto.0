Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2053C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 10:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiGYK2V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 06:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiGYK2L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 06:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895AE175BF
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 03:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06613B80DD9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 10:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0A2C341CD
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 10:28:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLOVJ68q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com; s=20210105;
        t=1658744880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jrp79KdnVbC67SbvT0BjYJeBblG8mzva9JDRRifZJsc=;
        b=NLOVJ68qPKsc0gW/nwz8emdCq8miRplEWAJg1NVhIXXyrtqf89bi6CpBnIAdIe48SlU2wQ
        S8wcJCzw7B938zmmTkSS/JFvzerEGExkxgAFVn1zPJezVXihcEa3hy7zCo2S77IHWW+ltL
        tniRvUX6rBxZ64M8u8Fz53cxfkVNvqc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5d81789b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 10:28:00 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
        <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com>
Date:   Mon, 25 Jul 2022 12:14:08 +0200
In-Reply-To: <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com>
        ("Cristian =?utf-8?Q?Rodr=C3=ADguez=22's?= message of "Sat, 23 Jul 2022
 15:04:36 -0400")
Message-ID: <877d41sdn3.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Cristian Rodr=C3=ADguez:

> On Sat, Jul 23, 2022 at 12:25 PM Jason A. Donenfeld via Libc-alpha
> <libc-alpha@sourceware.org> wrote:
>
>> For that reason, past discussion of having some random number generation
>> in userspace libcs has geared toward doing this in the vDSO, somehow,
>> where the kernel can be part and parcel of that effort.
>
> On linux just making this interface call "something" from the VDSO that
>
> - does not block.
> - cannot ever fail or if it does indeed need to bail out it kills the
> calling thread as last resort.
>
> (if neither of those can be provided, we are back to square one)
>
> Will be beyond awesome because it could be usable everywhere,
> including the dynamic linker, malloc or whatever else
> question is..is there any at least experimental patch  with a hope of
> beign accepted available ?

I agree that this would be nice, but we'd like have to donate
thread-specific data for kernel use, and that's currently totally
vaporware.

The =E2=80=9Ccannot ever fail=E2=80=9D part is impossible to achieve due to=
 old kernels
and seccomp filters.  Low-level userspace needs to paper over it in some
way, so that applications don't have to deal with it.

Thanks,
Florian

