Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB2FC433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 16:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F2520578
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 16:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbhADQLM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbhADQLL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 11:11:11 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D539C061793
        for <linux-crypto@vger.kernel.org>; Mon,  4 Jan 2021 08:10:30 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ga15so5360701ejb.4
        for <linux-crypto@vger.kernel.org>; Mon, 04 Jan 2021 08:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:cc:date:message-id:in-reply-to:references:reply-to
         :user-agent:mime-version:content-transfer-encoding;
        bh=HxQ6rT9lhS65qk5Jh0AHKYsxUwAteYLwijXS+oeLOr8=;
        b=Ns8rrvk9QKJSZBXKhguEOpt2QqyDrVjv21poDBBCgMEQXgjNkGTCz4psrXX6B8z16l
         ZdEpLXKFPwVTUZnq+ssMSSPQ/RcfmBdtpBjo7iJv+XRpg8tGf+aph2nUlV9vEOGuutoe
         GfLRLXEq6YQK5qoJn9DbhQYFxuDB1hwIwOnbF0YPVb64NHtf4ekU1QtEaklIt61gQYgH
         pkBNKc+0beuimhRQ8OQ8WJwNIN1a0U+oos8rK4WWJjhzEJzKD7c/tyBUi+M8ParCgsgy
         ROz/qTIwC18wQzZ56XNSfmzt3l8PiD8TThOpn6WxIgt8jkXqmjI9QyfXQuQXLVrZxGvC
         +0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:cc:date:message-id:in-reply-to
         :references:reply-to:user-agent:mime-version
         :content-transfer-encoding;
        bh=HxQ6rT9lhS65qk5Jh0AHKYsxUwAteYLwijXS+oeLOr8=;
        b=t+flSzTiK6xaYBaV7Ye4biBvWxPUcAShxcQnnMEZuYVpUxfCYH+Wxvs6mSHSkWFQc+
         8FhKTHMObjYHTxhl+2Pwl/ynoHPbIysENymbATWntU8O1oTotu519GlO/rT5Ruc30lQd
         m+2Lg+EgYUJrHaa3su6weO8WiZnhRHho2Yp8ay7WK9tlyJAdVJetMT7PjEctcH/hJa3H
         k3wt8Gj17zrYMxd36jrNsUt5oml0ICNmdfLq/j4QvhbpbXLonNk8eMgQ0ApinjgnpDvT
         WnLaopCk+uMJScI5HYYzC7dGwRNecRaagf89iAQl/QJ25FIothuETr2pH2v1ANkkdvO5
         iz3w==
X-Gm-Message-State: AOAM530BK+WByJdRo0AvfiJ5Kt0kg/6wOpFriScVazQyMKxWLDYXvoMN
        y8SGs50/gxrXp0CNwHeZBXM=
X-Google-Smtp-Source: ABdhPJwzmQOw9suhX415P2usC5XaqivzJ3lrcEeQRio+tH0QS2kTuqlgOFxLiO5mEkNrMn/EW1k2wQ==
X-Received: by 2002:a17:906:3949:: with SMTP id g9mr65130159eje.493.1609776628270;
        Mon, 04 Jan 2021 08:10:28 -0800 (PST)
Received: from [10.0.0.6] (213-229-210.static.cytanet.com.cy. [213.7.229.210])
        by smtp.gmail.com with ESMTPSA id p22sm23695287ejx.59.2021.01.04.08.10.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jan 2021 08:10:27 -0800 (PST)
From:   "Domen Stangar" <domen.stangar@gmail.com>
To:     "Tom Lendacky" <thomas.lendacky@amd.com>,
        "John Allen" <john.allen@amd.com>
Subject: Re[2]: problem with ccp-crypto module on apu
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Date:   Mon, 04 Jan 2021 16:10:26 +0000
Message-Id: <eme43aecb9-708c-4fda-ba76-a446ecc12790@domen-5950x>
In-Reply-To: <95c0d9f7-e8e9-0b71-1f0a-44230c3dbfe5@amd.com>
References: <em96a2a8ae-80a7-4608-905e-5d932c0cf9bb@domen1-pc>
 <20201228152245.GA90548@nikka.amd.com>
 <95c0d9f7-e8e9-0b71-1f0a-44230c3dbfe5@amd.com>
Reply-To: "Domen Stangar" <domen.stangar@gmail.com>
User-Agent: eM_Client/8.1.979.0
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Device name: ccp-1
    RNG name: ccp-1-rng
    # Queues: 3
      # Cmds: 0
     Version: 5
     Engines: AES 3DES SHA RSA ECC ZDE TRNG
      Queues: 5
LSB Entries: 128

Let me know if you need anything else.
Domen

>Domen, do you have the debugfs support enabled? Could you supply the outpu=
t from /sys/kernel/debug/ccp/ccp-X/info (where X is replaced with each of t=
he present ccp ordinal values)?
>
>Thanks,
>Tom
>

