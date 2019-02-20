Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22BEC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 17:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0CF2146E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 17:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfBTRBw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:01:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35337 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfBTRBw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 12:01:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id z13so1110342qki.2;
        Wed, 20 Feb 2019 09:01:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXbYWIYJkkZAAFH98/Uj06LjFFWwnR7ob+mWG48FRes=;
        b=CBp/YkeAPim2h5EtmvgVz6a+OUd0IX2fJdn29dNrIJ8uiUzUifzJVbC9OFmN0LHCBQ
         AhrRtEd9P1QLeAJmPOSsVIj+Lh46xbOLbNsaFj/IoA9n7HxCRIvY8mRRQ4/y5wchIpNT
         8jJQRabbTeLt1fjhgLSeoRPADN0aGjeP5383e/PwBAaBKa64oTKr8DX6KXiWqTro19Ys
         +Rktqcgf5q06pk+oBArn7AxsBP8PB/ESoPKRjYQQPToLav+/F9Hizsrpf9Ty+NTdioFI
         uZH/p+UKTvUILXCtcjwRVOeVFvkJOcLJVadZWPHgWuHPqqcbyhpwVFsbC5O/TkiIgj5k
         KXZw==
X-Gm-Message-State: AHQUAubeCmTsBauUGyfzPK8E00aHF6uy7XjxW1DUVrRIHQT3WeMB54ia
        7O5Jz8pC5gUZcd67LZmVmP3MHiGHd6N8SETxcIM=
X-Google-Smtp-Source: AHgI3IbGP4wZ8sD3ebyZqsy1pfjXbASBJ8+CLjjlAwcaooyx+gEh1JE6BOdy+vFGmwa6q1ZGHHRrKvbo02jwkDwVhjU=
X-Received: by 2002:a37:bdc6:: with SMTP id n189mr24894009qkf.330.1550682111584;
 Wed, 20 Feb 2019 09:01:51 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
 <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com>
 <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com> <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
 <CAK8P3a3FMa9tpw4rj+8Aue2EYxxKSD4nxdwRFrzac_87Kzio5g@mail.gmail.com> <CAFA6WYNCxGTqw6LKUPK-ceWD1NbAhJQmzrH5fwOVRP5f2Auz2Q@mail.gmail.com>
In-Reply-To: <CAFA6WYNCxGTqw6LKUPK-ceWD1NbAhJQmzrH5fwOVRP5f2Auz2Q@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Feb 2019 18:01:34 +0100
Message-ID: <CAK8P3a3cPcBhFZkGKXEqJJtx-p_pNZ6M6gJQuXsoAdSENNrGUg@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 5:26 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> On Wed, 20 Feb 2019 at 21:04, Arnd Bergmann <arnd@arndb.de> wrote:

> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
>
> There are already fixes sent in upstream for these. Maybe you could
> pick those too.
>
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1935826.html
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1935849.html
>
> One more reported by Dan Carpenter here:
>
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1936881.html
>

Applied all for now, thanks a lot!

      Arnd
