Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F2DC4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 21:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37B4F2333C
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 21:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgLSVbj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Dec 2020 16:31:39 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:33032 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgLSVbj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Dec 2020 16:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1608413326;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=bN5Bo5Xp6bbNWNfibLEW05ERysjkshF+M+r+x5jX+R8=;
        b=tIt9lphuFTJZmG5WEKR5KBegJuL6sXsKIKe1CWbHEp+l59qped/TVmHAicWb7MsbGJ
        qAVJyHBDSm7R+cpw3YFxatH6Qkv9AanrDX5QXHQoH6F1MbGEz7JhFdDVsGa0RbyjAhvO
        0bLLtsxXJ0of+BfCro7VlN4hWFIKostbgjCM9bx8IqX6teIaa4Pi8NfwF+AuaKXEN3CW
        MZUDyGxDMP7NqCJydBTNBrFC5MVaAg8iqqtas0HoLToNPvCnCxBzvJ5KcEtK1OZyaqAH
        musOid5kd7dW3DRm/HCiC0eGRrcQI/yF+iCs2sUVU/vvE2p2mOqjFpPlrVRT4h4t6E82
        6Uew==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJPSfbd7O"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.9.3 DYNA|AUTH)
        with ESMTPSA id z0431awBJLPX8J1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 19 Dec 2020 22:25:33 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     yumeng <yumeng18@huawei.com>
Cc:     linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] crypto: hisilicon/hpre - add 'ECDH' algorithm
Date:   Sat, 19 Dec 2020 22:25:32 +0100
Message-ID: <4588284.GXAFRqVoOG@positron.chronox.de>
In-Reply-To: <06fa1f72-fad8-a3e5-987a-d322918ac30a@huawei.com>
References: <13db294664a6b2e26a892dd544c714d3e385b0cc.camel@chronox.de> <b38e3b40ef198166bff193940b8c82c41db6f13c.camel@chronox.de> <06fa1f72-fad8-a3e5-987a-d322918ac30a@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 17. Dezember 2020, 04:07:30 CET schrieb yumeng:

Hi yumeng,

> 
> I see in "SEC 2: Recommended Elliptic Curve Domain ParametersVersion2.0"
> that 'Recommend Elliptic Curve Domain Parameters over Fp' are secp192,
> secp224, secp256, secp384, and secp521, secp128 and secp320 are not
> recommended.
> So you mean it's better not to include secp128 and secp320, right?

Precisely because I do not see the use case in the kernel.
> 
> Thanks,


Ciao
Stephan


