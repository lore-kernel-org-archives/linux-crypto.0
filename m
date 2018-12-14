Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbeLNNPd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 08:15:33 -0500
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB2D621104
        for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2018 13:15:32 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id y78so3158343qka.12
        for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2018 05:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20181122091622.17531-1-rottela.nagadheeraj@cavium.com>
In-Reply-To: <20181122091622.17531-1-rottela.nagadheeraj@cavium.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Fri, 14 Dec 2018 08:15:20 -0500
Message-ID: <CA+5PVA49pzQ1Z5hDBMdqsavA3EqATO9q5QH3vJFM47MCrhEYAQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] cavium: Update firmware for CNN55XX crypto driver
To: Rottela.Nagadheeraj@cavium.com
Cc: Linux Firmware <linux-firmware@kernel.org>,
        linux-crypto@vger.kernel.org, Jampala.Srikanth@cavium.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 23, 2018 at 1:53 AM Nagadheeraj, Rottela
<Rottela.Nagadheeraj@cavium.com> wrote:
>
> Firmware upgraded to v10
>
> Signed-off-by: Nagadheeraj Rottela <rottela.nagadheeraj@cavium.com>
> ---
>  WHENCE               |   2 +-
>  cavium/cnn55xx_se.fw | Bin 27698 -> 35010 bytes
>  2 files changed, 1 insertion(+), 1 deletion(-)

Applied and pushed out.

josh
