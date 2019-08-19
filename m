Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E28C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 21:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE3622CE8
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 21:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="bfNVMyCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfHSVf7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 17:35:59 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:41421 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbfHSVf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 17:35:59 -0400
Received: by mail-qk1-f173.google.com with SMTP id g17so2754824qkk.8
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 14:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HRf/rgT/WG8UbnB9CjMWjQnc+PtTo38b22VnPUq0Gg8=;
        b=bfNVMyCC+kpeWN4Ybm2ppMO2SSq9dd2BlbnaSbYunSW9kMr7c3/Mn7ghnxAYXX/H9w
         5cnSpgo2YJd/pI0Wqb+d59pIFjFHJRUl59fR5WiO8eqo6wjq4l7mVfR/Dr2gNwO8ZQav
         6L9PLkWJJs05//MgTBjYa8Y+6ITBMMRL+sTah5MhvAS7N1/asb8a+WQaUDzPlrKstd9L
         HipbiFhOGFIavip/WSrlseDc+9rsiX1OLiBr9skoN9ZOkRjlgLZ0hh6eOiGSMaCMBWEN
         gj71PmdpSRKKD4F7Lsrve9PMd/cNE+Dx8in71GFDGAmo0/BO8CpnzHVBUI6xiqFz76Gr
         ej1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HRf/rgT/WG8UbnB9CjMWjQnc+PtTo38b22VnPUq0Gg8=;
        b=mpMMh6H279B7d6C3zecmeeMaXzgZcObE2f3nuEzFE6K2Q8iJchKJm4C6+v9JYz0c+P
         LS80MirQnBlWAmZU5Zz4eAd9YxWycui+9nPcKOgUfi3V4Bvgyc94aykultCJBjZ9vCQ5
         uA448AhvNRiOTL9fWouHD82kllK9Vkmym1b+KUJFyGL5ga8MbqMTbF2XrCsr6rt5ySHL
         EPdAXY7Iqs1CnutrmAj3mmWxJc3p4VfzdjrCs/Q1jtnH/GZIZ+0pEmXehDbOO0coMdzq
         wndRYwzkfkMb68oHvuCJ3/liIzjOCG5KDnKLubjLbr3Qe7wWr574tC0Axs8CHTjM0m+X
         Z/mA==
X-Gm-Message-State: APjAAAXy3T6jhgE0Vd/qJSzeuAjlXmDTMSMHVz6JqXgoAOgsYzj7F+dF
        40oCfs+Se9x1sMb3wCfHHb8XUw==
X-Google-Smtp-Source: APXvYqyP3YqD1FV6I4CPqc2ji59sr1BQNcZd6k5ZgqSkUowaBMDrU4lqioDJjyN9S5NapIiP5Q/Vrg==
X-Received: by 2002:a37:9cc2:: with SMTP id f185mr22980034qke.172.1566250558671;
        Mon, 19 Aug 2019 14:35:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i5sm8912132qti.0.2019.08.19.14.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:35:58 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:35:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, hdanton@sina.com, john.fastabend@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: INFO: task hung in tls_sw_release_resources_tx
Message-ID: <20190819143551.5b8935f5@cakuba.netronome.com>
In-Reply-To: <20190819141255.010a323a@cakuba.netronome.com>
References: <000000000000523ea3059025b11d@google.com>
        <000000000000e75f1805902bb919@google.com>
        <20190816190234.2aaab5b6@cakuba.netronome.com>
        <20190817054743.GE8209@sol.localdomain>
        <20190819141255.010a323a@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 19 Aug 2019 14:12:55 -0700, Jakub Kicinski wrote:
> Looks like the dup didn't tickle syzbot the right way. Let me retry
> sending this directly to the original report.

Oh, no, my bad, there was just a third bug of the same nature.
tls_sw_release_resources_tx got renamed at some point, hence 
the duplicate report.
