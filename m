Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FC3C282DA
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 18:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D402084F
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 18:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="LVkvVWEV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDISBm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 14:01:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33815 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfDISBm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 14:01:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id k2so20959187qtm.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Apr 2019 11:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eYjRAHK5WMbQ9cp3sAvRFJmb7++D9UrqdEGMRhTwWjg=;
        b=LVkvVWEVGHtY1owaoBTcnMZUpgZinrVZiYuSJoFua0FWjlu+LBoRjh4Yd42S2oWvkw
         x8kuYiua/uAK2+Hor9MXLgtUwF11WG/p3V6S4uGJjjrZ23BSGjCrTgei65PIw04bBgCH
         j581C1nPBfChJPRXrjhdNqNVPyyIzUihZXK0UUYUckPhxoZ1My6TLdKcv9BUMHSsbywk
         4VI6KY2mNeHaL9gt9sDhc/GRpCHqkWENAQwBjQulmv+Z8zJHJi0GmdIGkQ1wPv0nPCzg
         6ZXALaHxpDDMUSHW7FFBAqiamvc3RXaGUGUpC+jlizKMtK7IHPtqTgKw4CBoa9/VxzX2
         i4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eYjRAHK5WMbQ9cp3sAvRFJmb7++D9UrqdEGMRhTwWjg=;
        b=clYquwDqPxLa7KBZXn0YbBi/qoBQY/7ciCMC1AC2M7eeKR5ix6r5GAEkLMTvCDJBYO
         wI67WXbP3I49ISlqNU5tytBdpZMaFjv5txwgJ/XB5KiTtI8Bs4Cl0hqn/01TgdPkIVlw
         2oINo6Gw/Z604SNZ/VUY0bXDVhd3loahfdCap3qSbOxCG7uDiUF5RXp/M9fuV/oitNDd
         MxIDkhQUQkCLQafTA/E2eDPqKYhiFjXY7DfSEMMSM/MNNm7YkGthcfFWecpQg/OV6dPv
         OFSQJYqguu/0WIRHJDyBon4UVzxsng0D9N3/s0urZgonfsscYENF9CbZfPEfrbVaRugB
         Drjg==
X-Gm-Message-State: APjAAAWgZeGVjBGnpKgmRRmq5krrAdOwnu9qUc8lTZQV9wFfOeJFNX8F
        kDAG85ZaqL4JGQhzkUnFwGCr/A==
X-Google-Smtp-Source: APXvYqyimp5h2exvfMMHqWm3C0ZWhJz83FCzXvJCEPUG9avX0h3bjJYXdf+gdQS2Gl0Hp98m6/KOZA==
X-Received: by 2002:a0c:871a:: with SMTP id 26mr31062444qvh.203.1554832901403;
        Tue, 09 Apr 2019 11:01:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 50sm9414080qtq.7.2019.04.09.11.01.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Apr 2019 11:01:41 -0700 (PDT)
Date:   Tue, 9 Apr 2019 11:01:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
Message-ID: <20190409110137.1ff359e0@cakuba.netronome.com>
In-Reply-To: <20190409152234.11100-1-atul.gupta@chelsio.com>
References: <20190409152234.11100-1-atul.gupta@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue,  9 Apr 2019 08:22:34 -0700, Atul Gupta wrote:
> Extends Inline TLS record processing to TLS client. connect
> API is added to tls_context to setup hardware for TLS
> connection and handshake. Functionality wise, this makes the solution
> end-to-end Inline TLS capable. TLS server and client
> can operate in Inline mode and leverage hardware for complete
> TLS record offload.
> [0004] Adds the IPv6 support for Inline TLS server/client.
> 
> RFC series for this patch was created against net-next and 
> submitted on 18 Jan'2019.
> This series is created against Herbert branch.

Sorry if someone already asked this, but is your HW doing full ToE 
for all this TLS "record offload" stuff?
