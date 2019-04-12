Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85F7C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 18:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADDBA2171F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 18:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlNhDlGJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfDLSLA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:11:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43354 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfDLSLA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 14:11:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id c8so5505466pfd.10
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2019 11:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8FllLKQ2QHEwVgeoFUnXsepNmfPzQ+jbJTuDhlva8XM=;
        b=mlNhDlGJ52AA799NyIHDMyw0J49NJ+HE5PGDSjrOV4PjfQ8nkcfmmE5qpgpNMMSzYW
         IER27Epy6VGaLEcYyfPgmYZh3hIR8bBg1tu/p2FQm/gE7xZrY3tmtWhhLocvU53QZYF1
         /yQBomp+VJwDwdFd4ADGPLz5vDy5XPW/mrlY/D0+/0XOxYwfVWwO+vh1q93X2b6YvFYY
         6C0nQV4v4gVnOwjHf627KYwSQ0jmGM/5JG+5Bb/TmcjNvEDSFGiUxbvm+C3jnklG4nGl
         I18AqSan3lT7XVgyPQR+WVicRXL1XMx9Kqj2BNecWo7Tc49y/Nbfbtr2vjp5oRjQDkwd
         W4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8FllLKQ2QHEwVgeoFUnXsepNmfPzQ+jbJTuDhlva8XM=;
        b=nkkPj+Yx6/F+aoiJGuaNXiUeqU9qnKrP03MNHFINwftJEEGnznOus7M89FDZgR3C7g
         e00udIezR8mSFS6NX+6yRDU/b6YdOedZgwUU1ma1Sr2E7jkgTP2/qTN5cNTG+WXMdkop
         LokYurowrk9Yu6lVZ4hpkQ8tSaXMn1B3kxpm6BcwOJqHH/lQA1sgc84IE6EXSjKOsR5L
         nEUHIDf2wPhjUwzn8IfpTdTtE4If6q88tAsKrH1ypvffUOx1/idroafUskFM/u5vOFpe
         6uphympEjvudkqYoMXAI2fd/45NBLLlK3wR5BM+cXvb2pbBOUm15ZiK63aR7P64wKkzy
         ASTA==
X-Gm-Message-State: APjAAAU5fJ/GSzWYwUg0yOyHD7FZM/VlNfZhsIkR+eo+o83i22yNmsKM
        gCUQpgWexUvVup+c5y2YJkOKTKZ2
X-Google-Smtp-Source: APXvYqwPQLTAPd4rFdEp7IiOI+l+BqXWwD+nrgUjXQNXJLbuuQdFZ2oheDo/1nkUlLOjcxdJjSQvpg==
X-Received: by 2002:a63:c64a:: with SMTP id x10mr51718708pgg.12.1555092659933;
        Fri, 12 Apr 2019 11:10:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h71sm12851219pge.49.2019.04.12.11.10.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 11:10:59 -0700 (PDT)
Subject: Re: [PATCH] crypto: scompress - initialize per-CPU variables on each
 CPU
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
References: <20190412151415.de33mytvtga6ihvi@linutronix.de>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5ac3d728-c5b3-c870-e602-f02c66acf6bc@roeck-us.net>
Date:   Fri, 12 Apr 2019 11:10:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412151415.de33mytvtga6ihvi@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/12/19 8:14 AM, Sebastian Andrzej Siewior wrote:
> In commit 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead
> multiple variables") I accidentally initialized multiple times the memory on a
> random CPU. I should have initialize the memory on every CPU like it has
> been done earlier. I didn't notice this because the scheduler didn't
> move the task to another CPU.
> Guenter managed to do that and the code crashed as expected.
> 
> Allocate / free per-CPU memory on each CPU.
> 
> Fixes: 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead multiple variables")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Guenter, this should cure that.

Yes, it does.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Tested with the patch applied on top of next-20190412, running all
345 qemu boot tests. No boot failures or new warnings observed.
To be sure, I ran the arm64 boot tests twice.

Guenter
