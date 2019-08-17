Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3682EC3A59B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 09:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1FB21019
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 09:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="QIwjNCsT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfHQJQu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 05:16:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48730 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfHQJQu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 05:16:50 -0400
Received: from zn.tnic (p200300EC2F1E0200B954753091D6D12E.dip0.t-ipconnect.de [IPv6:2003:ec:2f1e:200:b954:7530:91d6:d12e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2B1AC1EC02C1;
        Sat, 17 Aug 2019 11:16:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1566033409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=aQO+j6px4sGqBWVzWdx+8ivnoSbLuI/Sig3yf3nbQqk=;
        b=QIwjNCsTWdsUQJ2Uef7tZo1rIRMmU9VyeGuiH7GnvS0D7jZ0w/xCbsRqQXpRTEcKmT4EHA
        0VRMGkX3khQroDGKsgTxblzRlswemeDvrmz7Fbjf6AM7CqhyiV16AfZFIeD+Dfv1dzpeX0
        FIa2dtEQuHuf9pB7ywdrPXD9b46tVgk=
Date:   Sat, 17 Aug 2019 11:17:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8 06/28] x86/asm/crypto: annotate local functions
Message-ID: <20190817091733.GB15364@zn.tnic>
References: <20190808103854.6192-1-jslaby@suse.cz>
 <20190808103854.6192-7-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190808103854.6192-7-jslaby@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 08, 2019 at 12:38:32PM +0200, Jiri Slaby wrote:
> Use the newly added SYM_FUNC_START_LOCAL to annotate starts of all
> functions which do not have ".globl" annotation, but their ends are
> annotated by ENDPROC. This is needed to balance ENDPROC for tools that
> generate debuginfo.
> 
> To be symmetric, we also convert their ENDPROCs to the new SYM_FUNC_END.

All those functions look like they could be made local symbols by
prepending their names with ".L" so that they disappear from the
vmlinux symtable too.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
