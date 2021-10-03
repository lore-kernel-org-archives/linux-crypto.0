Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0A7C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 01:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A02619E7
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 01:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhJCBor convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Oct 2021 21:44:47 -0400
Received: from vm1.rngh.net ([50.116.5.249]:60748 "EHLO mail.rngh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhJCBor (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Oct 2021 21:44:47 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Oct 2021 21:44:47 EDT
Received: from [192.168.1.107] (c-73-231-123-62.hsd1.ca.comcast.net [73.231.123.62])
        by mail.rngh.net (Postfix) with ESMTPSA id 6B93E3DB36;
        Sun,  3 Oct 2021 01:34:55 +0000 (UTC)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [Cryptography] [RFC] random: add new pseudorandom number generator
From:   Ron Garret <ron@flownet.com>
In-Reply-To: <378733E4-D976-4E2D-BE14-AD900C901CE8@callas.org>
Date:   Sat, 2 Oct 2021 18:34:54 -0700
Cc:     Sandy Harris <sandyinchina@gmail.com>, Ted Ts'o <tytso@mit.edu>,
        Cryptography <cryptography@metzdowd.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2DAE91DD-D16B-42B2-A34B-E405725048C2@flownet.com>
References: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com> <378733E4-D976-4E2D-BE14-AD900C901CE8@callas.org>
To:     Jon Callas <jon@callas.org>
X-Mailer: Apple Mail (2.1878.6)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Oct 2, 2021, at 5:08 PM, Jon Callas <jon@callas.org> wrote:

> 
> 
>> On Sep 16, 2021, at 20:18, Sandy Harris <sandyinchina@gmail.com> wrote:
>> 
>> I have a PRNG that I want to use within the Linux random(4) driver. It
>> looks remarkably strong to me, but analysis from others is needed.
> 
> A good block cipher in counter mode makes a pretty-okay PRNG. I say pretty-okay only because I would like my PRNG not to be invertible. Iterated hash functions are better.

Whatever you use you want to truncate the output, otherwise you won’t get repetitions, which you actually want from a good PRNG.

rg

