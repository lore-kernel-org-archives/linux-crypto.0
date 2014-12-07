From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 25/25] crypto: ansi_cprng - If non-deterministic, don't buffer old output
Date: 7 Dec 2014 17:49:59 -0500
Message-ID: <20141207224959.25453.qmail@ns.horizon.com>
References: <6f29805d8bbde1af112d48201d5fde9a7776027f.1417951990.git.linux@horizon.com>
Cc: herbert@gondor.apana.org.au, smueller@chronox.de
To: linux-crypto@vger.kernel.org, linux@horizon.com,
	nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:57173 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753465AbaLGWuB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 17:50:01 -0500
In-Reply-To: <6f29805d8bbde1af112d48201d5fde9a7776027f.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

By the way, this patch includes a bug due to a last minute "oh, I can
make that more efficient!" which I realized after a night's sleep.
(The v1 patch worked, FWIW.)

Anyway, it's an RFC; I'm not even sure if I want this personally,
but it's a bit of extra paranoia to always genreate fresh seed per
read.
