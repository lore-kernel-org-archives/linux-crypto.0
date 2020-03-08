Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71614C10DCE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 14:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EABE206D7
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 14:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="MhmV/SgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCHOou (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 10:44:50 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:33108 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgCHOou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 10:44:50 -0400
Received: by mail-vs1-f67.google.com with SMTP id n27so4516187vsa.0
        for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2020 07:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=28FE7SwK8QUORdA0zvvH1bss8QJwZiB4WA4O6HOQ+lc=;
        b=MhmV/SgASdvRuvx3CX7299dfWyEtdKexZgvAB1K+2YBdq67CMkN3lO7ILcj5R3XQkj
         RWf4hWP62Kiu3jBsm+UeXmiEFS4dqvEO+sj5lhq9/FIirHuhL76WQyeVXBie+LG+9mwr
         t5i2TQbgOqP8T9OYr19tTbWqHuAbICKKX/bgUpiL8lgCNsfjkNxK560IH6EqrTVz6U4D
         A+0ERfbUE2pzDMovSHut2BiZc0WmDPBDQ2qV0mlAJVm5gmv+5VizcVp34jgUQb0DpuFY
         0M81M1Bv9n8QIagW6yfhBmuoMKKkyGkjupJfjJC0fATuVklUntqRlj3of3W3KI+Bpwof
         TLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=28FE7SwK8QUORdA0zvvH1bss8QJwZiB4WA4O6HOQ+lc=;
        b=W8gYOjryGmbxyRcwfyAcy82IrCuOGGnS0KcX3gxv6JDCe1bNxOp00XJNvLHP5K9gAE
         8xq6z7UsggXa0RHzrF1Cs9yt/zMYa8KVaavJQcJWLvNpnLkPXzYmW+6o4SOuJsQrJENB
         5PXRw/ucsReICmRYveGGMKjwoL+tBOn0whZ3plyB2Yn2z9z+l27iP1nyQaes4B1h3If0
         w5rqkHJf3B9wz951txQhXqJ6lPA+scBsqtze9i4w5GI1PdtGdF8kWY92PBRwaQsehiag
         8QxtCMJ9oOI3gRNB3LOhiWvl7b1ltGeEbz+DnCvGzjXE3XscMOX+ImkZWzYEkyPyJFYM
         vGTw==
X-Gm-Message-State: ANhLgQ33BABZSuYnh1TRjRTZf301O3ul7pf/CmPWQwCUiDKVVm87pAvi
        oVcg7kpuWTPl5G/NawRD07PgsfG1RXnlY9H7H/fw5w==
X-Google-Smtp-Source: ADFU+vscxkjHzRW80atkksLmIXO6QkdK1axMYerLnCQrNhGmaNFwFEhkX5Qpbn5Xhxrqu/PRwdCniqOkrdop6FSUGYU=
X-Received: by 2002:a67:d06:: with SMTP id 6mr5127040vsn.11.1583678689023;
 Sun, 08 Mar 2020 07:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200304224405.152829-1-ebiggers@kernel.org>
In-Reply-To: <20200304224405.152829-1-ebiggers@kernel.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 8 Mar 2020 16:44:36 +0200
Message-ID: <CAOtvUMejzz-B+NgdGNcHNcuRPPVd06EHQ85PSCp+YHukCdw_7A@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: AEAD fuzz tests and doc improvement
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 5, 2020 at 12:44 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> - Make the AEAD fuzz tests avoid implementation-defined behavior for
>   rfc4106, rfc4309, rfc4543, and rfc7539esp.  This replaces
>   "[PATCH v2] crypto: testmgr - sync both RFC4106 IV copies"
>
> - Adjust the order of the AEAD fuzz tests to be more logical.
>
> - Improve the documentation for the AEAD scatterlist layout.
>
> (I was also going to add a patch that makes the inauthentic AEAD tests
> start mutating the IVs, but it turns out that "ccm" needs special
> handling so I've left that for later.)

For the whole series:
Tested-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thank you Eric!
Gilad

>
> Eric Biggers (3):
>   crypto: testmgr - use consistent IV copies for AEADs that need it
>   crypto: testmgr - do comparison tests before inauthentic input tests
>   crypto: aead - improve documentation for scatterlist layout
>
>  crypto/testmgr.c      | 28 +++++++++++++++----------
>  include/crypto/aead.h | 48 ++++++++++++++++++++++++-------------------
>  2 files changed, 44 insertions(+), 32 deletions(-)
>
> --
> 2.25.1
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
