From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3] crypto: driver for tegra AES hardware
Date: Mon, 14 Nov 2011 10:42:12 -0800
Message-ID: <CAOesGMheE3r63O2ZijfKH1MNkxXnv_NBWkEtKTjXK5vXYKSDzg@mail.gmail.com>
References: <1321094567-16561-1-git-send-email-vwadekar@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805ABE@HQMAIL01.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Varun Wadekar <vwadekar@nvidia.com>,
	"Colin Cross (ccross@android.com)" <ccross@android.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Stephen Warren <swarren@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34538 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1KNSmO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Nov 2011 13:42:14 -0500
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805ABE@HQMAIL01.nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 14, 2011 at 9:32 AM, Stephen Warren <swarren@nvidia.com> wrote:
> vwadekar@nvidia.com wrote at Saturday, November 12, 2011 3:43 AM:
>> driver supports ecb/cbc/ofb/ansi_x9.31rng modes,
>> 128, 192 and 256-bit key sizes
>
> This will fail to build as a module unless your other patch "arm: tegra:
> export tegra_chip_uid" is also merged. You should mention this fact when
> posting the patch, below the --- line.
>
> I'll let Olof and the crypto maintainers comment on the solution they'd
> prefer for this, but perhaps it's: have one of the Tegra maintainers ack
> that other patch, then have the crypto maintainer merge both patches in
> order into the crypto tree.

Yeah, I'll ack it once I'm OK with it.

There will be other fuse.c changes for 3.3 but the conflict resolution
should be trivial if needed at all.


-Olof
