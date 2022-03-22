Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855FBC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 12:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiCVMaE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiCVMaD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 08:30:03 -0400
X-Greylist: delayed 573 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 05:28:33 PDT
Received: from mail.strongswan.org (sitav-80046.hsr.ch [152.96.80.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D656228;
        Tue, 22 Mar 2022 05:28:32 -0700 (PDT)
Received: from think (unknown [185.12.128.224])
        by mail.strongswan.org (Postfix) with ESMTPSA id E100B40AE5;
        Tue, 22 Mar 2022 13:18:57 +0100 (CET)
Message-ID: <6250f5f254f08bf767c052fbe0b5e281cafea2cc.camel@strongswan.org>
Subject: Re: [PATCH 1/2] x86/chacha20: Avoid spurious jumps to other
 functions
From:   Martin Willi <martin@strongswan.org>
To:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ebiggers@google.com, herbert@gondor.apana.org.au, Jason@zx2c4.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue, 22 Mar 2022 13:18:57 +0100
In-Reply-To: <20220322115125.737671717@infradead.org>
References: <20220322114809.381992456@infradead.org>
         <20220322115125.737671717@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> The chacha_Nblock_xor_avx512vl() functions all have their own,
> identical, .LdoneN label, however in one particular spot {2,4} jump
> to the 8 version instead of their own. [...]
> 
> Make each function consistently use its own done label.

Reviewed-by: Martin Willi <martin@strongswan.org>

