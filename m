Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FBBC2BBCD
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 07:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD20F23884
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 07:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgLQHxT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 02:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgLQHxS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 02:53:18 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA05C061794
        for <linux-crypto@vger.kernel.org>; Wed, 16 Dec 2020 23:52:38 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e25so4813949wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 16 Dec 2020 23:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:reply-to:user-agent:mime-version
         :content-transfer-encoding;
        bh=f4993yGKH/ma2ShhrFC0TVSghCD8lqy54dvW7oEPwKs=;
        b=dd7L0fLnOWbhJBBxiUWtBnMJphlUuruSnr8FJJT8Ls5rFyTtVVVvt1Lf5qer0MPlqW
         gzmMO9LBLN6oJuIFNmGLiX/9u9UQeDswQ4aIYOAC5BKgrdqwDkrtEGhBxdKYBOaPlG8U
         s1O2HMN8NKfLGDtVB7COj7iV0x+Zsjder3d7krFhztpJ05R/tDUGTWAOBQOi1fc4R+EH
         qnMRzIWjH2Aro1DQcDCi3n8z4jgUELQxi/4vtyGyp8lnWgJ84b62OmFjLTOgekYjbSoy
         vi+XhgiyXsNgyE1ILOerC9BC/uzplpeSpy7yvQZ7rqaE9RY5VsfsP4tgRnNAio0DK7t5
         VI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:reply-to
         :user-agent:mime-version:content-transfer-encoding;
        bh=f4993yGKH/ma2ShhrFC0TVSghCD8lqy54dvW7oEPwKs=;
        b=rPhB42EOmw+3fufsW/Oa6GQV/tmlu6Be3YDMwfTS/HwI63JppAczQb41ysQBJiCsWw
         mcf+4uZvTBDt8TisB2BLrh9tKM17nDAJr7uXN2xcwGv7fTc9a5nMlg1bgNPiEsY/d/bW
         6UOr2tDAMxs1QLCPRVQHojcMsfrKJ9WV3NeqiqClwKn2HGQkHjQ3+s66I4i02WLoecMo
         Sc279W6XvO6ahVyh+QeVSQO2wPr3Y1ZRGg/MwnFpYbvywjfGtw8bUPMdrsPdCgDFNmfj
         0et6fB1bvL7jkQ30x2yviMVyWCf0H7WQkMTQVZ3eAHdYDjL++zprmUfdPfx8GaMau02E
         0qSw==
X-Gm-Message-State: AOAM531NtJTGdBsrIjUBUkwSGeQU32lvyRM5OG95rmolj6d3rfDc+lzJ
        DOyrZCBTxQGZ5J8xleGDocdkQ6ec7wP9qg==
X-Google-Smtp-Source: ABdhPJxNp7EFMNgkUdckPtrvZ9+lmhPS/FASFBWXc+Q6LVUhatHaIWoTf5pDXJ+5i3oL5uCX1Xxqfg==
X-Received: by 2002:a1c:2b46:: with SMTP id r67mr7107638wmr.162.1608191556590;
        Wed, 16 Dec 2020 23:52:36 -0800 (PST)
Received: from [10.0.0.5] (213-229-210.static.cytanet.com.cy. [213.7.229.210])
        by smtp.gmail.com with ESMTPSA id p9sm6605389wmm.17.2020.12.16.23.52.35
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Dec 2020 23:52:36 -0800 (PST)
From:   "Domen Stangar" <domen.stangar@gmail.com>
To:     linux-crypto@vger.kernel.org
Subject: problem with ccp-crypto module on apu
Date:   Thu, 17 Dec 2020 07:52:34 +0000
Message-Id: <em2eb060dc-78a2-4c71-b4f5-66cad818e069@domen1-pc>
Reply-To: "Domen Stangar" <domen.stangar@gmail.com>
User-Agent: eM_Client/7.2.36908.0
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,
I would like to report issue with ccp-crypto.
When I issue modprobe command, it would not continue, without SIGINT=20
signal (ctrl+c).
If module is compiled in kernel, boot doesn't finish.
Looks like problem is that ecb(aes) selftest do not finish ?

kernel 5.10.1
smpboot: CPU0: AMD Athlon PRO 200GE w/ Radeon Vega Graphics (family:=20
0x17, model: 0x11, stepping: 0x0)

part of /proc/crypto
name         : cfb(aes)
driver       : cfb-aes-ccp
module       : ccp_crypto
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 1
walksize     : 1

name         : cbc(aes)
driver       : cbc-aes-ccp
module       : ccp_crypto
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16

name         : ecb(aes)
driver       : ecb-aes-ccp
module       : ccp_crypto
priority     : 300
refcnt       : 2
selftest     : unknown
internal     : no
type         : skcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16

ccp-1/info
Device name: ccp-1
    RNG name: ccp-1-rng
    # Queues: 3
      # Cmds: 0
     Version: 5
     Engines: AES 3DES SHA RSA ECC ZDE TRNG
      Queues: 5
LSB Entries: 128

