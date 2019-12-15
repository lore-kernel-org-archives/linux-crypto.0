Return-Path: <SRS0=cN8K=2F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40FFC43603
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 12:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADBEE2253D
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576413078;
	bh=hdh7disvm2RbUZIMXLQRop4N5UGAjnEIBGoNteTESGU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=plYIKm+aLxwpkquoXXTAXaXl5srMhdZWtsBwaM9rGfuuyvQ80o9AB5/j24DuWXKGq
	 tAltRgrjqtO8jdl3wilKvN2D8AI9uJjEiL7Z/rx9pBNFq4MjEmzlUdcpWhfLGqNF8n
	 YK4TYrz8GzWfmK27JQ/7GfICKxq7b7xTaWUOUPg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfLOMbS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 07:31:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfLOMbS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 07:31:18 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7602A2253D
        for <linux-crypto@vger.kernel.org>; Sun, 15 Dec 2019 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576413077;
        bh=hdh7disvm2RbUZIMXLQRop4N5UGAjnEIBGoNteTESGU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vmR+0HG3kwo6RiJzvkfX4Htq3NqEXyFBDAdi+5xqmyo1omTTSt6/jqodVhSvLj5rx
         bjbhm/4HxLvu36JV4+ifjU4dq+miwL1o74h3kj7GMQFBaIZY2OoMnwsBAxEdzrm0OK
         uqrZ+kpRtJXrubUYetk2KuHdacA/qpYF9FdbDunY=
Received: by mail-qt1-f180.google.com with SMTP id k40so3204830qtk.8
        for <linux-crypto@vger.kernel.org>; Sun, 15 Dec 2019 04:31:17 -0800 (PST)
X-Gm-Message-State: APjAAAW7MYvtyrg5ahBIWnygzenNXbvtdejhZdYs2a9taRfYHC2U/6TI
        kjtO22n8A4dGdNpjqKwOAmn4ZYxGkWx0YiQvSBk=
X-Google-Smtp-Source: APXvYqxsu2Sh4Du6Ys9zyaMTkNxlRCvRWmrytm80lxwd5kF1v/haOIDP9g21GnRvCImShPYnZ+nQqG+9b0uUwc0SqeM=
X-Received: by 2002:ac8:21ae:: with SMTP id 43mr20569089qty.223.1576413076676;
 Sun, 15 Dec 2019 04:31:16 -0800 (PST)
MIME-Version: 1.0
References: <1575297822-30977-1-git-send-email-pvanleeuwen@verimatrix.com>
In-Reply-To: <1575297822-30977-1-git-send-email-pvanleeuwen@verimatrix.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Sun, 15 Dec 2019 07:31:05 -0500
X-Gmail-Original-Message-ID: <CA+5PVA6trAap7=R9yBJJ4u-YDrybfD4zc13jeh6tzNWFa4=0gQ@mail.gmail.com>
Message-ID: <CA+5PVA6trAap7=R9yBJJ4u-YDrybfD4zc13jeh6tzNWFa4=0gQ@mail.gmail.com>
Subject: Re: [PATCH] inside-secure: add new "mini" firmware for the EIP197 driver
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        linux-crypto@vger.kernel.org,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 2, 2019 at 9:47 AM Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
>
> This adds the "minifw" version of the EIP197 firmware, which the inside-
> secure driver will use as a fallback if the original full-featured
> firmware cannot be found. This allows for using the inside-secure driver
> and hardware without access to "official" firmware only available under
> NDA. Note that this "minifw" was written by me (Pascal) specifically for
> this driver and I am allowed by my employer, Verimatrix, to release this
> for distribution with the Linux kernel.
>
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> ---
>  WHENCE                               |  15 +++++++++++++++
>  inside-secure/eip197_minifw/ifpp.bin | Bin 0 -> 100 bytes
>  inside-secure/eip197_minifw/ipue.bin | Bin 0 -> 108 bytes
>  3 files changed, 15 insertions(+)
>  create mode 100644 inside-secure/eip197_minifw/ifpp.bin
>  create mode 100644 inside-secure/eip197_minifw/ipue.bin

Applied and pushed out.

josh
