Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863B6C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 20:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F9021BE5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 20:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbhADULj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:11:39 -0500
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21196 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbhADULj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 15:11:39 -0500
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2021 15:11:37 EST
ARC-Seal: i=1; a=rsa-sha256; t=1609790030; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=L5B51pqFVPdKmtgIe8HJqmcA03fKdvpJj1TKT9OdvwRHFhLZuZbPmUvXQ3uBAw5Ry82G7/2w6o8cdTn8TDUNVOJmS2A0TokH6TD8csDXmUMdxJHe+HBbRtf9OiBb7/7Y9dGB50p/RKdAJMA7ySBKZeIa1O2xu7hatF0xV3oiW1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1609790030; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=2fbRtgEInDpEAUjS1ursIgnvcc2gSmA0J8EHb9tBsiM=; 
        b=QzF9qUputxW5UxKMT1negaxmnSQalbSVMyD23GbdCaeuxiyr8goYNSNds3TwgmV5Qoj5TuNsU83oTgSziVw+hdx8ZeYCGasxpqUCQNV48jCasHiVC0GNKzb4V2zfIrK6KjzxV5imFaN8v6iW0suPApU+35uH8WUDmyFfuwADjsI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=philipp@uvos.xyz;
        dmarc=pass header.from=<philipp@uvos.xyz> header.from=<philipp@uvos.xyz>
Received: from localhost.localdomain (ip-95-222-213-78.hsi15.unitymediagroup.de [95.222.213.78]) by mx.zoho.eu
        with SMTPS id 1609790028899518.4887980385104; Mon, 4 Jan 2021 20:53:48 +0100 (CET)
Date:   Mon, 4 Jan 2021 20:53:48 +0100
From:   Carl Philipp Klemm <philipp@uvos.xyz>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, tony@atomide.com
Subject: [BISECTED REGRESSION] v5.10 stalles on assoication with a wpa2
 802.11 ap
Message-Id: <20210104205348.ba98a7a6c7dc905ba4c684c7@uvos.xyz>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Im on Motorola XT894 and Motorola XT875. The Devices contain a texas
instruments wl1285c and wl1271c wifi chip respectively and use the
wlcore wl12xx driver. Since v5.10 the first attempt at connecting to an
encrypted ap will stall the userspace tool performing the operation
(eg. wpa_supplicant) for about one minute and the association will
fail, in the mean time parts or all of userspace may end up hanging,
this appears to be most readly triggerd by running sudo while
wpa_supplicant is attempting the association. Subsiqent associations
may also end up stalling but do not allways do so and association will
eventually succeed.

I bisected this regession to the commit
00b99ad2bac256e3e4f10214c77fce6603afca26 "crypto: arm/aes-neonbs - Use
generic cbc encryption path", reverting this commit and
5f254dd440fbad0c00632f9ac7645f07d8df9229 "crypto: cbc - Remove cbc.h"
to allow the v5.10 tag to compile restores full functionality.

-- 
Carl Philipp Klemm <philipp@uvos.xyz> <carl@uvos.xyz>
