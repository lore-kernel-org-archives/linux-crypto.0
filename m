Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9182CA9EB9
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 11:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE03E2070B
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 11:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="W4ZHEiZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfJZLq3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:46:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51862 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfJZLq2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 07:46:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id q70so4817908wme.1
        for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2019 04:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WvV3v05v3ZEEVXEmLYdFb7lylJednPWrhNA9CKc5BuQ=;
        b=W4ZHEiZIpNqE3hsCeGHeX4lyrYRkFJ8+N2pzP5EIW+H2uFC30kwXAhqq34aA7o+DDB
         BmU1dchLy+sQVZesfH/mgQBQDsdBbSDqrjHp4rrvN/hygQxIKYOORGF6JIgpFkpPKVlt
         UX1ZC79a1kG1Tb5S12311GoebWaT7Ub492bZ3+7A2UGgJVGEzG5ccbJhAnhhApB30gp6
         2Yqv04+sNcM7GWXQPNdhpABEuHMIeuWBCyxbJaIKRZFaUFVHsK2SJ0wyxH1aC4ARqZoq
         AL38hGrSHCxmYez764UcYWBgdjsfFclVsenwWzYKCLW3HlF04rxnTaEz+TXd8tgEc2TJ
         nAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WvV3v05v3ZEEVXEmLYdFb7lylJednPWrhNA9CKc5BuQ=;
        b=R5gR0yjesoApu6ITyflfbkIikogrXYXfwcnocrYH5q7k2h/EEVuPMUzO931+/0J3hb
         PiAIwdbfbd8VYdnAKBtKHCwtuHdbpIOFj0n2IuzWSvnlpaekdZqQxdaPkYI/7ZgVp7jq
         EUNKc/dlLAiAxFNWKf5wKhKRw1anmyXoIUihGPdRtcVGhzwMOTtgJPu4J7D6DMFfJAUk
         VKGHq9XzjgarFDXQdwlAYetjDZJ7cv3spA1e5Q93F2HtLw/Sv0lg9zpZtUG3p8kjjaNu
         Ip26s9fzs3RdZBPkCac89VgwkVoPGs8u39Wl4rGu927m2Dg6miUXeNJWtiN75JfquVjV
         Mm2w==
X-Gm-Message-State: APjAAAXYvIoTfcnr+1ptEa2VqsATfuDCdXqL5Mq/VNTUrgXt/3YnsQux
        pPwakbTzBVBXzGT7C91wKR7zZg==
X-Google-Smtp-Source: APXvYqzIGA1fzbnD59EkfsIe3VNpri1WAOprW76nJRcZAdCg/+VTJ8MZ+ItfjZ0R+iC4V6eP5dKUrg==
X-Received: by 2002:a05:600c:2387:: with SMTP id m7mr7366917wma.137.1572090385092;
        Sat, 26 Oct 2019 04:46:25 -0700 (PDT)
Received: from localhost (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id o73sm5340728wme.34.2019.10.26.04.46.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Oct 2019 04:46:24 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, mark.rutland@arm.com,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH v3 4/4] ARM64: dts: amlogic: adds crypto hardware node
In-Reply-To: <1571288786-34601-5-git-send-email-clabbe@baylibre.com>
References: <1571288786-34601-1-git-send-email-clabbe@baylibre.com> <1571288786-34601-5-git-send-email-clabbe@baylibre.com>
Date:   Sat, 26 Oct 2019 13:46:22 +0200
Message-ID: <7ho8y3g25t.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Corentin Labbe <clabbe@baylibre.com> writes:

> This patch adds the GXL crypto hardware node for all GXL SoCs.
>
> Reviewed-by: Kevin Hilman <khilman@baylibre.com>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Queued for v5.5,

Thanks,

Kevin
