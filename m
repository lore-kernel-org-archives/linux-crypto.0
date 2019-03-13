Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5099DC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 12:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E0C214AE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 12:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtoKDihI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfCMMhs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:37:48 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36689 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfCMMhs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 08:37:48 -0400
Received: by mail-lf1-f67.google.com with SMTP id d18so1358144lfn.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 05:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=CdYfUfttsF/kySMHWgoDShevDsGvHaOxDNgj07I8HEc=;
        b=OtoKDihId7zj6hePTz9cJkfEJLrZdwGeXZvSlkOgp7wMslBc7cdxiM9G5Hvj6V46Nk
         lGDg62OhjeKE50hklQXqWtBldJhGHU+j9tY5A1jJ2LY53Tskj/j7PGGIHNvKEpMK8QtL
         O4nQLcUaLzZHnu1sDH6EhsLwwcXPDt6SyXf3H2ZBi4bp1tx355ENxA6QK23kRkNaVr7p
         QTT/jPIALns5DtpCdzv5cALfNoS+3/QHrE89aPKh20PbThH0FDeUF2HASmu9Cm6LO+q9
         VbImadloR5FznH78WT7u/5gmGomRh7Lh7iuJydavicLpeqFwK7aojTUOkCOaMeVqMws/
         pMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=CdYfUfttsF/kySMHWgoDShevDsGvHaOxDNgj07I8HEc=;
        b=B1Ww/qQk9oaotkuW1rqqsXWomGh83Nf8v5sLwlSdH8+lC79AzuU8Yerig3Ys1+w2bY
         885Y689mBT0urgKHwAvWn8xy6dWR45+pNJ1ogFswku81fnB/dyhOmZJz2qM+wLDIyTfD
         XR8oqCNWVfNHm2uR2T5bcXV8637sL2AMI6FxLD9zZrky5prvt+B3x2KIpD+EWG1AR4VM
         nwIuNJDNzZBd7UZbwWAgZ/k8BKn8lrSkp9DFmEmtszNu+teCrUy2tMBo2TkDUKaOV1ew
         lsPq+h9loGx+er9lzHZDMAjcBXG6fPkwt0FwQNqn4AAJa8erqCyoS0lYUpAMID5KJfMD
         zBwg==
X-Gm-Message-State: APjAAAXwsGyUjkX4v8jug/YIOKPAvSZ75FxtFn8BvXh2Jwd2ViNeUCdn
        mPe0wGJKx76YQSm18UIdEV4qlVl7Pn90pmJteTXTivFz
X-Google-Smtp-Source: APXvYqxuChVgXckB6598UiGr0KDlGQ2kznb8aJV2vk9rPcqc/QTO0cNWhMyXL86C3HpYG+S/aPme3UjGUulqZvLOnws=
X-Received: by 2002:ac2:5542:: with SMTP id l2mr21398076lfk.136.1552480665706;
 Wed, 13 Mar 2019 05:37:45 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 13 Mar 2019 13:37:34 +0100
Message-ID: <CAAUqJDtsx6Sdv=6xAb1VWWjDF08y8wh2nsAypR8_x_e99a1Uwg@mail.gmail.com>
Subject: BUG: p8_aes_ctr randomly returns wrong results
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        marcelo.cerri@canonical.com, leo.barbosa@canonical.com,
        linuxppc-dev@lists.ozlabs.org,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

FYI, the p8_aes_ctr crypto driver (drivers/crypto/vmx/aes_ctr.c) seems
to be seriously broken. When I do repeated encryption using libkcapi
multiple times in a row, I sometimes get a wrong result. This happens
more often with long messages (e.g. at 16 KiB it already happens very
frequently).

To reproduce:
1. Install or locally build libkcapi [1] (you will need the kcapi-enc
binary in PATH) on a ppc64le system.
2. Run the following in bash:
for i in {1..100}; do head -c $((16*1024)) /dev/zero | kcapi-enc -e -c
'ctr(aes)' -p test -s test --pbkdfiter 1 2>/dev/null | sha256sum; done
| sort -u

Expected result:
All invocations produce output with identical checksum.

Actual result:
Multiple different checksums are produced.

When I run 'rmmod vmx_crypto' before running the reproducer, I get
only one (correct) checksum, so this is definitely a bug in the
driver. Other ciphers (cbc(aes), xts(aes)) are not affected, even
though the glue code is very similar. That leads me to believe the
problem is somewhere in the assembly code.

[1] http://github.com/smuellerDD/libkcapi

Cheers,
Ondrej
