Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D69C433E5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DADE20B1F
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgGWH6f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 03:58:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34770 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgGWH6e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 03:58:34 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyW7a-00061b-QG; Thu, 23 Jul 2020 17:58:31 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Jul 2020 17:58:30 +1000
Date:   Thu, 23 Jul 2020 17:58:30 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] crypto: x86 - Put back integer parts of
 include/asm/inst.h
Message-ID: <20200723075830.GI14246@gondor.apana.org.au>
References: <20200720135157.4332-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720135157.4332-1-ubizjak@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 20, 2020 at 03:51:57PM +0200, Uros Bizjak wrote:
> Resolves conflict with the tip tree.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>,
> CC: "Chang S. Bae" <chang.seok.bae@intel.com>,
> CC: Peter Zijlstra <peterz@infradead.org>,
> CC: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/include/asm/inst.h | 148 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 148 insertions(+)
>  create mode 100644 arch/x86/include/asm/inst.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
