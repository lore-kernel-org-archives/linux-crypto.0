From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [1/3] 2.6.22-rc1: known regressions v2
Date: Wed, 16 May 2007 22:31:30 +0200
Message-ID: <464B6A22.905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Bob Tracy <rct@gherkin.frus.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
	Ray Lee <ray-lk@madrabbit.org>, alsa-devel@alsa-project.org,
	"Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@suse.cz>,
	Pete Clements <clem@clem.clem-digital.net>,
	Rene Herman <rene.herman@gmail.com>, viro@zeniv.linux.org.uk,
	Uwe Bugla <uwe.bugla@gmx.de>, linux-crypto@vger.kernel.org,
	Luca Tettamanti <kronos.it@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:18101 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763334AbXEPUb6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 May 2007 16:31:58 -0400
Received: by ug-out-1314.google.com with SMTP id 44so193388uga
        for <linux-crypto@vger.kernel.org>; Wed, 16 May 2007 13:31:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : AMD k6-III/450 won't boot w/2.6.22-rc1
References : http://lkml.org/lkml/2007/5/16/192
Submitter  : Bob Tracy <rct@gherkin.frus.com>
Handled-By : Dave Jones <davej@codemonkey.org.uk>
Status     : problem is being debugged



ACPI

Subject    : nx6125 has lost fan control
References : http://lkml.org/lkml/2007/5/16/249
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Status     : Unknown



ALSA

Subject    : lost snd_4236 device
References : http://lkml.org/lkml/2007/5/13/87
Submitter  : Pete Clements <clem@clem.clem-digital.net>
Handled-By : Rene Herman <rene.herman@gmail.com>
Patch      : http://lkml.org/lkml/2007/5/15/23
Status     : patch available



Block devices

Subject    : loop devices limited to one single device
References : http://lkml.org/lkml/2007/5/16/229
Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
Status     : Unknown



Cryptography

Subject    : cryptomgr oops
References : http://lkml.org/lkml/2007/5/14/283
Submitter  : Luca Tettamanti <kronos.it@gmail.com>
Handled-By : Herbert Xu <herbert@gondor.apana.org.au>
Status     : problem is being debugged



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
