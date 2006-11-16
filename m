From: linux@horizon.com
Subject: Re: crypto/des.c cleanups for review
Date: 16 Nov 2006 05:13:40 -0500
Message-ID: <20061116101340.9296.qmail@science.horizon.com>
References: <20061116070516.31107.qmail@science.horizon.com>
Cc: herbert@gondor.apana.org.au, linux@horizon.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:54317 "HELO
	science.horizon.com") by vger.kernel.org with SMTP id S1422935AbWKPKNl
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Nov 2006 05:13:41 -0500
To: linux-crypto@vger.kernel.org
In-Reply-To: <20061116070516.31107.qmail@science.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Minor update to the preceding;

Somehow, I managed to misplace a semicolon after "B >>= 8" in the ROUND
macro, which prevents the patch I posted from compiling.  With that
obvious fix, I just verified that it passes the NBS Special Publication
500-20 test vectors.  (Single-DES and triple-DES with 3 identical keys.)

Sorry about that.
