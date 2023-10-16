Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89397CDB483
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 14:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjJPOCP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 10:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbjJPOCI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 10:02:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5887D121
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 07:02:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A52AC433C7;
        Mon, 16 Oct 2023 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697464922;
        bh=YCHdoRPvqELmp8HFBIy5Fp2nbM9F5EbXq5PutDl2sMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IXxTlPlInDOC5qpMnCDb/8r92ypdGzc86y6EEgmQ4CzkJtn+IuYV5BusGh/cY9xy1
         NzNMq3ZCbFYoO+HciHbLMGeqN0OwzpCAotj0KwipwKRmJyLlP5BSYNtzA+IGzj9H+Q
         ePXK0DedMakCQaOI61D8Od2RDOYZdFzw8rUfNa0CMGLBu0sFpYj3eC7B+GJCaVSUK6
         tDwjSLJ7Kd3jaZGTQd6wIIf15TAXNPJukteW7DMsqPiWZy6ryHkeuH/a4FeMZvPPGG
         OFPmwZpfFhKd2FYkYiAFgfpIX0KyHm6yPR+V+UdZjKpbuDk8QOMTnn64oofE+cu0aD
         6KPLqj9ZwAScA==
Date:   Mon, 16 Oct 2023 07:02:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <ndabilpuram@marvell.com>
Subject: Re: [PATCH 03/10] crypto: octeontx2: add devlink option to set
 max_rxc_icb_cnt
Message-ID: <20231016070200.6f18ede4@kernel.org>
In-Reply-To: <20231016064934.1913964-4-schalla@marvell.com>
References: <20231016064934.1913964-1-schalla@marvell.com>
        <20231016064934.1913964-4-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Oct 2023 12:19:27 +0530 Srujana Challa wrote:
> On CN10KA B0/CN10KB HW, maximum icb entries that RX can use,
> can be configured through HW CSR. This patch adds option
> to set max icb entries through devlink parameter and also sets
> max_rxc_icb_cnt to 0xc0 as default to match inline
> inbound peak performance compared to other chip versions.

If it's a resource it should be configured via devlink-resource.

Every piece of devlink config must be documented under Documentation/

When you repost please CC netdev.
