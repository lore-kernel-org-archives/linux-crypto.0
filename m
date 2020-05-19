Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TRACKER_ID autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24C2C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 15:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3782207FB
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 15:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="MaSBA8jd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgESPbo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgESPbn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 11:31:43 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC5EC08C5C0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 08:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589902301;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=ucRXuMNPg1y+q2yEinn9r7vZjs+gASLXv9qV2kb3ESg=;
        b=MaSBA8jdc5NoXAuXMg59WQKyXBBKXRvxrd20UYFD7jZtDPdCxnb5/6EFShkbcs574j
        CcfJjjmH212zWBY+Ofemh01CUZbSq4tbuENkX7ZEDU4Tu6TR23uc5nS9W1nDPSfe0x4z
        la+1Z7aaJ50XwRv8afK//h8iXuYYwzRhhGXTpyW6qmjUqUPHzrCVUWzbPLSlTZiOARFC
        B/S4+SwJMaqOs/OAwsTkEr+IqX7QF3PM3nKJ7tW26bRSv0VWm8zN33vpugWBCxde5qZ1
        2scWZWNI0rQrVMMrBGWm6PtK4EzjUikBjXg4X7FlEYBEL1ZbPmk5TqXgXbsXVgvUzzin
        DUYw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4JFVf0Wk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 19 May 2020 17:31:41 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     ard.biesheuvel@linaro.org
Cc:     linux-crypto@vger.kernel.org
Subject: ARM CE: CTS IV handling
Date:   Tue, 19 May 2020 17:31:41 +0200
Message-ID: <4311723.JCXmkh6OgN@tauon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

The following report applies to kernel 5.3 as I am currently unable to test 
the latest upstream version.

The CTS IV handling for cts-cbc-aes-ce and cts-cbc-aes-neon is not consistent 
with the C implementation for CTS such as cts(cbc-aes-ce) and cts(cbc-aes-
neon).

For example, assume encryption operation with the following data:

iv "6CDD928D19C56A2255D1EC16CAA2CCCB"
pt 
"2D6BFE335F45EED1C3C404CAA5CA4D41FF2B8C6DE94C706B10F1D207972DE6599C92E117E3CBF61F"
key "930E9D4E65DB121E05F11A16E408AE82"

When you perform one encryption operation, all 4 ciphes return:

022edfa38975b09b295e1958efde2104be1e8e70c81340adfbdf431d5c80e77b89df5997aa96af72

Now, when you leave the TFM untouched (i.e. retain the IV state) and simply 
set the following new pt: 

6cdd928d19c56a2255d1ec16caa2cccb022edfa38975b09b295e1958efde2104be1e8e70c81340ad

the C CTS implementations return

35d54eb425afe7438c5e96b61b061f04df85a322942210568c20a5e78856c79c0af021f3e0650863

But the cts-cbc-aes-ce and cts-cbc-aes-neon return

a62f57efbe9d815aaf1b6c62f78a31da8ef46e5d401eaf48c261bcf889e6910abbc65c2bf26add9f


My hunch is that the internal IV handling is different. I am aware that CTS 
does not exactly specify how the IV should look like after the encryption 
operation, but using the NIST reference implementation of ACVP, the C CTS 
implementation is considered to be OK whereas the ARM CE assembler 
implementation is considered to be not OK.

Bottom line, feeding plaintext in chunks into the ARM CE assembler 
implementation will yield a different output than the C implementation.

Ciao
Stephan



