Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FB3C6379F
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Feb 2023 00:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBKA0u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 19:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBKA0s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 19:26:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF908453A;
        Fri, 10 Feb 2023 16:26:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB80AB8262D;
        Sat, 11 Feb 2023 00:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C5DC4339C;
        Sat, 11 Feb 2023 00:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676075202;
        bh=CMGfOH8/+hEus/gWlx5JPmPZBYrw3oaiLIy8CsyZeTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CNCe2LKlrVkOPxVU9vOMUOeRR0V54AZc+/pYq5S4sIOSZ9zrhwPeXjSKv+SRgYR34
         Bd9BGx4xbAfFocqyBm+fqJwhT+fommNeygKoBuSA14gh89EpnEMSntM9RsNLfSQMW3
         0sdULXBAYgebWGwlOsL1VduQoJqTdoHu8AeAdHYgjOwYTZv28YG0uQgp1O6DQK4UuC
         gWJ2zfxOxW3W5rMJIvyPqnP8//WPiMHIHKKFjTfVvoDnu80sGyYo+JaqF9W14mO8n2
         pICSUl6kQPDwa7hokhCVZgrJlGbAXQrOGQJbeIKq8lN+STeljLXv/CDvIAFBGs+/d+
         kPjGmGCnMokYw==
Date:   Fri, 10 Feb 2023 16:26:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH 03/24] Documentation: core-api: correct spelling
Message-ID: <20230210162640.09e040ad@kernel.org>
In-Reply-To: <20230209071400.31476-4-rdunlap@infradead.org>
References: <20230209071400.31476-1-rdunlap@infradead.org>
        <20230209071400.31476-4-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed,  8 Feb 2023 23:13:39 -0800 Randy Dunlap wrote:
>  Documentation/core-api/packing.rst |    2 +-
>  Documentation/core-api/padata.rst  |    2 +-

I think these go to different trees (crypto vs netdev)
