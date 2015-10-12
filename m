From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: add precalculated hash for zero message length
Date: Mon, 12 Oct 2015 18:53:38 +0200
Message-ID: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	thomas.lendacky@amd.com, geert+renesas@glider.be,
	ulf.hansson@linaro.org, wsa@the-dreams.de, keescook@chromium.org,
	maxime.ripard@free-electrons.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37626 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbbJLQxy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 12:53:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

Some crypto drivers cannot process empty data message and so rely on
precalculated hash.
This patch series add precalculated hash in headers and
make the drivers use them.

Using those precalculated hash make some additionnal constify patch necessary.

Regards
