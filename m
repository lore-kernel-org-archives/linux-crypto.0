Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC32C07545
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Oct 2023 13:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjJUN0H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Oct 2023 09:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJUN0G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2023 09:26:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C035D6B
        for <linux-crypto@vger.kernel.org>; Sat, 21 Oct 2023 06:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697894655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAJJoylF1cW1oW2mCcwy+DSGsa9dllVFEwoULjFHt7U=;
        b=A9EQoDI2r7GS0h6DLPg21qT/Px4dbp7Z7PPm4GRJoCJ7RhE4S5qOm/OYi43qiasxrOwCe5
        sHxzbPy0KZbl6RP7Cp0Z3hGtHEHcv1D05RkV4F08NmGwd11hPgFSHy1ArEnvc+CDind5od
        3SENhSEU9NKOG/Je2TUYGYN3d8axhqE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-zbgpUdHPPPaMc0UKGHYHqw-1; Sat, 21 Oct 2023 09:24:08 -0400
X-MC-Unique: zbgpUdHPPPaMc0UKGHYHqw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-53e2acda9d6so1084854a12.2
        for <linux-crypto@vger.kernel.org>; Sat, 21 Oct 2023 06:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697894647; x=1698499447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sAJJoylF1cW1oW2mCcwy+DSGsa9dllVFEwoULjFHt7U=;
        b=NCTMBzqL7rJKJlf2hinrU18PXUCProH48kZpoKDI2A9MMVtdbqjwGHf0LM4ME6SaKT
         o/5wee5jT0sUZju5bdSl6BE/4q7WzAYUB40oo8Omg05CLpgY5XHboM5pypMWpBS0lQeN
         cImurittn/wDp2XHBHYuldvBTPt6IONZ4ZoD62Cak+19Pdcd4H7WrNp5cqDV5fvd1KcA
         ofCPuCbw0dDVmQTqPbxlXkXRMh1PEZP4QuD60X0yRxB8EC7kEcD5McqvSCRBR42jY2b4
         6ngRkVG4Z5kYBCAAQhwVBsmzma7yjxCPF14IsBkXpwC18+fx6ZjOtZVgIjD0hFc2pC8E
         Mvvg==
X-Gm-Message-State: AOJu0Yw+FdNFO8oHdR0LvkKvSsj2pfBbUPiwaPsJlhMWsXzJ1O+AlSjc
        Poig0HJoToRy0ENmv4Bl0+452MCgDsLFNlfr+LxNGvn3CXCnwCuuBkNy22NMZqvNDegpKc9g+Rl
        JKbIIO/bflZgiajVMnnR38ILyaHiA5zQqPVQQfDel
X-Received: by 2002:a50:aacf:0:b0:53e:1388:cb2e with SMTP id r15-20020a50aacf000000b0053e1388cb2emr3332758edc.35.1697894647030;
        Sat, 21 Oct 2023 06:24:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyy9uSFCMUqfgN2rj17ch/G/jvq1QTWJGPAXTF5FtC6Qouo5v3kERhMpzgMczbfZXe5FR3mAcf/aFuBhBAvjs=
X-Received: by 2002:a50:aacf:0:b0:53e:1388:cb2e with SMTP id
 r15-20020a50aacf000000b0053e1388cb2emr3332740edc.35.1697894646692; Sat, 21
 Oct 2023 06:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <143690ecc1102c0f67fa7faec437ec7b02bb2304.1697885975.git.lukas@wunner.de>
In-Reply-To: <143690ecc1102c0f67fa7faec437ec7b02bb2304.1697885975.git.lukas@wunner.de>
From:   Richard Fontana <rfontana@redhat.com>
Date:   Sat, 21 Oct 2023 09:23:55 -0400
Message-ID: <CAC1cPGx-cb+YZ9KgEFvSjtf+fp9Dhcn4sm9qHmFFDRDxb=7fHg@mail.gmail.com>
Subject: Re: [PATCH] treewide: Add SPDX identifier to IETF ASN.1 modules
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-spdx@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 21, 2023 at 7:25=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> Per section 4.c. of the IETF Trust Legal Provisions, "Code Components"
> in IETF Documents are licensed on the terms of the BSD-3-Clause license:
>
> https://trustee.ietf.org/documents/trust-legal-provisions/tlp-5/
>
> The term "Code Components" specifically includes ASN.1 modules:
>
> https://trustee.ietf.org/documents/trust-legal-provisions/code-components=
-list-3/

Sorry if this seems super-pedantic but I am pretty sure the license
text in the IETF Trust Legal Provisions does not actually match SPDX
`BSD-3-Clause` because of one additional word in clause 3 ("specific"
before "contributors"), so IMO you should get SPDX to modify its
definition of `BSD-3-Clause` prior to applying this patch (or get IETF
to change its version of the license, but I imagine that would be more
difficult). This issue of a multitude of nonsubstantively different,
non-matching versions of clause 3 is a common issue that has been
coming up in the Fedora project's adoption of SPDX identifiers for
license metadata.

Richard

