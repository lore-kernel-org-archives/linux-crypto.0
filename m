Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FEFC10F05
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 08:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 522C3214C6
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 08:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731833AbfDAIDX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:03:23 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:51711 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfDAIDX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 04:03:23 -0400
Received: from book (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 20681419C9;
        Mon,  1 Apr 2019 09:56:59 +0200 (CEST)
Message-ID: <580b51283b9f16f0ae378a892e2d1016a0a65d45.camel@strongswan.org>
Subject: Re: [RFC/RFT PATCH 06/18] crypto: chacha20poly1305 - set cra_name
 correctly
From:   Martin Willi <martin@strongswan.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Mon, 01 Apr 2019 09:57:16 +0200
In-Reply-To: <20190331200428.26597-7-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
         <20190331200428.26597-7-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> If the rfc7539 template is instantiated with specific
> implementations, e.g. "rfc7539(chacha20-generic,poly1305-generic)"
> rather than "rfc7539(chacha20,poly1305)", then the implementation
> names end up included in the instance's cra_name.  This is incorrect
> [...]

Reviewed-by: Martin Willi <martin@strongswan.org>

Thanks,
Martin

