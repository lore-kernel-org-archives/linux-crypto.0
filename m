From: Stephan Mueller <smueller@chronox.de>
Subject: [RFC] DRBG: which shall be default?
Date: Tue, 31 May 2016 13:23:21 +0200
Message-ID: <1972759.dI50hI8gdY@tauon.atsec.com>
References: <1664837.3VbqQRUZed@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35210 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbcEaLXY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 07:23:24 -0400
In-Reply-To: <1664837.3VbqQRUZed@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

with that patch, the CTR DRBG is the fasted DRBG by orders of magnitude -- 
about 2 times faster than the HMAC DRBG (current default) and 1.5 times faster 
than the Hash DRBG.

However, I am not too fond of the CTR DRBG due to the following that I already 
mentioned some days ago. Quote:

"""
the DF/BCC function in the DRBG is critical as I think it looses entropy 
IMHO. When you seed the DRBG with, say 256 or 384 bits of data, the BCC acts 
akin a MAC by taking the 256 or 384 bits and collapse it into one AES block of 
128 bits. Then he DF function expands this one block into the DRBG internal 
state including the AES key of 256 / 384 bits depending on the type of AES you 
use. So, if you have 256 bits of entropy in the seed, you have 128 bits left 
after the BCC operation.
"""


The current default of the HMAC DRBG is the leanest and cleanest, but it is 
also the slowest.

The fastest DRBG is the one that has the most complex state maintenance and I 
do not like parts of it.


Hence my question: shall we leave the HMAC DRBG as default or shall we use the 
CTR DRBG as default?

Ciao
Stephan
