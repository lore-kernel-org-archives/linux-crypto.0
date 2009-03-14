From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: enable padlock on x86_64
Date: Sat, 14 Mar 2009 12:24:01 +0100
Message-ID: <1237029843-28076-1-git-send-email-sebastian@breakpoint.cc>
References: <49B83002.9040705@tobiasvolk.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	mail@tobiasvolk.de
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60023 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbZCNLYI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Mar 2009 07:24:08 -0400
In-Reply-To: <49B83002.9040705@tobiasvolk.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To enable the padlock unit, two msr bits have to flipped. This is allready
done in the 32bit path and is missing in the other. Instead of copy paste
the code, I merged the 64bit part into the 32bit part. The things that
changed during the merge:
- the fixups from x86_64 (family 6, model >= 15) were not present in 32bit
  path but are now. They might be usefull if this CPU is booted in 32bit
  mode.
- the fixups which are executed via ->c_early_init() are now executed
  again via ->c_init(). This was done in the 64bit path and without this I
  lost the constant_tsc flag. However, tsc is not useable due to
| [    2.023006] Marking TSC unstable due to TSC halts in idle
| [    2.500082] Clocksource tsc unstable (delta = -326436711 ns)

The two patches are against the current tip tree. A version of patch 1
against current -rc8 is available at [0].

[0] http://download.breakpoint.cc/0001-x86-centaur-merge-32-64-bit-version.patch

Sebastian
