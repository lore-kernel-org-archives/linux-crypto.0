From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [1/2] 2.6.22-rc2: known regressions with patches
Date: Sun, 20 May 2007 00:06:42 +0200
Message-ID: <464F74F2.8090207@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Bob Tracy <rct@gherkin.frus.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	Christian Volkmann <haveaniceday@cv-sv.de>,
	Sam Ravnborg <sam@ravnborg.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Luca Tettamanti <kronos.it@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:21902 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764807AbXESWHJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 May 2007 18:07:09 -0400
Received: by mu-out-0910.google.com with SMTP id w1so816738mue
        for <linux-crypto@vger.kernel.org>; Sat, 19 May 2007 15:07:08 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : 2.6.22-rc2: section mismatch
References : http://lkml.org/lkml/2007/5/19/59
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Sam Ravnborg <sam@ravnborg.org>
Status     : fixed in kbuild-git.git

Subject    : VIA C3_2 does only boot with M386/M486 kernel. Not with M586.../MVIAC3_2
References : http://lkml.org/lkml/2007/5/16/499
Submitter  : Christian Volkmann <haveaniceday@cv-sv.de>
Patch      : http://lkml.org/lkml/2007/5/16/499
Status     : different patches in thread.

Subject    : AMD k6-III/450 won't boot w/2.6.22-rc1
References : http://lkml.org/lkml/2007/5/16/192
Submitter  : Bob Tracy <rct@gherkin.frus.com>
Handled-By : Dave Jones <davej@codemonkey.org.uk>
Patch      : http://lkml.org/lkml/2007/5/17/122
Status     : patch available



Cryptography

Subject    : cryptomgr oops
References : http://lkml.org/lkml/2007/5/14/283
Submitter  : Luca Tettamanti <kronos.it@gmail.com>
Handled-By : Herbert Xu <herbert@gondor.apana.org.au>
Patch      : http://lkml.org/lkml/2007/5/19/3
Status     : patch available



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
