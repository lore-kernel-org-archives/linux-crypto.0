Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B34C7EE29
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 02:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjFJCSn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 22:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbjFJCSk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 22:18:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2AF3ABD;
        Fri,  9 Jun 2023 19:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34CEC61D7E;
        Sat, 10 Jun 2023 02:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAE5C433EF;
        Sat, 10 Jun 2023 02:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686363517;
        bh=zTcnaOwJkU+Z2/e1G0RB0Vq4DlB0sZXLNrsYGdE2US8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AO98/AQ4iyYcrfpmAjmXJBNZvfyUHabRQgMVrRWqVA1SRaiyGWSRrNuBg6bIo3cYy
         GAkxomoMCCE6ZWIG1xKezlhSuWQnvnYdr/ZK1wF/rwSltb6Z0m8W4pREq/c69xFYwA
         5v2XVxfgJBXiEWP7BXGmCe7qL6NyZEsEtgDKrhYQPQmXn7RmOZ+sS+byItBmcmjH/B
         tzhcnlje9YeDDHzZ+IHEjPmVju3vDzYzS3a8Smt+sCzogzcFVNjbtEj39Y5FaZ5JJ5
         yC5H3Ctnb/EhsMH99IWSzo12nCGnNUSvqk6ecEl4BkjNYmKK1QOnCKOQxuMRJc9AhO
         n1hKo5tyJ5wgQ==
Date:   Fri, 9 Jun 2023 19:18:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, iuliana.prodan@nxp.com
Subject: Re: [PATCH v2 1/5] crypto:caam - avoid allocating memory at crypto
 request runtime for skcipher
Message-ID: <20230610021835.GB872@sol.localdomain>
References: <20230523153421.1528359-1-meenakshi.aggarwal@nxp.com>
 <20230609103842.4159321-1-meenakshi.aggarwal@nxp.com>
 <20230609103842.4159321-2-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609103842.4159321-2-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 12:38:38PM +0200, meenakshi.aggarwal@nxp.com wrote:
> If the driver needs more than the 4 entries maximum, the memory
> is dynamically allocated, at runtime.

Again, this is not currently allowed.  Please see my comment on v1:
https://lore.kernel.org/linux-crypto/20230523165503.GA864814@google.com

- Eric
