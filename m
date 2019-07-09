Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEC3C004EF
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 11:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AA8F20844
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 11:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="VlApBi7V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfGILed (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 07:34:33 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40615 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGILed (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 07:34:33 -0400
Received: by mail-vs1-f68.google.com with SMTP id a186so10396823vsd.7
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jul 2019 04:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CGzDFS1Bv4DEi06akjll6evAdaNH8lWyUH1GXoVHxZw=;
        b=VlApBi7VP6O0l5TLW4xKUeP1IP3gld8yI+26iO6zNpYhHfvwdWFMhV+Ua7LqXaGheH
         XskVEtqaurt4yH7ETAnfX2RxLFGkcvxAXiNzliaEKP+vYZNjAHOxiFa83B4IxJ6XQSxr
         kF/5w5ghuo5E0iWmaQBioi2mFKAD7V+vqzFAxkuAxkAfj1khA/+I+uU3CE0dIAbxjjOo
         xRb6l5HMdw/MRvo9hTC/xjgj9L84BoTP6RZsCXAyH1cYLK9Ot+IchEqzH1EFi9OZ0bDB
         WY6ohWHHZdBq++Ck1jD52zIiPcFBfZmeouzQ88Q2JW+RV1p21DWtZCxSwSOUGMTMeBDe
         Pd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CGzDFS1Bv4DEi06akjll6evAdaNH8lWyUH1GXoVHxZw=;
        b=FbNx/hH8ONubuRGXiaG/xolDty1HWhcGxXE7bhWUEf9IRM/3F6TU9lyzW0/ZphtBv5
         P9BOJRXrlo9dXtw4roFLWfQqghGwGeCC5nhv4Ee9Tjmy9pUK7xQ5VqosVSjzOzqYoktC
         yshU+L7Rl2IKobmdujs2o/t9cc4b5MeaX6e63+5OoxOI6G99kxuClBVqJaEL1wAk/tz/
         L9nBBIqdWob31hJvk4wXkQShQmB9EiZ5wjW7bKymeWhMVvFUd+83RN7Tk4iZjb3aIRZt
         5SMMejbLW7Le2S+DhsX5E2qp0qPHoGJiZzOUMqyyfZHlIu9Dhxq1CoSF4/7fiEOutWWi
         5y/w==
X-Gm-Message-State: APjAAAVT0dv5L6iG9S4TG604DPNMGJ7tQPOkNQXuaATwi0j6zJqwoOim
        eXZQCwGI5tG8UHgyhfQyfCw67U09IlZrcTfBJ02F+Q==
X-Google-Smtp-Source: APXvYqw/fOlBWCZg3eOdJ4Z+R/Zzyb35A8vjOMRIwr2ALQ9RHroIGw/qY8lDtLz8G7xKq+Di/EEzcol/mz8PreNSHP0=
X-Received: by 2002:a67:8081:: with SMTP id b123mr14107151vsd.117.1562672071964;
 Tue, 09 Jul 2019 04:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 9 Jul 2019 14:34:21 +0300
Message-ID: <CAOtvUMcUeVYh_eUrQWqunR8NUpos5-7zRU0jn0RdSTMtikm0XQ@mail.gmail.com>
Subject: Re: CAVS test harness
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 9, 2019 at 9:44 AM Bhat, Jayalakshmi Manjunath
<jayalakshmi.bhat@hp.com> wrote:
>
> Hi All,
>
> We are working on a product that requires NIAP certification and use IPSe=
c environment for certification. IPSec functionality is achieved by third p=
arty IPsec library and native XFRM.
> Third  party IPsec library is used for ISAKMP and XFRM for IPsec.
>
> CAVS test cases are required for NIAP certification.  Thus we need to imp=
lement CAVS test harness for Third party library and Linux crypto algorithm=
s. I found the documentation on kernel crypto
> API usage.
>
> Please can you indication what is the right method to implement the test =
harness for Linux crypto algorithms.
> 1.      Should I implement CAVS test harness for Linux kernel crypto algo=
rithms as a user space application that exercise the kernel crypto API?
> 2.      Should I implement  CAVS test harness as module in Linux kernel?
>
>
> Any information on this will help me very much on implementation.

Are you sure the needed tests are not already implemented in the
kernel crypto API testmgr?

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
