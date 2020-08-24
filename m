Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901B1C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 15:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 478BA20738
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 15:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="lwOG3IGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgHXPae (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:30:34 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:13501 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgHXPaa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 11:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1598283019;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=/yMlEPzuPqgye73MfE9Zc71sZL5jO9wYOUpSwiehvFM=;
        b=lwOG3IGDalubdLMGpyp6HPdmazPHGAoNObRU3Q20NjlBRG3RC8cFGJr3VqfLmeWXx3
        aMiNvNnluupXsBm2CE80dkKcL9KdFg09uN7t74RVTpcnXUMC7TZNINxPTCADsJ7mECtO
        UDphnj9y9JPwFSFu/C04ibEI60Q6vVAaLsoBobLWwBpXf+00vKqT5B318gL5APnXzKFH
        FX4cKRJ9jX1XAE7qDbDx52L5yHc2KPvJRNoJbA2/0qbI9nJ0qQkLiKKgpi6TsCqV3A/g
        oPVmvp42e/QNN4AlDFwXwykZmP9wUJnlmKWFPQ+v/NPwQJ4NDnNOd9gMMm8TDkvmeznN
        mxYQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXPSI/Sc5clZ"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.7 DYNA|AUTH)
        with ESMTPSA id 002e9aw7OFUHWer
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 24 Aug 2020 17:30:17 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Subject: Re: HMAC test fails for big key using libkcapi
Date:   Mon, 24 Aug 2020 17:30:16 +0200
Message-ID: <6448041.Y6S9NjorxK@tauon.chronox.de>
In-Reply-To: <TU4PR8401MB12164EFE831D43A41DDC8EA1F6560@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB12164EFE831D43A41DDC8EA1F6560@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 24. August 2020, 16:41:13 CEST schrieb Bhat, Jayalakshmi Manjunath:

Hi Jayalakshmi,

> Hi All,
> 
> I am using libkcapi to execute HMAC tests. One of key size is 229248 bytes. 
> setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY API fails to set the key. I am not
> getting an option to set the buffer size to higher value.
> 
> Can you please provide me inputs on how to set the higher buffer size to
> socket?

Update your network write buffer size?

/proc/sys/net/core/wmem_default
> 
> Regards,
> Jayalakshmi


Ciao
Stephan


