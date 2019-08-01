Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F4DC32753
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 19:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C06020B7C
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 19:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPTHyeLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbfHATmy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 15:42:54 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:34372 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388639AbfHATmy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 15:42:54 -0400
Received: by mail-wm1-f53.google.com with SMTP id w9so4381061wmd.1;
        Thu, 01 Aug 2019 12:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=MRmRK8ES1zrnsFz0iLrmb8hRYIZpLFPxk8moMF7JGao=;
        b=CPTHyeLNOHPEwj4NM2uwBHf9AHz2Vg4Kkvlvcox72QGc+pmiX68n7JvxY98byA6x6B
         zuUCdqLZQqq6F4LP8YPWU+JQL3EdwVxe6jyHVFKtRMM+vzYi3959e6U2cAijQaOESH7d
         z6Kl0misfX54hwpTfxJQIgCVIswCmj5hSbF7t6bCgPVgoVbZX1rZxZ5cciG9TuqosteP
         B+JfopDaJUVOuN6n3a3xrgJiordSdHs+9Q0gBWKlbYTIC4oyWmBPlxonQsUxQVODfrXa
         2KT3/4FqJw9EheAJLCmM47hn9Q82PRrfwjIEYTmYSUifb0qBQtMrtQz13N1hWmtZLje/
         Pw2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=MRmRK8ES1zrnsFz0iLrmb8hRYIZpLFPxk8moMF7JGao=;
        b=LhLu2quT985rV8ex0nSUhlhcHJJIZIb33XtTsa5VlQj6EP55b+Ti4QcHROAUAy6Bvw
         ghtCf1pFd2hiMPSd/orMWsLnOCLIjKM2Wf7MlMj65uqjd4EJ9UPfNSnxMXx4h7qwxJ9g
         zYMxuEmLoVDfT6mgJyPR2nBQEmo/wvviNfa3BWFD/N8rLRdzE1wRjy0l1qye8WW37uNZ
         EcRSgURbjQsZApZ3RtxEZpdnEozfXq8oHYiwi39ee9wNSVC2rChG3BgR6PbviCAQuxs7
         nDtnQ0bR45KKV4RGU1iTZObF1CQ8aSgJbfyjAmAUbu5ewOAjSGReFMz23/Y+tNR3HI6h
         ultg==
X-Gm-Message-State: APjAAAWoAFJUU68Pk/V6At5X4tTRVWQnxzWOOfiGv6pf4ioCyF4snIE+
        NMdlFRkn8wwhAYRg2AbI+YQIczYk
X-Google-Smtp-Source: APXvYqyIR560sr/mYwSHdGi7BJZ42L9k42MYXo7lmTp6hVCNaJsJt78cWnUbFATL7AMiDUQFsFC2pA==
X-Received: by 2002:a1c:dc07:: with SMTP id t7mr287825wmg.164.1564688572289;
        Thu, 01 Aug 2019 12:42:52 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y12sm67449292wrm.79.2019.08.01.12.42.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 12:42:51 -0700 (PDT)
Date:   Thu, 1 Aug 2019 21:42:49 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Need help with failling gcm_base(ctr,ghash-generic) selftest
Message-ID: <20190801194249.GA18705@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

I am writing the Allwinner sun8i-ce driver and when running tcrypt I got
[   30.201739] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) decryption failed on test vector 3; expected_error=0, actual_error=-74, cfg=\"random: may_sleep use_digest src_divs=[100.0%@+2614] dst_divs=[5.90%@alignmask+3015, 60.56%@+3996, 17.92%@+865, 15.62%@+10]\"
or
[  148.613537] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) encryption test failed (wrong result) on test vector 2, cfg=\"random: may_sleep use_final src_divs=[100.0%@+0] iv_offset=20\"

Since ctr-aes-sun8i-ce is passing the ctr(aes) selftest, I dont understand what could be wrong.

Thanks
Regards
