Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A98BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbiKRTTC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241969AbiKRTTA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:19:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8D36457A
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A8BF626B2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C54C4347C;
        Fri, 18 Nov 2022 19:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668799138;
        bh=MpDNHR/DzsboY7rAaW2LUqmp104SU5eb+mdV2/4ZGoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSJLlAoSjCUOz+nAtP/U2QJd7oluxCHc7pZAQLjhTnr/KBi6t6qe9L54zSlS3/vlR
         cxl6FnLOejzGlB8Kc7Mvbwj+7FxXCm4ihhDR7QsDRJPJPkurP5jjdxVwdI70h8UueK
         oCiLmsV4YEBlsVeAxMZ5NJJsmDhTm8wcKWp3xu7LolyqPtsMIHgjSQ1NA53zb60Ki3
         b41qll3cHxxwgkjdT5DP9OsA82eRKfInetmyHMWrOj69+jJNE3PCReh8jkt96IpUbo
         VRJdlFYY9tRAC1OTyHKBjX3fXl6sR1NEhGWy8TaSL1wXFVAKvtLFsz+bjgIdXhTWe7
         wE5Yk6abedNHQ==
Date:   Fri, 18 Nov 2022 11:18:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 0/11] crypto: CFI fixes
Message-ID: <Y3faoM3CZNRlR/t2@sol.localdomain>
References: <20221118090220.398819-1-ebiggers@kernel.org>
 <MW5PR84MB18424C160896BF9081E8CFCAAB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <Y3fTvOKW1txyDOJE@sol.localdomain>
 <MW5PR84MB1842FB8323FED755045A48F4AB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB1842FB8323FED755045A48F4AB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 07:14:13PM +0000, Elliott, Robert (Servers) wrote:
> 
> > arch/x86/crypto/twofish_glue_3way.c:EXPORT_SYMBOL_GPL(__twofish_enc_blk_3w
> > ay);
> > 
> > No, that doesn't matter at all.  Whether a symbol is exported or not just
> > has to do with how the code is divided into modules.  It doesn't have
> > anything to do with indirect calls.
>  
> I thought that makes them available to external modules, and there is no
> control over how they use them.
> 

The upstream kernel doesn't support out of tree modules.  In the highly unlikely
event that someone wants to make these low-level implementation details
available to out of tree modules, they can just patch the kernel themselves.

- Eric
