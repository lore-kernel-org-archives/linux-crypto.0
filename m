Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550C6C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 06:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33A956102A
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 06:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbhICGQ1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Sep 2021 02:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhICGQ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Sep 2021 02:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E117F6102A;
        Fri,  3 Sep 2021 06:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630649727;
        bh=aPXE9le7LhtzTxSD68JNBjcrtI6anL9T4lJuDtzffFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QOMdDzatejgXZ1y1bY+YSAR2LNfwqV1506HLbBhYV3xTTxVaXcmzpVmLnwqa3sfn8
         EXelluFfjx34DYIjHk3tJlk7kKPxHbxRsbUDbgJXgaFPIhZMvzllbJRv9Sn8P7bg0k
         z+kUXlH242VZt0S1e0gAbLYiQm91MHp/icK14H8k=
Date:   Fri, 3 Sep 2021 08:15:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Subject: Re: memset() in crypto code
Message-ID: <YTG9fAQTha7ZP/kh@kroah.com>
References: <CACXcFmnOeHwuu4N=WiGrMB+NNgGer9oCLoG0JAORN03gv1y+HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmnOeHwuu4N=WiGrMB+NNgGer9oCLoG0JAORN03gv1y+HQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 03, 2021 at 09:13:43AM +0800, Sandy Harris wrote:
> Doing this the crypto directory:
> grep memset *.c | wc -l
> I get 137 results.
> 
> The compiler may optimise memset() away, subverting the intent of
> these operations. We have memzero_explicit() to avoid that problem.
> 
> Should most or all those memset() calls be replaced?

The ones that are determined to actually need this, sure, but a simple
grep like that does not actually show that.  You need to read the code
itself to determine the need or not, please do so.

good luck!

greg k-h
