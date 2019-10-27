Return-Path: <SRS0=b68P=YU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF2CCA9EAF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 09:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885B821726
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 09:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572170396;
	bh=0y0SRx8HR9EiEmSNyoLk6vVHSMKEaoqC8szmDK7YJpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UCRjC6AF0RY6rjtdeXPZdTYugATNvDM1ZCbvmed7WOkOiRnJdEbRDpyzw0b+JBXdF
	 OtthBRfnV4aLngZeGUvzBN/FIkt8IDmIkUgs+5C9B4Mx42fl838ElNCfydugoLRbQ0
	 8HvLmNkLLF2nLiqt0NDjOQ/O3bL3osfK+5Quo3OY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfJ0J7z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Oct 2019 05:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfJ0J7z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Oct 2019 05:59:55 -0400
Received: from localhost (lfbn-1-17239-195.w86-248.abo.wanadoo.fr [86.248.61.195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D198C2067B;
        Sun, 27 Oct 2019 09:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572170394;
        bh=0y0SRx8HR9EiEmSNyoLk6vVHSMKEaoqC8szmDK7YJpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yYJF8+CAHm6PzevDJyBnQR1Pt3MpZLE+pd1H5sKxWhCAvVjXPwfh7mH1GYzrIU/aE
         4EM3NyYuC6hPIRf6uYUfQsHuV3P3E1davO/gnBHj1F1CMa4tn+bu1FETFB/aRBhJOK
         z5rq957YoPIS2LV72SDJZGG/6+zD2E7f0OwzFmTM=
Date:   Sun, 27 Oct 2019 10:59:31 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, p.zabel@pengutronix.de, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 2/4] dt-bindings: crypto: Add DT bindings
 documentation for sun8i-ss Security System
Message-ID: <20191027095931.lruqnzw2gluwfkrz@hendrix>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
 <20191025185128.24068-3-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025185128.24068-3-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Oct 25, 2019 at 08:51:26PM +0200, Corentin Labbe wrote:
> This patch adds documentation for Device-Tree bindings of the
> Security System cryptographic offloader driver.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

This patch and the previous one are:
Acked-by: Maxime Ripard <mripard@kernel.org>

I'll apply the DT patches when Herbert will apply the first two.

Maxime
