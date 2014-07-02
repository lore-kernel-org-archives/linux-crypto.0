From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Testing the PRNG driver of the Allwinner Security System A20
Date: Wed, 2 Jul 2014 19:06:40 -0400
Message-ID: <CACXcFmmSWP1MAAzX0A1jVoCNdex9EoJ50S9zdDgf-WuiwjSA5w@mail.gmail.com>
References: <53B297FA.4050106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Corentin LABBE <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36520 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGBXGl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Jul 2014 19:06:41 -0400
Received: by mail-ve0-f173.google.com with SMTP id db11so12057474veb.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2014 16:06:41 -0700 (PDT)
In-Reply-To: <53B297FA.4050106@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 1, 2014 at 7:14 AM, Corentin LABBE
<clabbe.montjoie@gmail.com> wrote:

> I am writing the PRNG driver for the Allwinner Security System SoC A20.

The datasheet my search turned up (v1, Feb. 2013) just says:  "160-bit
hardware PRNG with 192-bit seed" and gives no other details. Do you
have more info, perhaps from a more recent version or talking to the
company?

> I didn't know how to test it, so ...

Unless you have much more info, I see no point in enabling it or
writing a driver. You need a true hardware RNG to seed it, so you need
random(4) /dev/random anyway and can just use /dev/urandom for PRNG
requirements.

Using this device might have an advantage if it is much faster or less
resource-hungry than urandom, but I see nothing in its documentation
that indicates it is. Anyway, do your applications need that? And, if
so, would an application-specific PRNG be better yet?

Then there is the crucial question of trusting the device. Kerckhoff's Principle
(http://en.citizendium.org/wiki/Kerckhoffs%27_Principle)
has been a maxim for cryptographers since the 19th century; no-one
should even consider trusting it until full design details are made
public and reviewed.

Even then, there might be serious doubts, since hardware can be very
subtly sabotaged and an RNG is a tempting target for an intelligence
agency.
(http://arstechnica.com/security/2013/09/researchers-can-slip-an-undetectable-trojan-into-intels-ivy-bridge-cpus/)
That article discusses Intel and the NSA, but similar worries apply
elsewhere. Allwinner is a fabless company, so you also need to worry
about whatever fab they use.
