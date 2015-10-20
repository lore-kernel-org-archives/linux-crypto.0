From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2] crypto: add precalculated hash for zero message length
Date: Tue, 20 Oct 2015 09:33:56 +0200
Message-ID: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, davem@davemloft.net,
	geert+renesas@glider.be, herbert@gondor.apana.org.au,
	keescook@chromium.org, maxime.ripard@free-electrons.com,
	thomas.lendacky@amd.com, ulf.hansson@linaro.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36044 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbJTHeL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 03:34:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

Some crypto drivers cannot process empty data message and so rely on
precalculated hash.
This patch series add precalculated hash in headers and
make the drivers use them.

Using those precalculated hash make some additionnal constify patch necessary.

Changes since v1:
- Added missing sha/md5 header in testmgr.h
- indented a block comment in CCP
- moved precalculated hash from header to .c files

Regards
