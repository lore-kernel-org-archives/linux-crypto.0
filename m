From: Stephen Warren <swarren@nvidia.com>
Subject: RE: [PATCH v1] arm: tegra: export tegra_chip_uid
Date: Tue, 15 Nov 2011 08:28:19 -0800
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805D45@HQMAIL01.nvidia.com>
References: <1321330772-2750-1-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "heinold@inf.fu-berlin.de" <heinold@inf.fu-berlin.de>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Varun Wadekar <vwadekar@nvidia.com>,
	"olof@lixom.net" <olof@lixom.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18179 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab1KOQ21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Nov 2011 11:28:27 -0500
In-Reply-To: <1321330772-2750-1-git-send-email-vwadekar@nvidia.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Varun Wadekar wrote at Monday, November 14, 2011 9:20 PM:
> The crypto driver will need this api to use
> it in the RNG calculations. In order to build
> the crypto driver as a module, tegra_chip_uid
> has to be exported.
> 
> Original author: Henning Heinold <heinold@inf.fu-berlin.de>

You should drop that line from the patch description, and fix the git
author field for the commit so that it reflects that Henning wrote this.

If this commit is HEAD, you'd run:

git commit --amend --author='Henning Heinold <heinold@inf.fu-berlin.de>'

If the commit isn't HEAD, you'll need to run "git rebase -i X", choose
"edit" for this commit, then run the "git commit --amend" command above
once you're at this commit. Finally, run "git rebase --continue". "X" in
the above command is the commit ID immediately preceding this current
commit in your git history.

Second, this patch is really part of a 2-patch series beginning with this
patch, and ending with the Tegra AES driver implementation. You should
generate and email out the two patches together, and to the same set of
people, so it's clear they're related. That way, they'll typically always
be applied in sequence to the same git tree. Mail me internally if you
need help with this.

(BTW, Colin Cross is also a Tegra maintainer. He should be CC'd on Tegra
patches too; see the output from scripts/get_maintainer.pl as a guide)

My inclination is that you'll need to repost to fix at least the git
author field, but I'd probably wait a little to see if there's any further
feedback on the AES driver first.

-- 
nvpublic
