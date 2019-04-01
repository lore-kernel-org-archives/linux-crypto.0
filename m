Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F585C10F05
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 07:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0814420896
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 07:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732177AbfDAH6Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 03:58:25 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:51649 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbfDAH6Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 03:58:24 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2019 03:58:23 EDT
Received: from book (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 1862240752;
        Mon,  1 Apr 2019 09:52:37 +0200 (CEST)
Message-ID: <d06c26e2fd52c5a34e1fb6c9f98363e009e2671c.camel@strongswan.org>
Subject: Re: [RFC/RFT PATCH 01/18] crypto: x86/poly1305 - fix overflow
 during partial reduction
From:   Martin Willi <martin@strongswan.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 01 Apr 2019 09:52:53 +0200
In-Reply-To: <20190331200428.26597-2-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
         <20190331200428.26597-2-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

> The x86_64 implementation of Poly1305 produces the wrong result on
> some inputs because poly1305_4block_avx2() incorrectly assumes that
> when partially reducing the accumulator, the bits carried from limb
> 'd4' to limb 'h0' fit in a 32-bit integer.

> [...] This bug was originally detected by my patches that improve
> testmgr to fuzz algorithms against their generic implementation. 

Thanks Eric. This shows how valuable your continued work on the crypto
testing code is, and how useful such a (common) testing infrastructure
can be.

Reviewed-by: Martin Willi <martin@strongswan.org>

