Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1419DC19F2D
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Aug 2022 18:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiHFSQa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 6 Aug 2022 14:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiHFSQ3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 6 Aug 2022 14:16:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13212DEEA;
        Sat,  6 Aug 2022 11:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E3A61205;
        Sat,  6 Aug 2022 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE3BC433D6;
        Sat,  6 Aug 2022 18:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659809788;
        bh=u+2EWCmrS8XS1j8mXKDr+RA0fNLxlLVKpqLKR8Pgb7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gu2mUVhKz/J564OpLAR6Xtsc4s4xm06Qr4cnHbB3LVOc7P0mmr2F6USJBpB++RweI
         j921G5W7pK+QgyIBADmrXKt21Ydb67eK+cHbd/RkBlMCCOFoT5pG/S4QTWGYM23WDN
         2OBGW65yhrnO79Xrn0hzfYSXIR6IjWE2Vvx/XkqHzdi+0rr9PT+aA3BonOFedvz0x/
         1u8wr5cSw9irnCXtOp+Ws6LRFuWIvG9BKczHCZeKuuHA38KvCijYkknNA6nfzFucQw
         jgdKuCYzv+wYLeXF1j/RYNE/zYbYlW9hxf+L2Z+p8FxydkuoLAZ9bK4jETkZAB/5Bo
         H6YGy0ExwHZcg==
Date:   Sat, 6 Aug 2022 21:16:25 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Harald Hoyer <harald@profian.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp: Load the firmware twice when SEV API
 version < 1.43
Message-ID: <Yu6v+ZFe7zDQjcvZ@kernel.org>
References: <20220804010223.3619-1-jarkko@kernel.org>
 <58e8f9dc-a8d3-a2a5-2dd7-0783355e2567@amd.com>
 <de02389f-249d-f565-1136-4af3655fab2a@profian.com>
 <cd0d79a9-310c-2181-401a-64a67f454c66@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd0d79a9-310c-2181-401a-64a67f454c66@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 04, 2022 at 08:51:02AM -0500, Tom Lendacky wrote:
> On 8/4/22 08:37, Harald Hoyer wrote:
> > Am 04.08.22 um 15:13 schrieb Tom Lendacky:
> > > On 8/3/22 20:02, Jarkko Sakkinen wrote:
> > > > From: Jarkko Sakkinen <jarkko@profian.com>
> > > > 
> > > > SEV-SNP does not initialize to a legit state, unless the firmware is
> > > > loaded twice, when SEP API version < 1.43, and the firmware is updated
> > > > to a later version. Because of this user space needs to work around
> > > > this with "rmmod && modprobe" combo. Fix this by implementing the
> > > > workaround to the driver.
> > > 
> > > The SNP hypervisor patches are placing a minimum supported version
> > > requirement for the SEV firmware that exceeds the specified version
> > > above [1] (for the reason above, as well as some others), so this patch
> > > is not needed, NAK.
> > 
> > As described in the "Milan Release Notes.txt" of the AMD firmware update
> > package amd_sev_fam19h_model0xh_1.33.03.zip.
> > 
> > "If upgrading to 1.33.01 or later from something older (picking up
> > CSF-1201), it is required that two Download Firmware commands be run to
> > fix the "Committed Version" across the firmware. CSF-1201 fixed a bug
> > where the committed version in the attestation report was incorrect.
> > Performing a single Download Firmware will upgrade the firmware, but
> > performing a second one will correct the committed version. This is a
> > one-time upgrade issue.
> > "
> > 
> > Note that `1.33.01` is not the same version number as "1.51" in [1]. One
> > is the firmware version, the other is the SEV-SNP API version.
> 
> It is the same and are meant to correlate, the 33 is hex => 51.
> 
> > 
> > I am definitely seeing a wrong TCB version, if the firmware is only
> > updated once to `1.33.01` aka "1.51".
> > Reloading the `ccp` module, which triggers another firmware load, cures
> > the problem.
> > 
> > The patch might be wrong, as it might not do the right thing, but the
> > problem and the solution exist.
> > 
> > What is your suggestion then to fix the wrong committed TCB version?
> 
> Hmmm... ok, I see what you're saying. We don't want to have to make everyone
> update their BIOS/firmware to get to a starting level above 1.43 to begin
> with.
> 
> Ok, let me review/comment on the patch.

This was has a bug, and the reference to what Harald denoted
is missing. Hold on for v2. I'll put it out soon.

BR, Jarkko
