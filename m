Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9148BC10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 14:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A70E2084F
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 14:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfDIODB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:03:01 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:53596 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbfDIODB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 10:03:01 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2C27972CC61;
        Tue,  9 Apr 2019 17:02:59 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 10F584A4A2A;
        Tue,  9 Apr 2019 17:02:59 +0300 (MSK)
Date:   Tue, 9 Apr 2019 17:02:58 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] crypto: add EC-RDSA (GOST 34.10) algorithm
Message-ID: <20190409140258.edqnpzr3ghuq5p7g@altlinux.org>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190408160516.wvpcnvrmask56b2g@altlinux.org>
 <20190409061756.iyja4535fsu7xrqo@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190409061756.iyja4535fsu7xrqo@gondor.apana.org.au>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Tue, Apr 09, 2019 at 02:17:56PM +0800, Herbert Xu wrote:
> On Mon, Apr 08, 2019 at 07:05:16PM +0300, Vitaly Chikunov wrote:
> > Herbert,
> > 
> > On Tue, Mar 26, 2019 at 03:58:32PM +0300, Vitaly Chikunov wrote:
> > > This patchset changes akcipher API to support ECDSA style signature
> > > verification, augments x509 parser to make it work with EC-RDSA certificates,
> > > and, finally, implements EC-RDSA (GOST 34.10) signature verification and its
> > > integration with IMA.
> > 
> > Can you please explain what changes are requested?
> 
> Please see
> 
> https://patchwork.kernel.org/patch/10870987/

Ah, thanks. I somehow mixed it up with other tagged patch.

Vitaly,

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
