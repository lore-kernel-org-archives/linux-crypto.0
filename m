Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8FBC10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 15:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8C54206DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 15:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="BrRUaKZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731707AbfDJP6s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 11:58:48 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45421 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730931AbfDJP6s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 11:58:48 -0400
Received: by mail-qk1-f194.google.com with SMTP id z76so1518861qkb.12
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2019 08:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=asK8s9Ix0RNEzI1LR3lZPuifiKKx02+eKS+tVgAxraI=;
        b=BrRUaKZL9stL/5fzUw+GLR4YOdDBA4w+hanZBbwWT9pYu9Ijs60pAuPhfPR07hto1e
         kvEusbei5xMO3Z6aQHdMVIyiDTjl7S9sUdFbr7I9/pfC2vMMr5UqmA4OgCwUPZgmBAE0
         FIjjVhdO2wDnnKiRPv+s8X6qAi+MlggfPfaHrzhdtoz+ynHq/f8xv/5I/lxgPYhqeDaH
         /nIGZJZFg+IqlA9Hj6FFh2ZMkQEj2z1KdQr+p7yqNnDaAI5XlMnlKWVLbRooTiS/BPN0
         vo47cFkWGAySmz//dwki3k5ZcpMTQEzD+gr4rt42u2YBIczso8uQvp6llAu2niFhpxCC
         c03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=asK8s9Ix0RNEzI1LR3lZPuifiKKx02+eKS+tVgAxraI=;
        b=HF5pQmcoIkL2pYPjq/8ycLstr/HCUWqcBXaEdOHt9BotrI49eZf8wtp9rXnPDSoLs3
         UWvPIkw4iY/ATz+WBlespY1ppDh/giJqNja3UJtTORqUi1vd3iyYaLZnwWffSLDtEMz0
         gwshLpnO26zJjcGFZYLSbJwZQsbx2dV5xw/LdeIy4gHQThyMo/CBdDlVO/NC0d00Ezp6
         cWT8mrtqGaUE8NM2f/zx/ISBtkWz3xOBfuG4rTeV1CuFsYW1vk7vG2pRLiGhQdq+fLlu
         0YglDJOr0f04riduEVEPkZk2msoD5VGxt9wUIhnnEuDSsBQ2rHeZDYRLNsJpJK6bTI03
         whSA==
X-Gm-Message-State: APjAAAU9V+ytVcPhMogpN1iIp048RvIRfhyYaaK+f9L645dVSI6G1dlf
        N5yP8y/s6ruOSIsPcF5Qcwba1Q==
X-Google-Smtp-Source: APXvYqzNWL4BwNr8iMy+3BjJN3Ych+kq9WPGBLf4CFrbgHAnxPKuSws6FAUe1NLvHbK1ApiP9SMLQQ==
X-Received: by 2002:a37:a8cb:: with SMTP id r194mr32379483qke.53.1554911926962;
        Wed, 10 Apr 2019 08:58:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o64sm16451839qkd.12.2019.04.10.08.58.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Apr 2019 08:58:46 -0700 (PDT)
Date:   Wed, 10 Apr 2019 08:58:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
Message-ID: <20190410085842.687f2d2f@cakuba.netronome.com>
In-Reply-To: <a443baa3-a192-2d3d-d3bf-20b0f12e53a4@chelsio.com>
References: <20190409152234.11100-1-atul.gupta@chelsio.com>
        <20190409110137.1ff359e0@cakuba.netronome.com>
        <a443baa3-a192-2d3d-d3bf-20b0f12e53a4@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 10 Apr 2019 10:56:37 +0530, Atul Gupta wrote:
> On 4/9/2019 11:31 PM, Jakub Kicinski wrote:
> > On Tue,  9 Apr 2019 08:22:34 -0700, Atul Gupta wrote:  
> >> Extends Inline TLS record processing to TLS client. connect
> >> API is added to tls_context to setup hardware for TLS
> >> connection and handshake. Functionality wise, this makes the solution
> >> end-to-end Inline TLS capable. TLS server and client
> >> can operate in Inline mode and leverage hardware for complete
> >> TLS record offload.
> >> [0004] Adds the IPv6 support for Inline TLS server/client.
> >>
> >> RFC series for this patch was created against net-next and 
> >> submitted on 18 Jan'2019.
> >> This series is created against Herbert branch.  
> > Sorry if someone already asked this, but is your HW doing full ToE 
> > for all this TLS "record offload" stuff?  
> 
> Yes Jakub

So from what I grok you already feed all the data directly to the
socket completely bypassing the lower layers of the networking stack,
and with this patch set you'd also move 3WHS into the FW?
