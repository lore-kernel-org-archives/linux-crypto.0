From: Joe Perches <joe@perches.com>
Subject: drivers/crypto/picoxcell_crypto.c: boolean and / or confusion
Date: Mon, 12 Dec 2011 15:44:53 -0800
Message-ID: <1323733493.1812.10.camel@joe2Laptop>
References: <4EE688FC.8090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: roel <roel.kluin@gmail.com>, Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52311 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023Ab1LLXo4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 18:44:56 -0500
In-Reply-To: <4EE688FC.8090606@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
> The test not [val1] or not [val2] always evaluates to true

Hey Jamie and Roel

Looking at drivers with:

$ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\|\|\s*\1\s*\!\=" drivers

drivers/crypto/picoxcell_crypto.c:	if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&
drivers/crypto/picoxcell_crypto.c:	} else if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&

Most likely these should be && not ||.
