Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE83CC2BA19
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 08:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90442071C
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 08:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qdVmv7Y2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgDUII2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 04:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgDUII1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 04:08:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D303DC061A0F
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2020 01:08:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gr25so10280083ejb.10
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2020 01:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6LylzXPDXZSt7bTECl5+HOg+eFcrgoekt+O0ZSKvfe4=;
        b=qdVmv7Y2C5VNBiDNYgmMIusmQWw4+SlXv1ND68Wsc6n4l6AseAFHDdHhWsWAjGSuqr
         qIsF6t9A4bpZIcVzkKaBEtCneHac/zBJtgvKKsPtnv0MNQsHEAZIdYwmeCatHJ6vqOWw
         obCM3D9OhjTup2wyUtJlA/oluGg5GOYYh5tb+rkzlUwVaTN8xz+wLIHVlsLnaK/NX3wP
         6aN+63k1ECqS60fkiS95e+UlWUMG4WiGtSxQNOM9pHhkPlIk6zRlc4D0U8tBGvP1F/FI
         S9qCcgRm6XeOHt16B+R1Wg4/4J1zQRs5PeikanNUZPUVezLf6HKSHHDZewX+benuuRqY
         bEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6LylzXPDXZSt7bTECl5+HOg+eFcrgoekt+O0ZSKvfe4=;
        b=g2HYw7JakkOqt0ecsPTp0MfWcKsl065gzeMP/azB71PWn5Ad12gVMijLIY9MEED/it
         qccC9sWKZfZAbcOt+Wq72OFdXxC5cXjBC/W1FATG2aQl4YhddySNecJwAwSXf7YvfPAG
         9+BoDB3SYHtX/W50pnRqmf9FMxhxLkDvqjoYz+RwaOZrK3Au6pKIyrQJUYdapLP+wIji
         q8PB/3S7YTqUCIlbr87qcAuHzARrE55qx3wvbC9FCx0TKRr/su+dgd8qafWpzgJ33mjQ
         xNHUS53w0mcrQztBcBeBvzcZPw729nlgR/kxEhFW1vJDWl1IEX3nhVbwRUiVfGnRg0wT
         bpjA==
X-Gm-Message-State: AGi0PuazDj76XqkmhlADtY1cbFSl/NVTX4Xu02XVTrZ3dCrQ6J+HsQ7j
        kRf9Xo2MLT3YuDoPtTphiDHWoWkYoHx97/5/gOWS/rZU
X-Google-Smtp-Source: APiQypKQqMgNWcmUDetHFvRDXNqXgcFY6m4ydLSTSiJCc4uLkxz3MRKmc2GOxz16ZDMVBysYKVJRwd2GwtKmntPKZEg=
X-Received: by 2002:a17:906:695:: with SMTP id u21mr19188987ejb.187.1587456505299;
 Tue, 21 Apr 2020 01:08:25 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Tue, 21 Apr 2020 10:08:14 +0200
Message-ID: <CAAUqJDvZt7_j+eor1sXRg+QmrdXTjMiymFnji86PoatsYPUugA@mail.gmail.com>
Subject: libkcapi tests are failing on kernels 5.5+
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Cc:     Sahana Prasad <saprasad@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

the libkcapi [1] tests are failing on kernels 5.5-rc1 and above [2].
All encryption/decryption tests that use 'ctr(aes)' and a message size
that is not a multiple of 16 fail due to kcapi-enc returning different
output than expected.

It seems that it started with:
commit 5b0fe9552336338acb52756daf65dd7a4eeca73f
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Sep 10 11:42:05 2019 +1000

    crypto: algif_skcipher - Use chunksize instead of blocksize

Reverting the above commit makes the tests pass again.

Here is a one-line reproducer:
head -c 257 /dev/zero | kcapi-enc -vvv --pbkdfiter 1 -p "passwd" -s
"123" -e -c "ctr(aes)" --iv "0123456789abcdef0123456789abcdef"
>/dev/null

Output without revert:
[...]
libkcapi - Debug: AF_ALG: recvmsg syscall returned 256
kcapi-enc - Verbose: Removal of padding disabled
kcapi-enc - Verbose: 256 bytes of ciphertext created

Output with the revert and on older kernels:
[...]
libkcapi - Debug: AF_ALG: recvmsg syscall returned 257
kcapi-enc - Verbose: Removal of padding disabled
kcapi-enc - Verbose: 257 bytes of ciphertext created

I'm not familiar with the code in question, so I'm not sure if this is
a kernel bug or whether the change just exposed a bug in libkcapi.

Stephan, Herbert, can you please have a look?

Thanks,

Ondrej

[1] https://github.com/smuellerDD/libkcapi
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1826022
