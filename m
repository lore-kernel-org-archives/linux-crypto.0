From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Re: blowfish from openSSL to kernel cryptoAPI
Date: Tue, 03 May 2011 17:48:13 +0300
Message-ID: <4DC015AD.BA46DC3F@users.sourceforge.net>
References: <ipnbl5$ug4$1@dough.gmane.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Tzvi Chumash <tzvi@research.att.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:52514 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1ECOsS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2011 10:48:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tzvi Chumash wrote:
> I'm trying (without much success) to decrypt in-kernel
> (2.6.18-194.el5PAE) a cipher that was created using openSSL
> (0.9.8e-fips-rhel5) using blowfish with a 56-byte key/8-byte iv. Are the
> implementations incompatible (i.e. can't encrypt in one and decrypt in
> the other?) or am I doing something wrong?

Check byte order of the two implementations. Many blowfish implementations
got byte order wrong. Does it help if you swap byte order from
0-1-2-3-4-5-6-7 to 7-6-5-4-3-2-1-0 of key/data/IV before and after crypto
operation?

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
