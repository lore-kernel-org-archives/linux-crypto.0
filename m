Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E12EC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 08:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 485B860F3A
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 08:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240028AbhIWIus (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 04:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239985AbhIWIur (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 04:50:47 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563FFC061574
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 01:49:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w29so14898026wra.8
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 01:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=USzeR9slXkpfmnKo54nYxuAPdrvAsUKYkq8GvDP9n+s=;
        b=Yr21kPsYbxyIvO0Bujp7O8fQoS0NNEPztJk1fbm9lEbXaku6tfDZW/2VjK0IYJiTYc
         ALCA5/1/zGmDUmDl0yVm20toyvY38Gs9mrcjsfavG1nklwRUkNQDtm8BKbWRif9NHNOz
         HM1fx29fPcBzwqCxkdTyaCPR3idOqGorLdfg1Xeik6BWog25LJhaHcwuiTEwXgG0pMKW
         lA3jsWQTnB5e5hwNPiXbVBUA3xBRpJS73tp26HzMeXYdvfbL/65+A8kEH6xN0fZc2oyA
         C/N2crcbgQOoZxdmGuGxoyeKTIGdGYr7tmUAPt1/fpR4VM9V2Eo62Y+yTtQFlkfmiGbg
         NMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=USzeR9slXkpfmnKo54nYxuAPdrvAsUKYkq8GvDP9n+s=;
        b=hxtczEdx+J+RtATF7C1/TrQNob/y6WIrBvdFcfnELidDylJ/dkrZAzgVxc7YfBtDs7
         C7iqoY0lwRi1goUmilwStQnWfd6TUccHsNv1YSvo6NJsZt6Mq8supp3Dh96rGzMUv3gm
         xQdXwLf/nNobYTdGWA/AV7yw5gO+E09MVtdZp/UqEzIlYj0XgYXLVAzFTfTnUCvwz/Zu
         rJDNWYJD+AsEOUHdjDzv3qAnk9CHbYG4K/fgHqVAHdfwekjQjYO74pcIQRqbNNK3zBni
         tuPHJAkaXTCuT8ojLrPaQDbu4DCWk9y3xGuESNaJEE/gAuAXjhMexEbZY8ExP59EsJP4
         bQZw==
X-Gm-Message-State: AOAM531CLkp8CHyjwxScBxExxSi5MTXHGoyk5Zy6eefEp/t0i4DUU6vE
        qEAML8Y4vdDEOZQ4oY4fQHcZOScCu6o3AK0LKJEU8DykveI=
X-Google-Smtp-Source: ABdhPJx7ar4gP+Q2ZPduJconGq3J46OhRtOOmgaFqhuJ/O101hLzeIbYeFuKz7icbJFfniVdKwcPxipoPbEEJ18kBaM=
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr14760540wmg.17.1632386954980;
 Thu, 23 Sep 2021 01:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <TU4PR8401MB1216089F2D1773ECD03561FFF6A39@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB1216089F2D1773ECD03561FFF6A39@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 23 Sep 2021 16:49:02 +0800
Message-ID: <CACXcFm=8xBVdmoDSxt-WCpVunOf_km+BdTH=1dNkzHABjSM9Lg@mail.gmail.com>
Subject: Re: RFC 4301,3602 and 4868 support in Linux kernel 4.9.180
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com> wrote:

> We are in the process of submitting our device for Common Criteria Certif=
ication. Our device uses Linux kernel 4.9.180  for aarch64.  We want to und=
erstand of the Linux kernel version 4.9.180 supports the below RFC's. I loo=
ked in https://www.kernel.org/doc/rfc-linux.html, but could not get enough =
information.

> Can anyone let me know if the Linux kernel support the below RFC's.
>
> *       RFC 4301 (Security Architecture for the Internet Protocol)

That is the core RFC for the IPsec protocols, version two.
Yes, Linux has had IPsec support for over 20 years now.

4301 is not the only relevant RFC, though. Here is a summary document:
https://eprint.iacr.org/2006/097.pdf

Note that not everything in the RFCs is necessarily a good idea.
Back around the turn of the century, FreeS/WAN was the first
IPsec implementation for Linux. Here's their document on
features in the version 1 IPsec RFCs that they deliberately
left out:
https://www.freeswan.org/freeswan_trees/freeswan-2.06/doc/compat.html#dropp=
ed
