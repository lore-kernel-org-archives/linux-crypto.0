Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086F1C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 10:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350458AbiE0KG4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 06:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiE0KGz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 06:06:55 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BD46C0DA
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 03:06:54 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nuWri-000YOp-UK; Fri, 27 May 2022 20:06:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 May 2022 18:06:43 +0800
Date:   Fri, 27 May 2022 18:06:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCHv12 00/11] nvme: In-band authentication support
Message-ID: <YpCis+8bv/EJqdlc@gondor.apana.org.au>
References: <20220518112234.24264-1-hare@suse.de>
 <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
 <20220526090056.GA27050@lst.de>
 <99126556-65b8-d0eb-bcd5-7b850493b51f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99126556-65b8-d0eb-bcd5-7b850493b51f@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 27, 2022 at 07:50:42AM +0200, Hannes Reinecke wrote:
> On 5/26/22 11:00, Christoph Hellwig wrote:
> > On Wed, May 25, 2022 at 11:54:54AM +0200, Hannes Reinecke wrote:
> > > How do we proceed here?
> > > This has been lingering for quite some time now, without any real progress.
> > 
> > As said it is a high priority for the upcoming merge window.  But we
> > also really need reviews from the crypto maintainers for the crypto
> > patches, without that I can't merge the series even if I'd like to.
> 
> Hmm. Guess I can remove those helpers; after all,
> both are just wrappers around existing exported helpers.
> I'll resend.

I've just acked those two patches.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
