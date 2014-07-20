From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Sun, 20 Jul 2014 19:27:42 +0200
Message-ID: <87tx6cvt2p.fsf@igel.home>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:60399 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaGTR1t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jul 2014 13:27:49 -0400
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Thu, 17 Jul 2014 05:18:15 -0400")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> ERRORS
> 	EINVAL		The buflen value was invalid.

Also on unknown flags?  Without that it would be impossible to probe for
implemented flags.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
