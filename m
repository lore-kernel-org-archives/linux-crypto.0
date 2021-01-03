Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D33C433DB
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 10:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16699207D0
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 10:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbhACKRv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Jan 2021 05:17:51 -0500
Received: from fgw21-4.mail.saunalahti.fi ([62.142.5.108]:59890 "EHLO
        fgw21-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbhACKRv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Jan 2021 05:17:51 -0500
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2021 05:17:50 EST
Received: from toshiba (85-76-20-179-nat.elisa-mobile.fi [85.76.20.179])
        by fgw21.mail.saunalahti.fi (Halon) with ESMTP
        id 673993fd-4daa-11eb-9eb8-005056bdd08f;
        Sun, 03 Jan 2021 11:59:44 +0200 (EET)
Message-ID: <5FF1958C.A29E0278@users.sourceforge.net>
Date:   Sun, 03 Jan 2021 11:59:40 +0200
From:   Jari Ruusu <jariruusu@users.sourceforge.net>
MIME-Version: 1.0
To:     noloader@gmail.com
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Loss of performance in RDRAND and RDSEED?
References: <CAH8yC8knjfUR2S1NUhWWwBOovvCTWKQ1_MkowVSeRVPKfe-O4w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jeffrey Walton wrote:
> The hardware is the same, but the OS was upgraded from Fedora 32 to
> Fedora 33. The kernel and possibly intel-microcode have changed
> between May 2020 and January 2021.
> 
> I'm aware of this problem with AMD's RDRAND and RDSEED, but it doesn't
> affect Intel machines:
> https://bugzilla.kernel.org/show_bug.cgi?id=85911 (so there should not
> be any remediations in place).
> 
> My question is, is anyone aware of what may be responsible for the
> performance loss?

Intel messed up RDRAND security. Microcode fix to avoid data leak includes
getting exclusive lock on some processor internal bus or something like that.
That can be used as DoS tool: run those RDRAND instructions in tight loop,
and all code execution on that CPU does slows down significantly.

https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa-00320.html

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
