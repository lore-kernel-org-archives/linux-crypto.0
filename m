From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 00/10] crypto/des_generic: Code cleanups
Date: Sun, 08 Feb 2009 06:50:07 -0500
Message-ID: <20090208115007.4117.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:12008 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752477AbZBHL4s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:56:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These are a bunch of code cleanups I worked out a couple of years ago,
split up into least publishable units.  They're logically independent,
although some overlap so will take some fixing to apply without the
earlier ones.
