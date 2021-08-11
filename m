Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3CFC4320A
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 00:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F11B60FD9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 00:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhHKAEA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Aug 2021 20:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhHKAEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Aug 2021 20:04:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB97C0613D3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Aug 2021 17:03:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id e19so534902ejs.9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Aug 2021 17:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=x8YBzcp9J7sIIcKvJ91gEevJKo3BkB0p3cRSz2JtjBw=;
        b=PxVmSBk8sUcuhFPP9jNIONX/Ci6WXxS1j+QLs/gl1tSNq+SoSr0RobJAhvoyRZYmON
         jHjG2bWhP/JLf70sjs6hmco1GGuGCXF2tjEU/PXTHflcxjGLClorieSosnsKymI785WC
         pYhpws/yl09mA0f6cxFY61bd4zAxiHA2TCTJUyB9vUzVtkCvu3HTemvewRCEgJcZL4nj
         8Fs76WBrNDbM5VV/lrdjgLw2ELjtLlpFdqJkSu31qliaBsmtqWV4qZ72RhEVRnd2fB9i
         yd6q2nSS9mDADPRFf9SnA9NlWs5mNJnuB7GzF8DAtTUY3GsfsAnR66BeuBSdtvhbNs09
         oo5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=x8YBzcp9J7sIIcKvJ91gEevJKo3BkB0p3cRSz2JtjBw=;
        b=aiSVZcQGtRiTL0lIH6G+8HFw1ogmVZQ78+jmCAcOP12LgiBZ/zuaB8GqxkQ0o76ms+
         2p9Iq1JbYpMT9C6+uYCzCiwaxuwijAlqu2N2lrYi+8dYrloqcN0cwqiABWZMOG0TFUkn
         8O4p4ZmBQ4EXqA6q7lUbQ7HRclUuZu7HfRmaaS4pM+SYNEHqB0XBU4dmOydV7h2WoW+G
         iAC8AHXk328+225EgnyQtLVd50wrAiBVg5w7Ey8/E/jGdU9U7QP8kQVeT8YOQK+wSmkA
         6fHe/WCAfaneqBHcGbvgYJhV9s/BGocUQsxczlpqKlc/lfcTf7Is40g7Ihq97hzJCkat
         o8jA==
X-Gm-Message-State: AOAM530gR9I99xMQUGOsKOE/vKBVRLglbtvTsw8WYo3LODjdzWohHo58
        +6GILxYh/2mhpf4G8njFjUGnaA==
X-Google-Smtp-Source: ABdhPJz2JJ48Eh35mVgtuidsXSqT+oSDNmhtm4chCbPZCFFw4f4xyiXEG/N+PQL0Fe2VjfILDHgkiA==
X-Received: by 2002:a17:906:404:: with SMTP id d4mr947819eja.449.1628640216029;
        Tue, 10 Aug 2021 17:03:36 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id q30sm974026edi.84.2021.08.10.17.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 17:03:35 -0700 (PDT)
Date:   Wed, 11 Aug 2021 02:03:33 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>
Subject: [PATCH 0/2] omap-crypto fixes
Message-ID: <20210811000333.GA22095@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These are two non-urgent fixes for the omap-crypto drivers.

Ben.

Ben Hutchings (2):
  crypto: omap - Avoid redundant copy when using truncated sg list
  crypto: omap - Fix inconsistent locking of device lists

 drivers/crypto/omap-aes.c    |  8 ++++----
 drivers/crypto/omap-crypto.c |  2 +-
 drivers/crypto/omap-des.c    |  8 ++++----
 drivers/crypto/omap-sham.c   | 12 ++++++------
 4 files changed, 15 insertions(+), 15 deletions(-)

-- 
2.20.1
