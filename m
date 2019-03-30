Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1542C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 15:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7317A2146F
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 15:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbfC3P3L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 11:29:11 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:55378 "EHLO ou.quest-ce.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730597AbfC3P3L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 11:29:11 -0400
X-Greylist: delayed 2259 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Mar 2019 11:29:10 EDT
Received: from [2a01:e35:39f2:1220:98ae:65aa:acef:50cb] (helo=test.quest-ce.net)
        by ou.quest-ce.net with esmtpsa (TLS1.1:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <ydroneaud@opteya.com>)
        id 1hAFKS-0000Qm-IY; Sat, 30 Mar 2019 15:51:28 +0100
Message-ID: <f335564e7de4bdaf93b05b2db2519ad273b31415.camel@opteya.com>
From:   Yann Droneaud <ydroneaud@opteya.com>
To:     Andi Kleen <andi@firstfloor.org>, linux-crypto@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, herbert@gondor.apana.org.au,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Sat, 30 Mar 2019 15:51:28 +0100
In-Reply-To: <20190330004629.29394-1-andi@firstfloor.org>
References: <20190330004629.29394-1-andi@firstfloor.org>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0 (3.32.0-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:39f2:1220:98ae:65aa:acef:50cb
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] crypto: Use ___cacheline_aligned for aes data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le vendredi 29 mars 2019 à 17:46 -0700, Andi Kleen a écrit :
> 
> Mark it ____cacheline_aligned to not place it in a special section,
> but just align it in .rodata
> 

Small typo: commit title seems to suggests there's only 3 underscore
('___cacheline_aligned') instead of 4.

Regards.

-- 
Yann Droneaud
OPTEYA


