Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55628C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Mar 2022 07:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiCNHHN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Mar 2022 03:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiCNHHG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Mar 2022 03:07:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BAB40905
        for <linux-crypto@vger.kernel.org>; Mon, 14 Mar 2022 00:05:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3FB7F68B05; Mon, 14 Mar 2022 08:05:53 +0100 (CET)
Date:   Mon, 14 Mar 2022 08:05:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Niolai Stange <nstange@suse.com>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
Message-ID: <20220314070552.GA3806@lst.de>
References: <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de> <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me> <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de> <483836f5-f850-6eac-8c38-3f03db3189ab@grimberg.me> <0c4613ff-ba30-c812-a6e9-1954d77b1d1b@suse.de> <ad9af172-4b7b-4206-feab-8ab54ba7cfe5@grimberg.me> <e2ccd5bf-c13f-8660-c4c0-31a1053846ed@suse.de> <1d1522c6-7f6b-7023-9e66-a05ac5a5a0be@grimberg.me> <ac3056fe-e5bb-92cb-2d4f-a86c04117e5d@grimberg.me> <e9b43c80-0eb7-99ae-55d5-aca9bf2a308b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9b43c80-0eb7-99ae-55d5-aca9bf2a308b@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 14, 2022 at 07:54:28AM +0100, Hannes Reinecke wrote:
> Pondering what the next steps should be. Herbert Xu has merged Nicolais 
> patchset, so I _could_ submit the patches, but then I would need to base it 
> on Herberts cryptodev-2.6 branch.
> And without these patches my patchset won't compile.
> So no sure how to proceed; sending the patches relative to Herberts tree? 
> Waiting for the patches to appear upstream? Not sure what'll be best...

We're at 5.17-rc8, so hopefully they will in mainline for 5.18-rc1 in
a few weeks. Let's wait until then to avoid complex tree dependencies.
