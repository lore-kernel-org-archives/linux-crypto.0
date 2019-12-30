Return-Path: <SRS0=xlaa=2U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290BAC2D0D3
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 15:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E699D206DB
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 15:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gh7FK9xO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfL3PLo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 10:11:44 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:40701 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbfL3PLn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 10:11:43 -0500
Received: by mail-wm1-f45.google.com with SMTP id t14so14365015wmi.5
        for <linux-crypto@vger.kernel.org>; Mon, 30 Dec 2019 07:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e3s/WqsE2mHLYt7Hngrm7F8xpgITs0maBNJiKYSk6TA=;
        b=gh7FK9xO2hmKAPF22jizPP9iHVy7lZ3H1yPZbrPR/URCc4mTqrHAWX9Aovbsx1xvbw
         Ns03qTiVpiiuMBmij6rQWQUoIhbKEFQaDLJLXZJDwxFB5bL3gmOSZbpVFHwTHoQZ45JB
         9xAYeX2CcvRlHBN7q1u9w/Os6YGULVVrJiNUhyi7zFVJV/H/nQje2nL7Y6+GnqPI7RBQ
         07DQgUWlhXo5vSRlGvk2S+7VxNEb2hDXPOhbEnrLjI8U9J5misIbV4RlTptUSZV1IJ9U
         JU6PzICGxiyOXfpGgeVKhM6DBcFSwIGo8WwgzP5T4zXkgUwGqW7yb2GeqlRl8G6/InkS
         Q5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e3s/WqsE2mHLYt7Hngrm7F8xpgITs0maBNJiKYSk6TA=;
        b=KDuJOXLtLJw10OWTrRPKKaHvjzPJ89gtte+SomFRx6DLlJD6p28RQTDJs7ROSsm7+p
         qYhm7sgfVjuxBsQlb28jUEqqDbcHLBq0C+L47DeIb2MPDJy8LBg+pw9LrpJMJBEb7fgU
         sUQrH619itK8+asXtrslR7e8nPKXU/VR3YE9Co33xhsIJnm+zBj1Iy0L7vEbTMLT5Egl
         DOREDXiULH1xKpqWuGIz3OOsPhyhX2cg3ou82p6p89DLY3wJaxNQ//Wcuy8MXY6L4jGC
         z0HFesWO0Z8l/XHuE52elQnuNYg0ZapMy0Eoz4IT3/kiNTqJoSNq7GRAdfx2ZSVCjXgL
         4O+Q==
X-Gm-Message-State: APjAAAU/+3qEz1jSSwYpQsjsqwqnMMn23fxcFzJuqc4dx4GNUypWuCdI
        yBzrhffBXZaHx4Ui9h0aWm2NHsTEYdvp2uB1gL7a2g==
X-Google-Smtp-Source: APXvYqwzQ871Sh9SS0XYOwGIBHumOJDKGewqOI4/C01uRMt0eriOANA0seCV0k3nuhtHGJd2VnFwTIU1yEOYL56Gk58=
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr35381433wme.148.1577718702089;
 Mon, 30 Dec 2019 07:11:42 -0800 (PST)
MIME-Version: 1.0
References: <6c4fbd8240af542f2c5e26e990825f1232009aaf.camel.ref@cs.com> <6c4fbd8240af542f2c5e26e990825f1232009aaf.camel@cs.com>
In-Reply-To: <6c4fbd8240af542f2c5e26e990825f1232009aaf.camel@cs.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 30 Dec 2019 16:11:31 +0100
Message-ID: <CAKv+Gu91psRa=Jyug5Hfcsse-ZgbG-6eVpgVSKUszqU6oPxZXw@mail.gmail.com>
Subject: Re: Internal crypto test fail: changed 'req->iv'
To:     Richard van Schagen <vschagen@cs.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Dec 2019 at 11:10, Richard van Schagen <vschagen@cs.com> wrote:
>
> I am writing a module for the EIP93 crypto engine. From what I have
> been reading on this mailing list, the driver should return the updated
> IV in order for the caller to =E2=80=9Cresume=E2=80=9D or =E2=80=9Ccontin=
ue=E2=80=9D with this IV in
> another call.
>
> A code-snippet:
>
> int ivsize =3D crypto_skcipher_ivsize(skcipher);
>
> If (ivsize)
>         memcpy(req->iv, rctx->lastiv, ivsize);
>
> Where rctx->lastiv was read from the hardware itself.
>
> The fail message I am getting is:
> [   57.290000] alg: skcipher: changed 'req->iv'
> [   57.370000] alg: skcipher: eip93-cbc-aes encryption co
> rrupted request struct on test vector 0, cfg=3D"in-place"
> [   57.380000] alg: skcipher: changed 'req->iv'
> [   57.460000] alg: skcipher: eip93-ctr-aes encryption corrupted
> request struct on test vector 0, cfg=3D"in-place"
> [   57.470000] alg: skcipher: changed 'req->iv'
> [   57.560000] alg: skcipher: eip93-rfc3686(ctr)-aes encryption
> corrupted request struct on test vector 0, cfg=3D"in-place"
> [   57.570000] alg: skcipher: changed 'req->iv=E2=80=99
>
> Where/How should I return the new/updated IV ?
>

Are you sure you are not making req->iv point to a different buffer?
