Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CD3C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 00:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbiBSAyo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 19:54:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240641AbiBSAye (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 19:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB7F27792B
        for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2022 16:54:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF4B8B82764
        for <linux-crypto@vger.kernel.org>; Sat, 19 Feb 2022 00:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178BAC340ED;
        Sat, 19 Feb 2022 00:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645232054;
        bh=o4V+SgoVVVDHAsLHw06x53cm5Mf2URwbscepLNprQm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hchYl3a7A04OP3TCtC0kUYAvSNFTvVycRXIzFOsPhXEfc6Ab9rODywKnXQrF55Dm+
         ziV4s7gPesway+6g0dDiZmkFME2pXcAsZaX8A1Ef8vUF7bA2FSXxLuQ1QFUk/ftR3p
         hEEReo/TmmU8Exysgt6nGdn8FQ+yldOTLoon/5CjQHC3ulItzDrp2vBvF64Vz/X9lv
         x1D956MEkpBQpeXlcMGhScauh/Q+jO8Lh8B1EhVrTWT8rUYagwwR0cEweqL3XWGN91
         K/gVVBRQcpNFYuM0VwJ2P+cdkJNJp+vAEvKM9BGXsznTLLu02k6EuTqhHrukVWg0VK
         4uBv2TJlY5UAw==
Date:   Fri, 18 Feb 2022 16:54:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v2 6/7] crypto: x86/polyval: Add PCLMULQDQ
 accelerated implementation of POLYVAL
Message-ID: <YhA/tAaDi/3e35Q1@sol.localdomain>
References: <20220210232812.798387-1-nhuck@google.com>
 <20220210232812.798387-7-nhuck@google.com>
 <YhA7Ej8UfyCwkTNa@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhA7Ej8UfyCwkTNa@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 18, 2022 at 04:34:28PM -0800, Eric Biggers wrote:
> > +.macro schoolbook1_iteration i xor_sum
> > +	.set i, \i
> > +	.set xor_sum, \xor_sum
> > +	movups (16*i)(OP1), %xmm0
> > +	.if(i == 0 && xor_sum == 1)
> > +		pxor SUM, %xmm0
> > +	.endif
> > +	vpclmulqdq $0x01, (16*i)(OP2), %xmm0, %xmm1
> > +	vpxor %xmm1, MI, MI
> > +	vpclmulqdq $0x00, (16*i)(OP2), %xmm0, %xmm2
> > +	vpxor %xmm2, LO, LO
> > +	vpclmulqdq $0x11, (16*i)(OP2), %xmm0, %xmm3
> > +	vpxor %xmm3, HI, HI
> > +	vpclmulqdq $0x10, (16*i)(OP2), %xmm0, %xmm4
> > +	vpxor %xmm4, MI, MI
> 
> Perhaps the above multiplications and XORs should be reordered slightly so that
> each XOR doesn't depend on the previous instruction?  A good ordering might be:
> 
> 	vpclmulqdq $0x01, (16*\i)(OP2), %xmm0, %xmm1
> 	vpclmulqdq $0x10, (16*\i)(OP2), %xmm0, %xmm2
> 	vpclmulqdq $0x00, (16*\i)(OP2), %xmm0, %xmm3
> 	vpclmulqdq $0x11, (16*\i)(OP2), %xmm0, %xmm4
> 	vpxor %xmm1, MI, MI
> 	vpxor %xmm3, LO, LO
> 	vpxor %xmm4, HI, HI
> 	vpxor %xmm2, MI, MI
> 
> With that, no instruction would depend on either of the previous two
> instructions.
> 
> This might be more important in the ARM64 version than the x86_64 version, as
> x86_64 CPUs are pretty aggressive about internally reordering instructions.  But
> it's something to consider in both versions.
> 
> Likewise in schoolbook1_noload.

Or slightly better:

        vpclmulqdq $0x01, (16*\i)(OP2), %xmm0, %xmm2
        vpclmulqdq $0x00, (16*\i)(OP2), %xmm0, %xmm1
        vpclmulqdq $0x10, (16*\i)(OP2), %xmm0, %xmm3
        vpclmulqdq $0x11, (16*\i)(OP2), %xmm0, %xmm4
        vpxor %xmm2, MI, MI
        vpxor %xmm1, LO, LO
        vpxor %xmm4, HI, HI
        vpxor %xmm3, MI, MI

- Eric
