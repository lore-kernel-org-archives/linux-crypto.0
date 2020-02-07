Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCF0C2BA83
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 20:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FD721741
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 20:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HIcSkZzd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgBGUsv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 15:48:51 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55954 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 15:48:51 -0500
Received: by mail-wm1-f45.google.com with SMTP id q9so3867525wmj.5;
        Fri, 07 Feb 2020 12:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Vo3y/3LI/9xS6ovXLyiIY19qZ4rNDgl5cjTrH5DGm4I=;
        b=HIcSkZzdBvgR0WPcV6MG53XbfktoeIflCnUKVByWe0jBVHEfCzzei6rSL0pCM7RKDY
         wOvMog9dnWZEgWH2WvNPvv9oxFMCMI2ePH54mtU+k/JkksURgPOxbzsjjvLKSiQMLu3u
         Coi36nEJkRtD5bOrgG7lxQKGTGbp1O4j9GjUUn4D8JZW8fujXkvnsykngs5jlBCpQhsf
         WK87zaQPNiICgy5PpkE2HvhNwcZKHZmd0BtOJFD61Om+Nq7nihY5yrvaUJ3r1wFYvS3F
         W36Qkw7vvt6+d+Vqz1rPdcd2MpVRA1dVA2bnCfzw1TsAoogFmSk2vLlP9K4/9XGaJRQY
         swUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Vo3y/3LI/9xS6ovXLyiIY19qZ4rNDgl5cjTrH5DGm4I=;
        b=r+ulk18HLk+qNKmhTbe0/3VSJYflviNNiFQQzTqsxaaqJS0gcFT+yVrkfMIR3ZO4+J
         qoU2XIlVl/kEamTXzQbu7m4X7zcJA5q7S4HXme2H+34qd9f3RJoNP5u6WMvP3xl399Pb
         9DopYd5Jyxv2KZowWsrp0MbDClHKe/5D9bqbBW5k62p+8nBIAI8hvJQafJziaPoBrdCb
         1ivLIaz8I15R3y5hyRUALQM+m5rK/32RvoFbS1KnlTPRwaTeDexxEsu83LJoswJrPleG
         IOXu/suvPDJ75s1pXYbH3LFG3qRIYKz3K7ZQOv5gsCyY13qb0+BaLOYFuvQHDgDoCS6Y
         JLQg==
X-Gm-Message-State: APjAAAWp+P0YQoL/m/MVG37veeLbAbIW7GO2Zio5oZQxdNTmNb1YAM3b
        2wTWt5Fc/a/gD9ohGmLo8GV1h2C8
X-Google-Smtp-Source: APXvYqww2HjjQMNwdkQTkIkLEammO08yj4O42JmLPef87CvM4J1Vq8Ec3LZwBSGk+vtbq6vnsV4cfA==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr116024wma.87.1581108528197;
        Fri, 07 Feb 2020 12:48:48 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id g128sm4518742wme.47.2020.02.07.12.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 12:48:47 -0800 (PST)
Date:   Fri, 7 Feb 2020 21:48:45 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, heiko@sntech.de,
        linux-rockchip@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] crypto: rk3288: ecb-aes-rk encryption failed
Message-ID: <20200207204845.GA15221@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

When running next-20200207 on a rk3288-miqi, I get
alg: skcipher: ecb-aes-rk encryption failed on test vector \"random: len=0 klen=32\"; expected_error=0, actual_error=-22, cfg=\"random: use_final nosimd src_divs=[<flush>54.11%@+27, 29.21%@+0, <flush>0.9%@+3586, 16.59%@+3971] dst_divs=[100.0%@+20] key_offset=63\"

Loading tcrypt later give me:
udevd[117]: worker [125] /devices/platform/ff8a0000.cypto-controller is taking a long time
udevd[117]: worker [125] /devices/platform/ff8a0000.cypto-controller timeout; kill it

Regards
