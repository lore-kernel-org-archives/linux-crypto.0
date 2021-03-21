Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBDEC433C1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 17:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171E761931
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 17:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhCUReo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Mar 2021 13:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhCUReV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Mar 2021 13:34:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CB0C061574;
        Sun, 21 Mar 2021 10:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:References:
        Message-ID:In-Reply-To:Subject:cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b6kxlAh3fIabeLvigmFVk68R8rwvjb2NK7Orm1rRGAo=; b=zoso+9PaOZXk0kOw2FuTs66wdp
        6ZCwzxl4MbPIgWQNj2SM8rozWv5lm+S1GMySmBVrt3b01r9s335TsV8OW/OsXJi8UV6j6PUHUWDwS
        Qw7UVEJstdbnuL++Qz2UpOfUc8m6D6bjSGE4S/MeUMcEMLj/NrrUbwPPzjKRVcln74+eAh+C5kY9j
        r0sOQqvDKR2rkyhueQH9QgNAQTPCjp3xzMUWSsdVY7SqYdU5pEOB8jJx0pY86V4MrIuIpjtZFBW2f
        8H5cgzZw9b9x83VRXdYwwyIFNiexRHx5KyPuRG1EwLkHIG9xM7b9AdewQTr2fSlzE6gVNlCPNo6Dl
        ktoLcXGQ==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lO1xw-002QSK-VC; Sun, 21 Mar 2021 17:34:17 +0000
Date:   Sun, 21 Mar 2021 10:34:16 -0700 (PDT)
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Aditya Srivastava <yashsri421@gmail.com>
cc:     linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com,
        corbet@lwn.net, linux-kernel-mentees@lists.linuxfoundation.org,
        leitao@debian.org, nayna@linux.ibm.com, pfsmorigo@gmail.com,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: nx: fix incorrect kernel-doc comment syntax in
 files
In-Reply-To: <20210321123007.15505-1-yashsri421@gmail.com>
Message-ID: <84443584-2cbf-5945-2b6-b7a057a72540@infradead.org>
References: <20210321123007.15505-1-yashsri421@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210321_103417_013224_F9F210D0 
X-CRM114-Status: UNSURE (   1.45  )
X-CRM114-Notice: Please train this message.
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Looks good. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


